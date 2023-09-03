import 'dart:async';
import 'dart:isolate';

import 'package:client/app_constants.dart';
import 'package:client/app_logger.dart';
import 'package:client/models/app_models.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/modules/files/services/utilities/exif_extractor.dart';
import 'package:client/modules/files/services/utilities/thumbnail_generator.dart';
import 'package:client/modules/files/services/file_system_repository.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';

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

    Configuration config = Configuration.local(
        [Apps.schema, AppUser.schema, Collection.schema, Folder.schema, File.schema, Email.schema],
        schemaVersion: AppConstants.schemaVersion,
        shouldDeleteIfMigrationNeeded: AppConstants.shouldDeleteIfMigrationNeeded,
        path: path);

    Realm database = Realm(config);
    print("Realm Db initialized in watcher isolate = ${database.config.path}");

    fileSystemRepository = FileSystemRepository(database);
    collectionRepository = CollectionRepository(database);
    emailRepository = EmailRepository(database);

    _initializeSyncWatchers(database);
  }

  final AppLogger logger = AppLogger(null);

  //class reference to keep change listeners running
  StreamSubscription<RealmResultsChanges>? collectionSubs;
  StreamSubscription<RealmResultsChanges>? emailSubs;
  StreamSubscription<RealmResultsChanges>? fileSubs;
  StreamSubscription<RealmResultsChanges>? folderSubs;

  /// Start a realm change stream for each collection type
  void _initializeSyncWatchers(Realm database) {
    _watchCollections(database);
    _watchFolders(database);
    _watchFiles(database);
    _watchEmails(database);
  }

  /// Listen for object changes in 'Collection'
  void _watchCollections(Realm database) {
    collectionSubs = database.all<Collection>().changes.listen((changes) {
      if (changes.inserted.isNotEmpty) {
        for (var e in changes.inserted) {
          //var obj = database.all<Collection>().elementAt(e);
          //logger.d('[Collection] inserted | $obj');
          logger.d('[Collection] inserted | $e');
          //todo sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        for (var e in changes.modified) {
          //var obj = database.all<Collection>().elementAt(e);
          //logger.d('[Collection] modified | $obj');
          logger.d('[Collection] modified | $e');
          //todo sync record
        }
      }
      if (changes.deleted.isNotEmpty) {
        for (var e in changes.deleted) {
          //var obj = database.all<Collection>().elementAt(e);
          //logger.d('[Collection] deleted | $obj');
          logger.d('[Collection] deleted | $e');
          //todo sync record
        }
      }
    });
  }

  /// Listen for object changes in 'Folder'
  void _watchFolders(Realm database) {
    folderSubs = database.all<Folder>().changes.listen((changes) {
      if (changes.inserted.isNotEmpty) {
        for (var e in changes.inserted) {
          //var obj = database.all<Folder>().elementAt(e);
          //logger.d('[Folder] inserted | ${obj.path}');
          logger.d('[Folder] inserted | $e');
          //todo sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        for (var e in changes.modified) {
          //var obj = database.all<Folder>().elementAt(e);
          //logger.d('[Folder] modified | ${obj.path}');
          logger.d('[Folder] modified | $e');
          //todo sync record
        }
      }
      if (changes.deleted.isNotEmpty) {
        for (var e in changes.deleted) {
          //var obj = database.all<Folder>().elementAt(e);
          //logger.d('[Folder] deleted | $obj');
          logger.d('[Folder] deleted | $e');
          //todo sync record
        }
      }
    });
  }

  /// Listen for object changes in 'File'
  void _watchFiles(Realm database) {
    fileSubs = database.all<File>().changes.listen((changes) async {
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
          //todo sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        for (var e in changes.modified) {
          //var obj = database.all<File>().elementAt(e);
          //logger.d('[File] modified | ${obj.path}');
          //logger.d('[File] modified | $e');
          //todo sync record
        }
      }
      if (changes.deleted.isNotEmpty) {
        for (var e in changes.deleted) {
          //var obj = database.all<File>().elementAt(e);
          //logger.d('[File] deleted | $obj');
          logger.d('[File] deleted | $e');
          //todo sync record
        }
      }
    });
  }

  /// Listen for object changes in 'Email'
  void _watchEmails(Realm database) {
    emailSubs = database.all<Email>().changes.listen((changes) {
      if (changes.inserted.isNotEmpty) {
        for (var e in changes.inserted) {
          var obj = database.all<Email>().elementAt(e);
          //logger.d('[Email] inserted | $obj');
          logger.d('[Email] inserted | $obj.subject');
          //todo sync record
        }
      }
      if (changes.modified.isNotEmpty) {
        for (var e in changes.modified) {
          //var obj = database.all<Email>().elementAt(e);
          //logger.d('[Email] modified | $obj');
          logger.d('[Email] modified | $e');
          //todo sync record
        }
      }
      if (changes.deleted.isNotEmpty) {
        for (var e in changes.deleted) {
          //var obj = database.all<Email>().elementAt(e);
          //logger.d('[Email] deleted | $obj');
          logger.d('[Email] deleted | $e');
          //todo sync record
        }
      }
    });
  }
}
