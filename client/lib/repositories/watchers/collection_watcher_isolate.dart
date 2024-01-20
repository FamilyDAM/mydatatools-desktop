// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:isolate';

import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/modules/files/services/utilities/exif_extractor.dart';
import 'package:client/modules/files/services/utilities/thumbnail_generator.dart';
import 'package:client/modules/files/services/file_system_repository.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:flutter/services.dart';

class CollectionWatcherIsolate {
  String path;
  RootIsolateToken? token;
  late FileSystemRepository fileSystemRepository;
  late CollectionRepository collectionRepository;
  late EmailRepository emailRepository;

  //Utilities
  ThumbnailGenerator thumbnailGenerator = ThumbnailGenerator();
  ExifExtractor exifExtractor = ExifExtractor();

  CollectionWatcherIsolate(this.path, this.token);

  void start(SendPort port) {
    if (token != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token!);
    }

    fileSystemRepository = FileSystemRepository();
    collectionRepository = CollectionRepository();
    emailRepository = EmailRepository();

    _initializeSyncWatchers(MainApp.appDatabase.value);
  }

  final AppLogger logger = AppLogger(null);

  //class reference to keep change listeners running
  StreamSubscription<List<Collection>>? collectionSubs;
  StreamSubscription<List<Email>>? emailSubs;
  StreamSubscription<List<File>>? fileSubs;
  StreamSubscription<List<Folder>>? folderSubs;

  /// Start a realm change stream for each collection type
  void _initializeSyncWatchers(AppDatabase database) {
    _watchCollections(database);
    _watchFolders(database);
    _watchFiles(database);
    _watchEmails(database);
  }

  /// Listen for object changes in 'Collection'
  void _watchCollections(AppDatabase database) async {
    var collections = database.select(database.collections).watch();

    collectionSubs = collections.listen((changes) {
      print(changes);
      /** TODO
      if (changes.inserted.isNotEmpty) {
        for (var e in changes.inserted) {
          //var obj = database.all<Collection>().elementAt(e);
          //logger.d('[Collection] inserted | $obj');
          logger.d('[Collection] inserted | $e');
          // TODO sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        for (var e in changes.modified) {
          //var obj = database.all<Collection>().elementAt(e);
          //logger.d('[Collection] modified | $obj');
          logger.d('[Collection] modified | $e');
          // TODO sync record
        }
      }
      if (changes.deleted.isNotEmpty) {
        for (var e in changes.deleted) {
          //var obj = database.all<Collection>().elementAt(e);
          //logger.d('[Collection] deleted | $obj');
          logger.d('[Collection] deleted | $e');
          // TODO sync record
        }
      }
       */
    });
  }

  /// Listen for object changes in 'Folder'
  void _watchFolders(AppDatabase database) {
    var folders = database.select(database.folders).watch();

    folderSubs = folders.listen((changes) {
      print(changes);

      /** TODO
      if (changes.inserted.isNotEmpty) {
        for (var idx in changes.inserted) {
          Folder f = changes.results[idx];

          //var obj = database.all<Folder>().elementAt(e);
          //logger.d('[Folder] inserted | ${obj.path}');
          logger.d('[Folder] inserted | ${f.path} | ${f.collectionId}');
          // TODO sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        if (changes.modified.isNotEmpty) {
          for (var idx in changes.modified) {
            Folder f = changes.results[idx];
            //var obj = database.all<Folder>().elementAt(e);
            //logger.d('[Folder] modified | ${obj.path}');
            logger.d('[Folder] modified | ${f.path} | ${f.collectionId}');
            // TODO sync record
          }
        }
      }
      if (changes.deleted.isNotEmpty) {
        if (changes.deleted.isNotEmpty) {
          for (var idx in changes.deleted) {
            Folder f = changes.results[idx];
            //var obj = database.all<Folder>().elementAt(e);
            //logger.d('[Folder] deleted | $obj');
            logger.d('[Folder] deleted | ${f.path} | ${f.collectionId}');
            // TODO sync record
          }
        }
      }
      */
    });
  }

  /// Listen for object changes in 'File'
  void _watchFiles(AppDatabase database) {
    var files = database.select(database.files).watch();

    fileSubs = files.listen((changes) {
      print(changes);
      /** TODO
      if (changes.inserted.isNotEmpty) {
        for (var idx in changes.inserted) {
          File file = changes.results[idx];
          //Generate thumbnail, if image
          var thumbnail = await thumbnailGenerator.imageToBase64(file);
          if (thumbnail != null) {
            fileSystemRepository.updateProperty(file, "thumbnail", thumbnail);
          }

          var latLng = await exifExtractor.extractLatLng(file);
          if (latLng != null) {
            fileSystemRepository.updateProperty(file, "latitude", latLng['latitude']);
            fileSystemRepository.updateProperty(file, "longitude", latLng['longitude']);
          }

          //var obj = database.all<File>().elementAt(e);
          //logger.d('[File] inserted | ${obj.path}');
          //logger.d('[File] inserted | ${file.path}');
          // TODO sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        if (changes.modified.isNotEmpty) {
          for (var idx in changes.modified) {
            //File file = changes.results[idx];
            //var obj = database.all<File>().elementAt(e);
            //logger.d('[File] modified | ${obj.path}');
            //logger.d('[File] modified | $file');
            // TODO sync record
          }
        }
      }
      if (changes.deleted.isNotEmpty) {
        if (changes.deleted.isNotEmpty) {
          for (var idx in changes.deleted) {
            File f = changes.results[idx];
            //var obj = database.all<File>().elementAt(e);
            //logger.d('[File] deleted | $obj');
            //logger.d('[File] deleted | $f');
            // TODO sync record
          }
        }
      }
       */
    });
  }

  /// Listen for object changes in 'Email'
  void _watchEmails(AppDatabase database) {
    var emails = database.select(database.emails).watch();

    emailSubs = emails.listen((changes) {
      print(changes);

      /** TODO
      if (changes.inserted.isNotEmpty) {
        for (var e in changes.inserted) {
          var obj = database.all<Email>().elementAt(e);
          //logger.d('[Email] inserted | $obj');
          //logger.d('[Email] inserted | $obj.subject');
          // TODO sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        if (changes.modified.isNotEmpty) {
          for (var e in changes.modified) {
            var obj = database.all<Email>().elementAt(e);
            //var obj = database.all<Email>().elementAt(e);
            //logger.d('[Email] modified | $obj');
            //logger.d('[Email] modified | $e');
            // TODO sync record
          }
        }
      }
      if (changes.deleted.isNotEmpty) {
        if (changes.deleted.isNotEmpty) {
          for (var e in changes.deleted) {
            var obj = database.all<Email>().elementAt(e);
            //var obj = database.all<Email>().elementAt(e);
            //logger.d('[Email] deleted | $obj');
            //logger.d('[Email] deleted | $e');
            // TODO sync record
          }
        }
      }
       */
    });
  }
}
