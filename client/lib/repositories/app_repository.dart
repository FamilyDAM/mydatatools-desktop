import 'package:client/models/app_models.dart';
import 'package:realm/realm.dart';

class AppRepository {
  final Realm database;
  AppRepository(this.database);

  List<Apps> apps() {
    return database.all<Apps>().toList();
  }
}
