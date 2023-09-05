import 'dart:isolate';

import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/modules/email/services/scanners/gmail_scanner_isolate.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:flutter/services.dart';

//todo
//@see https://pub.dev/packages/driven
class GmailScanner implements CollectionScanner {
  String dbPath;
  final Collection collection;
  late String appDir;
  GmailScannerIsolate? isolate;
  bool isStopped = false;

  final AppLogger logger = AppLogger(null);

  GmailScanner(this.dbPath, this.collection, this.appDir);

  @override
  Future<int> start(Collection collection, String? path, bool recursive, bool force) async {
    // check if scan has already been run once
    if (!force && collection.lastScanDate != null) return Future(() => 0);
    //todo: add a date range check to rerun scan

    //start full scan in isolate
    ReceivePort receivePort = ReceivePort();
    receivePort.listen((message) {
      //listen for logger status messages
      if (message is String && message.isNotEmpty) {
        logger.s(message);
      }
    });

    //start isolate
    RootIsolateToken? token = RootIsolateToken.instance;
    isolate = GmailScannerIsolate(token, receivePort.sendPort, dbPath, appDir);
    int count = await isolate!.start(collection, path ?? collection.path, recursive, force);

    return Future(() => count);
  }

  @override
  void stop() async {
    isStopped = true;
    isolate?.stop();
  }
}
