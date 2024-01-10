import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

part 'app_user.g.dart';

@UseRowClass(AppUser, constructor: 'fromDb')
class AppUsers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get localStoragePath => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppUser implements Insertable<AppUser> {
  late String id;
  late String name;
  late String email;
  late String password;
  late String localStoragePath;
  //not in DB
  String? privateKey;
  String? publicKey;

  AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.localStoragePath,
      this.privateKey,
      this.publicKey});

  AppUser.fromDb(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.localStoragePath});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return AppUsersCompanion(
            id: Value(id),
            name: Value(name),
            email: Value(email),
            password: Value(password),
            localStoragePath: Value(localStoragePath))
        .toColumns(nullToAbsent);
  }
}
