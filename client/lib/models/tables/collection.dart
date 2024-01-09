import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

part 'collection.g.dart';

@UseRowClass(Collection, constructor: 'fromDb')
@TableIndex(name: 'collections_id_idx', columns: {#id})
@TableIndex(name: 'collections_path_idx', columns: {#path})
@TableIndex(name: 'collections_type_idx', columns: {#type})
class Collections extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get type => text()();
  TextColumn get scanner => text()();
  TextColumn get scanStatus => text()();
  //oauth tokens for external systems
  TextColumn get oauthService => text().nullable()();
  TextColumn get accessToken => text().nullable()();
  TextColumn get refreshToken => text().nullable()();
  TextColumn get idToken => text().nullable()();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get expiration => dateTime().nullable()();
  DateTimeColumn get lastScanDate => dateTime().nullable()();
  BoolColumn get needsReAuth => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class Collection implements Insertable<Collection> {
  String id;
  String name;
  String path;
  String type;
  String scanner;
  String scanStatus;
  //oauth tokens for external systems
  String? oauthService;
  String? accessToken;
  String? refreshToken;
  String? idToken;
  String? userId;
  DateTime? expiration;
  DateTime? lastScanDate;
  bool needsReAuth = false;

  // fields not in db
  String? status;
  String? statusMessage;

  Collection(
      this.id,
      this.name,
      this.path,
      this.type,
      this.scanner,
      this.scanStatus,
      this.oauthService,
      this.accessToken,
      this.refreshToken,
      this.idToken,
      this.userId,
      this.expiration,
      this.lastScanDate,
      this.needsReAuth);

  Collection.fromDb(
      {required this.id,
      required this.name,
      required this.path,
      required this.type,
      required this.scanner,
      required this.scanStatus,
      this.oauthService,
      this.accessToken,
      this.refreshToken,
      this.idToken,
      this.userId,
      this.expiration,
      this.lastScanDate,
      required this.needsReAuth});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return CollectionsCompanion(
            id: Value(id),
            name: Value(name),
            path: Value(path),
            type: Value(type),
            scanner: Value(scanner),
            scanStatus: Value(scanStatus),
            oauthService: Value(oauthService),
            accessToken: Value(accessToken),
            refreshToken: Value(refreshToken),
            idToken: Value(idToken),
            userId: Value(userId),
            expiration: Value(expiration),
            lastScanDate: Value(lastScanDate),
            needsReAuth: Value(needsReAuth))
        .toColumns(nullToAbsent);
  }
}
