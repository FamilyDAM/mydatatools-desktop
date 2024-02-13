import 'package:client/models/tables/folder.dart';
import 'package:client/modules/files/services/repositories/folder_desktop_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:flutter/material.dart';

class FolderUpsertService extends RxService<FolderUpsertServiceCommand, Folder?> {
  static final FolderUpsertService _singleton = FolderUpsertService();
  static get instance => _singleton;

  @override
  Future<Folder?> invoke(FolderUpsertServiceCommand command) async {
    // AppDatabase database = await DatabaseRepository.instance.database;

    isLoading.add(true);

    FolderDesktopRepository repo = FolderDesktopRepository();

    Folder? folder;
    try {
      folder = await repo.getByPath(command.folder);
      if (folder == null) {
        folder = await repo.create(command.folder);
      } else {
        folder = await repo.update(command.folder);
      }
      sink.add(folder);
    } catch (err) {
      debugPrint(err.toString());
    }
    //UserRepository repo = UserRepository();
    //AppUser? user = await repo.user(command.password!);
    isLoading.add(false);
    return Future(() => folder);
  }
}

class FolderUpsertServiceCommand implements RxCommand {
  Folder folder;
  FolderUpsertServiceCommand(this.folder);
}
