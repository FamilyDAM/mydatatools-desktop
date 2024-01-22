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
import 'package:client/widgets/router/navigation_wrapper.dart';
import 'package:client/widgets/router/route_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static get instance => GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/',
          debugLogDiagnostics: true,
          redirect: (BuildContext context, GoRouterState state) async {
            if (state.uri.toString() == '/setup') return null;

            //check app startup initialization
            if (!DatabaseRepository.isInitialized) {
              return '/setup';
            }

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
                  return child;
                },
                routes: [
                  GoRoute(
                      path: '/login',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return RoutePage(key: UniqueKey(), isStandalone: true, body: const LoginPage());
                      }),

                  GoRoute(
                      path: '/setup',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return RoutePage(key: UniqueKey(), isStandalone: true, body: const SetupPage());
                      }),

                  GoRoute(
                      path: '/',
                      pageBuilder: (context, state) {
                        return RoutePage(key: UniqueKey(), body: const NavigationWrapper(body: HomePage()));
                      }),

                  /// File Module Routes
                  GoRoute(
                      path: '/files',
                      pageBuilder: (context, state) {
                        //build method will load "new collection form" if needed
                        return RoutePage(
                            key: UniqueKey(), body: const NavigationWrapper(body: RxFilesPage(), drawer: FileDrawer()));
                      },
                      routes: [
                        GoRoute(
                            path: 'add',
                            pageBuilder: (context, state) => RoutePage(
                                key: UniqueKey(),
                                body: const NavigationWrapper(body: NewFileCollectionPage(), drawer: FileDrawer()))),
                      ]),

                  /// Photos Module Routes
                  GoRoute(
                      path: '/photos',
                      pageBuilder: (context, state) => RoutePage(
                          key: UniqueKey(), body: const NavigationWrapper(body: PhotosApp(), drawer: PhotoDrawer()))),

                  //Email Networks
                  GoRoute(
                      path: '/email',
                      pageBuilder: (context, state) {
                        return RoutePage(
                            key: UniqueKey(), body: const NavigationWrapper(body: EmailPage(), drawer: EmailDrawer()));
                      },
                      routes: [
                        GoRoute(
                            path: 'add',
                            pageBuilder: (context, state) => RoutePage(
                                key: UniqueKey(),
                                body: const NavigationWrapper(body: NewEmailPage(), drawer: EmailDrawer()))),
                      ]),

                  /// Social Archive Module Routes
                  GoRoute(
                      path: '/social',
                      pageBuilder: (context, state) {
                        return RoutePage(
                            key: UniqueKey(),
                            body: const NavigationWrapper(body: NewSocialPage(), drawer: SocialDrawer()));
                      },
                      routes: [
                        GoRoute(
                            path: 'add',
                            pageBuilder: (context, state) =>
                                RoutePage(key: UniqueKey(), body: const NavigationWrapper(body: NewSocialPage()))),
                        GoRoute(
                            path: 'facebook/:id',
                            pageBuilder: (context, state) {
                              return RoutePage(
                                  key: UniqueKey(),
                                  body: NavigationWrapper(
                                      body: FacebookPage(id: state.pathParameters['id']!),
                                      drawer: const SocialDrawer()));
                            }),
                        GoRoute(
                            path: 'twitter/:id',
                            pageBuilder: (context, state) {
                              return RoutePage(
                                  key: UniqueKey(),
                                  body: NavigationWrapper(
                                      body: TwitterPage(id: state.pathParameters['id']!),
                                      drawer: const SocialDrawer()));
                            }),
                        GoRoute(
                            path: 'instagram/:id',
                            pageBuilder: (context, state) {
                              return RoutePage(
                                  key: UniqueKey(),
                                  body: NavigationWrapper(
                                      body: InstagramPage(id: state.pathParameters["id"]!),
                                      drawer: const SocialDrawer()));
                            }),
                      ]),
                ])
          ]);
}
