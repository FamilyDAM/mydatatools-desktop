import 'dart:io';

import 'package:client/models/tables/app_user.dart';
import 'package:client/repositories/database_repository.dart';

class UserRepository {
  final AppDatabase database;
  UserRepository(this.database);

  Future<List<AppUser>> users() async {
    return await database.select(database.appUsers).get();
  }

  Future<AppUser?> userExists() async {
    AppUser? user = await database.select(database.appUsers).getSingleOrNull();
    return user;
  }

  /// Search for user by password that has been hashed with a PBKDF2 algorithm
  Future<AppUser?> user(String password) async {
    AppUser? user =
        await (database.select(database.appUsers)..where((e) => e.password.equals(password))).getSingleOrNull();
    if (user != null) {
      String keyDir = '${user.localStoragePath}${Platform.pathSeparator}keys';
      String publicFilePath = '$keyDir/public.pem';
      String privateFilePath = '$keyDir/private.pem';
      if (!File(publicFilePath).existsSync() && !File(privateFilePath).existsSync()) {
        throw Exception("Keys not found, stopping application");
      }
      // TODO: read/write from app /keys folder
      user.publicKey = File(publicFilePath).readAsStringSync();
      user.privateKey = File(privateFilePath).readAsStringSync();
    }
    return user;
  }

  /// Save user to database
  /// Save public/private keys to /key folder
  Future<AppUser> saveUser(AppUser user) async {
    //Save key into secure storage
    //save keys
    String keyDir = '${user.localStoragePath}${Platform.pathSeparator}keys';
    String publicFilePath = '$keyDir/public.pem';
    String privateFilePath = '$keyDir/private.pem';
    if (!File(publicFilePath).existsSync() && !File(privateFilePath).existsSync()) {
      if (!Directory(keyDir).existsSync()) {
        Directory(keyDir).createSync(recursive: true);
      }
      if (user.publicKey != null) {
        File(publicFilePath).writeAsStringSync(user.publicKey!);
      }
      if (user.privateKey != null) {
        File(privateFilePath).writeAsStringSync(user.privateKey!);
      }
    }

    //FlutterSecureStorage storage = const FlutterSecureStorage();
    //await storage.write(key: AppConstants.securePassword, value: user.password);

    int rowsUpdated = await database.into(database.appUsers).insertOnConflictUpdate(user);

    if (rowsUpdated == 0) {
      throw Exception("Error saving user");
    }

    // TODO: register user, with only the Public Key to server

    return Future(() => user);
  }
}
