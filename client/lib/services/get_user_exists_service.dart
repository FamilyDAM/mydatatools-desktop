import 'package:client/main.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';

class GetUserExistsService extends RxService<GetUserExistsServiceCommand, AppUser?> {
  static final GetUserExistsService _instance = GetUserExistsService();
  static get instance => _instance;

  AppDatabase? database;

  GetUserExistsService() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  @override
  Future<AppUser?> invoke(GetUserExistsServiceCommand command) async {
    if (database == null) return Future(() => null);

    isLoading.add(true);
    UserRepository repo = UserRepository();
    AppUser? user = await repo.userExists();
    sink.add(user);
    isLoading.add(false);

    return Future(() => user);
  }
}

class GetUserExistsServiceCommand implements RxCommand {}
