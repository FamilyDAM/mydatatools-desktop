import 'package:realm/realm.dart';

part 'photo_models.g.dart';

//
//File App Models
//
@RealmModel()
class _Album {
  @PrimaryKey()
  late ObjectId id;
  late String name;
}
