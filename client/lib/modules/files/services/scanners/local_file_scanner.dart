import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart' as models;
import 'package:client/modules/files/files_constants.dart';
import 'package:client/modules/files/services/file_system_repository.dart';
import 'package:client/modules/files/services/scanners/local_file_isolate.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:realm/realm.dart';
import 'package:time/time.dart';

class LocalFileScanner implements CollectionScanner {
  final Realm realm;
  final Collection collection;
  final int repeatFrequency;
  bool isStopped = false;
  StreamSubscription? subscription;
  LocalFileIsolate? fileIsolate;

  AppLogger logger = AppLogger();
  LocalFileScanner(this.realm, this.collection, this.repeatFrequency);

  /// Scan single directory.
  /// This is called while a user is browsing files in the module
  @override
  Future<int> scanDirectory(String path) async {
    try {
      logger.s("Scanning dir: $path");
      var dir = Directory(path);
      //print("scan single dir: ${dir.toString()}");

      List<FileSystemEntity> filesAndFolders = [];
      var dirList = dir.listSync(recursive: false, followLinks: false);
      for (var asset in dirList) {
        if (asset is File) {
          filesAndFolders.add(asset);
        } else if (asset is Directory) {
          filesAndFolders.add(asset);
        }
        //skip semantic links
      }

      //save all files in folder
      return await saveResults(filesAndFolders, path);
    } catch (err) {
      logger.w(err);
      //throw Exception(err);
      return Future(() => 0);
    }
  }

  /// Start an Isolate to scan all files and sub-directories linked to a collection
  @override
  void start(bool recursive, bool force) async {
    // check if scan has already been run once
    if (!force && collection.lastScanDate != null) return;
    //todo: add a date range check to rerun scan

    //start full scan
    fileIsolate = LocalFileIsolate(collection.id, collection.path, recursive);
    Stream<dynamic> fileStream = fileIsolate!.start();

    //var files = await fileStream.toList();

    List<FileSystemEntity> files = [];
    fileStream.listen(
      (data) async {
        if (data is String) {
          logger.s(data.toString());
        } else if (data is FileSystemEntity) {
          files.add(data);
          //await saveResults(data, null);
        } else {
          logger.s("Saving ${data.length} files & directories");
          await saveResults(data, null);
          logger.s("");
        }
      },
      onError: (err) {
        print(err);
      },
      cancelOnError: false,
      onDone: () async {
        //save all files in collection
        logger.s("Saving ${files.length} files & directories");
        await saveResults(files, null);
        //logger.s("");
        //todo move to repo
        CollectionRepository(realm).updateLastScanDate(collection, DateTime.now());
      },
    );
  }

  @override
  void stop() async {
    isStopped = true;
    subscription?.cancel();
    fileIsolate?.stop();
  }

  Future<int> saveResults(List<FileSystemEntity> files, String? parent) async {
    int batchFolderSize = 100;
    int batchFileSize = 100;
    int count = 0;
    //create repository & load list of all existing files
    FileSystemRepository repo = FileSystemRepository(realm, collection.id, parent);

    //Save Directories
    List<Directory> dirList = files.whereType<Directory>().toList();
    logger.s("Saving Directories");
    while (dirList.isNotEmpty) {
      //var start = DateTime.now().millisecondsSinceEpoch;
      //pull out batch, so we don't lock ui trying to save too many folders
      batchFolderSize = min(batchFolderSize, dirList.length);
      List<Directory> range = dirList.sublist(0, batchFolderSize);
      if (range.isEmpty) break;

      //remove files from larger list
      dirList.removeRange(0, batchFolderSize);

      //valid files (not system, hidden, duplicates)
      var validFolders = await _validateFolders(repo.existingFolders, collection.id, range);

      //save files w/pause
      int saveCount = await repo.addFolders(validFolders);
      count += saveCount;
      //logger.d('[${DateTime.now().millisecondsSinceEpoch - start}ms] Saving Dir Complete: ${validFolders.length}');
      5.milliseconds.delay; //pause to prevent UX freezing
    }

    //Save Files
    List<File> fileList = files.whereType<File>().toList();
    int total = fileList.length;
    int completed = 0;
    logger.s("Saving Files");
    while (fileList.isNotEmpty) {
      //var start = DateTime.now().millisecondsSinceEpoch;
      //pull out batch, so we don't lock ui trying to save too many files
      batchFileSize = min(batchFileSize, fileList.length);
      List<File> range = fileList.sublist(0, batchFileSize);
      if (range.isEmpty) break;

      //Future.delayed(const Duration(seconds: 10), () async {
      //remove files from larger list
      batchFileSize = min(batchFileSize, fileList.length);
      fileList.removeRange(0, batchFileSize);

      //valid files (not system, hidden, duplicates)
      var validFiles = await _validateFiles(repo.existingFiles, collection.id, range);
      if (validFiles.isEmpty) break;

      //save files w/pause
      completed += validFiles.length;
      logger.s("Saving $completed / $total files");
      int saveCount = await repo.addFiles(validFiles);
      count += saveCount;
      //logger.s('[${DateTime.now().millisecondsSinceEpoch - start}ms] Saving Files Complete: ${validFiles.length}');
      5.milliseconds.delay; //pause to prevent UX freezing
    }
    logger.s(""); //clear status
    return Future(() => count);
  }

  /// Validate directories against the know paths we want to skip.
  /// Convert dart.io to a local model object
  Future<List<models.Folder>> _validateFolders(
      Map<String, DateTime> existingFolders, String collectionId, List<Directory> dirs) {
    final hiddenFolderRegex = RegExp('/[.].*/?', multiLine: false, caseSensitive: true, unicode: true);

    //todo: add this list to a global config / UI page
    final skipFolderRegex =
        RegExp('/(go|node_modules|Pods|.git)+/?', multiLine: false, caseSensitive: true, unicode: true);

    //skip any hidden or system folders
    List<Directory> cleanList = dirs.where((f) {
      bool hidden = hiddenFolderRegex.hasMatch(f.path);
      bool skipFolder = skipFolderRegex.hasMatch(f.path);
      return !hidden && !skipFolder;
    }).toList();

    //List<String> paths = cleanList.map((e) => e.path).toList();

    //todo remove deleted folders
    //await fileService.folderRepository.deleteFolders(collectionId, parentPath, paths);

    List<models.Folder> newFolders = [];
    for (var d in cleanList) {
      if (existingFolders["$collectionId:${d.path}"] == null) {
        String name = d.path.split("/").last;
        String parentPath = d.path.split("/").sublist(0, d.path.split("/").length - 1).join("/");

        //todo: get date created/modified from file system
        newFolders.add(models.Folder('$collectionId:${d.path.hashCode}', name, d.path, parentPath, DateTime.now(),
            DateTime.now(), collectionId));
      }
    }

    return Future(() => newFolders);
  }

  /// Validate directories against the know paths we want to skip.
  /// Convert dart.io to a local model object
  Future<List<models.File>> _validateFiles(
      Map<String, DateTime> existingFiles, String collectionId, List<File> files) async {
    final hiddenFolderRegex = RegExp('/[.].*/?', multiLine: false, caseSensitive: true, unicode: true);

    //todo: add this list to a global config / UI page
    final skipFolderRegex =
        RegExp('/(go|node_modules|Pods|.git)+/?', multiLine: false, caseSensitive: true, unicode: true);

    //skip any fines in a hidden or system folder
    List<File> cleanList = files.where((f) {
      bool hidden = hiddenFolderRegex.hasMatch(f.path);
      bool skipFolder = skipFolderRegex.hasMatch(f.path);
      return !hidden && !skipFolder;
    }).toList();

    //list of good paths
    //List<String> paths = cleanList.map((e) => e.path).toList();

    //todo remove deleted files
    //await fileService.fileRepository.deleteFiles(collectionId, parentPath, paths);

    List<models.File> newFiles = [];
    for (var d in cleanList) {
      if (existingFiles["$collectionId:${d.path}"] == null) {
        String name = d.path.split("/").last;
        String parentPath = d.path.split("/").sublist(0, d.path.split("/").length - 1).join("/");
        DateTime lmDate = d.lastModifiedSync();
        newFiles.add(models.File('$collectionId:${d.path.hashCode}', collectionId, name, d.path, parentPath, lmDate,
            lmDate, d.lengthSync(), getMimeType(name)));
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
}

/** todo
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
