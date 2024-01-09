import 'package:client/models/tables/file_asset.dart';
import 'package:drift/drift.dart';

part 'file.g.dart';

@UseRowClass(File, constructor: 'fromDb')
@TableIndex(name: 'file_path_idx', columns: {#path})
@TableIndex(name: 'file_parent_idx', columns: {#parent})
@TableIndex(name: 'file_collectionid_idx', columns: {#collectionId})
@TableIndex(name: 'file_contenttype_idx', columns: {#contentType})
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get parent => text()();
  DateTimeColumn get dateCreated => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  TextColumn get collectionId => text()();
  TextColumn get contentType => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class File implements FileAsset {
  @override
  late String id;
  @override
  late String name;
  @override
  late String path;
  @override
  late String parent;
  @override
  late DateTime dateCreated;
  @override
  late DateTime lastModified;
  @override
  late String collectionId;

  late String contentType; //mime/type

  File.fromDb(
      {required this.id,
      required this.name,
      required this.path,
      required this.parent,
      required this.dateCreated,
      required this.lastModified,
      required this.collectionId,
      required this.contentType});
}
