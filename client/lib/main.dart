import 'dart:io';
import 'dart:math';

import 'package:client/app_router.dart';
import 'package:client/family_dam_app.dart';
import 'package:client/widgets/auth_dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:logger/logger.dart';

/// The main() function is the starting point of the application. It first ensures that the Flutter binding is initialized.
/// Then, it checks if the platform is Windows, Linux or macOS. If it is, it gets the current screen and sets the window title, minimum size and maximum size.
/// Finally, it runs the FamilyDamApp widget wrapped in a ProviderScope using the runApp function.
class App {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    Logger.level = Level.debug;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      var win = await getCurrentScreen();
      setWindowTitle('Family D.A.M.');
      setWindowMinSize(Size(min(1200, win?.frame.width ?? 1200), min(700, win?.frame.height ?? 700)));
      setWindowMaxSize(Size.infinite);
    }

    _initDialogManager();
    runApp(const FamilyDamApp());
  }
}

void _initDialogManager() => AuthDialogManager(AppRouter.rootNavigatorKey).init();

void main() => App().main();
