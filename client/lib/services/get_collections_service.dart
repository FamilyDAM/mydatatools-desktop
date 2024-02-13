import 'package:client/models/tables/collection.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/services/rx_service.dart';

class GetCollectionsService extends RxService<GetCollectionsServiceCommand, List<Collection>> {
  static final GetCollectionsService _singleton = GetCollectionsService();
  static get instance => _singleton;

  GetCollectionsServiceCommand? currentCommand;

  @override
  Future<List<Collection>> invoke(GetCollectionsServiceCommand command) async {
    isLoading.add(true);
    currentCommand = command;
    CollectionRepository repo = CollectionRepository();
    if (command.type == null) {
      sink.add(await repo.collections());
    } else {
      sink.add(await repo.collectionsByType(command.type!));
    }
    isLoading.add(false);

    return Future(() => repo.collections());
  }

  void addCollection(Collection c) {
    CollectionRepository repo = CollectionRepository();
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
