import 'dart:io' as io;

import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/modules/files/services/scanners/local_file_scanner.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseRepository', () {
    late DatabaseRepository databaseRepository;
    io.Directory? path;
    String dbName = 'test-${DateTime.now().millisecondsSinceEpoch}.sqlite';

    setUpAll(() async {
      //https://github.com/flutter/flutter/issues/10912#issuecomment-587403632
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      // ignore: deprecated_member_use
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return ".";
      });

      path = await getTemporaryDirectory();
      MainApp.appDataDirectory.add(path!.path);
      databaseRepository = DatabaseRepository.instance; //dbName
      print(databaseRepository);

      var db = await databaseRepository.database;
      await db.into(db.collections).insert(Collection(
          id: const Uuid().v4().toString(),
          name: "test",
          path: "/",
          type: "files",
          scanner: "test",
          scanStatus: "pending",
          needsReAuth: false));
    });

    tearDownAll(() async {
      (await databaseRepository.database).close();

      if (path != null) {
        io.File f = io.File("data/$dbName");
        if (f.existsSync()) {
          f.deleteSync();
        }
      }
    });

    //Apps, AppUsers, Collections, Emails, Files, Folders
    test('Scan project macos Dir', () async {
      var db = await databaseRepository.database;
      String path = "./macos";
      Collection c = await (db.select(db.collections)..where((tbl) => tbl.name.equals("test"))).getSingle();
      await LocalFileScanner(db).start(c, path, true, true);

      var files = await db.select(db.files).get();
      expect(files.length, equals(37));
    });
  });
}
