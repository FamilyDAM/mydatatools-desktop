import 'dart:convert';
import 'dart:io' as io;

import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/modules/email/services/email_service.dart';
import 'package:client/oauth/login_provider.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

//todo
//@see https://pub.dev/packages/driven
class GmailScanner implements CollectionScanner {
  final Realm realm;
  final Collection collection;
  final int repeatFrequency;
  late String accessToken;
  late String refreshToken;
  late String appDir;
  bool isStopped = false;

  final AppLogger logger = AppLogger(null);

  GmailScanner(this.realm, this.collection, this.appDir, this.repeatFrequency) {
    accessToken = collection.accessToken ?? '';
    refreshToken = collection.refreshToken ?? '';
  }

  @override
  void stop() async {
    isStopped = true;
  }

  @override
  Future<int> start(Collection collection, String? path, bool recursive, bool force) async {
    //skip on restart
    if (!force && collection.lastScanDate != null) return Future(() => 0);

    EmailRepository emailRepository = EmailRepository(realm);

    DateTime? minDate = emailRepository.getMinEmailDate(collection.id);
    String? minQuery;
    if (minDate != null) {
      //minQuery = "before:${minDate.millisecondsSinceEpoch}";
      minQuery = "before:${(minDate.millisecondsSinceEpoch / 1000).floor()}";
    }

    DateTime? maxDate = emailRepository.getMaxEmailDate(collection.id);
    String? maxQuery;
    if (maxDate != null) {
      //maxQuery = "after:${maxDate.millisecondsSinceEpoch}";
      maxQuery = "after:${(maxDate.millisecondsSinceEpoch / 1000).floor()}";
      //maxQuery = "after:${DateFormat('MM/dd/yyyy').format(maxDate)}";
    }

    if (maxQuery == null && minQuery == null) {
      //get default everything before next year
      pullEmails(null, null, true, false).listen((emails) {
        //save initial emails
        logger.s("Saving emails");
        emailRepository.addEmails(collection.id, emails);
        EmailService.instance!.invoke(EmailServiceCommand(collection, "date", false));
        logger.s("");
      });
    } else {
      //get new emails
      pullEmails(null, maxQuery, true, false).listen((emails) {
        logger.s("Saving emails");
        emailRepository.addEmails(collection.id, emails);
        EmailService.instance!.invoke(EmailServiceCommand(collection, "date", false));
        logger.s("");
      });
      //pause to help avoid api quota/sec
      await Future.delayed(const Duration(seconds: 1));
      //load old emails we might have missed
      pullEmails(null, minQuery, true, false).listen((emails) {
        logger.s("Saving emails");
        emailRepository.addEmails(collection.id, emails);
        EmailService.instance!.invoke(EmailServiceCommand(collection, "date", false));
        logger.s("");
      });

      //force delete all messages in trash & attachements
      pullEmails(null, "in:trash", false, true).listen((emails) {
        logger.s("Delete emails in trash");
        List<String> ids = [];
        //create list of ids to search (so we can ignore emails we've never seen before)
        for (var e in emails) {
          ids.add(e.id);
        }
        //get emails that match, with attachment info
        List<Email> existingEmails = emailRepository.getAllById(ids);
        //delete all attachments from disk
        for (var e in existingEmails) {
          for (var f in e.attachments) {
            var file = io.File(f.path);
            if (file.existsSync()) {
              file.delete();
            }
          }
        }
        //delete in db
        emailRepository.deleteEmails(collection.id, existingEmails);
        logger.s("");
      });

      //force delete all messages in spam & attachements
      pullEmails(null, "in:spam", false, true).listen((emails) {
        logger.s("Delete emails in spam");
        List<String> ids = [];
        //create list of ids to search (so we can ignore emails we've never seen before)
        for (var e in emails) {
          ids.add(e.id);
        }
        //get emails that match, with attachment info
        List<Email> existingEmails = emailRepository.getAllById(ids);
        //delete all attachments from disk
        for (var e in existingEmails) {
          for (var f in e.attachments) {
            var file = io.File(f.path);
            if (file.existsSync()) {
              file.delete();
            }
          }
        }
        //delete in db
        emailRepository.deleteEmails(collection.id, existingEmails);
        logger.s("");
      });
    }

    return Future(() => -1);
  }

  ///Call Google API and load all of the emails
  Stream<List<Email>> pullEmails(
      String? pageToken, String? query_, bool downloadAttachments, bool includeSpamTrash) async* {
    if (isStopped) return;

    // Check token and refresh if needed
    try {
      accessToken = await validateToken(collection, accessToken, refreshToken);
    } catch (err) {
      collection.needsReAuth = true;
    }

    // Create a new GmailApi object with Bearer Token header
    Map<String, String> authHeaders = {"Authorization": "Bearer $accessToken"};
    final authHttpClient = GoogleAuthClient(authHeaders);
    GmailApi gmailApi = GmailApi(authHttpClient);

    String? nextPageToken;
    String? activeQuery;
    List<Message> messages = [];
    List<Email> emailBatch = [];

    // if null, start with a default query to get latest messages
    activeQuery = query_ ?? "before:${DateTime.now().year + 1}";
    //"newer_than:${days}d"; //"after:186d2adcd2343c01"; //"newer_than:2d";

    //pull message ids
    logger.s("Query gmail for messages");
    //print("Query for gmail messages matching: query=$activeQuery | token=$pageToken");
    ListMessagesResponse messagesResponse = await gmailApi.users.messages.list(collection.name,
        includeSpamTrash: includeSpamTrash,
        maxResults: 50,
        pageToken: pageToken, //todo, remove
        q: activeQuery); //after:2023/03/05 //todo: make this dynamic so it can return all data or new data only

    //grab values out of response
    nextPageToken = messagesResponse.nextPageToken;
    messages = messagesResponse.messages ?? [];

    // Iterate through the list of messages and extract the information you need.
    for (Message msg in messages) {
      String id = msg.id!;

      //call api to get the rest of the messages
      var m = await gmailApi.users.messages.get("me", id, format: "full");
      var headers = jsonEncode(m.payload?.headers);
      //Pull important data out of headers
      MessagePartHeader? subject = m.payload?.headers?.singleWhere(
          (element) => element.name?.toLowerCase() == "subject",
          orElse: () => MessagePartHeader(name: "Subject", value: null));
      MessagePartHeader? from = m.payload?.headers?.singleWhere((element) => element.name?.toLowerCase() == "from",
          orElse: () => MessagePartHeader(name: "From", value: null));

      //todo, support array of TO headers
      MessagePartHeader? to = m.payload?.headers?.firstWhere((element) => element.name?.toLowerCase() == "to",
          orElse: () => MessagePartHeader(name: "To", value: null));

      MessagePartHeader? cc = m.payload?.headers?.singleWhere((element) => element.name?.toLowerCase() == "cc",
          orElse: () => MessagePartHeader(name: "CC", value: null));
      //MessagePartHeader? msgDate = m.payload?.headers?.singleWhere((element) => element.name?.toLowerCase() == "date",
      //    orElse: () => MessagePartHeader(name: "Date", value: null));
      DateTime msgDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(m.internalDate as String));
      //DateTime? msgDateTime;
      //msgDateTime = HttpDate.parse(msgDate.value!);

      String? plainPayload = parseBodyParts(m.payload?.parts ?? [], "text/plain");
      String? htmlPayload = parseBodyParts(m.payload?.parts ?? [], "text/html");
      List<File> attachments = [];
      if (downloadAttachments) {
        attachments = await parseAttachmentParts(accessToken, collection, appDir, id,
            int.parse(m.internalDate ?? DateTime.now().millisecondsSinceEpoch.toString()), m.payload?.parts ?? []);
      }

      //build object
      Email email = Email(id, collection.id, msgDateTime,
          subject: subject?.value,
          snippet: m.snippet,
          to: to?.value?.split(",") ?? [],
          cc: cc?.value?.split(",") ?? [],
          from: from?.value,
          headers: headers,
          labels: m.labelIds ?? [],
          plainBody: plainPayload,
          htmlBody: htmlPayload,
          attachments: attachments);
      emailBatch.add(email);
    }

    logger.s("Saving emails");
    yield emailBatch;
    logger.s("");

    if (nextPageToken != null) {
      //print("get more messages");
      yield* pullEmails(nextPageToken, activeQuery, downloadAttachments, includeSpamTrash);
    } else {
      print("Completed pulling all messages from acct: ${collection.name}");
    }
  }

  /// Validate the Google access token and refresh if necessary
  Future<String> validateToken(Collection collection, String accessToken, String refreshToken) async {
    //todo: call Google and refresh the token
    return await refresh(collection, accessToken, refreshToken);
  }
}

Future<bool> isExpiredToken(String accessToken) async {
  var httpClient = http.Client();
  String infoUrl = "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=$accessToken";
  http.Response checkResp = await httpClient.get(Uri.parse(infoUrl), headers: null);
  var checkBody = jsonDecode(checkResp.body);
  return checkBody['expires_in'] == null || int.parse(checkBody['expires_in']) <= 0;
}

Future<String> refresh(Collection collection, String accessToken, String refreshToken) async {
  LoginProvider loginProvider = LoginProvider.google;
  final Logger logger = Logger();

  //first check to see if it needs to be refreshed
  bool isExpired = await isExpiredToken(accessToken);
  if (!isExpired) {
    return accessToken;
  }

  //refresh access token
  String url = "https://www.googleapis.com/oauth2/v4/token";
  Map<String, String> params = {
    'refresh_token': refreshToken,
    'client_id': loginProvider.clientId,
    'client_secret': loginProvider.clientSecret,
    'grant_type': 'refresh_token'
  };
  var httpClient = http.Client();
  http.Response response = await httpClient.post(Uri.parse(url), headers: null, body: params);

  var body = jsonDecode(response.body);
  if (body['access_token'] != null) {
    //todo save access token to db
    return body['access_token'];
  } else {
    logger.e('${collection.name} \n ${body['error_description']}');
    throw Exception(body['error_description']);
    //todo: flip flag on collection, show warning in UI asking user to reauth acccount.
  }
}

String? parseBodyParts(List<MessagePart> parts, String mimeType) {
  //1st look for root level part that matches (emails without attachments)
  for (var part in parts) {
    if (part.mimeType == mimeType) {
      var decoded = base64Url.decode(part.body?.data ?? "");
      return utf8.decode(decoded).trim();
    }
  }

  //look in nested parts for a match
  for (var part in parts) {
    if (part.parts != null) {
      for (var innerPart in part.parts ?? []) {
        if (innerPart.mimeType == mimeType) {
          var decoded = base64Url.decode(innerPart.body?.data ?? "");
          return utf8.decode(decoded).trim();
        }
      }
    }
  }

  return null;
}

/// Parameters:
/// collection: The collection to which the attachments belong.
/// appDir: The directory where the attachments will be saved.
/// messageId: The ID of the message that contains the attachments.
/// epochDate: The epoch date of the message.
/// parts: The list of message parts that contain the attachments.
///
/// Returns: A list of File objects representing the parsed attachments.
///
/// Description:
///
/// This method parses the attachments of a Gmail message and saves them to the specified directory.
/// The attachments are saved in a subdirectory of the specified directory, named after the year, month, and day of the message.
/// The name of each attachment is the same as the name of the file in the Gmail message.
///
Future<List<File>> parseAttachmentParts(String accessToken, Collection collection, String appDir, String messageId,
    int epochDate, List<MessagePart> parts) async {
  List<File> files = [];
  final Logger logger = Logger();
  for (var part in parts) {
    if (part.body?.attachmentId != null) {
      try {
        //print("Attachment: ${part.filename} ${part.body?.attachmentId}");
        //String url = 'https://gmail.googleapis.com/gmail/v1/users/me/messages/$messageId/attachments/${part.body?.attachmentId}';

        Map<String, String> authHeaders = {"Authorization": "Bearer $accessToken"};
        final authHttpClient = GoogleAuthClient(authHeaders);
        GmailApi gmailApi = GmailApi(authHttpClient);
        var apiMsg = await gmailApi.users.messages.attachments.get('me', messageId, part.body?.attachmentId ?? "");

        //print(response);
        String contentType = part.mimeType ?? "application/octet-stream";
        String? fileName = part.filename;
        if (fileName == null || fileName.isEmpty) {
          fileName = "unknown_$messageId";
        }
        String email = collection.name;
        String year = DateTime.fromMillisecondsSinceEpoch(epochDate).year.toString();
        String month = DateTime.fromMillisecondsSinceEpoch(epochDate).month.toString();
        String day = DateTime.fromMillisecondsSinceEpoch(epochDate).day.toString();

        String sep = io.Platform.pathSeparator;
        io.Directory dir = io.Directory('$appDir${sep}files${sep}email$sep$email$sep$year$sep$month$sep$day');
        //create dir, if it doesn't exist
        dir.createSync(recursive: true);
        io.File file = io.File('${dir.path}$sep$fileName');
        //write bytes to file
        file.writeAsBytesSync(base64.decode(apiMsg.data!));

        logger.v('Download Attachment: $fileName | dir:$dir | messageId: $messageId');
        File f = File(Uuid.v4().toString(), collection.id, fileName, file.path, dir.path, DateTime.now(),
            DateTime.now(), 0, contentType);
        files.add(f);
      } catch (e) {
        logger.w('Cannot parse attachment: $e | messageId: $messageId | part: $part');
      }
    }
  }

  return files;
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
