import 'dart:async';
import 'dart:io' as io;
import 'dart:isolate';
import 'dart:math';

import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:flutter/services.dart';
import 'package:client/app_logger.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:client/modules/files/services/file_system_repository.dart';

class LocalFileIsolate {
  String dbPath;
  RootIsolateToken? token;
  SendPort sendPort;
  Isolate? isolate;
  AppLogger logger = AppLogger(null);

  LocalFileIsolate(this.dbPath, this.sendPort) : super() {
    logger = AppLogger(sendPort);
  }

  Future<int> start(Collection collection, String? path, recursive, bool force) async {
    // A Stream that handles communication between isolates
    ReceivePort p = ReceivePort();
    RootIsolateToken? token = RootIsolateToken.instance;
    Map<String, dynamic> args = {
      'token': token,
      'port': p.sendPort,
      'dbPath': dbPath,
      'path': path,
      'recursive': recursive,
      'collectionId': collection.id
    };

    isolate = await Isolate.spawn<Map<String, dynamic>>(_scan, args);
    isolate!.addOnExitListener(p.sendPort);

    await for (var message in p) {
      if (message is SendPort) {
        // connected
        logger.i(message);
      } else if (message == null) {
        //logger.i("Scan Complete");
        return Future(() => -1);
      }
    }

    return Future(() => 0);
  }

  void stop() async {
    //clear any isolates
    if (isolate != null) {
      isolate!.kill(priority: Isolate.beforeNextEvent);
      logger.w('Killed local file scanner');
    }
  }

  //Method will run in Isolate
  // Scan directory
  void _scan(Map<String, dynamic> args) async {
    //print(args);
    RootIsolateToken? token = args['token'];
    SendPort resultPort = args['port'];
    String path = args['path'];
    String dbPath = args['dbPath'];
    bool recursive = args['recursive'];
    String collectionId = args['collectionId'];

    if (token != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    }

    //Start Database inside isolate
    var database = _initDatabase(dbPath);

    // start scanner
    resultPort.send('Scanning: $path');
    var fileCount = await _scanDir(database, resultPort, collectionId, path, recursive);

    // return all files
    Isolate.exit(resultPort, fileCount);
  }

  Future<int> _scanDir(AppDatabase database, SendPort resultPort, String collectionId, String path, recursive) async {
    int count = 0;
    var dir = io.Directory(path);
    List<io.FileSystemEntity> files = [];
    logger.s('Scanning ${dir.path}');
    var dirList = dir.listSync(recursive: false, followLinks: false);
    for (var asset in dirList) {
      if (asset is io.File) {
        //resultPort.send('file: ${asset.path}');
        count++;
        files.add(asset);
      } else if (asset is io.Directory) {
        //send status message back
        resultPort.send('Scanning: ${asset.path}');
        //save file
        files.add(asset);
        try {
          if (recursive) {
            int fileCount = await _scanDir(database, resultPort, collectionId, asset.path, recursive);
            count += fileCount;
          }
        } catch (err) {
          logger.w(err);
        }
      } else {
        logger.w("unknown type");
      }
    }

    //save all files
    _saveResults(database, collectionId, files, path);

    return Future(() => count);
  }

  Future<int> _saveResults(
      AppDatabase database, String collectionId, List<io.FileSystemEntity> files, String parent) async {
    int batchFolderSize = 100;
    int batchFileSize = 100;
    int count = 0;
    //create repository & load list of all existing files
    FileSystemRepository repo = FileSystemRepository();
    Map<String, DateTime> existingFolders = {};
    for (var e in (await repo.folders(collectionId, parent))) {
      existingFolders.putIfAbsent('${e.collectionId}:${e.path}', () => e.dateLastModified);
    }

    Map<String, DateTime> existingFiles = {};
    for (var e in (await repo.files(collectionId, parent))) {
      existingFiles.putIfAbsent('${e.collectionId}:${e.path}', () => e.dateLastModified);
    }

    //First Save all the Directories
    List<io.Directory> dirList = files.whereType<io.Directory>().toList();
    while (dirList.isNotEmpty) {
      //var start = DateTime.now().millisecondsSinceEpoch;
      //pull out batch, so we don't lock ui trying to save too many folders
      batchFolderSize = min(batchFolderSize, dirList.length);
      List<io.Directory> range = dirList.sublist(0, batchFolderSize);
      if (range.isEmpty) break;

      //remove files from larger list
      dirList.removeRange(0, batchFolderSize);

      //valid files (not system, hidden, duplicates)
      var validFolders = await _validateFolders(existingFolders, collectionId, range);

      //save files w/pause
      if (validFolders.isNotEmpty) {
        logger.s("Saving Directories");
        int saveCount = await repo.addFolders(validFolders);
        count += saveCount;
      }
      //logger.d('[${DateTime.now().millisecondsSinceEpoch - st1art}ms] Saving Dir Complete: ${validFolders.length}');
    }

    //Save Files
    List<io.File> fileList = files.whereType<io.File>().toList();
    int total = fileList.length;
    int completed = 0;
    while (fileList.isNotEmpty) {
      //var start = DateTime.now().millisecondsSinceEpoch;
      //pull out batch, so we don't lock ui trying to save too many files
      batchFileSize = min(batchFileSize, fileList.length);
      List<io.File> range = fileList.sublist(0, batchFileSize);
      if (range.isEmpty) break;

      //Future.delayed(const Duration(seconds: 10), () async {
      //remove files from larger list
      batchFileSize = min(batchFileSize, fileList.length);
      fileList.removeRange(0, batchFileSize);

      //valid files (not system, hidden, duplicates)
      var validFiles = await _validateFiles(existingFiles, collectionId, range);
      if (validFiles.isEmpty) break;

      //save files w/pause
      if (validFiles.isNotEmpty) {
        completed += validFiles.length;
        logger.s("Saving $completed / $total files");
        int saveCount = await repo.addFiles(validFiles);
        count += saveCount;
      }
      //logger.s('[${DateTime.now().millisecondsSinceEpoch - start}ms] Saving Files Complete: ${validFiles.length}');
    }
    logger.s(""); //clear status
    return Future(() => count);
  }

  /// Validate directories against the know paths we want to skip.
  /// Convert dart.io to a local model object
  Future<List<Folder>> _validateFolders(
      Map<String, DateTime> existingFolders, String collectionId, List<io.Directory> dirs) {
    final hiddenFolderRegex = RegExp('/[.].*/?', multiLine: false, caseSensitive: true, unicode: true);

    // TODO: add this list to a global config / UI page
    final skipFolderRegex =
        RegExp('/(go|node_modules|Pods|.git)+/?', multiLine: false, caseSensitive: true, unicode: true);

    //skip any hidden or system folders
    List<io.Directory> cleanList = dirs.where((f) {
      bool hidden = hiddenFolderRegex.hasMatch(f.path);
      bool skipFolder = skipFolderRegex.hasMatch(f.path);
      return !hidden && !skipFolder;
    }).toList();

    //List<String> paths = cleanList.map((e) => e.path).toList();

    // TODO remove deleted folders
    //await fileService.folderRepository.deleteFolders(collectionId, parentPath, paths);

    List<Folder> newFolders = [];
    for (var d in cleanList) {
      if (existingFolders["$collectionId:${d.path}"] == null) {
        String name = d.path.split("/").last;
        String parentPath = d.path.split("/").sublist(0, d.path.split("/").length - 1).join("/");

        // TODO: get date created/modified from file system
        newFolders.add(Folder(
            id: '$collectionId:${d.path.hashCode}',
            name: name,
            path: d.path,
            parent: parentPath,
            dateCreated: DateTime.now(),
            dateLastModified: DateTime.now(),
            collectionId: collectionId));
      }
    }

    return Future(() => newFolders);
  }

  /// Validate directories against the know paths we want to skip.
  /// Convert dart.io to a local model object
  Future<List<File>> _validateFiles(
      Map<String, DateTime> existingFiles, String collectionId, List<io.File> files) async {
    final hiddenFolderRegex = RegExp('/[.].*/?', multiLine: false, caseSensitive: true, unicode: true);

    // TODO: add this list to a global config / UI page
    final skipFolderRegex =
        RegExp('/(go|node_modules|Pods|.git)+/?', multiLine: false, caseSensitive: true, unicode: true);

    //skip any fines in a hidden or system folder
    List<io.File> cleanList = files.where((f) {
      bool hidden = hiddenFolderRegex.hasMatch(f.path);
      bool skipFolder = skipFolderRegex.hasMatch(f.path);
      return !hidden && !skipFolder;
    }).toList();

    //list of good paths
    //List<String> paths = cleanList.map((e) => e.path).toList();

    // TODO remove deleted files
    //await fileService.fileRepository.deleteFiles(collectionId, parentPath, paths);

    List<File> newFiles = [];
    for (var d in cleanList) {
      if (existingFiles["$collectionId:${d.path}"] == null) {
        String name = d.path.split("/").last;
        String parentPath = d.path.split("/").sublist(0, d.path.split("/").length - 1).join("/");
        DateTime lmDate = d.lastModifiedSync();
        newFiles.add(File(
            id: '$collectionId:${d.path.hashCode}',
            collectionId: collectionId,
            name: name,
            path: d.path,
            parent: parentPath,
            dateCreated: lmDate,
            dateLastModified: lmDate,
            isDeleted: false,
            size: d.lengthSync(),
            contentType: getMimeType(name)));
      }
    }

    return Future(() => newFiles);
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

  _initDatabase(String dbPath) {}
}


/** TODO map extra types and move to helper class
    {
    {".3gp",    "video/3gpp"},
    {".torrent","application/x-bittorrent"},
    {".kml",    "application/vnd.google-earth.kml+xml"},
    {".gpx",    "application/gpx+xml"},
    {".csv",    "application/vnd.ms-excel"},
    {".apk",    "application/vnd.android.package-archive"},
    {".asf",    "video/x-ms-asf"},
    {".avi",    "video/x-msvideo"},
    {".bin",    "application/octet-stream"},
    {".bmp",    "image/bmp"},
    {".c",      "text/plain"},
    {".class",  "application/octet-stream"},
    {".conf",   "text/plain"},
    {".cpp",    "text/plain"},
    {".doc",    "application/msword"},
    {".docx",   "application/vnd.openxmlformats-officedocument.wordprocessingml.document"},
    {".xls",    "application/vnd.ms-excel"},
    {".xlsx",   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
    {".exe",    "application/octet-stream"},
    {".gif",    "image/gif"},
    {".gtar",   "application/x-gtar"},
    {".gz",     "application/x-gzip"},
    {".h",      "text/plain"},
    {".htm",    "text/html"},
    {".html",   "text/html"},
    {".jar",    "application/java-archive"},
    {".java",   "text/plain"},
    {".jpeg",   "image/jpeg"},
    {".jpg",    "image/jpeg"},
    {".js",     "application/x-javascript"},
    {".log",    "text/plain"},
    {".m3u",    "audio/x-mpegurl"},
    {".m4a",    "audio/mp4a-latm"},
    {".m4b",    "audio/mp4a-latm"},
    {".m4p",    "audio/mp4a-latm"},
    {".m4u",    "video/vnd.mpegurl"},
    {".m4v",    "video/x-m4v"},
    {".mov",    "video/quicktime"},
    {".mp2",    "audio/x-mpeg"},
    {".mp3",    "audio/x-mpeg"},
   
    {".mpc",    "application/vnd.mpohun.certificate"},
    {".mpe",    "video/mpeg"},
   
    {".mpg",    "video/mpeg"},
    {".mpg4",   "video/mp4"},
    {".mpga",   "audio/mpeg"},
    {".msg",    "application/vnd.ms-outlook"},
    {".ogg",    "audio/ogg"},
    {".pdf",    "application/pdf"},
    {".png",    "image/png"},
    {".pps",    "application/vnd.ms-powerpoint"},
    {".ppt",    "application/vnd.ms-powerpoint"},
    {".pptx",   "application/vnd.openxmlformats-officedocument.presentationml.presentation"},
    {".prop",   "text/plain"},
    {".rc",     "text/plain"},
    {".rmvb",   "audio/x-pn-realaudio"},
    {".rtf",    "application/rtf"},
    {".sh",     "text/plain"},
    {".tar",    "application/x-tar"},
    {".tgz",    "application/x-compressed"},
    {".txt",    "text/plain"},
    {".wav",    "audio/x-wav"},
    {".wma",    "audio/x-ms-wma"},
    {".wmv",    "audio/x-ms-wmv"},
    {".wps",    "application/vnd.ms-works"},
    {".xml",    "text/plain"},
    {".z",      "application/x-compress"},
    {".zip",    "application/x-zip-compressed"},

}
 */
