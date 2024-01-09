import 'dart:io' as io;

import 'package:client/models/tables/collection.dart' as m;
import 'package:client/repositories/database_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

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
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return ".";
      });

      path = await getTemporaryDirectory();
      databaseRepository = DatabaseRepository(".", dbName); //dbName
      print(databaseRepository);
    });

    tearDownAll(() async {
      databaseRepository.database?.close();

      if (path != null) {
        io.File f = io.File("data/$dbName");
        if (f.existsSync()) {
          f.deleteSync();
        }
      }
    });

    test('check instance not null', () {
      expect(databaseRepository.database != null, true);
    });

    //Apps, AppUsers, Collections, Emails, Files, Folders
    test('check Collections tables exists', () {
      print("closing database");
      var tables = databaseRepository.database!.allTables;

      var t = tables.firstWhereOrNull((e) {
        return e is m.Collections;
      });
      expect(t != null, true);
    });

    test("Delete Collection", () async {
      m.Collection collection = m.Collection(
          id: Uuid.v4().toString(),
          name: "Files",
          path: "/files",
          type: "file",
          scanner: "",
          scanStatus: "",
          needsReAuth: true);
      var db = databaseRepository.database!;
      await db.into(db.collections).insert(collection);

      List<m.Collection> allItems = await db.select(db.collections).get();
      expect(allItems.length, equals(1));

      await db.delete(db.collections).delete(collection);

      List<m.Collection> afterDeleteItems = await db.select(db.collections).get();
      expect(afterDeleteItems.length, equals(0));
    });

    test("check all properties are saved", () async {
      m.Collection collection = m.Collection(
          id: Uuid.v4().toString(),
          name: "Files",
          path: "/files",
          type: "file",
          scanner: "",
          scanStatus: "",
          needsReAuth: true);

      var db = databaseRepository.database!;
      await db.into(db.collections).insert(collection);

      List<m.Collection> allItems = await db.select(db.collections).get();

      expect(allItems.length, equals(1));
      expect(allItems[0].id, equals(collection.id));
      expect(allItems[0].name, equals(collection.name));
      expect(allItems[0].path, equals(collection.path));
      expect(allItems[0].type, equals(collection.type));
      expect(allItems[0].scanner, equals(collection.scanner));
      expect(allItems[0].scanStatus, equals(collection.scanStatus));
      expect(allItems[0].oauthService, equals(collection.oauthService));
      expect(allItems[0].accessToken, equals(collection.accessToken));
      expect(allItems[0].refreshToken, equals(collection.refreshToken));
      expect(allItems[0].idToken, equals(collection.idToken));
      expect(allItems[0].userId, equals(collection.userId));
      expect(allItems[0].expiration, equals(collection.expiration));
      expect(allItems[0].lastScanDate, equals(collection.lastScanDate));
      expect(allItems[0].status, equals(collection.status));

      await db.delete(db.collections).delete(collection);
    });

    test("update nullable props in db", () async {
      m.Collection collection = m.Collection(
          id: Uuid.v4().toString(),
          name: "Files",
          path: "/files",
          type: "file",
          scanner: "",
          scanStatus: "",
          needsReAuth: true);

      var db = databaseRepository.database!;
      await db.into(db.collections).insert(collection);

      List<m.Collection> allItems = await db.select(db.collections).get();
      expect(allItems.length, equals(1));

      m.Collection c = allItems[0];
      c.oauthService = "oAuthService";
      c.accessToken = "accessToken";
      c.idToken = "idToken";
      c.refreshToken = "refresh token";
      c.userId = "user id";
      c.expiration = DateTime.now();
      c.lastScanDate = DateTime.now();
      c.needsReAuth = true;
      //
      c.status = "status";
      c.statusMessage = "status message";

      await db.update(db.collections).replace(c);
      m.Collection c2 = await (db.select(db.collections)..where((tbl) => tbl.id.equals(c.id))).getSingle();

      expect(c2.id, equals(c.id));
      expect(c2.name, equals(c.name));
      expect(c2.path, equals(c.path));
      expect(c2.type, equals(c.type));
      expect(c2.scanner, equals(c.scanner));
      expect(c2.scanStatus, equals(c.scanStatus));
      expect(c2.oauthService, equals(c.oauthService));
      expect(c2.accessToken, equals(c.accessToken));
      expect(c2.refreshToken, equals(c.refreshToken));
      expect(c2.idToken, equals(c.idToken));
      expect(c2.userId, equals(c.userId));
      expect(c2.expiration!.difference(c.expiration!).inSeconds, equals(0));
      expect(c2.lastScanDate!.difference(c.lastScanDate!).inSeconds, equals(0));
      expect(c2.needsReAuth, equals(c.needsReAuth));
      expect(c2.status, isNull);
      expect(c2.statusMessage, isNull);

      await db.delete(db.collections).delete(collection);
    });

    test("Insert multiple AppUsers", () async {
      m.Collection collection1 = m.Collection(
          id: Uuid.v4().toString(),
          name: "Files",
          path: "/files",
          type: "file",
          scanner: "",
          scanStatus: "",
          needsReAuth: true);
      m.Collection collection2 = m.Collection(
          id: Uuid.v4().toString(),
          name: "Files",
          path: "/files",
          type: "file",
          scanner: "",
          scanStatus: "",
          needsReAuth: true);
      m.Collection collection3 = m.Collection(
          id: Uuid.v4().toString(),
          name: "Files",
          path: "/files",
          type: "file",
          scanner: "",
          scanStatus: "",
          needsReAuth: true);

      var db = databaseRepository.database!;
      await db.into(db.collections).insert(collection1);
      await db.into(db.collections).insert(collection2);
      await db.into(db.collections).insert(collection3);

      List<m.Collection> allItems = await db.select(db.collections).get();

      expect(allItems.length, equals(3));

      await db.delete(db.collections).delete(collection1);
      await db.delete(db.collections).delete(collection2);
      await db.delete(db.collections).delete(collection3);
    });
  });
}
