import 'package:client/models/app_models.dart';
import 'package:client/repositories/app_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:client/repositories/realm_repository.dart';

class GetAppsService extends RxService<GetAppsServiceCommand, List<Apps>> {
  static final GetAppsService _instance = GetAppsService();
  static get instance => _instance;

  @override
  Future<List<Apps>> invoke(GetAppsServiceCommand command) {
    isLoading.add(true);
    AppRepository repo = AppRepository(RealmRepository.instance.database);
    List<Apps> apps = repo.apps();
    sink.add(apps);
    isLoading.add(false);
    return Future(() => apps);
  }
}

class GetAppsServiceCommand implements RxCommand {}
