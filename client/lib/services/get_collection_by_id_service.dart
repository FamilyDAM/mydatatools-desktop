import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/rx_service.dart';

class GetCollectionByIdService extends RxService<GetCollectionByIdServiceCommand, Collection?> {
  static final GetCollectionByIdService _instance = GetCollectionByIdService();
  static get instance => _instance;

  AppDatabase? database;

  GetCollectionByIdService() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  @override
  Future<Collection?> invoke(GetCollectionByIdServiceCommand command) async {
    if (database == null) return Future(() => null);

    isLoading.add(true);
    CollectionRepository repo = CollectionRepository();
    Collection? c = await repo.collectionById(command.id);
    if (c != null) {
      sink.add(c);
    } else {
      sink.addError(Exception("Collection Not Found"));
    }
    isLoading.add(false);

    return Future(() => c);
  }
}

class GetCollectionByIdServiceCommand implements RxCommand {
  String id;
  GetCollectionByIdServiceCommand(this.id);
}
