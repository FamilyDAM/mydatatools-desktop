import 'package:client/app_logger.dart';
import 'package:client/models/tables/app.dart';
import 'package:client/repositories/database_repository.dart';

class AppRepository {
  AppDatabase? database;
  AppLogger logger = AppLogger(null);

  ///
  /// Get a list of all Apps
  Future<List<App>> apps() async {
    AppDatabase database = await DatabaseRepository.instance.database;
    return await database.select(database.apps).get();
  }
}
