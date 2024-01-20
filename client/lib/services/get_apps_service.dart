import 'package:client/main.dart';
import 'package:client/models/tables/app.dart';
import 'package:client/repositories/app_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/rx_service.dart';

class GetAppsService extends RxService<GetAppsServiceCommand, List<App>> {
  static final GetAppsService _instance = GetAppsService();
  static get instance => _instance;

  AppDatabase? database;

  GetAppsService() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  @override
  Future<List<App>> invoke(GetAppsServiceCommand command) async {
    if (database == null) return Future(() => []);

    isLoading.add(true);
    AppRepository repo = AppRepository();
    List<App> apps = await repo.apps();
    sink.add(apps);
    isLoading.add(false);
    return Future(() => apps);
  }
}

class GetAppsServiceCommand implements RxCommand {}
