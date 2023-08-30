import 'package:realm/realm.dart';

part 'module_models.g.dart';

//
//File App Models
//
class FileAsset {
  late String id;
  late String name;
  late String path;
  late String parent;
  late DateTime dateCreated;
  late DateTime lastModified;
  late String collectionId;
}

@RealmModel()
class _Folder implements FileAsset {
  @override
  @PrimaryKey()
  late String id;
  @override
  late String name;
  @override
  @Indexed()
  late String path;
  @override
  @Indexed()
  late String parent;
  @override
  late DateTime dateCreated;
  @override
  late DateTime lastModified;
  @override
  @Indexed()
  late String collectionId;

  String contentType = "folder";
}

@RealmModel()
class _File implements FileAsset {
  @override
  @PrimaryKey()
  late String id;
  @override
  late String name;
  @override
  @Indexed()
  late String path;
  @override
  @Indexed()
  late String parent;
  @override
  late DateTime dateCreated;
  @override
  late DateTime lastModified;
  @override
  @Indexed()
  late String collectionId;

  late int size; //in KB
  late String contentType; //mime/type
  late bool isDeleted = false;
}

@RealmModel()
class _Email {
  @PrimaryKey()
  late String id;
  @Indexed()
  late String collectionId;
  @Indexed()
  late DateTime date;
  @Indexed()
  late String? from;
  late List<String> to = [];
  late List<String> cc = [];
  late String? subject;
  late String? snippet;
  late String? htmlBody;
  late String? plainBody;
  late List<String> labels = [];
  late String? headers;
  late List<_File> attachments = [];
  late bool isDeleted = false;

  @Ignored()
  bool isSelected = false;

  @override
  String toString() {
    return '_Email{id: $id, from: $from, to: $to, cc: $cc, subject: $subject}';
  } //json of map
}
