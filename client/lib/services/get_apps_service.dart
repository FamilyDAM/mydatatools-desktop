import 'package:client/models/tables/app.dart';
import 'package:client/repositories/app_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/rx_service.dart';

class GetAppsService extends RxService<GetAppsServiceCommand, List<App>> {
  static final GetAppsService _instance = GetAppsService();
  static get instance => _instance;

  @override
  Future<List<App>> invoke(GetAppsServiceCommand command) async {
    isLoading.add(true);
    AppRepository repo = AppRepository(DatabaseRepository.instance.database!);
    List<App> apps = await repo.apps();
    sink.add(apps);
    isLoading.add(false);
    return Future(() => apps);
  }
}

class GetAppsServiceCommand implements RxCommand {}
