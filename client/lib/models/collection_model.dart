import 'package:realm/realm.dart';

part 'collection_model.g.dart';

@RealmModel()
class _Collection {
  @PrimaryKey()
  late String id;
  late String name;
  late String path;
  late String type;
  late String scanner;
  late String scanStatus;
  //oauth tokens for external systems
  late String? oauthService;
  late String? accessToken;
  late String? refreshToken;
  late String? idToken;
  late String? userId;
  late DateTime? expiration;
  late DateTime? lastScanDate;
  @Ignored()
  late String status = '';
  @Ignored()
  late String statusMessage = '';
  late bool needsReAuth = false;
}
