import 'package:drift/drift.dart';

part 'app.g.dart';

class App extends Table {
  TextColumn get id => text().unique()();
  TextColumn get name => text()();
  TextColumn get slug => text().unique()(); //l10n safe name
  TextColumn get group => text().withDefault(const Constant("collections"))(); //collection or app
  IntColumn get order => integer().withDefault(const Constant(0))(); //order in drawer
  IntColumn get icon => integer().nullable()();
  TextColumn get route => text().withDefault(const Constant("/"))();
}
