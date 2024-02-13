import 'dart:async';
import 'dart:io' as io;

import 'package:client/app_constants.dart';
import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/album.dart';
import 'package:client/models/tables/app.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/converters/string_array_convertor.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/folder.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

part 'database_repository.g.dart';

class DatabaseRepository {
  // Singleton instance
  static final DatabaseRepository _singleton = DatabaseRepository._();

  // Singleton accessor
  static DatabaseRepository get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<AppDatabase>? _dbOpenCompleter;

  final AppLogger logger = AppLogger(null);
  static bool isInitialized = false;
  bool useMemoryDb = false;
  late String path;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  DatabaseRepository._();

  // Database object accessor
  Future<AppDatabase> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      //
      String path = MainApp.appDataDirectory.value;
      // Calling _openDatabase will also complete the completer with database instance
      await _openDatabase(path);
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase(String storagePath) async {
    try {
      //make sure root dir exists
      io.Directory(storagePath).createSync(recursive: true);
      //make sure data, files, and keys sub dirs have been created
      var dbDir = io.Directory(p.join(storagePath, 'data'));
      io.Directory(dbDir.path).createSync(recursive: true);
      var keyDir = io.Directory(p.join(storagePath, 'keys'));
      io.Directory(keyDir.path).createSync(recursive: true);
      var fileDir = io.Directory(p.join(storagePath, 'files'));
      io.Directory(fileDir.path).createSync(recursive: true);

      //on app startup, start db.
      AppDatabase database = AppDatabase(null, storagePath, AppConstants.dbName, useMemoryDb);
      print("DB Schema Version=${database.schemaVersion}");

      //last check, if we have no users then we need to re-run database
      var users = await database.select(database.appUsers).get();
      if (users.isNotEmpty) {
        DatabaseRepository.isInitialized = true;
      }

      // Any code awaiting the Completers future will now start executing
      _dbOpenCompleter!.complete(database);
    } catch (err) {
      //unknown error
      print(err);
    }
  }

  ///
  /// Helper SQL Methods
  ///

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<int> countAllRows(String table) async {
    AppDatabase db = await database;
    if (db == null) throw Exception("Query is being run before database has been initialized");

    var rows = db.customSelect("select count(*) as count from $table;");
    return (await rows.getSingle()).read("count");
  }
}

@DriftDatabase(tables: [Apps, AppUsers, Collections, Emails, Files, Folders, Albums])
class AppDatabase extends _$AppDatabase {
  final AppLogger logger = AppLogger(null);

  AppDatabase([QueryExecutor? executor, String? path, String? name, bool useMemoryDb = false])
      : super(executor ?? _openConnection(path, name, useMemoryDb));

  String? path;
  String? name;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        print("Creating all Tables");
        await m.createAll();
        print("Load initial data");
        await _loadInitialData(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          print("Upgrade to v2");
        }
        if (from < 3) {
          print("Upgrade tables to v3");
          // we added the priority property in the change from version 1 or 2
          // to version 3
          //await m.addColumn(todos, todos.priority);
        }
      },
    );
  }

  /// Make sure each app is in database
  Future<int> _loadInitialData(Migrator m) async {
    try {
      int appsAdded = 0;
      //Load initial data
      TableInfo<Table, dynamic>? appsTable = m.database.allTables.firstWhereOrNull((e) => e.actualTableName == 'apps');

      List<dynamic> apps = await m.database.select(appsTable!).get();
      //apps
      if (!apps.any((element) => element.slug == "files")) {
        await m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Files",
            slug: 'files',
            group: "collections",
            order: 10,
            icon: 0xe2a3,
            route: "/files"));
        appsAdded++;
      }
      if (!apps.any((element) => element.slug == "email")) {
        await m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Email",
            slug: 'email',
            group: "collections",
            order: 30,
            icon: 0xe2a3,
            route: "/email"));
        appsAdded++;
      }
      if (!apps.any((element) => element.slug == "social")) {
        await m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Social Networks",
            slug: 'social',
            group: "collections",
            order: 50,
            icon: 0xe2a3,
            route: "/social"));
        appsAdded++;
      }
      if (!apps.any((element) => element.slug == "photos")) {
        await m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Photos",
            slug: 'photos',
            group: "app",
            order: 20,
            icon: 0xe2a3,
            route: "/photos"));
        appsAdded++;
      }

      return Future(() => appsAdded);
    } catch (err) {
      logger.e(err);
      rethrow;
    }
  }
}

LazyDatabase _openConnection(String? path, String? name, bool useMemoryDb) {
  if (path == null || name == null) {
    throw ("Path or Name not provided, can not start scanner");
  }
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    print('Initialize Database | path=$path');
    //check app startup initialization
    io.File file = io.File(p.join(path!, 'data', name));
    path = file.path;

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to ios/mac app sandbox.
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = (await getTemporaryDirectory()).path;

    print("Opening Database | $path");
    if (!useMemoryDb) {
      return NativeDatabase(file, logStatements: true, cachePreparedStatements: true, setup: null);
      //return NativeDatabase.createInBackground(file, logStatements: true, cachePreparedStatements: true, setup: null);
    } else {
      return NativeDatabase.memory(logStatements: true, setup: null, cachePreparedStatements: false);
    }
  });
}
