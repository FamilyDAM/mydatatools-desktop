import 'package:client/main.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';

class GetUserService extends RxService<GetUserServiceCommand, AppUser?> {
  static final GetUserService _instance = GetUserService();
  static get instance => _instance;

  AppDatabase? database;

  GetUserService() {
    database = MainApp.appDatabase.value;
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  @override
  Future<AppUser?> invoke(GetUserServiceCommand command) async {
    if (database == null) return Future(() => null);

    if (command.password == null) {
      sink.add(null);
      return Future(() => null);
    }
    isLoading.add(true);
    UserRepository repo = UserRepository();
    AppUser? user = await repo.user(command.password!);
    sink.add(user);
    isLoading.add(false);
    return Future(() => user);
  }
}

class GetUserServiceCommand implements RxCommand {
  String? password;
  GetUserServiceCommand(this.password);
}
