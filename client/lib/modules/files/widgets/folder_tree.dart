// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class FolderTree extends StatefulWidget {
  const FolderTree({super.key});

  @override
  State<FolderTree> createState() => _FolderTreeState();
}

class _FolderTreeState extends State<FolderTree> {
  @override
  Widget build(BuildContext context) {
    //final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //final dataProvider = Provider.of<DataProvider>(context, listen: false);
    //final theme = Theme.of(context);

    return const Column(children: [
      Text("Tree View"),
    ]);
  }
}
