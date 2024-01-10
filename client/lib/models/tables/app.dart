import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

part 'app.g.dart';

@UseRowClass(App, constructor: 'fromDb')
class Apps extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slug => text().unique()(); //l10n safe name
  TextColumn get group => text().withDefault(const Constant("collections"))(); //collection or app
  IntColumn get order => integer().withDefault(const Constant(0))(); //order in drawer
  IntColumn get icon => integer().nullable()();
  TextColumn get route => text().withDefault(const Constant("/"))();

  @override
  Set<Column> get primaryKey => {id};
}

class App implements Insertable<App> {
  late String id;
  late String name;
  late String slug; //l10n safe name
  String group = "collections"; //collection or app
  int order = 0; //order in drawer
  int? icon;
  String route = "/";

  App(
      {required this.id,
      required this.name,
      required this.slug,
      required this.group,
      required this.order,
      this.icon,
      required this.route});

  App.fromDb(
      {required this.id,
      required this.name,
      required this.slug,
      required this.group,
      required this.order,
      this.icon,
      required this.route});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return AppsCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      group: Value(group),
      order: Value(order),
      icon: Value(icon),
      route: Value(route),
    ).toColumns(nullToAbsent);
  }
}
