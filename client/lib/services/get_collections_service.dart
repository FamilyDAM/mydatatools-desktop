import 'package:client/models/collection_model.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:client/repositories/realm_repository.dart';

class GetCollectionsService extends RxService<GetCollectionsServiceCommand, List<Collection>> {
  GetCollectionsServiceCommand? currentCommand;

  static final GetCollectionsService _instance = GetCollectionsService();
  static get instance => _instance;

  //GetCollectionsService() : super() {}

  @override
  Future<List<Collection>> invoke(GetCollectionsServiceCommand command) {
    isLoading.add(true);
    currentCommand = command;
    CollectionRepository repo = CollectionRepository(RealmRepository.instance.database);
    if (command.type == null) {
      sink.add(repo.collections());
    } else {
      sink.add(repo.collectionsByType(command.type!));
    }
    isLoading.add(false);

    return Future(() => repo.collections());
  }

  void addCollection(Collection c) {
    CollectionRepository repo = CollectionRepository(RealmRepository.instance.database);
    //save
    repo.addCollection(c);
    //refresh list with current command type (if defined)
    invoke(GetCollectionsServiceCommand(currentCommand?.type));
  }
}

class GetCollectionsServiceCommand implements RxCommand {
  String? type;
  GetCollectionsServiceCommand(this.type);
}
