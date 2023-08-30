// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //_authDialogManager();
    //SchedulerBinding.instance.addPostFrameCallback((_) => _showDialog(context));

    GetCollectionsService.instance.invoke(GetCollectionsServiceCommand(null));
  }

  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    //final colorScheme = Theme.of(context).colorScheme;
    //bool isDesktop = !kIsWeb;
    //(defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.windows);

    return const Column(children: [
      Text("Home Page"),
      Text("welcome!"),
    ]);
  }
}
