import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:intl/intl.dart';

class PhotosRepository {
  static PhotosRepository get instance => PhotosRepository();

  AppDatabase? database;
  AppLogger logger = AppLogger(null);

  PhotosRepository() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  Future<List<File>> photos() async {
    if (database == null) return Future(() => []);

    return await (database!.select(database!.files)..where((e) => e.contentType.equals(FilesConstants.mimeTypeImage)))
        .get();
    // TODO add sort  SORT(dateCreated DESC)
  }

  Future<Map<String, List<File>>> photosByDate() async {
    if (database == null) return Future(() => {});
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    Map<String, List<File>> groupedImages = {};
    List<File> p = await (database!.select(database!.files)
          ..where((e) => e.contentType.equals(FilesConstants.mimeTypeImage)))
        .get();

    // TODO add sort SORT(dateCreated ASC)

    for (var f in p) {
      String group = dateFormat.format(f.dateCreated);

      if (groupedImages[group] == null) {
        groupedImages[group] = [];
      }
      List<File>? groupList = groupedImages[group];
      groupList?.add(f);
    }

    return groupedImages;
  }
}
