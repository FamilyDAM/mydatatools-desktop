import 'package:drift/drift.dart';

part 'app_user.g.dart';

class AppUser extends Table {
  TextColumn get id => text().unique()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get localStoragePath => text()();
  String get privateKey => "";
  String get publicKey => "";
}
