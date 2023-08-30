import 'package:client/models/app_models.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:client/repositories/realm_repository.dart';

class GetUserExistsService extends RxService<GetUserExistsServiceCommand, AppUser?> {
  static final GetUserExistsService _instance = GetUserExistsService();
  static get instance => _instance;

  @override
  Future<AppUser?> invoke(GetUserExistsServiceCommand command) {
    isLoading.add(true);
    UserRepository repo = UserRepository(RealmRepository.instance.database);
    AppUser? user = repo.userExists();
    sink.add(user);
    isLoading.add(false);

    return Future(() => user);
  }
}

class GetUserExistsServiceCommand implements RxCommand {}
