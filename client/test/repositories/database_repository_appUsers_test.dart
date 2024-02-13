import 'dart:io' as io;

import 'package:client/models/tables/app_user.dart' as m;
import 'package:client/repositories/database_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseRepository', () async {
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
      databaseRepository = DatabaseRepository.instance; //dbName
      print(databaseRepository);
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

    test('check instance not null', () {
      expect(DatabaseRepository.instance, isNotNull);
    });

    //Apps, AppUsers, Collections, Emails, Files, Folders
    test('check Apps tables exists', () async {
      print("closing database");
      var tables = (await databaseRepository.database).allTables;

      var t = tables.firstWhere((e) {
        return e is m.AppUsers;
      });
      expect(t != null, true);
    });

    test("Delete AppUser", () async {
      m.AppUser user = m.AppUser(
          id: const Uuid().v4().toString(), name: "mike", email: "foo@foo.com", password: "123", localStoragePath: ".");
      var db = await databaseRepository.database;
      await db.into(db.appUsers).insert(user);

      List<m.AppUser> allItems = await db.select(db.appUsers).get();
      expect(allItems.length, equals(1));

      await db.delete(db.appUsers).delete(user);

      List<m.AppUser> afterDeleteItems = await db.select(db.appUsers).get();
      expect(afterDeleteItems.length, equals(0));
    });

    test("check all properties are saved", () async {
      m.AppUser user = m.AppUser(
          id: const Uuid().v4().toString(), name: "mike", email: "foo@foo.com", password: "123", localStoragePath: ".");
      var db = await databaseRepository.database;
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
      m.AppUser user1 = m.AppUser(
          id: const Uuid().v4().toString(),
          name: "mike-1",
          email: "foo@foo.com",
          password: "123",
          localStoragePath: ".");
      m.AppUser user2 = m.AppUser(
          id: const Uuid().v4().toString(),
          name: "mike-2",
          email: "foo@foo.com",
          password: "123",
          localStoragePath: ".");
      m.AppUser user3 = m.AppUser(
          id: const Uuid().v4().toString(),
          name: "mike-3",
          email: "foo@foo.com",
          password: "123",
          localStoragePath: ".");
      var db = await databaseRepository.database;
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
