import 'dart:io' as io;

import 'package:client/models/tables/folder.dart' as m;
import 'package:client/repositories/database_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseRepository', () {
    late DatabaseRepository databaseRepository;
    io.Directory? path;
    String dbName = 'test-${DateTime.now().millisecondsSinceEpoch}.sqllite';

    setUpAll(() async {
      //final Uri basedir = (goldenFileComparator as LocalFileComparator).basedir;

      //https://github.com/flutter/flutter/issues/10912#issuecomment-587403632
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      // ignore: deprecated_member_use
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return ".";
      });

      path = await getTemporaryDirectory();
      databaseRepository = DatabaseRepository(); //dbName
      print(databaseRepository);
    });

    tearDownAll(() async {
      databaseRepository.database!.close();

      if (path != null) {
        io.File f = io.File("data/$dbName");
        if (f.existsSync()) {
          f.deleteSync();
        }
      }
    });

    test('check instance not null', () {
      expect(DatabaseRepository.instance, isNotNull);
    });

    //Apps, AppUsers, Collections, Emails, Files, Folders
    test('check folders tables exists', () {
      print("closing database");
      var tables = databaseRepository.database!.allTables;

      var t = tables.firstWhereOrNull((e) {
        return e is m.Folders;
      });
      expect(t != null, true);
    });

    test("Delete Folder", () async {
      m.Folder folder = m.Folder(
        id: const Uuid().v4().toString(),
        name: "Files",
        path: "/files",
        parent: "/",
        dateCreated: DateTime.now().subtract(const Duration(days: 1)),
        dateLastModified: DateTime.now(),
        collectionId: const Uuid().v4().toString(),
      );
      var db = databaseRepository.database!;
      await db.into(db.folders).insert(folder);

      List<m.Folder> allItems = await db.select(db.folders).get();
      expect(allItems.length, equals(1));

      await db.delete(db.folders).delete(folder);

      List<m.Folder> afterDeleteItems = await db.select(db.folders).get();
      expect(afterDeleteItems.length, equals(0));
    });

    test("check all properties are saved", () async {
      m.Folder folder = m.Folder(
        id: const Uuid().v4().toString(),
        name: "Files",
        path: "/files",
        parent: "/",
        dateCreated: DateTime.now().subtract(const Duration(days: 1)),
        dateLastModified: DateTime.now(),
        collectionId: const Uuid().v4().toString(),
      );

      var db = databaseRepository.database!;
      await db.into(db.folders).insert(folder);

      List<m.Folder> allItems = await db.select(db.folders).get();

      expect(allItems.length, equals(1));
      expect(allItems[0].id, equals(folder.id));
      expect(allItems[0].name, equals(folder.name));
      expect(allItems[0].path, equals(folder.path));
      expect(allItems[0].parent, equals(folder.parent));

      await db.delete(db.folders).delete(folder);
    });

    test("Insert multiple folders", () async {
      m.Folder folder1 = m.Folder(
        id: const Uuid().v4().toString(),
        name: "Files",
        path: "/files",
        parent: "/",
        dateCreated: DateTime.now().subtract(const Duration(days: 1)),
        dateLastModified: DateTime.now(),
        collectionId: const Uuid().v4().toString(),
      );
      m.Folder folder2 = m.Folder(
        id: const Uuid().v4().toString(),
        name: "Files",
        path: "/files",
        parent: "/",
        dateCreated: DateTime.now().subtract(const Duration(days: 1)),
        dateLastModified: DateTime.now(),
        collectionId: const Uuid().v4().toString(),
      );
      m.Folder folder3 = m.Folder(
        id: const Uuid().v4().toString(),
        name: "Files",
        path: "/files",
        parent: "/",
        dateCreated: DateTime.now().subtract(const Duration(days: 1)),
        dateLastModified: DateTime.now(),
        collectionId: const Uuid().v4().toString(),
      );

      var db = databaseRepository.database!;
      await db.into(db.folders).insert(folder1);
      await db.into(db.folders).insert(folder2);
      await db.into(db.folders).insert(folder3);

      List<m.Folder> allItems = await db.select(db.folders).get();

      expect(allItems.length, equals(3));

      await db.delete(db.folders).delete(folder1);
      await db.delete(db.folders).delete(folder2);
      await db.delete(db.folders).delete(folder3);
    });
  });
}
