import 'package:client/models/tables/app_user.dart';
import 'package:client/repositories/user_repository.dart';
import 'package:client/services/rx_service.dart';

class GetUserExistsService extends RxService<GetUserExistsServiceCommand, AppUser?> {
  @override
  Future<AppUser?> invoke(GetUserExistsServiceCommand command) async {
    isLoading.add(true);
    UserRepository repo = UserRepository();
    AppUser? user = await repo.userExists();
    sink.add(user);
    isLoading.add(false);

    return Future(() => user);
  }
}

class GetUserExistsServiceCommand implements RxCommand {}
