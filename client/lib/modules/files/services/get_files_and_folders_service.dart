import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart';
import 'package:client/modules/files/services/file_system_repository.dart';
import 'package:client/modules/files/services/scanners/local_file_scanner.dart';
import 'package:client/services/rx_service.dart';
import 'package:client/repositories/realm_repository.dart';

class GetFileAndFoldersService extends RxService<GetFileServiceCommand, List<FileAsset>> {
  final AppLogger logger = AppLogger();

  static final GetFileAndFoldersService _instance = GetFileAndFoldersService();
  static get instance => _instance;

  @override
  Future<List<FileAsset>> invoke(GetFileServiceCommand command) async {
    isLoading.add(true);
    FileSystemRepository repo =
        FileSystemRepository(RealmRepository.instance.database, command.collection.id, command.path);

    //first refresh folders
    LocalFileScanner(repo.database, command.collection, 0).scanDirectory(command.path).then((value) {
      if (value > 0) {
        logger.s("reloading with $value saved files");
        List<FileAsset> filesAndFoldersList = _refreshFiles(repo, command.collection.id, command.path);
        sink.add(filesAndFoldersList);
      }
    });

    //load files and folders from db
    List<FileAsset> filesAndFoldersList = _refreshFiles(repo, command.collection.id, command.path);
    sink.add(filesAndFoldersList);
    isLoading.add(false);

    return Future(() => filesAndFoldersList);
  }

  List<FileAsset> _refreshFiles(FileSystemRepository repo, String collectionId, String? parentPath) {
    List<FileAsset> filesAndFoldersList = [];
    if (parentPath == null) {
      filesAndFoldersList.addAll(repo.foldersByCollection(collectionId).cast<Folder>());
    } else {
      filesAndFoldersList.addAll(repo.folders(collectionId, parentPath));
    }

    if (parentPath == null) {
      filesAndFoldersList.addAll(repo.filesByCollection(collectionId).cast<File>());
    } else {
      filesAndFoldersList.addAll(repo.files(collectionId, parentPath));
    }

    return filesAndFoldersList;
  }
}

class GetFileServiceCommand implements RxCommand {
  Collection collection;
  String path;

  GetFileServiceCommand(this.collection, this.path);
}
