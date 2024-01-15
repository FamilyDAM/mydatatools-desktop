import 'package:client/models/tables/file_asset.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

//part 'folder.g.dart';

@UseRowClass(Folder, constructor: 'fromDb')
@TableIndex(name: 'folder_path_idx', columns: {#path})
@TableIndex(name: 'folder_parent_idx', columns: {#parent})
@TableIndex(name: 'folder_collection_id_idx', columns: {#collectionId})
class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get parent => text()();
  DateTimeColumn get dateCreated => dateTime()();
  DateTimeColumn get dateLastModified => dateTime()();
  TextColumn get collectionId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folder implements FileAsset, Insertable<Folder> {
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

  Folder(
      {required this.id,
      required this.name,
      required this.path,
      required this.parent,
      required this.dateCreated,
      required this.dateLastModified,
      required this.collectionId});

  Folder.fromDb(
      {required this.id,
      required this.name,
      required this.path,
      required this.parent,
      required this.dateCreated,
      required this.dateLastModified,
      required this.collectionId});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return FoldersCompanion(
            id: Value(id),
            name: Value(name),
            path: Value(path),
            parent: Value(parent),
            dateCreated: Value(dateCreated),
            dateLastModified: Value(dateLastModified),
            collectionId: Value(collectionId))
        .toColumns(nullToAbsent);
  }
}
