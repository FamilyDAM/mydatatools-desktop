import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:client/app_logger.dart';

class LocalFileIsolate {
  String collectionId;
  String path;
  bool recursive;
  List<Isolate> isolates = [];
  final AppLogger logger = AppLogger();

  LocalFileIsolate(this.collectionId, this.path, this.recursive);

  Stream<dynamic> start() async* {
    // A Stream that handles communication between isolates
    ReceivePort p = ReceivePort();
    //List<FileSystemEntity> files = [];

    var args = {'port': p.sendPort, 'path': path, 'recursive': recursive};
    var iso = await Isolate.spawn(scan, args);
    iso.addOnExitListener(p.sendPort);
    isolates.add(iso);

    await for (var message in p) {
      if (message is SendPort) {
        // connected
      } else if (message == null) {
        //logger.i("Scan Complete");
        return;
      } else if (message is String && message != "done") {
        //logger.s(message);
        yield message;
      } else if (message is List) {
        for (var f in message) {
          //logger.i("file ${f.path}");
          yield f;
        }
      }
    }
  }

  void stop() async {
    //clear any isolates
    for (Isolate i in isolates) {
      i.kill(priority: Isolate.immediate);
      print('Killed');
    }
    isolates.clear();
  }

  void scan(Map<String, dynamic> args) async {
    //print(args);
    SendPort resultPort = args['port'];
    String path = args['path'];
    bool recursive = args['recursive'];

    // start scanner
    List<FileSystemEntity> files = [];
    files = scanDir(resultPort, path, recursive);

    // return all files
    resultPort.send('Scanning: $path');
    Isolate.exit(resultPort, files);
  }

  List<FileSystemEntity> scanDir(SendPort resultPort, String path, recursive) {
    var dir = Directory(path);
    List<FileSystemEntity> files = [];
    var dirList = dir.listSync(recursive: false, followLinks: false);
    for (var asset in dirList) {
      if (asset is File) {
        //resultPort.send('file: ${asset.path}');
        files.add(asset);
      } else if (asset is Directory) {
        //send status message back
        resultPort.send('Scanning: ${asset.path}');
        //save file
        files.add(asset);
        try {
          if (recursive) {
            files.addAll(scanDir(resultPort, asset.path, recursive));
          }
        } catch (err) {
          logger.w(err);
        }
      }
    }

    return files;
  }
}
