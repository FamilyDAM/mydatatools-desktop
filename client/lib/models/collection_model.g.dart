// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Collection extends _Collection
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Collection(
    String id,
    String name,
    String path,
    String type,
    String scanner,
    String scanStatus, {
    String? oauthService,
    String? accessToken,
    String? refreshToken,
    String? idToken,
    String? userId,
    DateTime? expiration,
    DateTime? lastScanDate,
    bool needsReAuth = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Collection>({
        'needsReAuth': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'scanner', scanner);
    RealmObjectBase.set(this, 'scanStatus', scanStatus);
    RealmObjectBase.set(this, 'oauthService', oauthService);
    RealmObjectBase.set(this, 'accessToken', accessToken);
    RealmObjectBase.set(this, 'refreshToken', refreshToken);
    RealmObjectBase.set(this, 'idToken', idToken);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'expiration', expiration);
    RealmObjectBase.set(this, 'lastScanDate', lastScanDate);
    RealmObjectBase.set(this, 'needsReAuth', needsReAuth);
  }

  Collection._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get path => RealmObjectBase.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObjectBase.set(this, 'path', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String get scanner => RealmObjectBase.get<String>(this, 'scanner') as String;
  @override
  set scanner(String value) => RealmObjectBase.set(this, 'scanner', value);

  @override
  String get scanStatus =>
      RealmObjectBase.get<String>(this, 'scanStatus') as String;
  @override
  set scanStatus(String value) =>
      RealmObjectBase.set(this, 'scanStatus', value);

  @override
  String? get oauthService =>
      RealmObjectBase.get<String>(this, 'oauthService') as String?;
  @override
  set oauthService(String? value) =>
      RealmObjectBase.set(this, 'oauthService', value);

  @override
  String? get accessToken =>
      RealmObjectBase.get<String>(this, 'accessToken') as String?;
  @override
  set accessToken(String? value) =>
      RealmObjectBase.set(this, 'accessToken', value);

  @override
  String? get refreshToken =>
      RealmObjectBase.get<String>(this, 'refreshToken') as String?;
  @override
  set refreshToken(String? value) =>
      RealmObjectBase.set(this, 'refreshToken', value);

  @override
  String? get idToken =>
      RealmObjectBase.get<String>(this, 'idToken') as String?;
  @override
  set idToken(String? value) => RealmObjectBase.set(this, 'idToken', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  DateTime? get expiration =>
      RealmObjectBase.get<DateTime>(this, 'expiration') as DateTime?;
  @override
  set expiration(DateTime? value) =>
      RealmObjectBase.set(this, 'expiration', value);

  @override
  DateTime? get lastScanDate =>
      RealmObjectBase.get<DateTime>(this, 'lastScanDate') as DateTime?;
  @override
  set lastScanDate(DateTime? value) =>
      RealmObjectBase.set(this, 'lastScanDate', value);

  @override
  bool get needsReAuth =>
      RealmObjectBase.get<bool>(this, 'needsReAuth') as bool;
  @override
  set needsReAuth(bool value) =>
      RealmObjectBase.set(this, 'needsReAuth', value);

  @override
  Stream<RealmObjectChanges<Collection>> get changes =>
      RealmObjectBase.getChanges<Collection>(this);

  @override
  Collection freeze() => RealmObjectBase.freezeObject<Collection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Collection._);
    return const SchemaObject(
        ObjectType.realmObject, Collection, 'Collection', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('scanner', RealmPropertyType.string),
      SchemaProperty('scanStatus', RealmPropertyType.string),
      SchemaProperty('oauthService', RealmPropertyType.string, optional: true),
      SchemaProperty('accessToken', RealmPropertyType.string, optional: true),
      SchemaProperty('refreshToken', RealmPropertyType.string, optional: true),
      SchemaProperty('idToken', RealmPropertyType.string, optional: true),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
      SchemaProperty('expiration', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lastScanDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('needsReAuth', RealmPropertyType.bool),
    ]);
  }
}
