// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Folder extends _Folder with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Folder(
    String id,
    String name,
    String path,
    String parent,
    DateTime dateCreated,
    DateTime lastModified,
    String collectionId, {
    String contentType = "folder",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Folder>({
        'contentType': "folder",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'parent', parent);
    RealmObjectBase.set(this, 'dateCreated', dateCreated);
    RealmObjectBase.set(this, 'lastModified', lastModified);
    RealmObjectBase.set(this, 'collectionId', collectionId);
    RealmObjectBase.set(this, 'contentType', contentType);
  }

  Folder._();

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
  String get parent => RealmObjectBase.get<String>(this, 'parent') as String;
  @override
  set parent(String value) => RealmObjectBase.set(this, 'parent', value);

  @override
  DateTime get dateCreated =>
      RealmObjectBase.get<DateTime>(this, 'dateCreated') as DateTime;
  @override
  set dateCreated(DateTime value) =>
      RealmObjectBase.set(this, 'dateCreated', value);

  @override
  DateTime get lastModified =>
      RealmObjectBase.get<DateTime>(this, 'lastModified') as DateTime;
  @override
  set lastModified(DateTime value) =>
      RealmObjectBase.set(this, 'lastModified', value);

  @override
  String get collectionId =>
      RealmObjectBase.get<String>(this, 'collectionId') as String;
  @override
  set collectionId(String value) =>
      RealmObjectBase.set(this, 'collectionId', value);

  @override
  String get contentType =>
      RealmObjectBase.get<String>(this, 'contentType') as String;
  @override
  set contentType(String value) =>
      RealmObjectBase.set(this, 'contentType', value);

  @override
  Stream<RealmObjectChanges<Folder>> get changes =>
      RealmObjectBase.getChanges<Folder>(this);

  @override
  Folder freeze() => RealmObjectBase.freezeObject<Folder>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Folder._);
    return const SchemaObject(ObjectType.realmObject, Folder, 'Folder', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('parent', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('dateCreated', RealmPropertyType.timestamp),
      SchemaProperty('lastModified', RealmPropertyType.timestamp),
      SchemaProperty('collectionId', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('contentType', RealmPropertyType.string),
    ]);
  }
}

class File extends _File with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  File(
    String id,
    String collectionId,
    String name,
    String path,
    String parent,
    DateTime dateCreated,
    DateTime lastModified,
    int size,
    String contentType, {
    String? thumbnail,
    bool isDeleted = false,
    double? latitude,
    double? longitude,
    Iterable<int> embeddings = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<File>({
        'isDeleted': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'collectionId', collectionId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'parent', parent);
    RealmObjectBase.set(this, 'dateCreated', dateCreated);
    RealmObjectBase.set(this, 'lastModified', lastModified);
    RealmObjectBase.set(this, 'size', size);
    RealmObjectBase.set(this, 'contentType', contentType);
    RealmObjectBase.set(this, 'thumbnail', thumbnail);
    RealmObjectBase.set(this, 'isDeleted', isDeleted);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set<RealmList<int>>(
        this, 'embeddings', RealmList<int>(embeddings));
  }

  File._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get collectionId =>
      RealmObjectBase.get<String>(this, 'collectionId') as String;
  @override
  set collectionId(String value) =>
      RealmObjectBase.set(this, 'collectionId', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get path => RealmObjectBase.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObjectBase.set(this, 'path', value);

  @override
  String get parent => RealmObjectBase.get<String>(this, 'parent') as String;
  @override
  set parent(String value) => RealmObjectBase.set(this, 'parent', value);

  @override
  DateTime get dateCreated =>
      RealmObjectBase.get<DateTime>(this, 'dateCreated') as DateTime;
  @override
  set dateCreated(DateTime value) =>
      RealmObjectBase.set(this, 'dateCreated', value);

  @override
  DateTime get lastModified =>
      RealmObjectBase.get<DateTime>(this, 'lastModified') as DateTime;
  @override
  set lastModified(DateTime value) =>
      RealmObjectBase.set(this, 'lastModified', value);

  @override
  int get size => RealmObjectBase.get<int>(this, 'size') as int;
  @override
  set size(int value) => RealmObjectBase.set(this, 'size', value);

  @override
  RealmList<int> get embeddings =>
      RealmObjectBase.get<int>(this, 'embeddings') as RealmList<int>;
  @override
  set embeddings(covariant RealmList<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get contentType =>
      RealmObjectBase.get<String>(this, 'contentType') as String;
  @override
  set contentType(String value) =>
      RealmObjectBase.set(this, 'contentType', value);

  @override
  String? get thumbnail =>
      RealmObjectBase.get<String>(this, 'thumbnail') as String?;
  @override
  set thumbnail(String? value) => RealmObjectBase.set(this, 'thumbnail', value);

  @override
  bool get isDeleted => RealmObjectBase.get<bool>(this, 'isDeleted') as bool;
  @override
  set isDeleted(bool value) => RealmObjectBase.set(this, 'isDeleted', value);

  @override
  double? get latitude =>
      RealmObjectBase.get<double>(this, 'latitude') as double?;
  @override
  set latitude(double? value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  double? get longitude =>
      RealmObjectBase.get<double>(this, 'longitude') as double?;
  @override
  set longitude(double? value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  Stream<RealmObjectChanges<File>> get changes =>
      RealmObjectBase.getChanges<File>(this);

  @override
  File freeze() => RealmObjectBase.freezeObject<File>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(File._);
    return const SchemaObject(ObjectType.realmObject, File, 'File', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('collectionId', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('parent', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('dateCreated', RealmPropertyType.timestamp),
      SchemaProperty('lastModified', RealmPropertyType.timestamp),
      SchemaProperty('size', RealmPropertyType.int),
      SchemaProperty('embeddings', RealmPropertyType.int,
          collectionType: RealmCollectionType.list),
      SchemaProperty('contentType', RealmPropertyType.string),
      SchemaProperty('thumbnail', RealmPropertyType.string, optional: true),
      SchemaProperty('isDeleted', RealmPropertyType.bool),
      SchemaProperty('latitude', RealmPropertyType.double, optional: true),
      SchemaProperty('longitude', RealmPropertyType.double, optional: true),
    ]);
  }
}

class Email extends _Email with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Email(
    String id,
    String collectionId,
    DateTime date, {
    String? from,
    String? subject,
    String? snippet,
    String? htmlBody,
    String? plainBody,
    String? headers,
    bool isDeleted = false,
    Iterable<String> to = const [],
    Iterable<String> cc = const [],
    Iterable<String> labels = const [],
    Iterable<File> attachments = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Email>({
        'isDeleted': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'collectionId', collectionId);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'from', from);
    RealmObjectBase.set(this, 'subject', subject);
    RealmObjectBase.set(this, 'snippet', snippet);
    RealmObjectBase.set(this, 'htmlBody', htmlBody);
    RealmObjectBase.set(this, 'plainBody', plainBody);
    RealmObjectBase.set(this, 'headers', headers);
    RealmObjectBase.set(this, 'isDeleted', isDeleted);
    RealmObjectBase.set<RealmList<String>>(this, 'to', RealmList<String>(to));
    RealmObjectBase.set<RealmList<String>>(this, 'cc', RealmList<String>(cc));
    RealmObjectBase.set<RealmList<String>>(
        this, 'labels', RealmList<String>(labels));
    RealmObjectBase.set<RealmList<File>>(
        this, 'attachments', RealmList<File>(attachments));
  }

  Email._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get collectionId =>
      RealmObjectBase.get<String>(this, 'collectionId') as String;
  @override
  set collectionId(String value) =>
      RealmObjectBase.set(this, 'collectionId', value);

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  String? get from => RealmObjectBase.get<String>(this, 'from') as String?;
  @override
  set from(String? value) => RealmObjectBase.set(this, 'from', value);

  @override
  RealmList<String> get to =>
      RealmObjectBase.get<String>(this, 'to') as RealmList<String>;
  @override
  set to(covariant RealmList<String> value) => throw RealmUnsupportedSetError();

  @override
  RealmList<String> get cc =>
      RealmObjectBase.get<String>(this, 'cc') as RealmList<String>;
  @override
  set cc(covariant RealmList<String> value) => throw RealmUnsupportedSetError();

  @override
  String? get subject =>
      RealmObjectBase.get<String>(this, 'subject') as String?;
  @override
  set subject(String? value) => RealmObjectBase.set(this, 'subject', value);

  @override
  String? get snippet =>
      RealmObjectBase.get<String>(this, 'snippet') as String?;
  @override
  set snippet(String? value) => RealmObjectBase.set(this, 'snippet', value);

  @override
  String? get htmlBody =>
      RealmObjectBase.get<String>(this, 'htmlBody') as String?;
  @override
  set htmlBody(String? value) => RealmObjectBase.set(this, 'htmlBody', value);

  @override
  String? get plainBody =>
      RealmObjectBase.get<String>(this, 'plainBody') as String?;
  @override
  set plainBody(String? value) => RealmObjectBase.set(this, 'plainBody', value);

  @override
  RealmList<String> get labels =>
      RealmObjectBase.get<String>(this, 'labels') as RealmList<String>;
  @override
  set labels(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get headers =>
      RealmObjectBase.get<String>(this, 'headers') as String?;
  @override
  set headers(String? value) => RealmObjectBase.set(this, 'headers', value);

  @override
  RealmList<File> get attachments =>
      RealmObjectBase.get<File>(this, 'attachments') as RealmList<File>;
  @override
  set attachments(covariant RealmList<File> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool get isDeleted => RealmObjectBase.get<bool>(this, 'isDeleted') as bool;
  @override
  set isDeleted(bool value) => RealmObjectBase.set(this, 'isDeleted', value);

  @override
  Stream<RealmObjectChanges<Email>> get changes =>
      RealmObjectBase.getChanges<Email>(this);

  @override
  Email freeze() => RealmObjectBase.freezeObject<Email>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Email._);
    return const SchemaObject(ObjectType.realmObject, Email, 'Email', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('collectionId', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
      SchemaProperty('date', RealmPropertyType.timestamp,
          indexType: RealmIndexType.regular),
      SchemaProperty('from', RealmPropertyType.string,
          optional: true, indexType: RealmIndexType.regular),
      SchemaProperty('to', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('cc', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('subject', RealmPropertyType.string, optional: true),
      SchemaProperty('snippet', RealmPropertyType.string, optional: true),
      SchemaProperty('htmlBody', RealmPropertyType.string, optional: true),
      SchemaProperty('plainBody', RealmPropertyType.string, optional: true),
      SchemaProperty('labels', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('headers', RealmPropertyType.string, optional: true),
      SchemaProperty('attachments', RealmPropertyType.object,
          linkTarget: 'File', collectionType: RealmCollectionType.list),
      SchemaProperty('isDeleted', RealmPropertyType.bool),
    ]);
  }
}
