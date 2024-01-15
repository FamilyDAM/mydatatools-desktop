import 'package:client/models/tables/app.dart';
import 'package:client/repositories/database_repository.dart';

class AppRepository {
  final AppDatabase database;
  AppRepository(this.database);

  ///
  /// Get a list of all Apps
  Future<List<App>> apps() async {
    return await database.select(database.apps).get();
  }
}
