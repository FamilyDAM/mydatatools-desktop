import 'package:client/app_logger.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/repositories/database_repository.dart';

class FileDesktopRepository {
  AppLogger logger = AppLogger(null);

  Future<File?> getByPath(File f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    File? file = await (database.select(database.files)..where((t) => t.path.equals(f.path))).getSingleOrNull();

    if (file == null) return Future(() => null);

    return Future(() => file);
  }

  Future<List<File>> getByParentPath(String path) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    List<File> files = await (database.select(database.files)..where((t) => t.parent.equals(path))).get();

    return Future(() => files);
  }

  Future<File?> create(File f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    await database.into(database.files).insert(f);
    //grab latest
    File file = await (database.select(database.files)..where((t) => t.path.equals(f.path))).getSingle();

    return Future(() => file);
  }

  Future<File?> update(File f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    await database.update(database.files).replace(f);
    //grab latest
    File file = await (database.select(database.files)..where((t) => t.path.equals(f.path))).getSingle();

    return Future(() => file);
  }

  Future<File?> delete(File f) async {
    AppDatabase database = await DatabaseRepository.instance.database;

    await database.delete(database.files).delete(f);
    return Future(() => null);
  }
}
