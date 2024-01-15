import 'dart:async';

import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/modules/email/notifications/email_sort_changed_notification.dart';
import 'package:client/modules/email/pages/new_email_page.dart';
import 'package:client/modules/email/services/email_service.dart';
import 'package:client/modules/email/widgets/email_details.dart';
import 'package:client/modules/email/widgets/email_table.dart';
import 'package:client/scanners/scanner_manager.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  static PublishSubject selectedCollection = PublishSubject();

  @override
  State<EmailPage> createState() => _EmailPage();
}

class _EmailPage extends State<EmailPage> {
  AppLogger logger = AppLogger(null);

  EmailService? _emailService;
  GetCollectionsService? _collectionService;
  StreamSubscription<List<Collection>>? _collectionsServiceSub;
  StreamSubscription? _selectedCollectionSub;
  StreamSubscription? _emailsSub;
  List<Collection> collections = [];
  Collection? collection;
  int count = 0;
  List<Email> emails = [];
  String sortColumn = 'date';
  bool sortAsc = false;
  String emailLayout = 'vertical';
  Email? selectedEmail;

  @override
  void initState() {
    _collectionService = GetCollectionsService.instance;

    _collectionsServiceSub = _collectionService!.sink.listen((value) {
      setState(() {
        collections = value;
      });
      if (value.isNotEmpty) {
        //select default collection
        EmailPage.selectedCollection.add(value.first);
      }
    });

    _selectedCollectionSub = EmailPage.selectedCollection.listen((value) {
      //call service to load all emails
      if (value != null && collection != value) {
        //create new sub for emails in this collection
        _emailService = EmailService();
        //close old subscription
        if (_emailsSub != null) _emailsSub?.cancel();
        //listen for changes while visible
        _emailsSub = _emailService!.sink.listen((value) {
          setState(() {
            emails = value;
            count = value.length;
          });
        });

        _emailService!.invoke(EmailServiceCommand(value, sortColumn, sortAsc));
      }
      //udpate ui with selected collection
      setState(() {
        collection = value;
      });
    });

    //get all email collections
    _collectionService?.invoke(GetCollectionsServiceCommand("email"));
    super.initState();
  }

  @override
  void dispose() {
    _emailsSub?.cancel();
    _collectionsServiceSub?.cancel();
    _selectedCollectionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (collections.isEmpty) {
      return const NewEmailPage();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.secondaryHeaderColor,
          centerTitle: false,
          shadowColor: theme.scaffoldBackgroundColor,
          title: Text(collection?.name ?? ''),
          actions: <Widget>[
            IconButton(
              // TODO: disable is no files are checked
              icon: const Icon(Icons.search, color: Colors.black),
              tooltip: 'Search Emails',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('todo: show search field')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              tooltip: 'Refresh',
              onPressed: () {
                logger.s("refresh emails");
                ScannerManager.getInstance().getScanner(collection!)?.start(collection!, null, true, true);
              },
            ),
            IconButton(
              // TODO: disable is no files are checked
              icon: const Icon(Icons.delete, color: Colors.black),
              tooltip: 'Delete Selected Messages',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('todo: delete selected messages')));
              },
            ),
            IconButton(
                // TODO: disable is no files are checked
                icon: const Icon(Icons.vertical_split, color: Colors.black),
                tooltip: 'Vertical layout',
                onPressed: (emailLayout == 'vertical')
                    ? null
                    : () {
                        setState(() {
                          emailLayout = 'vertical';
                        });
                      }),
            IconButton(
                // TODO: disable is no files are checked
                icon: const Icon(Icons.horizontal_split, color: Colors.black),
                tooltip: 'Side by Side Layout',
                onPressed: (emailLayout == 'horizontal')
                    ? null
                    : () {
                        setState(() {
                          emailLayout = 'horizontal';
                        });
                      }),
            const IconButton(
              // TODO: disable is no files are checked
              icon: Icon(Icons.settings, color: Colors.black),
              tooltip: 'Collection Settings',
              onPressed: null,
            ),
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          NotificationListener<EmailSortChangedNotification>(
              child: (emailLayout == 'vertical')
                  ? Column(children: [
                      EmailTable(
                        count: count,
                        emails: emails,
                      ),
                      (selectedEmail != null)
                          ? EmailDetails(email: selectedEmail!)
                          : const SizedBox(width: 0, height: 0),
                    ])
                  : Row(children: [
                      EmailTable(
                        count: count,
                        emails: emails,
                      ),
                      (selectedEmail != null)
                          ? EmailDetails(email: selectedEmail!)
                          : const SizedBox(width: 0, height: 0),
                    ]),
              onNotification: (EmailSortChangedNotification n) {
                sortColumn = n.sortColumn;
                sortAsc = n.sortAsc;
                _emailService!.invoke(EmailServiceCommand(collection!, sortColumn, sortAsc));
                return true;
              })
        ]));
  }
}
