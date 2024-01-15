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

  AppDatabase? database;

  // only have a single app-wide reference to the database
  static DatabaseRepository? _instance;
  static DatabaseRepository get instance => _instance!; //not null is safe to assume since this is set in constructor

  DatabaseRepository(String? databasePath, String? databaseName) {
    //initialized db
    database = AppDatabase(databasePath ?? ".", databaseName ?? AppConstants.configFileName);

    _instance = this;
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

  String? path;

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
    path = file.path;
    //start with default path and override if one is defined in config
    if (file.existsSync()) {
      //pull location from config folder
      var storageFile = file.readAsStringSync();
      path = jsonDecode(storageFile)['path'];
    }

    //set subfolder for data;
    path = p.join(path, 'data', name);
    final dbFile = io.File(path);

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
