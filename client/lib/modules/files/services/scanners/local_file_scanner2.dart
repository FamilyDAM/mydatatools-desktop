import 'dart:async';
import 'dart:io' as io;

import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/file_asset.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/modules/files/files_constants.dart';

class LocalFileScanner2 {
  String rootPath;
  String collectionId;
  final hiddenFolderRegex = RegExp('/[.].*/?', multiLine: false, caseSensitive: true, unicode: true);
  final skipFolderRegex =
      RegExp('/(go|node_modules|Pods|.git)+/?', multiLine: false, caseSensitive: true, unicode: true);

  LocalFileScanner2(this.collectionId, this.rootPath);

  Future<int> scanDir(StreamController<List<FileAsset>> controller, String path, recursive) async {
    int count = 0;
    var dir = io.Directory(path);
    List<FileAsset> files = [];
    //logger.s('Scanning ${dir.path}');
    var dirList = dir.listSync(recursive: false, followLinks: false);
    for (var asset in dirList) {
      if (asset is io.File) {
        //resultPort.send('file: ${asset.path}');
        File? file = _validateFile(collectionId, asset);
        if (file != null) {
          count++;
          files.add(file);
        }
      } else if (asset is io.Directory) {
        //send status message back
        //resultPort.send('Scanning: ${asset.path}');
        //save file
        Folder? folder = _validateFolder(collectionId, asset);
        if (folder != null) {
          count++;
          files.add(folder);
        }
        try {
          if (recursive) {
            count += await scanDir(controller, asset.path, recursive);
          }
        } catch (err) {
          //logger.w(err);
        }
      } else {
        //logger.w("unknown type");
      }
    }

    //return file set
    controller.add(files);

    if (rootPath == path) {
      //controller.close();
    }

    return Future(() => count);
  }

  /// Validate directories against the know paths we want to skip.
  /// Convert dart.io to a local model object
  Folder? _validateFolder(String collectionId, io.Directory dir) {
    //skip any hidden or system folders
    bool hidden = hiddenFolderRegex.hasMatch(dir.path);
    bool skipFolder = skipFolderRegex.hasMatch(dir.path);
    if (hidden || skipFolder) {
      return null;
    }

    List<Folder> newFolders = [];
    String name = dir.path.split("/").last;
    String parentPath = dir.path.split("/").sublist(0, dir.path.split("/").length - 1).join("/");

    // TODO: get date created/modified from file system
    var newDir = Folder(
        id: '$collectionId:${dir.path.hashCode}',
        name: name,
        path: dir.path,
        parent: parentPath,
        dateCreated: DateTime.now(),
        dateLastModified: DateTime.now(),
        collectionId: collectionId);

    return newDir;
  }

  /// Validate directories against the know paths we want to skip.
  /// Convert dart.io to a local model object
  File? _validateFile(String collectionId, io.File f) {
    //skip any fines in a hidden or system folder
    bool hidden = hiddenFolderRegex.hasMatch(f.path);
    bool skipFolder = skipFolderRegex.hasMatch(f.path);
    if (hidden || skipFolder) {
      return null;
    }

    String name = f.path.split("/").last;
    String parentPath = f.path.split("/").sublist(0, f.path.split("/").length - 1).join("/");
    DateTime lmDate = f.lastModifiedSync();
    File file = File(
        id: '$collectionId:${f.path.hashCode}',
        collectionId: collectionId,
        name: name,
        path: f.path,
        parent: parentPath,
        dateCreated: lmDate,
        dateLastModified: lmDate,
        isDeleted: false,
        size: f.lengthSync(),
        contentType: getMimeType(name));

    return file;
  }

  String getMimeType(String name) {
    String extension = name.split(".").last;
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'png':
      case 'tif':
      case 'psd':
        return FilesConstants.mimeTypeImage;
      case 'pdf':
        return FilesConstants.mimeTypePdf;
      case 'mp4':
      case 'm4v':
      case 'mpeg':
      case 'mov':
        return FilesConstants.mimeTypeMovie;
      case 'mp3':
        return FilesConstants.mimeTypeMusic;
      default:
        return FilesConstants.mimeTypeUnKnown;
    }
  }
}
