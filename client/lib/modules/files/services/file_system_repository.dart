import 'dart:io' as io;

import 'package:client/app_logger.dart';
import 'package:client/models/module_models.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

class FileSystemRepository {
  static final FileSystemRepository _instance = FileSystemRepository._internal();
  late Realm database;
  AppLogger logger = AppLogger(null);

  //list of file paths and their size, so we can compare when looking for new or changed files.
  Map<String, DateTime> existingFiles = <String, DateTime>{};
  Map<String, DateTime> existingFolders = <String, DateTime>{};

  static FileSystemRepository getInstance() {
    return _instance;
  }

  factory FileSystemRepository(Realm db) {
    _instance.database = db;
    return _instance;
  }

  FileSystemRepository._internal() {
    // initialization logic
  }

  ///
  /// Folder Specific Methods
  ///

  List<Folder> folders(String collectionId, String parentPath) {
    return database.query<Folder>("collectionId = '$collectionId' AND parent == '$parentPath' SORT(name asc)").toList();
  }

  List<Folder> foldersByCollection(String collectionId) {
    //todo: add collectionId to filter
    return database.query<Folder>("collectionId = '$collectionId' SORT(path asc)").toList();
  }

  void addFolder(Folder folder) {
    database.writeAsync(() {
      database.add<Folder>(folder, update: true);
      //print('save folder: ${file.path}');
    });
  }

  Future<int> addFolders(List<Folder> folders) {
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
        database.write(() {
          database.addAll<Folder>(newFolders, update: true);
          //print('save ${newFolders.length} files');
        });
      } catch (error) {
        logger.e(error);
        logger.s(error);
      }
    }
    return Future(() {
      return newFolders.length;
    });
  }

  Future<bool> deleteFolders(String collectionId, String parent, List<String> paths) {
    Transaction t = database.beginWrite();
    try {
      //find folders not in list
      String query = "parent == '$parent' ";
      for (var p in paths) {
        query += " and path != '$p' ";
      }
      List<Folder> pendingFoldersToDelete = database.all<Folder>().query(query).toList();
      //find all files in deleted folders & sub-folders, using a start with check
      if (pendingFoldersToDelete.isNotEmpty) {
        List<File> filesInDeletedFolders = [];
        for (var pf in pendingFoldersToDelete) {
          List<File> files = database.all<File>().query("parent BEGINSWITH ${pf.path}}").toList();
          filesInDeletedFolders.addAll(files);
        }
        database.deleteMany(filesInDeletedFolders);
        database.deleteMany(pendingFoldersToDelete);
      }
      t.commit();
    } catch (_) {
      t.rollback();
      rethrow;
    }
    return Future(() {
      return true;
    });
  }

  ///
  /// File Specific Methods
  ///

  File? getFileById(int id) {
    //todo: add collectionId to filter
    return database.query<File>("id = '$id'").firstOrNull;
  }

  List<File> files(String collectionId, String parentPath) {
    //todo: add collectionId to filter
    return database.query<File>("collectionId = '$collectionId' AND parent == '$parentPath' SORT(path asc)").toList();
  }

  List<File> filesByCollection(String collectionId) {
    //todo: add collectionId to filter
    return database.query<File>("collectionId = '$collectionId' SORT(path asc)").toList();
  }

  Future<io.File> downloadFile(File f) async {
    io.Directory? downloadFolder = await getDownloadsDirectory();

    debugPrint('${f.name} to ${downloadFolder?.path}/${f.name}');
    return io.File(f.path).copy('${downloadFolder?.path}/${f.name}');
  }

  void addFile(File file) {
    database.writeAsync(() => {
          database.add<File>(file, update: true)
          //print('save file: ${file.path}');
        });
  }

  Future<int> addFiles(List<File> files) async {
    if (files.isNotEmpty) {
      try {
        database.write(() {
          database.addAll<File>(files, update: true);
          //print('saved ${files.length} files');
        });
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
    database.writeAsync(() {
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
    }).then((value) {
      //print("saved file: $value");
    }).catchError((error) {
      logger.e(error);
      logger.s(error);
    });
  }

  void updatePropertyMap(File file, Map<String, dynamic> props) {
    database.writeAsync(() {
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
      }
    }).then((value) {
      //print("saved file: $value");
    }).catchError((error) {
      logger.e(error);
      logger.s(error);
    });
  }

  Future<bool> deleteFiles(String collectionId, String parent, List<String> paths) {
    Transaction t = database.beginWrite();
    try {
      //find all files not in list of current files
      String query = "parent == '$parent' ";
      for (var p in paths) {
        query += " and path != '$p' ";
      }
      List<File> files = database.all<File>().query(query).toList();
      if (files.isNotEmpty) {
        database.deleteMany(files);
      }
      t.commit();
    } catch (_) {
      t.rollback();
    }
    return Future(() {
      return true;
    });
  }
}
