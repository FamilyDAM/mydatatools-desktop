import 'dart:async';

import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/modules/files/services/scanners/local_file_scanner.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:logger/logger.dart';

class ScannerManager {
  final Logger logger = Logger();
  static final ScannerManager _instance = ScannerManager._internal();
  List<Collection> collections = [];
  Map<String, CollectionScanner> scanners = {};

  late AppDatabase database;
  //class reference to keep change listeners running
  StreamSubscription<List<Collection>>? collectionSubs;

  factory ScannerManager(AppDatabase database) {
    _instance.database = database;
    return _instance;
  }

  static ScannerManager getInstance() {
    return _instance;
  }

  ScannerManager._internal() {
    // initialization logic
    //_instance.startScanners();
  }

  void startScanners() async {
    //start scanner for all existing collections
    var collections = await database.select(database.collections).get();
    for (var c in collections) {
      logger.d('${c.id} | ${c.path}');
      _registerSingleScanner(c);
    }

    //listen for new collections and add them at runtime
    Stream<List<Collection>> collectionWatch = database.select(database.collections).watch();

    collectionWatch.listen((changes) {
      print('Value from controller: $changes');

      for (var c in changes) {
        if (getScanner(c) == null) {
          _registerSingleScanner(c);
        }
      }
    });
  }

  void stopScanners() {
    try {
      for (var key in scanners.keys) {
        scanners[key]!.stop();
        scanners.remove(key);
      }
    } catch (error) {
      //print(error);
    }
  }

  void startScanner(Collection c) {
    // TODO, not implemented yet
  }

  CollectionScanner? getScanner(Collection c) {
    return scanners[c.id];
  }

  void _registerSingleScanner(Collection c) {
    //go up 2 folders from db folder
    /** TODO: implement this with sqlite */
    String dir = MainApp.appDataDirectory.value;

    switch (c.scanner) {
      case "file.local":
        print("Start '${c.scanner}' scanner for ${c.name} | ${c.path}");
        CollectionScanner s = LocalFileScanner(database);
        s.start(c, c.path, true, false);
        scanners.putIfAbsent(c.id, () => s);
        break;
      case "email.gmail":
        print("Start '${c.scanner}' scanner for ${c.name} | ${c.path}");
        //CollectionScanner s = GmailScanner(database.config.path, c, fileDir.path);
        //s.start(c, c.path, true, false);
        //scanners.putIfAbsent(c.id, () => s);
        break;
      default:
        break;
    }
  }
}
