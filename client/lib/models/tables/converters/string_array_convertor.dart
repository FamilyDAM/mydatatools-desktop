// stores preferences as strings
import 'package:drift/drift.dart';

class StringArrayConverter extends TypeConverter<List<String>, String> {
  const StringArrayConverter();

  @override
  List<String> fromSql(String fromDb) {
    return fromDb.split(",");
  }

  @override
  String toSql(List<String> value) {
    return value.join(",");
  }
}
