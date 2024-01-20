import 'dart:io' as io;

import 'package:client/app_logger.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

// TODO: create Unit Test for this
class FileSystemRepository {
  static FileSystemRepository get instance => FileSystemRepository();

  AppDatabase? database;
  AppLogger logger = AppLogger(null);

  //list of file paths and their size, so we can compare when looking for new or changed files.
  Map<String, DateTime> existingFiles = <String, DateTime>{};
  Map<String, DateTime> existingFolders = <String, DateTime>{};

  FileSystemRepository() {
    MainApp.appDatabase.listen((value) {
      database = value;
    });
  }

  ///
  /// Folder Specific Methods
  ///

  Future<List<Folder>> folders(String collectionId, String parentPath) async {
    if (database == null) return Future(() => []);

    return await ((database!.select(database!.folders)..where((e) => e.collectionId.equals(collectionId)))
          ..where((e) => e.parent.equals(parentPath)))
        .get();
    // TODO: add back  SORT(name asc);
  }

  Future<List<Folder>> foldersByCollection(String collectionId) async {
    if (database == null) return Future(() => []);

    // TODO: add collectionId to filter
    return await (database!.select(database!.folders)..where((e) => e.collectionId.equals(collectionId))).get();
    // TODO add back  SORT(path asc)
  }

  void addFolder(Folder folder) {
    if (database != null) {
      database!.into(database!.folders).insertOnConflictUpdate(folder);
    }
  }

  Future<int> addFolders(List<Folder> folders) async {
    if (database == null) return Future(() => 0);
    List<Folder> newFolders = [];
    for (var f in folders) {
      if (!existingFolders.containsKey(f.path)) {
        existingFolders.remove(f.path);
        newFolders.add(f);
      } else {
        existingFolders.remove(f.path);
      }
    }

    if (newFolders.isNotEmpty) {
      try {
        for (var f in newFolders) {
          await database!.into(database!.folders).insertOnConflictUpdate(f);
        }
      } catch (error) {
        logger.e(error);
        logger.s(error);
      }
    }
    return Future(() {
      return newFolders.length;
    });
  }

  Future<bool> deleteFolders(String collectionId, String parent, List<String> paths) async {
    if (database == null) return Future(() => false);

    //find folders not in list
    for (var p in paths) {
      List<Folder> pendingFoldersToDelete = await (database!.select(database!.folders)
            ..where((e) => Expression.and([e.parent.equals(parent), e.path.equals(p)])))
          .get();

      //find all files in deleted folders & sub-folders, using a start with check
      if (pendingFoldersToDelete.isNotEmpty) {
        List<File> filesInDeletedFolders = [];
        for (var pf in pendingFoldersToDelete) {
          List<File> files =
              await (database!.select(database!.files)..where((e) => e.parent.like("${pf.path}%"))).get();
          filesInDeletedFolders.addAll(files);
        }

        // TODO can we do this in a batch statement instead of a loop?
        for (var file in filesInDeletedFolders) {
          await database!.delete(database!.files).delete(file);
        }
        for (var folder in pendingFoldersToDelete) {
          await database!.delete(database!.folders).delete(folder);
        }
      }
    }

    return Future(() => true);
  }

  ///
  /// File Specific Methods
  ///

  Future<File?> getFileById(String id) async {
    if (database == null) return Future(() => null);

    // TODO: add collectionId to filter
    return await (database!.select(database!.files)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Future<List<File>> files(String collectionId, String parentPath) async {
    if (database == null) return Future(() => []);

    // TODO: add collectionId to filter
    return await (database!.select(database!.files)
          ..where((e) => Expression.and([e.collectionId.equals(collectionId), e.parent.equals(parentPath)])))
        .get();
    // TODO: add SORT(path asc)
  }

  Future<List<File>> filesByCollection(String collectionId) async {
    // TODO: add collectionId to filter
    return await (database!.select(database!.files)..where((e) => e.collectionId.equals(collectionId))).get();
    // TODO: add SORT(path asc)
  }

  Future<io.File?> downloadFile(File f) async {
    if (database == null) return Future(() => null);
    io.Directory? downloadFolder = await getDownloadsDirectory();

    debugPrint('${f.name} to ${downloadFolder?.path}/${f.name}');
    return io.File(f.path).copy('${downloadFolder?.path}/${f.name}');
  }

  void addFile(File file) {
    if (database != null) {
      database!.into(database!.files).insertOnConflictUpdate(file);
    }
  }

  Future<int> addFiles(List<File> files) async {
    if (database == null) return Future(() => 0);

    if (files.isNotEmpty) {
      try {
        // TODO can this be done in a batch statment
        for (var file in files) {
          await database!.into(database!.files).insertOnConflictUpdate(file);
        }
      } catch (error) {
        logger.e(error);
        logger.s(error);
      }
    }
    return Future(() {
      return files.length;
    });
  }

  void updateProperty(File file, String prop, dynamic value) {
    switch (prop) {
      case "thumbnail":
        file.thumbnail = value;
        break;
      case "latitude":
        file.latitude = value;
        break;
      case "longitude":
        file.longitude = value;
        break;
    }

    database!.update(database!.files).write(file);
  }

  void updatePropertyMap(File file, Map<String, dynamic> props) {
    for (var key in props.keys) {
      switch (key) {
        case "thumbnail":
          file.thumbnail = props[key];
          break;
        case "latitude":
          file.latitude = props[key];
          break;
        case "longitude":
          file.longitude = props[key];
          break;
      }
      database!.update(database!.files).write(file);
    }

    Future<bool> deleteFiles(String collectionId, String parent, List<String> paths) async {
      //find all files not in list of current files
      for (var p in paths) {
        List<File> files = await (database!.select(database!.files)
              ..where((e) => Expression.and([e.parent.equals(parent), e.path.equals(p)])))
            .get();
        if (files.isNotEmpty) {
          for (var file in files) {
            database!.delete(database!.files).delete(file);
          }
        }
      }
      return Future(() => true);
    }
  }
}
