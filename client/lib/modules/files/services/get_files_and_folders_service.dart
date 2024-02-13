import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/file_asset.dart';
import 'package:client/modules/files/services/repositories/file_desktop_repository.dart';
import 'package:client/modules/files/services/repositories/folder_desktop_repository.dart';
import 'package:client/services/rx_service.dart';

class GetFileAndFoldersService extends RxService<GetFileAndFoldersServiceCommand, List<FileAsset>> {
  static final GetFileAndFoldersService _singleton = GetFileAndFoldersService();
  static get instance => _singleton;
  AppLogger logger = AppLogger(null);

  @override
  Future<List<FileAsset>> invoke(GetFileAndFoldersServiceCommand command) async {
    isLoading.add(true);
    FileDesktopRepository fileRepo = FileDesktopRepository();
    FolderDesktopRepository folderRepo = FolderDesktopRepository();

    // TODO: first refresh files & folders under path
    //ScannerManager.getInstance().getScanner(command.collection).

    List<FileAsset> files = await fileRepo.getByParentPath(command.path);
    List<FileAsset> folders = await folderRepo.getByParentPath(command.path);

    List<FileAsset> assets = [...files, ...folders];

    sink.add(assets);
    isLoading.add(false);

    return Future(() => files);
  }
}

class GetFileAndFoldersServiceCommand implements RxCommand {
  Collection collection;
  String path;

  GetFileAndFoldersServiceCommand(this.collection, this.path);
}
