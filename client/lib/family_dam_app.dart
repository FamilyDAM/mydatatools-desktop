import 'package:client/app_router.dart';
import 'package:flutter/material.dart';

class FamilyDamApp extends StatelessWidget {
  const FamilyDamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'mydata.tools',
      title: "MyData / Tools",
      debugShowCheckedModeBanner: true,
      routerConfig: AppRouter.instance,
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          dividerColor: Colors.black12,
          scaffoldBackgroundColor: Colors.white70,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black.withOpacity(.7),
                displayColor: Colors.black.withOpacity(.7),
              ),
          cardTheme: const CardTheme(
              //set card color for PaginatedDataTable
              surfaceTintColor: Colors.white,
              elevation: 0)),
      //theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      //darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    );
  }
}
