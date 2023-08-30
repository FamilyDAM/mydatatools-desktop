import 'package:client/models/module_models.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

class PhotosRepository {
  Realm database;
  PhotosRepository(this.database);

  List<File> photos() {
    return database.query<File>("contentType = '${FilesConstants.mimeTypeImage}' SORT(dateCreated DESC)").toList();
  }

  Map<String, List<File>> photosByDate() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    Map<String, List<File>> groupedImages = {};
    List<File> p =
        database.query<File>("contentType = '${FilesConstants.mimeTypeImage}' SORT(dateCreated ASC)").toList();

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
