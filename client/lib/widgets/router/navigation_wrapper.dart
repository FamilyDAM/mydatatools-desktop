import 'package:client/widgets/adaptive_app_bar.dart';
import 'package:client/widgets/collapsing_drawer.dart';
import 'package:client/widgets/router/status_message.dart';
import 'package:flutter/material.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key, required this.body, this.drawer});

  final Widget body;
  final Widget? drawer;

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  bool drawerOpen = true;
  final GlobalKey<ScaffoldState> appScaffold = GlobalKey<ScaffoldState>();

  List<NavigationDestination> destinations = const [
    NavigationDestination(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    NavigationDestination(
      label: 'Home2',
      icon: Icon(Icons.home),
    ),
    NavigationDestination(
      label: 'Home3',
      icon: Icon(Icons.home),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyWithDrawer = Column(
      children: [
        Expanded(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CollapsingDrawer(),
            (drawerOpen && widget.drawer != null) ? SizedBox(width: 225, child: widget.drawer) : Container(),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
              child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: theme.scaffoldBackgroundColor)),
                  child: widget.body),
            )),
          ],
        )),
        SizedBox(
          height: 22,
          child: Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: const Border(
                    top: BorderSide(width: 1.0, color: Colors.black12),
                  )),
              child: const Row(
                children: [StatusMessage()],
              )),
        )
      ],
    );

    return Scaffold(
        key: appScaffold,
        appBar: AdaptiveAppBar(onMenuPressed: () {
          setState(() => drawerOpen = !drawerOpen);
        }),
        body: bodyWithDrawer);
  }
}
