import 'dart:async';

import 'package:client/app_constants.dart';
import 'package:client/models/app_models.dart';
import 'package:client/services/get_apps_service.dart';
import 'package:client/services/get_user_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class CollapsingDrawer extends StatefulWidget {
  const CollapsingDrawer({super.key});

  @override
  State<CollapsingDrawer> createState() => _CollapsingDrawerState();
}

class _CollapsingDrawerState extends State<CollapsingDrawer> with SingleTickerProviderStateMixin {
  double maxWidth = 210;
  double minWidth = 70;
  bool isCollapsed = true;
  AnimationController? _animationController;
  Animation<double>? widthAnimation;
  int currentSelectedIndex = 0;
  GetAppsService? _getAppsService;
  StreamSubscription? _appsSub;
  List<Apps> apps = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: minWidth, end: maxWidth).animate(_animationController!);

    _getAppsService = GetAppsService.instance;
    _appsSub = _getAppsService!.sink.listen((value) {
      setState(() {
        apps = value;
      });
    });

    _getAppsService!.invoke(GetAppsServiceCommand());
  }

  @override
  void dispose() {
    _appsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController!, builder: (context, widget) => getWidget(context, widget, apps));
  }

  Widget getWidget(context, widget, List<Apps> apps) {
    //final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);
    double iconPadding = isCollapsed ? 20.0 : 16.0;

    var collectionApps = apps.where((e) => e.group == 'collections').toList();
    var appApps = apps.where((e) => e.group == 'app').toList();

    return MouseRegion(
        onEnter: (PointerEnterEvent details) {
          setState(() => isCollapsed = false);
          _animationController?.duration = const Duration(milliseconds: 70);
          _animationController?.forward();
        },
        onExit: (PointerExitEvent details) {
          setState(() => isCollapsed = true);
          _animationController?.duration = const Duration(milliseconds: 200);
          _animationController?.reverse();
        },
        child: Material(
          color: theme.scaffoldBackgroundColor,
          child: SizedBox(
            width: widthAnimation?.value,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                right: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              )),
              child: Column(
                  // Important: Remove any padding from the ListView.
                  //padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        size: 24.0,
                        color: theme.colorScheme.primary,
                      ),
                      title: isCollapsed ? null : const Text('Home'),
                      contentPadding: EdgeInsets.symmetric(horizontal: iconPadding),
                      onTap: () {
                        GoRouter.of(context).go("/");
                      },
                    ),

                    /// List of different collection apps
                    SizedBox(
                        height: 38,
                        child: ListTile(
                          title: isCollapsed ? const Text('') : const Text('Collections'),
                          onTap: null,
                        )),
                    ...collectionApps.map((app) {
                      return ListTile(
                        leading: Icon(
                          IconData(app.icon ?? 0xe08f, fontFamily: 'MaterialIcons'),
                          size: 24.0,
                          color: theme.colorScheme.primary,
                        ),
                        title: isCollapsed ? null : Text(app.name, softWrap: false),
                        contentPadding: EdgeInsets.symmetric(horizontal: iconPadding),
                        onTap: () {
                          GoRouter.of(context).go(app.route);
                        },
                      );
                    }),

                    /// Apps build to work with the different locations
                    SizedBox(
                        height: 38,
                        child: ListTile(
                          title: isCollapsed ? const Text('') : const Text('Applications'),
                          onTap: null,
                        )),
                    ...appApps.map((app) {
                      return ListTile(
                        leading: Icon(
                          IconData(app.icon ?? 0xe08f, fontFamily: 'MaterialIcons'),
                          size: 24.0,
                          color: theme.colorScheme.primary,
                        ),
                        title: isCollapsed ? null : Text(app.name, softWrap: false),
                        contentPadding: EdgeInsets.symmetric(horizontal: iconPadding),
                        onTap: () {
                          GoRouter.of(context).go(app.route);
                        },
                      );
                    }),
                    const Spacer(),
                    Divider(
                      color: theme.dividerColor,
                      height: 4.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: 24.0,
                        color: theme.colorScheme.primary,
                      ),
                      title: isCollapsed ? null : const Text('Logout'),
                      contentPadding: EdgeInsets.symmetric(horizontal: iconPadding),
                      onTap: () async {
                        //clear local provider
                        GetUserService.instance.invoke(GetUserServiceCommand(null));

                        //clear remembered password
                        FlutterSecureStorage storage = const FlutterSecureStorage();
                        await storage.write(key: AppConstants.securePassword, value: null);

                        //reload router
                        GoRouter.of(context).go('/?action=logout');
                      },
                    ),
                    /**
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isCollapsed = !isCollapsed;
                              isCollapsed
                                  ? _animationController?.forward()
                                  : _animationController?.reverse();
                            });
                          },
                          child: isCollapsed
                              ? const Icon(Icons.last_page)
                              : const Icon(Icons.first_page)),
                    ),
                    **/
                    const SizedBox(height: 10.0),
                  ]),
            ),
          ),
        ));
  }
}
