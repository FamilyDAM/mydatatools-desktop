import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/app.dart';
import 'package:client/repositories/database_repository.dart';

class AppRepository {
  static AppRepository get instance => AppRepository();

  AppDatabase? database;
  AppLogger logger = AppLogger(null);

  static AppRepository repo = AppRepository._internal();

  factory AppRepository() {
    return repo;
  }

  AppRepository._internal() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  ///
  /// Get a list of all Apps
  Future<List<App>> apps() async {
    if (database == null) return Future(() => []);
    return await database!.select(database!.apps).get();
  }
}
