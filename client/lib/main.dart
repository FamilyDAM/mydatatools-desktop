import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:client/app_constants.dart';
import 'package:client/app_router.dart';
import 'package:client/family_dam_app.dart';
import 'package:client/pages/splash.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/repositories/watchers/database_change_watcher.dart';
import 'package:client/scanners/scanner_manager.dart';
import 'package:client/services/get_user_service.dart';
import 'package:client/widgets/auth_dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_size/window_size.dart';

/// The main() function is the starting point of the application. It first ensures that the Flutter binding is initialized.
/// Then, it checks if the platform is Windows, Linux or macOS. If it is, it gets the current screen and sets the window title, minimum size and maximum size.
/// Finally, it runs the FamilyDamApp widget wrapped in a ProviderScope using the runApp function.
class MainApp {
  // Default system directory for app config
  static final BehaviorSubject supportDirectory = BehaviorSubject();
  // User selected directory to store files and metadata db.
  static final BehaviorSubject appDataDirectory = BehaviorSubject();
  // Flutter key for router
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    Logger.level = Level.debug;

    _initDialogManager();

    _initDatabaseRepository().then((db) async {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        getCurrentScreen().then((win) {
          setWindowTitle('MyData / Tools');
          setWindowMinSize(Size(min(1200, win?.frame.width ?? 1200), min(700, win?.frame.height ?? 700)));
          setWindowMaxSize(Size.infinite);
          runApp(const FamilyDamApp());
        });
      }
    });

    runApp(const SplashPage());
  }

  // Initialize a global Dialog Manager so any screen can launch global dialogs, such as oauth expired alerts
  void _initDialogManager() => AuthDialogManager(AppRouter.rootNavigatorKey).init();
  DatabaseChangeWatcher? collectionWatcher;
  ScannerManager? scannerManager;

  // Initialize the Database Repository as soon as possible, so the lazyDatabase is ready by the time the AppRouter needs it.
  Future<DatabaseRepository?> _initDatabaseRepository() async {
    var supportPath = await getApplicationSupportDirectory();
    MainApp.supportDirectory.add(supportPath);

    // Look for config file with user selected path for DB and Files
    File file = File(p.join(supportPath.path, AppConstants.configFileName));
    if (file.existsSync()) {
      //read location of db, from local config file
      var storageFile = file.readAsStringSync();
      var storagePath = jsonDecode(storageFile)['path'];
      // set path in BehaviorSubject
      MainApp.appDataDirectory.add(storagePath);

      //If this is false, we've reached a state where the local config exists but the older dir where
      //the user selected as the data folder, in a previous setup, has been deleted.
      //Maybe we should show a "can't find dialog instead" but for now we'll restart setup.
      // TODO: Prompt for location of old data files instead of returning null to start setup wizard again.
      if (Directory(storagePath).existsSync()) {
        // initialize database
        DatabaseRepository repo = DatabaseRepository.instance;
        AppDatabase database = await repo.database;

        // Add listener for User Login to start DB Watchers and Collection Scanners
        GetUserService.instance.sink.listen((user) {
          if (user != null) {
            //Register listeners
            collectionWatcher = DatabaseChangeWatcher(database);
            collectionWatcher?.start();

            // TODO: move to after login
            // initialize scanners
            scannerManager = ScannerManager(database);
            scannerManager?.startScanners();
          } else {
            scannerManager?.stopScanners();
            collectionWatcher?.stop();
          }
        });

        //add sleep to keep splash screen up for a tiny bit
        sleep(const Duration(seconds: 1));
        return Future(() => repo);
      }
    }

    return Future(() => null);
  }
}

void main() => MainApp().main();
