import 'package:client/models/tables/app_user.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';

class GetUsersService extends RxService<GetUsersServiceCommand, List<AppUser>> {
  static final GetUsersService _instance = GetUsersService();
  static get instance => _instance;

  @override
  Future<List<AppUser>> invoke(GetUsersServiceCommand command) async {
    isLoading.add(true);
    UserRepository repo = UserRepository(DatabaseRepository.instance!.database);
    List<AppUser> users = await repo.users();
    sink.add(users);
    isLoading.add(false);
    return Future(() => users);
  }
}

class GetUsersServiceCommand implements RxCommand {}
