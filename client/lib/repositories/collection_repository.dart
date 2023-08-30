import 'package:client/models/collection_model.dart';
import 'package:realm/realm.dart';

class CollectionRepository {
  final Realm database;
  CollectionRepository(this.database);

  List<Collection> collections() {
    List<Collection> results = database.all<Collection>().toList();

    return results;
  }

  List<Collection> collectionsByType(String type) {
    List<Collection> r = database.all<Collection>().where((element) => element.type == type).toList();
    return r;
  }

  Collection? collectionById(String val) {
    List<Collection> r = database.all<Collection>().where((element) => element.id == val).toList();
    return r.first;
  }

  Collection getCollectionByPath(String path) {
    List<Collection> r = database.all<Collection>().where((element) => element.path == path).toList();
    return r.first;
  }

  Future addCollection(Collection val) {
    return database.writeAsync(() {
      database.add<Collection>(val, update: true);
      //print('save collection ${val.name}');
    });
  }

  void updateLastScanDate(Collection collection, DateTime? value) {
    database.write(() {
      collection.lastScanDate = DateTime.now();
    });
  }
}
