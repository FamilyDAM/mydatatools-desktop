import 'dart:async';

import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/file_asset.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/modules/files/services/file_upsert_service.dart';
import 'package:client/modules/files/services/scanners/local_file_isolate.dart';
import 'package:client/modules/files/services/scanners/local_file_scanner2.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:flutter/foundation.dart';

class LocalFileScanner implements CollectionScanner {
  AppDatabase database;
  bool isStopped = false;
  LocalFileIsolate? fileIsolate;

  AppLogger logger = AppLogger(null);
  LocalFileScanner(this.database);

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
    // final connection = await database.serializableConnection();

    int count = await database.computeWithDatabase(
      computation: (database) async {
        // Expensive computation that runs on its own isolate but talks to the
        // main database.
        int count = 0;
        List<FileAsset> filesAndFolders = [];

        // We can't share the [database] object across isolates, but the connection is fine!
        LocalFileScanner2 streamScanner = LocalFileScanner2(collection.id, path ?? collection.path);
        StreamController<List<FileAsset>> controller = StreamController();

        controller.stream.listen((event) async {
          //save files
          Iterable<File> fileList = event.whereType<File>().toList();
          List<Future> fileFutures = [];
          for (var file in fileList) {
            FileUpsertService.instance.invoke(FileUpsertServiceCommand(file));
          }
          //wait for all file inserts to complete
          //await Future.wait(fileFutures);

          //save folders
          Iterable<Folder> folderList = event.whereType<Folder>().toList();
          List<Future> folderFutures = [];
          for (var folder in folderList) {
            try {
              // add if missing
              QueryRow? row = await database.customSelect("select id from folders where path = ?",
                  variables: [Variable.withString(folder.path)]).getSingleOrNull();
              if (row == null) {
                await database.into(database.folders).insert(folder);
              }
            } catch (err) {
              debugPrint(err.toString());
            }
          }
          //wait for all folders to complete
          //Future.wait(folderFutures);
        }, onDone: () {
          print("Scan Complete");
        });

        //Using the controller, scan the dir and return all items to the callback above
        count = await streamScanner.scanDir(controller, path!, recursive);
        return Future(() => count);
      },
      connect: (connection) {
        // This function is responsible for creating a second instance of your
        // database class with a short-lived [connection].
        // For this to work, your database class needs to have a constructor that
        // allows taking a connection as described above.
        return AppDatabase(connection);
      },
    );

    return Future(() => count);
  }

  @override
  void stop() async {
    isStopped = true;
    fileIsolate?.stop();
  }
}
