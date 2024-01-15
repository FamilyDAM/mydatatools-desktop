import 'package:client/models/tables/file_asset.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

//part 'file.g.dart';

@UseRowClass(File, constructor: 'fromDb')
@TableIndex(name: 'file_path_idx', columns: {#path})
@TableIndex(name: 'file_parent_idx', columns: {#parent})
@TableIndex(name: 'file_collection_id_idx', columns: {#collectionId})
@TableIndex(name: 'file_contenttype_idx', columns: {#contentType})
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get parent => text()();
  DateTimeColumn get dateCreated => dateTime()();
  DateTimeColumn get dateLastModified => dateTime()();
  TextColumn get collectionId => text()();
  TextColumn get contentType => text()();
  IntColumn get size => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get thumbnail => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class File implements FileAsset, Insertable<File> {
  @override
  String id;
  @override
  String name;
  @override
  String path;
  @override
  String parent;
  @override
  DateTime dateCreated;
  @override
  DateTime dateLastModified;
  @override
  String collectionId;
  String contentType; //mime/type
  int size;
  bool isDeleted;
  String? thumbnail;
  double? latitude;
  double? longitude;

  File({
    required this.id,
    required this.name,
    required this.path,
    required this.parent,
    required this.dateCreated,
    required this.dateLastModified,
    required this.collectionId,
    required this.contentType,
    required this.size,
    required this.isDeleted,
    this.thumbnail,
    this.latitude,
    this.longitude,
  });

  File.fromDb({
    required this.id,
    required this.name,
    required this.path,
    required this.parent,
    required this.dateCreated,
    required this.dateLastModified,
    required this.collectionId,
    required this.contentType,
    required this.size,
    required this.isDeleted,
    this.thumbnail,
    this.latitude,
    this.longitude,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return FilesCompanion(
      id: Value(id),
      name: Value(name),
      path: Value(path),
      parent: Value(parent),
      dateCreated: Value(dateCreated),
      dateLastModified: Value(dateLastModified),
      collectionId: Value(collectionId),
      contentType: Value(contentType),
      size: Value(size),
      isDeleted: Value(isDeleted),
      thumbnail: Value(thumbnail),
      latitude: Value(latitude),
      longitude: Value(longitude),
    ).toColumns(nullToAbsent);
  }
}
