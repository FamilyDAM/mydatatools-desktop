import 'dart:io' as io;

import 'package:client/models/tables/app_user.dart' as m;
import 'package:client/repositories/database_repository.dart';
import 'package:collection/collection.dart';
import 'package:realm/realm.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseRepository', () {
    late DatabaseRepository databaseRepository;
    io.Directory? path;
    String dbName = 'test-${DateTime.now().millisecondsSinceEpoch}.sqllite';

    setUpAll(() async {
      //https://github.com/flutter/flutter/issues/10912#issuecomment-587403632
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel =
          MethodChannel('plugins.flutter.io/path_provider');
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
    test('check Apps tables exists', () {
      print("closing database");
      var tables = databaseRepository.database!.allTables;

      var t = tables.firstWhereOrNull((e) {
        return e is m.AppUsers;
      });
      expect(t != null, true);
    });

    test("Delete AppUser", () async {
      m.AppUser user = m.AppUser(
          Uuid.v4().toString(), "mike", "foo@foo.com", "123", ".", null, null);
      var db = databaseRepository.database!;
      await db.into(db.appUsers).insert(user);

      List<m.AppUser> allItems = await db.select(db.appUsers).get();
      expect(allItems.length, equals(1));

      await db.delete(db.appUsers).delete(user);

      List<m.AppUser> afterDeleteItems = await db.select(db.appUsers).get();
      expect(afterDeleteItems.length, equals(0));
    });

    test("check all properties are saved", () async {
      m.AppUser user = m.AppUser(
          Uuid.v4().toString(), "mike", "foo@foo.com", "123", ".", null, null);
      var db = databaseRepository.database!;
      await db.into(db.appUsers).insert(user);

      List<m.AppUser> allItems = await db.select(db.appUsers).get();

      expect(allItems.length, equals(1));
      expect(allItems[0].id, equals(user.id));
      expect(allItems[0].name, equals(user.name));
      expect(allItems[0].email, equals(user.email));
      expect(allItems[0].localStoragePath, equals(user.localStoragePath));
      expect(allItems[0].password, equals(user.password));
      expect(allItems[0].privateKey, isNull);
      expect(allItems[0].publicKey, isNull);

      await db.delete(db.appUsers).delete(user);
    });

    test("Insert multiple AppUsers", () async {
      m.AppUser user1 = m.AppUser(Uuid.v4().toString(), "mike-1",
          "foo-1@foo.com", "123", ".", null, null);
      m.AppUser user2 = m.AppUser(Uuid.v4().toString(), "mike-2",
          "foo-2@foo.com", "123", ".", null, null);
      m.AppUser user3 = m.AppUser(Uuid.v4().toString(), "mike-3",
          "foo-3@foo.com", "123", ".", null, null);
      var db = databaseRepository.database!;
      await db.into(db.appUsers).insert(user1);
      await db.into(db.appUsers).insert(user2);
      await db.into(db.appUsers).insert(user3);

      List<m.AppUser> allItems = await db.select(db.appUsers).get();

      expect(allItems.length, equals(3));

      await db.delete(db.appUsers).delete(user1);
      await db.delete(db.appUsers).delete(user2);
      await db.delete(db.appUsers).delete(user3);
    });
  });
}
