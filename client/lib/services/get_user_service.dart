import 'package:client/models/app_models.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:client/repositories/realm_repository.dart';

class GetUserService extends RxService<GetUserServiceCommand, AppUser?> {
  static final GetUserService _instance = GetUserService();
  static get instance => _instance;

  @override
  Future<AppUser?> invoke(GetUserServiceCommand command) {
    if (command.password == null) {
      sink.add(null);
      return Future(() => null);
    }
    isLoading.add(true);
    UserRepository repo = UserRepository(RealmRepository.instance.database);
    AppUser? user = repo.user(command.password!);
    sink.add(user);
    isLoading.add(false);
    return Future(() => user);
  }
}

class GetUserServiceCommand implements RxCommand {
  String? password;
  GetUserServiceCommand(this.password);
}
