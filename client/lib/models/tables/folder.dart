import 'package:client/models/tables/file_asset.dart';
import 'package:drift/drift.dart';

part 'folder.g.dart';

@UseRowClass(Folder, constructor: 'fromDb')
@TableIndex(name: 'folder_path_idx', columns: {#path})
@TableIndex(name: 'folder_parent_idx', columns: {#parent})
@TableIndex(name: 'folder_collectionid_idx', columns: {#collectionId})
class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get parent => text()();
  DateTimeColumn get dateCreated => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  TextColumn get collectionId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folder implements FileAsset {
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

  //not in db
  String contentType = "folder";

  Folder.fromDb(
      {required this.id,
      required this.name,
      required this.path,
      required this.parent,
      required this.dateCreated,
      required this.lastModified,
      required this.collectionId});
}
