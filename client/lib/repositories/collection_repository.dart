import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/repositories/database_repository.dart';

class CollectionRepository {
  static CollectionRepository get instance => CollectionRepository();

  AppDatabase? database;
  AppLogger logger = AppLogger(null);

  static CollectionRepository repo = CollectionRepository._internal();

  factory CollectionRepository() {
    return repo;
  }

  CollectionRepository._internal() {
    database = MainApp.appDatabase.value;
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  Future<List<Collection>> collections() async {
    if (database == null) return Future(() => []);

    List<Collection> results = await database!.select(database!.collections).get();

    return results;
  }

  Future<List<Collection>> collectionsByType(String type) async {
    if (database == null) return Future(() => []);

    List<Collection> r =
        await (database!.select(database!.collections)..where((element) => element.type.equals(type))).get();
    return r;
  }

  Future<Collection?> collectionById(String val) async {
    if (database == null) return Future(() => null);

    List<Collection> r =
        await (database!.select(database!.collections)..where((element) => element.id.equals(val))).get();
    return r.first;
  }

  Future<Collection?> getCollectionByPath(String path) async {
    if (database == null) return Future(() => null);

    List<Collection> r =
        await (database!.select(database!.collections)..where((element) => element.path.equals(path))).get();
    return r.first;
  }

  ///
  /// Create new collection
  Future<Collection?> addCollection(Collection val) async {
    if (database == null) return Future(() => null);

    database!.into(database!.collections).insert(val);
    return Future(() => val);
  }

  ///
  /// Update the scan date for services that check external systems on a schedule, such as email
  void updateLastScanDate(Collection collection, DateTime? value) async {
    if (database != null) {
      //update date
      collection.lastScanDate = DateTime.now();
      await database!.update(database!.collections).write(collection);
    }
  }
}
