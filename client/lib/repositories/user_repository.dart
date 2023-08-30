import 'dart:io';

import 'package:client/models/app_models.dart';
import 'package:collection/collection.dart';
import 'package:realm/realm.dart';

class UserRepository {
  final Realm database;
  UserRepository(this.database);

  List<AppUser> users() {
    return database.all<AppUser>().toList();
  }

  AppUser? userExists() {
    AppUser? user = database.all<AppUser>().firstOrNull;
    return user;
  }

  /// Search for user by password that has been hashed with a PBKDF2 algorithm
  AppUser? user(String password) {
    AppUser? user = database.query<AppUser>("password == '$password'").firstOrNull;
    if (user != null) {
      String keyDir = '${user.localStoragePath}${Platform.pathSeparator}keys';
      String publicFilePath = '$keyDir/public.pem';
      String privateFilePath = '$keyDir/private.pem';
      if (!File(publicFilePath).existsSync() && !File(privateFilePath).existsSync()) {
        throw Exception("Keys not found, stopping application");
      }
      //todo: read/write from app /keys folder
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
      File(publicFilePath).writeAsStringSync(user.publicKey);
      File(privateFilePath).writeAsStringSync(user.privateKey);
    }

    //FlutterSecureStorage storage = const FlutterSecureStorage();
    //await storage.write(key: AppConstants.securePassword, value: user.password);

    database.write(() {
      database.add(user, update: true);
    });

    //todo: register user, with only the Public Key to server

    return Future(() => user);
  }
}
