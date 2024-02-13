import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/repositories/database_repository.dart';

class CollectionRepository {
  AppLogger logger = AppLogger(null);

  Future<List<Collection>> collections() async {
    AppDatabase database = await DatabaseRepository.instance.database;

    List<Collection> results = await database.select(database.collections).get();

    return results;
  }

  Future<List<Collection>> collectionsByType(String type) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    List<Collection> r =
        await (database.select(database.collections)..where((element) => element.type.equals(type))).get();
    return r;
  }

  Future<Collection?> collectionById(String val) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    List<Collection> r =
        await (database.select(database.collections)..where((element) => element.id.equals(val))).get();
    return r.first;
  }

  Future<Collection?> getCollectionByPath(String path) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    List<Collection> r =
        await (database.select(database.collections)..where((element) => element.path.equals(path))).get();
    return r.first;
  }

  ///
  /// Create new collection
  Future<Collection?> addCollection(Collection val) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    database.into(database.collections).insert(val);
    return Future(() => val);
  }

  ///
  /// Update the scan date for services that check external systems on a schedule, such as email
  void updateLastScanDate(Collection collection, DateTime? value) async {
    AppDatabase database = await DatabaseRepository.instance.database;
    //update date
    collection.lastScanDate = DateTime.now();
    await database.update(database.collections).write(collection);
  }
}
