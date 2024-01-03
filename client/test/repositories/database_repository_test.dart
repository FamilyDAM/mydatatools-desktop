import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:client/repositories/database_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseRepository', () {
    late DatabaseRepository databaseRepository;
    Directory? path;
    String dbName = 'test-${DateTime.now().millisecondsSinceEpoch}.sqllite';

    setUpAll(() async {
      //https://github.com/flutter/flutter/issues/10912#issuecomment-587403632
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return ".";
      });

      path = await getTemporaryDirectory();
      databaseRepository = DatabaseRepository(null, dbName); //dbName
      print(databaseRepository);
    });

    tearDownAll(() async {
      databaseRepository.database?.close();

      if (path != null) {
        File f = File(dbName);
        if (f.existsSync()) {
          f.deleteSync();
        }
      }
    });

    test('check instance not null', () {
      expect(databaseRepository.database != null, true);
    });

    test('check schema version', () {
      expect(databaseRepository.database!.schemaVersion, 1);
    });

    test('check all tables exists', () {
      var tables = databaseRepository.database!.allTables;

      var appTable = tables.firstWhereOrNull((e) {
        return e is $AppTable;
      });
      expect(appTable != null, true);

      var appUser = tables.firstWhereOrNull((e) {
        return e is $AppUserTable;
      });
      expect(appUser != null, true);
    });
  });
}
