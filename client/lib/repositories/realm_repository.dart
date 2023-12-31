// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:isolate';

import 'package:client/app_constants.dart';
import 'package:client/app_logger.dart';
import 'package:client/models/app_models.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart';
import 'package:client/repositories/watchers/collection_watcher_isolate.dart';
import 'package:client/scanners/scanner_manager.dart';
import 'package:client/services/get_user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';

class RealmRepository {
  final AppLogger logger = AppLogger(null);

  static bool isInitialized = false;
  static RealmRepository? _instance;
  static RealmRepository get instance => _instance!;

  late Configuration config;
  late Realm _db;
  // ignore: unnecessary_getters_setters
  Realm get database => _db;
  set database(Realm realm) {
    _db = realm;
  }

  //reference to running scanner manager
  ScannerManager? scannerManager;
  //class reference to keep change listeners running
  StreamSubscription<RealmResultsChanges>? collectionSubs;
  StreamSubscription<RealmResultsChanges>? emailSubs;
  StreamSubscription<RealmResultsChanges>? fileSubs;
  StreamSubscription<RealmResultsChanges>? folderSubs;

  /// Initialize with the async Application Support Directory. Which contains a json config file with path to where we should put the db
  RealmRepository(String path) {
    _initializeDb(path);
    //load initial data
    _loadInitialData();
    _initializeSyncWatchers();
    _initializeScanners();
    isInitialized = true;
    _instance = this;
  }

  void _initializeDb(String path) {
    //define path w/subfolders
    io.File file = io.File('$path${io.Platform.pathSeparator}${AppConstants.configFileName}');
    //start with default path and override if one is defined in config
    String storagePath = path;
    if (file.existsSync()) {
      //pull location from config folder
      var storageFile = file.readAsStringSync();
      storagePath = jsonDecode(storageFile)['path'];
    }

    //set subfolder for data;
    storagePath = '$storagePath${io.Platform.pathSeparator}data${io.Platform.pathSeparator}${AppConstants.dbFileName}';

    //todo: create an async provider to load this as well, so scannerManager can be initialized
    try {
      Configuration.defaultRealmName = AppConstants.realmName;

      config = Configuration.local(
          [Apps.schema, AppUser.schema, Collection.schema, Folder.schema, File.schema, Email.schema],
          schemaVersion: AppConstants.schemaVersion,
          shouldDeleteIfMigrationNeeded: AppConstants.shouldDeleteIfMigrationNeeded,
          path: storagePath);

      //todo: set app specific name
      database = Realm(config);
      debugPrint("Database Path: = ${database.config.path}");
    } catch (err) {
      logger.e(err);
      rethrow;
    }
  }

  /// Start a realm change stream for each collection type
  void _initializeSyncWatchers() {
    ReceivePort myReceivePort = ReceivePort();
    RootIsolateToken? token = ServicesBinding.rootIsolateToken;
    CollectionWatcherIsolate collectionWatcherIsolate = CollectionWatcherIsolate(config.path, token);
    //start isolate version of the collection watcher
    Isolate.spawn<SendPort>(collectionWatcherIsolate.start, myReceivePort.sendPort);
  }

  /// Start up a scanner for each collection
  void _initializeScanners() {
    GetUserService.instance.sink.listen((e) {
      if (e == null) {
        scannerManager?.stopScanners();
      } else {
        scannerManager = ScannerManager(database);
      }
    });
  }

  /// Make sure each app is in database
  void _loadInitialData() async {
    try {
      //Load initial data
      final apps = database.all<Apps>();
      //collections
      if (!apps.any((element) => element.slug == "files")) {
        database.write(() => database.add(Apps(Uuid.v4().toString(), "Files", 'files',
            group: "collections", order: 10, icon: 0xe2a3, route: "/files")));
      }
      if (!apps.any((element) => element.slug == "email")) {
        database.write(() => database.add(Apps(Uuid.v4().toString(), "Email", 'email',
            group: "collections", order: 30, icon: 0xe158, route: "/email")));
      }
      if (!apps.any((element) => element.slug == "social")) {
        database.write(() => database.add(Apps(Uuid.v4().toString(), "Social Networks", 'social',
            group: "collections", order: 40, icon: 0xf233, route: "/social")));
      }
      //apps
      if (!apps.any((element) => element.slug == "photos")) {
        database.write(() => database.add(
            Apps(Uuid.v4().toString(), "Photos", 'photos', group: "app", order: 20, icon: 0xe332, route: "/photos")));
      }
    } catch (err) {
      logger.e(err);
      rethrow;
    }
  }
}
