import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/file_asset.dart';
import 'package:client/modules/files/services/file_system_repository.dart';
import 'package:client/modules/files/services/scanners/local_file_scanner.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/rx_service.dart';

class GetFileAndFoldersService extends RxService<GetFileServiceCommand, List<FileAsset>> {
  final AppLogger logger = AppLogger(null);

  static final GetFileAndFoldersService _instance = GetFileAndFoldersService();
  static get instance => _instance;

  AppDatabase? database;

  GetFileAndFoldersService() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  @override
  Future<List<FileAsset>> invoke(GetFileServiceCommand command) async {
    if (database == null) return Future(() => []);

    isLoading.add(true);
    FileSystemRepository repo = FileSystemRepository();

    //first refresh folders
    LocalFileScanner(repo.database!.path!).start(command.collection, command.path, false, true).then((value) async {
      if (value > 0) {
        logger.s("reloading with $value saved files");
        List<FileAsset> filesAndFoldersList = await _refreshFiles(repo, command.collection.id, command.path);
        sink.add(filesAndFoldersList);
      }
    });

    //load files and folders from db
    List<FileAsset> filesAndFoldersList = await _refreshFiles(repo, command.collection.id, command.path);
    sink.add(filesAndFoldersList);
    isLoading.add(false);

    return Future(() => filesAndFoldersList);
  }

  Future<List<FileAsset>> _refreshFiles(FileSystemRepository repo, String collectionId, String? parentPath) async {
    List<FileAsset> filesAndFoldersList = [];
    if (parentPath == null) {
      filesAndFoldersList.addAll(await repo.foldersByCollection(collectionId));
    } else {
      filesAndFoldersList.addAll(await repo.folders(collectionId, parentPath));
    }

    if (parentPath == null) {
      filesAndFoldersList.addAll(await repo.filesByCollection(collectionId));
    } else {
      filesAndFoldersList.addAll(await repo.files(collectionId, parentPath));
    }

    return filesAndFoldersList;
  }
}

class GetFileServiceCommand implements RxCommand {
  Collection collection;
  String path;

  GetFileServiceCommand(this.collection, this.path);
}
