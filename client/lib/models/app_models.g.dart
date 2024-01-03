// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Apps extends _Apps with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Apps(
    String id,
    String name,
    String slug, {
    String group = "collections",
    int order = 0,
    int? icon,
    String route = "/",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Apps>({
        'group': "collections",
        'order': 0,
        'route': "/",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'slug', slug);
    RealmObjectBase.set(this, 'group', group);
    RealmObjectBase.set(this, 'order', order);
    RealmObjectBase.set(this, 'icon', icon);
    RealmObjectBase.set(this, 'route', route);
  }

  Apps._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get slug => RealmObjectBase.get<String>(this, 'slug') as String;
  @override
  set slug(String value) => RealmObjectBase.set(this, 'slug', value);

  @override
  String get group => RealmObjectBase.get<String>(this, 'group') as String;
  @override
  set group(String value) => RealmObjectBase.set(this, 'group', value);

  @override
  int get order => RealmObjectBase.get<int>(this, 'order') as int;
  @override
  set order(int value) => RealmObjectBase.set(this, 'order', value);

  @override
  int? get icon => RealmObjectBase.get<int>(this, 'icon') as int?;
  @override
  set icon(int? value) => RealmObjectBase.set(this, 'icon', value);

  @override
  String get route => RealmObjectBase.get<String>(this, 'route') as String;
  @override
  set route(String value) => RealmObjectBase.set(this, 'route', value);

  @override
  Stream<RealmObjectChanges<Apps>> get changes =>
      RealmObjectBase.getChanges<Apps>(this);

  @override
  Apps freeze() => RealmObjectBase.freezeObject<Apps>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Apps._);
    return const SchemaObject(ObjectType.realmObject, Apps, 'Apps', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('slug', RealmPropertyType.string),
      SchemaProperty('group', RealmPropertyType.string),
      SchemaProperty('order', RealmPropertyType.int),
      SchemaProperty('icon', RealmPropertyType.int, optional: true),
      SchemaProperty('route', RealmPropertyType.string),
    ]);
  }
}

class AppUser extends _AppUser with RealmEntity, RealmObjectBase, RealmObject {
  AppUser(
    String id,
    String name,
    String email,
    String password,
    String localStoragePath,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'password', password);
    RealmObjectBase.set(this, 'localStoragePath', localStoragePath);
  }

  AppUser._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get password =>
      RealmObjectBase.get<String>(this, 'password') as String;
  @override
  set password(String value) => RealmObjectBase.set(this, 'password', value);

  @override
  String get localStoragePath =>
      RealmObjectBase.get<String>(this, 'localStoragePath') as String;
  @override
  set localStoragePath(String value) =>
      RealmObjectBase.set(this, 'localStoragePath', value);

  @override
  Stream<RealmObjectChanges<AppUser>> get changes =>
      RealmObjectBase.getChanges<AppUser>(this);

  @override
  AppUser freeze() => RealmObjectBase.freezeObject<AppUser>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(AppUser._);
    return const SchemaObject(ObjectType.realmObject, AppUser, 'AppUser', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('password', RealmPropertyType.string),
      SchemaProperty('localStoragePath', RealmPropertyType.string),
    ]);
  }
}
