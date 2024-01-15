import 'dart:convert';
import 'dart:io';
import 'package:client/app_constants.dart';
import 'package:client/models/tables/app_user.dart';
import 'package:client/modules/email/pages/email_page.dart';
import 'package:client/modules/email/pages/new_email_page.dart';
import 'package:client/modules/email/widgets/email_drawer.dart';
import 'package:client/modules/files/pages/new_file_collection_page.dart';
import 'package:client/modules/files/pages/rx_files_page.dart';
import 'package:client/modules/files/widgets/file_drawer.dart';
import 'package:client/modules/photos/pages/photos_app.dart';
import 'package:client/modules/photos/widgets/photo_drawer.dart';
import 'package:client/modules/social/pages/facebook_page.dart';
import 'package:client/modules/social/pages/instagram_page.dart';
import 'package:client/modules/social/pages/new_social_page.dart';
import 'package:client/modules/social/pages/twitter_page.dart';
import 'package:client/modules/social/widgets/social_drawer.dart';
import 'package:client/pages/home.dart';
import 'package:client/pages/login.dart';
import 'package:client/pages/setup.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/get_user_service.dart';
import 'package:client/services/get_users_service.dart';
import 'package:client/widgets/router/navigation_wrapper.dart';
import 'package:client/widgets/router/route_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AppRouter {
  static final BehaviorSubject supportDirectory = BehaviorSubject();
  static GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static get instance => GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/',
          debugLogDiagnostics: true,
          redirect: (BuildContext context, GoRouterState state) async {
            if (state.uri.toString() == '/setup') return null;

            //check app startup initialization
            if (DatabaseRepository.instance == null) {
              var supportPath = await getApplicationSupportDirectory();
              supportDirectory.add(supportPath);
              bool needsSetup = await validateAppDirsAndDb(supportPath);
              if (needsSetup) {
                return '/setup';
              }
            }

            // TODO: add logic to show splash screen

            //check if user is logged in
            AppUser? user = GetUserService.instance.sink.valueOrNull;
            if (user == null) {
              return '/login';
            }

            if (state.uri.toString() == '/login') {
              return '/';
            } else {
              return state.uri.toString();
            }
          },
          routes: <ShellRoute>[
            ShellRoute(
                //navigatorKey: _shellNavigatorKey,
                builder: (context, state, child) {
                  if (child is HeroControllerScope) {
                    Navigator navigator = (child).child as Navigator;
                    RoutePage nw = navigator.pages[navigator.pages.length - 1] as RoutePage;
                    if (nw.isStandalone == true) {
                      return child;
                    }
                    return NavigationWrapper(body: nw.body, drawer: nw.drawer);
                  }
                  return child;
                },
                routes: [
                  GoRoute(
                      path: '/login',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return const RoutePage(isStandalone: true, body: LoginPage());
                      }),

                  GoRoute(
                      path: '/setup',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return const RoutePage(isStandalone: true, body: SetupPage());
                      }),

                  GoRoute(
                      path: '/',
                      pageBuilder: (context, state) {
                        return const RoutePage(body: HomePage(), drawer: null);
                      }),

                  /// File Module Routes
                  GoRoute(
                      path: '/files',
                      pageBuilder: (context, state) {
                        //build method will load "new collection form" if needed
                        return const RoutePage(body: RxFilesPage(), drawer: FileDrawer());
                      },
                      routes: [
                        GoRoute(
                            path: 'add',
                            pageBuilder: (context, state) =>
                                const RoutePage(body: NewFileCollectionPage(), drawer: FileDrawer())),
                      ]),

                  /// Photos Module Routes
                  GoRoute(
                      path: '/photos',
                      pageBuilder: (context, state) => const RoutePage(body: PhotosApp(), drawer: PhotoDrawer())),

                  //Email Networks
                  GoRoute(
                      path: '/email',
                      pageBuilder: (context, state) {
                        return const RoutePage(body: EmailPage(), drawer: EmailDrawer());
                      },
                      routes: [
                        GoRoute(
                            path: 'add',
                            pageBuilder: (context, state) =>
                                const RoutePage(body: NewEmailPage(), drawer: EmailDrawer())),
                      ]),

                  /// Social Archive Module Routes
                  GoRoute(
                      path: '/social',
                      pageBuilder: (context, state) {
                        return const RoutePage(body: NewSocialPage(), drawer: SocialDrawer());
                      },
                      routes: [
                        GoRoute(path: 'add', pageBuilder: (context, state) => const RoutePage(body: NewSocialPage())),
                        GoRoute(
                            path: 'facebook/:id',
                            pageBuilder: (context, state) {
                              return RoutePage(
                                  key: UniqueKey(),
                                  body: FacebookPage(id: state.pathParameters['id']!),
                                  drawer: const SocialDrawer());
                            }),
                        GoRoute(
                            path: 'twitter/:id',
                            pageBuilder: (context, state) {
                              return RoutePage(
                                  key: UniqueKey(),
                                  body: TwitterPage(id: state.pathParameters['id']!),
                                  drawer: const SocialDrawer());
                            }),
                        GoRoute(
                            path: 'instagram/:id',
                            pageBuilder: (context, state) {
                              return RoutePage(
                                  key: UniqueKey(),
                                  body: InstagramPage(id: state.pathParameters["id"]!),
                                  drawer: const SocialDrawer());
                            }),
                      ]),
                ])
          ]);

  static Future<bool> validateAppDirsAndDb(Directory supportPath) async {
    File file = File('${supportPath.path}${Platform.pathSeparator}${AppConstants.configFileName}');
    if (file.existsSync()) {
      //read location of db, from local config file
      var storageFile = file.readAsStringSync();
      var storagePath = jsonDecode(storageFile)['path'];
      if (File(storageFile).existsSync()) return true;

      //change default app support dir to the one the User Selected during setup, in case they picked a new dir
      AppRouter.supportDirectory.add(storagePath);

      var dbDir = Directory('$storagePath${Platform.pathSeparator}data');
      var keyDir = Directory('$storagePath${Platform.pathSeparator}keys');
      try {
        //do the app db & file cache directories exists
        if (!dbDir.existsSync() || dbDir.listSync().isEmpty && !keyDir.existsSync() || keyDir.listSync().isEmpty) {
          return true; //Needs Setup
        }

        //on app startup, start db.
        DatabaseRepository db = DatabaseRepository(null, null);
        print("Schema Version=${db.database.schemaVersion}");

        //last check, do we have any users?
        List<AppUser> users = await GetUsersService.instance.invoke(GetUsersServiceCommand());
        if (users.isEmpty) {
          return true; //Needs Setup
        }

        return false; //Start app
      } catch (err) {
        //unknown error, restart in setup
        print(err);
        return true; //Needs Setup
      }
    } else {
      //config does not exist, run setup
      return true;
    }
  }
}
