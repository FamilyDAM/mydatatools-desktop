// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:client/widgets/login_form.dart';
import 'package:client/widgets/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final unfocusNode = FocusNode();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    //final textTheme = Theme.of(context).textTheme;
    //final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: scaffoldKey,
      //backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Stack(children: [
                      Image.network(
                        'https://picsum.photos/800/800',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 1,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.75, 0),
                        child: SizedBox(
                            width: 300,
                            height: double.infinity,
                            child: Center(child: LoginForm(
                              onLoginSuccessful: () {
                                if (context.mounted) {
                                  context.go('/');
                                }
                              },
                            ))),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.87, 0.82),
                        child: Visibility(
                          visible: MediaQuery.of(context).orientation == Orientation.landscape,
                          child: const SizedBox(width: 250, height: 100, child: TimeWidget()),
                        ),
                      ),
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
