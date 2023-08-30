import 'dart:async';
import 'dart:io';

import 'package:client/models/collection_model.dart';
import 'package:client/modules/email/services/scanners/gmail_scanner.dart';
import 'package:client/modules/files/services/scanners/local_file_scanner.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

class ScannerManager {
  final Logger logger = Logger();
  static final ScannerManager _instance = ScannerManager._internal();
  List<Collection> collections = [];
  Map<String, CollectionScanner> scanners = {};

  late Realm database;
  //class reference to keep change listeners running
  StreamSubscription<RealmResultsChanges>? collectionSubs;

  factory ScannerManager(Realm realm) {
    _instance.database = realm;
    _instance.startScanners();
    return _instance;
  }

  static ScannerManager getInstance() {
    return _instance;
  }

  ScannerManager._internal() {
    // initialization logic
    //_instance.startScanners();
  }

  void startScanners() {
    //start scanner for all existing collections
    var collections = database.all<Collection>().toList();
    for (var c in collections) {
      logger.d('${c.id} | ${c.path}');
      _registerSingleScanner(c);
    }

    //listend for new collections and add them at runtime
    collectionSubs = database.all<Collection>().changes.listen((changes) {
      //start scanners for new collections
      if (changes.inserted.isNotEmpty) {
        for (var indx in changes.inserted) {
          //add collection to scanner manager
          var c = database.all<Collection>().elementAt(indx);
          _registerSingleScanner(c);
        }
      }

      if (changes.deleted.isNotEmpty) {
        //todo, stop scanner
      }
    });
  }

  void stopScanners() {
    for (var key in scanners.keys) {
      scanners[key]!.stop();
      scanners.remove(key);
    }
  }

  CollectionScanner? getScanner(Collection c) {
    return scanners[c.id];
  }

  void _registerSingleScanner(Collection c) {
    //go up 2 folders from db folder
    Directory appDir = Directory(database.config.path);
    Directory fileDir = appDir.parent.parent;

    switch (c.scanner) {
      case "file.local":
        print("Start '${c.scanner}' scanner for ${c.name} | ${c.path}");
        CollectionScanner s = LocalFileScanner(database, c, Duration.secondsPerDay);
        s.start(true, false);
        scanners.putIfAbsent(c.id, () => s);
        break;
      case "email.gmail":
        print("Start '${c.scanner}' scanner for ${c.name} | ${c.path}");
        CollectionScanner s = GmailScanner(database, c, fileDir.path, Duration.secondsPerDay);
        s.start(true, false);
        scanners.putIfAbsent(c.id, () => s);
        break;
      default:
        break;
    }
  }
}
