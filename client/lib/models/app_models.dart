import 'package:realm/realm.dart';

part 'app_models.g.dart';

//
//Global Models
//
@RealmModel()
class _Apps {
  @PrimaryKey()
  late String id;
  late String name;
  late String slug; //l10n safe name
  String group = "collections"; //collection or app
  int order = 0; //order in drawer
  int? icon;
  String route = "/";
}

@RealmModel()
class _AppUser {
  @PrimaryKey()
  late String id;
  late String name;
  late String email;
  late String password;
  late String localStoragePath;
  @Ignored()
  late String privateKey = '';
  @Ignored()
  late String publicKey = '';
}
