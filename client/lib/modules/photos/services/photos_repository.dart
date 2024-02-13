import 'package:client/app_logger.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:intl/intl.dart';

class PhotosRepository {
  AppLogger logger = AppLogger(null);

  Future<List<File>> photos() async {
    AppDatabase database = await DatabaseRepository.instance.database;

    return await (database.select(database.files)..where((e) => e.contentType.equals(FilesConstants.mimeTypeImage)))
        .get();
    // TODO add sort  SORT(dateCreated DESC)
  }

  Future<Map<String, List<File>>> photosByDate() async {
    AppDatabase database = await DatabaseRepository.instance.database;

    if (database == null) return Future(() => {});
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    Map<String, List<File>> groupedImages = {};
    List<File> p =
        await (database.select(database.files)..where((e) => e.contentType.equals(FilesConstants.mimeTypeImage))).get();

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
