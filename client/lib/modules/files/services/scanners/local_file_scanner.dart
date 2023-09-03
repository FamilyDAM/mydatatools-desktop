import 'dart:async';
import 'dart:isolate';

import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/modules/files/services/scanners/local_file_isolate.dart';
import 'package:client/scanners/collection_scanner.dart';

class LocalFileScanner implements CollectionScanner {
  String dbPath;
  bool isStopped = false;
  LocalFileIsolate? fileIsolate;

  AppLogger logger = AppLogger(null);
  LocalFileScanner(this.dbPath);

  /// Start an Isolate to scan all files and sub-directories linked to a collection
  /// Or if called while the user is browsing, scan the current directory
  ///
  /// [c] Collection to scan
  /// [path] Path to scan, or null to scan the collection's path
  /// [recursive] Scan sub-directories
  /// [force] Force a scan even if the collection has been scanned recently (default: false)
  ///
  /// Returns the number of files scanned
  @override
  Future<int> start(Collection collection, String? path, bool recursive, bool force) async {
    // check if scan has already been run once
    if (!force && collection.lastScanDate != null) return Future(() => 0);
    //todo: add a date range check to rerun scan

    //start full scan in isolate
    ReceivePort receivePort = ReceivePort();
    fileIsolate = LocalFileIsolate(dbPath, receivePort.sendPort);
    int count = await fileIsolate!.start(collection, path ?? collection.path, recursive, force);

    receivePort.listen((message) {
      if (message is String && message.isNotEmpty) {
        logger.s(message);
      }
    });

    return Future(() => count);
  }

  @override
  void stop() async {
    isStopped = true;
    fileIsolate?.stop();
  }
}
