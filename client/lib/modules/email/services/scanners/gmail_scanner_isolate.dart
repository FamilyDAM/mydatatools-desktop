import 'dart:convert';
import 'dart:io' as io;
import 'dart:isolate';

import 'package:client/app_constants.dart';
import 'package:client/app_logger.dart';
import 'package:client/models/app_models.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/modules/email/services/email_service.dart';
import 'package:client/oauth/google_auth_client.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:realm/realm.dart';

class GmailScannerIsolate {
  //constructor args
  RootIsolateToken? token;
  SendPort sendPort;
  Isolate? isolate;
  String dbPath;
  String appDir;
  //class props
  AppLogger logger = AppLogger(null);

  GmailScannerIsolate(this.token, this.sendPort, this.dbPath, this.appDir) : super() {
    logger = AppLogger(sendPort);
  }

  Future<int> start(Collection collection, String? path, recursive, bool force) async {
    // A Stream that handles communication between isolates
    ReceivePort p = ReceivePort();
    RootIsolateToken? token = RootIsolateToken.instance;
    Map<String, dynamic> args = {'token': token, 'port': p.sendPort, 'dbPath': dbPath, 'collectionId': collection.id};

    isolate = await Isolate.spawn<Map<String, dynamic>>(_scan, args);
    isolate!.addOnExitListener(p.sendPort);

    p.listen((message) {
      if (message is String) {
        if (message == "command:refresh") {
          EmailService.instance.invoke(EmailServiceCommand(collection, "date", false));
        } else {
          //todo
        }
      }
    });

    return Future(() => 0);
  }

  void stop() async {
    //clear any isolates
    if (isolate != null) {
      isolate!.kill(priority: Isolate.beforeNextEvent);
      logger.w('Killed local file scanner');
    }
  }

  void _scan(Map<String, dynamic> args) async {
    //print(args);
    RootIsolateToken? token = args['token'];
    SendPort resultPort = args['port'];
    String dbPath = args['dbPath'];
    String collectionId = args['collectionId'];

    if (token != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    }

    //Start Database inside isolate
    var database = _initDatabase(dbPath);

    // start scanner
    var fileCount = await _scanEmail(database, collectionId);

    // return all files
    Isolate.exit(resultPort, fileCount);
  }

  Realm _initDatabase(String path_) {
    Configuration config = Configuration.local(
        [Apps.schema, AppUser.schema, Collection.schema, Folder.schema, File.schema, Email.schema],
        schemaVersion: AppConstants.schemaVersion,
        shouldDeleteIfMigrationNeeded: AppConstants.shouldDeleteIfMigrationNeeded,
        path: path_);

    Realm database = Realm(config);
    print("Realm Db initialized in local file isolate = ${database.config.path}");
    return database;
  }

  /// Starting method to run in isolate
  Future<int> _scanEmail(Realm database, String collectionId) async {
    CollectionRepository collectionRepository = CollectionRepository(database);
    EmailRepository emailRepository = EmailRepository(database);

    Collection? collection = collectionRepository.collectionById(collectionId);
    if (collection == null) {
      logger.e("Collection Not Found, killing isolate");
      stop();
    }

    String? accessToken;
    try {
      accessToken = await GoogleAuthClient.validateToken(collection!.accessToken!, collection.refreshToken!);
    } catch (err) {
      collection!.needsReAuth = true;
    }

    int count = 0;
    if (accessToken != null) {
      //first get the newest emails since the last time we ran
      count += await _getNewestEmails(emailRepository, collection, accessToken);
      //double check there are no old emails we missed (ex:app closed before sync completed)
      count += await _getOldestEmails(emailRepository, collection, accessToken);
      //Check emails in trash and soft-delete from local repo and remove any attachments on disk
      count += await _getEmailsInTrashToDelete(emailRepository, collection, accessToken);
      //Check emails in spam and soft-delete from local repo and remove any attachments on disk
      count += await _getEmailsInSpamToDelete(emailRepository, collection, accessToken);
    }
    return Future(() => count);
  }

  /// Get the newest emails since the last time we ran
  /// First it will find the newest date in the db and then pull all emails since that date
  /// This will follow the 'nexttoken' from the api reponse to page through all emails
  /// This will save all attachements to the local disk
  Future<int> _getNewestEmails(EmailRepository emailRepository, Collection collection, String accessToken) async {
    // Check token and refresh if needed
    DateTime? maxDate = emailRepository.getMaxEmailDate(collection.id);
    String? maxQuery = 'in:inbox';
    if (maxDate != null) {
      maxQuery = "after:${(maxDate.millisecondsSinceEpoch / 1000).floor()}";
    }

    //get new emails
    var count = await _pullEmails(emailRepository, collection, maxQuery, true, false, null, collection.accessToken);

    return Future(() => count);
  }

  /// Get any old emails we might have missed on initial sync
  /// First it will find the oldest date in the db and then pull all emails before that date
  /// This will follow the 'nexttoken' from the api reponse to page through all emails
  /// This will save all attachements to the local disk
  Future<int> _getOldestEmails(EmailRepository emailRepository, Collection collection, String accessToken) async {
    int count = 0;
    DateTime? minDate = emailRepository.getMinEmailDate(collection.id);
    if (minDate != null) {
      String minQuery = "before:${(minDate.millisecondsSinceEpoch / 1000).floor()}";

      //get new emails
      count = await _pullEmails(emailRepository, collection, minQuery, true, false, null, collection.accessToken);
    }
    return Future(() => count);
  }

  /// Find all emails in trash and delete them from the local db
  /// This will delete any attachments saved to local disk too.
  Future<int> _getEmailsInTrashToDelete(
      EmailRepository emailRepository, Collection collection, String accessToken) async {
    int count = 0;
    String query = "in:trash";
    //get new emails
    count = await _deleteEmails(emailRepository, collection, query, false, true, null, collection.accessToken);

    return Future(() => count);
  }

  /// Find all emails in spam and delete them from the local db if they originally came in the inbox.
  /// Emails filtered by gmail will not be in local db.
  /// This will delete any attachments saved to local disk too.
  Future<int> _getEmailsInSpamToDelete(
      EmailRepository emailRepository, Collection collection, String accessToken) async {
    int count = 0;
    String query = "in:spam";
    //get new emails
    count = await _deleteEmails(emailRepository, collection, query, false, true, null, collection.accessToken);

    return Future(() => count);
  }

  Future<int> _pullEmails(EmailRepository emailRepository, Collection collection, String? query_,
      bool downloadAttachments, bool includeSpamTrash, String? pageToken, String? accessToken) async {
    int count = 0;
    // Create a new GmailApi object with Bearer Token header
    Map<String, String> authHeaders = {"Authorization": "Bearer $accessToken"};
    final authHttpClient = GoogleAuthClient(authHeaders);
    GmailApi gmailApi = GmailApi(authHttpClient);

    String? nextPageToken;
    List<Message> messages = [];
    List<Email> emailBatch = [];

    // if null, start with a default query to get latest messages
    String query = query_ ?? "before:${DateTime.now().year + 1}";
    //"newer_than:${days}d"; //"after:186d2adcd2343c01"; //"newer_than:2d";

    //pull message ids
    logger.s("Query gmail for messages");
    //print("Query for gmail messages matching: query=$activeQuery | token=$pageToken");
    ListMessagesResponse messagesResponse = await gmailApi.users.messages.list(collection.name,
        includeSpamTrash: includeSpamTrash,
        maxResults: 250,
        pageToken: pageToken, //todo, remove
        q: query);

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
        attachments = await parseAttachmentParts(
            accessToken!,
            collection,
            appDir,
            id,
            int.parse(m.internalDate ?? DateTime.now().millisecondsSinceEpoch.toString()),
            msgDateTime,
            m.payload?.parts ?? []);
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

    if (emailBatch.isNotEmpty) {
      logger.s("Saving ${emailBatch.length} emails");
      //save emails
      emailRepository.addEmails(collection.id, emailBatch);
      sendPort.send("command:refresh");
      logger.s("");
    }

    if (nextPageToken != null) {
      //print("get more messages");
      count += await _pullEmails(
          emailRepository, collection, query, downloadAttachments, includeSpamTrash, nextPageToken, accessToken);
    } else {
      print("Completed pulling all messages from acct: ${collection.name}");
    }

    return Future(() => count);
  }

  ///The _deleteEmails method deletes emails from a Gmail account.
  ///
  ///The method takes the following parameters:
  ///emailRepository: The EmailRepository object to use to access the local database.
  ///collection: The Collection object representing the collection to which the emails belong.
  ///query_: The query string to use to find the emails to delete.
  ///downloadAttachments: Whether or not to download the attachments of the emails.
  ///includeSpamTrash: Whether or not to include spam and trash emails in the search.
  ///pageToken: The page token to use to retrieve the next page of results.
  ///accessToken: The access token to use to authenticate with the Gmail API.
  ///The method returns a Future that resolves to the number of emails that were deleted.
  ///
  ///The method first creates a new GmailApi object with the provided access token.
  ///It then uses the users.messages.list method to retrieve a list of messages that match the provided query.
  ///
  ///The method then uses the getAllById method of the EmailRepository object to retrieve all of the emails in the
  ///local database that have the IDs in the list. The method then flips the isDeleted flag of each email to true.
  ///
  ///The method then uses the deleteEmails method of the EmailRepository object to delete the emails from the local database.
  ///
  ///The method then returns a Future that resolves to the number of emails that were deleted.
  Future<int> _deleteEmails(EmailRepository emailRepository, Collection collection, String query_,
      bool downloadAttachments, bool includeSpamTrash, String? pageToken, String? accessToken) async {
    // Create a new GmailApi object with Bearer Token header
    Map<String, String> authHeaders = {"Authorization": "Bearer $accessToken"};
    final authHttpClient = GoogleAuthClient(authHeaders);
    GmailApi gmailApi = GmailApi(authHttpClient);

    String? nextPageToken;
    List<Message> messages = [];
    List<Email> emailBatch = [];

    ListMessagesResponse messagesResponse = await gmailApi.users.messages.list(collection.name,
        includeSpamTrash: includeSpamTrash,
        maxResults: 50,
        pageToken: pageToken, //todo, remove
        q: query_);

    //grab values out of response
    nextPageToken = messagesResponse.nextPageToken;
    messages = messagesResponse.messages ?? [];

    // Iterate through the list of messages and extract the information you need.
    List<String> ids = [];
    for (Message msg in messages) {
      String id = msg.id!;
      ids.add(id);
    }
    //find all emails in local db, and flip is deleted flag
    emailBatch = emailRepository.getAllById(ids);
    for (Email e in emailBatch) {
      e.isDeleted = true;
    }

    if (emailBatch.isNotEmpty) {
      logger.s("Deleting ${emailBatch.length} emails");
      //save emails
      emailRepository.deleteEmails(collection.id, emailBatch);
      sendPort.send("command:refresh");
      logger.s("");
    }

    int count = 0;
    if (nextPageToken != null) {
      //print("get more messages");
      count += await _pullEmails(
          emailRepository, collection, query_, downloadAttachments, includeSpamTrash, nextPageToken, accessToken);
    } else {
      print("Completed pulling all messages from acct: ${collection.name}");
    }

    return Future(() => count);
  }

  ///The parseBodyParts method parses the body parts of a Gmail message and returns the text of the first part that matches the specified mime type.
  ///
  ///parameters:
  ///
  ///parts: The list of message parts to parse.
  ///mimeType: The mime type of the text to find.
  ///
  ///The method returns the text of the first part that matches the specified mime type, or null if no matching part is found.
  ///
  ///The method first iterates through the list of message parts, looking for a part that matches the specified mime type.
  ///If a matching part is found, the method decodes the part's body and returns the decoded text.
  ///
  ///If no matching part is found, the method iterates through the list of message parts again, looking for a part
  ///that has a nested part that matches the specified mime type. If a matching part is found, the method decodes
  ///the nested part's body and returns the decoded text.
  ///
  ///If no matching part is found, the method returns null.
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
      int epochDate, DateTime msgDateTime, List<MessagePart> parts) async {
    List<File> files = [];
    final AppLogger logger = AppLogger(null);
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

          logger.t('Download Attachment: $fileName | dir:$dir | messageId: $messageId');
          File f = File(Uuid.v4().toString(), collection.id, fileName, file.path, dir.path, msgDateTime, msgDateTime, 0,
              contentType);
          files.add(f);
        } catch (e) {
          logger.w('Cannot parse attachment: $e | messageId: $messageId | part: $part');
        }
      }
    }

    return files;
  }
}
