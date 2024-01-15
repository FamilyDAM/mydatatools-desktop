import 'dart:io' as io;

import 'package:client/models/tables/app.dart' as m;
import 'package:client/repositories/database_repository.dart';
import 'package:collection/collection.dart';
import 'package:drift/isolate.dart';
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
      //https://github.com/flutter/flutter/issues/10912#issuecomment-587403632
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      // ignore: deprecated_member_use
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return ".";
      });

      path = await getTemporaryDirectory();
      databaseRepository = DatabaseRepository(".", dbName); //dbName
      print(databaseRepository);
    });

    tearDownAll(() async {
      databaseRepository.database.close();

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
    test('check Apps tables exists', () {
      var tables = databaseRepository.database.allTables;

      var t = tables.firstWhereOrNull((e) {
        return e is m.Apps;
      });
      expect(t != null, true);
    });

    test("check all properties are saved", () async {
      m.App app = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #1",
          slug: "test_app_1",
          group: "files",
          order: 1,
          route: "/app/1");
      var db = databaseRepository.database;
      await db.into(db.apps).insert(app);

      List<m.App> allItems = await db.select(db.apps).get();

      expect(allItems.length, equals(1));
      expect(allItems[0].id, equals(app.id));
      expect(allItems[0].name, equals(app.name));
      expect(allItems[0].slug, equals(app.slug));
      expect(allItems[0].group, equals(app.group));
      expect(allItems[0].order, equals(app.order));
      expect(allItems[0].icon, equals(app.icon));
      expect(allItems[0].route, equals(app.route));

      await db.delete(db.apps).delete(app);
    });

    test("Get By App ID", () async {
      m.App app = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #1",
          slug: "test_app_1",
          group: "files",
          order: 1,
          route: "/app/1");
      var db = databaseRepository.database;
      await db.into(db.apps).insert(app);

      m.App dbApp = await (db.select(db.apps)..where((a) => a.id.equals(app.id))).getSingle();
      expect(dbApp, isNotNull);
      expect(dbApp.id, equals(app.id));

      await db.delete(db.apps).delete(app);
    });

    test("Insert multiple Apps", () async {
      m.App app1 = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #1",
          slug: "test_app_1",
          group: "files",
          order: 1,
          route: "/app/1");
      m.App app2 = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #2",
          slug: "test_app_2",
          group: "files",
          order: 1,
          route: "/app/2");
      m.App app3 = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #3",
          slug: "test_app_3",
          group: "files",
          order: 1,
          route: "/app/3");
      var db = databaseRepository.database;
      await db.into(db.apps).insert(app1);
      await db.into(db.apps).insert(app2);
      await db.into(db.apps).insert(app3);

      List<m.App> allItems = await db.select(db.apps).get();

      expect(allItems.length, equals(3));

      await db.delete(db.apps).delete(app1);
      await db.delete(db.apps).delete(app2);
      await db.delete(db.apps).delete(app3);
    });

    test("Check Unique Constraint in Apps", () async {
      m.App app1 = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #1",
          slug: "test_app_1",
          group: "files",
          order: 1,
          route: "/app/1");
      m.App app2 = m.App(
          id: const Uuid().v4().toString(),
          name: "test app #1",
          slug: "test_app_1",
          group: "files",
          order: 1,
          route: "/app/1");

      var db = databaseRepository.database;

      expect(() async {
        await db.into(db.apps).insert(app1);
        await db.into(db.apps).insert(app2);
      }, throwsA(isA<DriftRemoteException>()));
    });
  });
}
