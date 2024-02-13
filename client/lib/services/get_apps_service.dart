import 'package:client/models/tables/app.dart';
import 'package:client/repositories/app_repository.dart';
import 'package:client/services/rx_service.dart';

class GetAppsService extends RxService<GetAppsServiceCommand, List<App>> {
  static final GetAppsService _singleton = GetAppsService();
  static get instance => _singleton;

  @override
  Future<List<App>> invoke(GetAppsServiceCommand command) async {
    isLoading.add(true);
    AppRepository repo = AppRepository();
    List<App> apps = await repo.apps();
    sink.add(apps);
    isLoading.add(false);
    return Future(() => apps);
  }
}

class GetAppsServiceCommand implements RxCommand {}
