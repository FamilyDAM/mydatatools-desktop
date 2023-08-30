// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class TwitterPage extends StatelessWidget {
  const TwitterPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    //final colorScheme = Theme.of(context).colorScheme;
    //bool isDesktop = !kIsWeb;
    //(defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.windows);

    return const Column(children: [
      Text("Twitter Page"),
    ]);
  }
}
