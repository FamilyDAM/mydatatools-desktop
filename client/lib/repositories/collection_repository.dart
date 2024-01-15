import 'package:client/models/tables/collection.dart';
import 'package:client/repositories/database_repository.dart';

class CollectionRepository {
  final AppDatabase database;
  CollectionRepository(this.database);

  Future<List<Collection>> collections() async {
    List<Collection> results = await database.select(database.collections).get();

    return results;
  }

  Future<List<Collection>> collectionsByType(String type) async {
    List<Collection> r =
        await (database.select(database.collections)..where((element) => element.type.equals(type))).get();
    return r;
  }

  Future<Collection?> collectionById(String val) async {
    List<Collection> r =
        await (database.select(database.collections)..where((element) => element.id.equals(val))).get();
    return r.first;
  }

  Future<Collection?> getCollectionByPath(String path) async {
    List<Collection> r =
        await (database.select(database.collections)..where((element) => element.path.equals(path))).get();
    return r.first;
  }

  ///
  /// Create new collection
  Future addCollection(Collection val) async {
    database.into(database.collections).insert(val);
  }

  ///
  /// Update the scan date for services that check external systems on a schedule, such as email
  void updateLastScanDate(Collection collection, DateTime? value) async {
    //update date
    collection.lastScanDate = DateTime.now();
    await database.update(database.collections).write(collection);
  }
}
