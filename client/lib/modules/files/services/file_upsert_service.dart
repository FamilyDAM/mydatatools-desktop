import 'package:client/models/tables/file.dart';
import 'package:client/modules/files/services/repositories/file_desktop_repository.dart';
import 'package:client/services/rx_service.dart';
import 'package:flutter/material.dart';

class FileUpsertService extends RxService<FileUpsertServiceCommand, File> {
  static final FileUpsertService _singleton = FileUpsertService();
  static get instance => _singleton;

  @override
  Future<File> invoke(FileUpsertServiceCommand command) async {
    isLoading.add(true);

    FileDesktopRepository repo = FileDesktopRepository();

    File? file;
    try {
      file = await repo.getByPath(command.file);
      if (file == null) {
        file = await repo.create(command.file);
        sink.add(file!);
      } else {
        file = await repo.update(command.file);
        sink.add(file!);
      }
      return Future(() => file!);
    } catch (err) {
      debugPrint(err.toString());
    }
    //UserRepository repo = UserRepository();
    //AppUser? user = await repo.user(command.password!);
    isLoading.add(false);
    return Future(() => command.file);
  }
}

class FileUpsertServiceCommand implements RxCommand {
  File file;
  FileUpsertServiceCommand(this.file);
}
