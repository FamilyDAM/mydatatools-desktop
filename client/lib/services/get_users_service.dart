import 'package:client/models/app_models.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:client/repositories/realm_repository.dart';

class GetUsersService extends RxService<GetUsersServiceCommand, List<AppUser>> {
  static final GetUsersService _instance = GetUsersService();
  static get instance => _instance;

  @override
  Future<List<AppUser>> invoke(GetUsersServiceCommand command) {
    isLoading.add(true);
    UserRepository repo = UserRepository(RealmRepository.instance.database);
    List<AppUser> users = repo.users();
    sink.add(users);
    isLoading.add(false);
    return Future(() => users);
  }
}

class GetUsersServiceCommand implements RxCommand {}
