import 'dart:convert';
import 'dart:io' as io;
import 'package:client/app_logger.dart';
import 'package:client/models/tables/album.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/converters/string_array_convertor.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/folder.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:client/app_constants.dart';
import 'package:client/models/tables/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'database_repository.g.dart';

class DatabaseRepository {
  final AppLogger logger = AppLogger(null);

  late AppDatabase database;

  // only have a single app-wide reference to the database
  static DatabaseRepository? _instance;
  static DatabaseRepository? get instance => _instance; //not null is safe to assume since this is set in constructor

  DatabaseRepository(String? databasePath, String? databaseName) {
    //initialized db
    if (_instance == null) {
      database = AppDatabase(databasePath ?? ".", databaseName ?? AppConstants.configFileName);
    }

    _instance = this;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<int> countAllRows(String table) async {
    AppDatabase? db = database;
    var rows = db.customSelect("select count(*) as count from $table;");
    return (await rows.getSingle()).read("count");
  }
}

@DriftDatabase(tables: [Apps, AppUsers, Collections, Emails, Files, Folders, Albums])
class AppDatabase extends _$AppDatabase {
  final AppLogger logger = AppLogger(null);
  AppDatabase(String path, String name) : super(_openConnection(path, name));

  String? path;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        print("Creating all Tables");
        await m.createAll();
        print("Load initial data");
        _loadInitialData(m);
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
  void _loadInitialData(Migrator m) async {
    try {
      //Load initial data
      TableInfo<Table, dynamic>? appsTable = m.database.allTables.firstWhereOrNull((e) => e.actualTableName == 'apps');

      List<dynamic> apps = await m.database.select(appsTable!).get();
      //apps
      if (!apps.any((element) => element.slug == "files")) {
        m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Files",
            slug: 'files',
            group: "collections",
            order: 10,
            icon: 0xe2a3,
            route: "/files"));
      }
      if (!apps.any((element) => element.slug == "email")) {
        m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Email",
            slug: 'email',
            group: "collections",
            order: 30,
            icon: 0xe2a3,
            route: "/email"));
      }
      if (!apps.any((element) => element.slug == "social")) {
        m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Social Networks",
            slug: 'social',
            group: "collections",
            order: 50,
            icon: 0xe2a3,
            route: "/social"));
      }
      if (!apps.any((element) => element.slug == "photos")) {
        m.database.into(appsTable).insert(App(
            id: const Uuid().v4().toString(),
            name: "Photos",
            slug: 'photos',
            group: "app",
            order: 20,
            icon: 0xe2a3,
            route: "/photos"));
      }
    } catch (err) {
      logger.e(err);
      rethrow;
    }
  }
}

LazyDatabase _openConnection(String path, String name) {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    print("Initialize Database");
    //check app startup initialization
    io.File file = io.File(p.join(path, 'data', name));
    path = file.path;
    //start with default path and override if one is defined in config
    if (file.existsSync()) {
      //pull location from config folder
      var storageFile = file.readAsStringSync();
      path = jsonDecode(storageFile)['path'];
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    print("Opening Database | $path");
    return NativeDatabase.createInBackground(file, logStatements: true, cachePreparedStatements: true, setup: null);
  });
}
