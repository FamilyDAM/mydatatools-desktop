import 'package:client/app_logger.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/repositories/database_repository.dart';

class FolderDesktopRepository {
  AppLogger logger = AppLogger(null);

  Future<Folder?> getByPath(Folder f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    Folder? folder = await (database.select(database.folders)..where((t) => t.path.equals(f.path))).getSingleOrNull();

    if (folder == null) return Future(() => null);

    return Future(() => folder);
  }

  Future<List<Folder>> getByParentPath(String path) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    List<Folder> folders = await (database.select(database.folders)..where((t) => t.parent.equals(path))).get();

    return Future(() => folders);
  }

  Future<Folder?> create(Folder f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    await database.into(database.folders).insert(f);
    //grab latest
    Folder folder = await (database.select(database.folders)..where((t) => t.path.equals(f.path))).getSingle();

    return Future(() => folder);
  }

  Future<Folder?> update(Folder f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    await database.update(database.folders).replace(f);
    //grab latest
    Folder folder = await (database.select(database.folders)..where((t) => t.path.equals(f.path))).getSingle();

    return Future(() => folder);
  }

  Future<Folder?> delete(Folder f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    await database.delete(database.folders).delete(f);
    return Future(() => null);
  }
}
