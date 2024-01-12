import 'dart:convert';
import 'dart:io' as io;
import 'package:client/app_logger.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/converters/string_array_convertor.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/folder.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:client/app_constants.dart';
import 'package:client/models/tables/app.dart';
import 'package:path_provider/path_provider.dart';

part 'database_repository.g.dart';

class DatabaseRepository {
  final AppLogger logger = AppLogger(null);

  static String? databasePath;
  static String? databaseName;

  // only have a single app-wide reference to the database
  static AppDatabase? _database;
  AppDatabase? get database {
    if (_database != null) return _database;
    // instantiate the db the first time it is accessed
    _initDatabase(DatabaseRepository.databasePath!, DatabaseRepository.databaseName!);
    return _database;
  }

  set database(db) {
    _database = db;
  }

  DatabaseRepository(String? databasePath, String? databaseName) {
    if (DatabaseRepository.databaseName != null && DatabaseRepository.databaseName != databaseName) {
      throw Exception(
          "Two different DB names have been attempted - ${DatabaseRepository.databaseName} and $databaseName");
    }

    if (DatabaseRepository.databasePath != null && DatabaseRepository.databasePath != databasePath) {
      throw Exception(
          "Two different DB paths have been attempted - ${DatabaseRepository.databaseName} and $databaseName");
    }

    //use last used name if null, if this is the first time and it's null use the default name defined as an App Constant
    DatabaseRepository.databasePath = databasePath ?? DatabaseRepository.databasePath ?? ".";
    DatabaseRepository.databaseName = databaseName ?? DatabaseRepository.databaseName ?? AppConstants.configFileName;

    //db will be initialized on first access, from getter
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase(String path, String name) {
    database = AppDatabase(path, name);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<int> countAllRows(String table) async {
    AppDatabase? db = database;
    if (db == null) throw Error();
    var rows = db.customSelect("select count(*) as count from $table;");
    return (await rows.getSingle()).read("count");
  }
}

@DriftDatabase(tables: [Apps, AppUsers, Collections, Emails, Files, Folders])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String path, String name) : super(_openConnection(path, name));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        print("Creating all Tables");
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          print("Upgrade tables to v2");
          // we added the dueDate property in the change from version 1 to
          // version 2
          //await m.addColumn(todos, todos.dueDate);
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
}

LazyDatabase _openConnection(String path, String name) {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    print("Initialize Database");
    //check app startup initialization
    io.File file = io.File(p.join(path, name));
    //start with default path and override if one is defined in config
    String dbPath = path;
    if (file.existsSync()) {
      //pull location from config folder
      var storageFile = file.readAsStringSync();
      dbPath = jsonDecode(storageFile)['path'];
    }

    //set subfolder for data;
    dbPath = p.join(dbPath, 'data', name);
    final dbFile = io.File(dbPath);

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    print("Opening Database | ${dbFile.path}");
    return NativeDatabase.createInBackground(dbFile, logStatements: true, cachePreparedStatements: true, setup: null);
  });
}
