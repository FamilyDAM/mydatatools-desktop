// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class NewSocialPage extends StatelessWidget {
  const NewSocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    //final colorScheme = Theme.of(context).colorScheme;
    //bool isDesktop = !kIsWeb;
    //(defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.windows);

    return Scaffold(
        body: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.facebook), text: 'Facebook'),
                      Tab(icon: Icon(Icons.person), text: 'Instagram'),
                      Tab(icon: Icon(Icons.person), text: 'Twitter'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 225,
                            height: 48,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.facebook),
                                label: const Text("Login with Facebook"),
                                onPressed: null),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 225,
                            height: 48,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.person),
                                label: const Text("Login with Instagram"),
                                onPressed: null),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 225,
                            height: 48,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.person),
                                label: const Text("Login with Twitter"),
                                onPressed: null),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    ));
  }
}
