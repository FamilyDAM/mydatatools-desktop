// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:client/app_constants.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/modules/email/pages/email_page.dart';
import 'package:client/oauth/desktop_oauth_manager.dart';
import 'package:client/oauth/login_provider.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/repositories/realm_repository.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:reactive_forms/reactive_forms.dart';
import 'package:realm/realm.dart';

class NewEmailPage extends StatefulWidget {
  const NewEmailPage({super.key});

  @override
  State<NewEmailPage> createState() => _NewEmailPage();
}

class _NewEmailPage extends State<NewEmailPage> {
  final GetCollectionsService _collectionsService = GetCollectionsService.instance;
  StreamSubscription<List<Collection>>? _collectionsServiceSub;
  List<Collection> collections = [];

  @override
  void initState() {
    _collectionsServiceSub = _collectionsService.sink.listen((value) {
      setState(() {
        collections = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _collectionsServiceSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    //final colorScheme = Theme.of(context).colorScheme;

    final outlookPstForm = FormGroup({
      'file': FormControl<String>(),
    });

    final imapForm = FormGroup({
      'host': FormControl<String>(),
      'port': FormControl<Int>(),
      'username': FormControl<String>(),
      'password': FormControl<String>(),
    });

    final popForm = FormGroup({
      'host': FormControl<String>(),
      'port': FormControl<Int>(),
      'username': FormControl<String>(),
      'password': FormControl<String>(),
    });

    return Scaffold(
        body: Center(
      child: SizedBox.expand(
        child: DefaultTabController(
            length: 6,
            child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.email), text: 'Gmail'),
                      Tab(icon: Icon(Icons.email), text: 'Yahoo Mail'),
                      Tab(icon: Icon(Icons.email), text: 'Outlook Mail'),
                      Tab(icon: Icon(Icons.email), text: 'Outlook PST'),
                      Tab(icon: Icon(Icons.email), text: 'IMAP'),
                      Tab(icon: Icon(Icons.email), text: 'POP'),
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
                                icon: const Icon(Icons.email),
                                label: const Text("Login with Google"),
                                onPressed: () async {
                                  await LoginProviderExtension.handleGoogleMail(context, null);
                                  if (context.mounted) {
                                    GoRouter.of(context).go("/email");
                                    GoRouter.of(context).refresh();
                                  }
                                }),
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
                                icon: const Icon(Icons.email),
                                label: const Text("Login with Yahoo"),
                                onPressed: () async {
                                  await handleYahooMail(context, collections);
                                  if (context.mounted) {
                                    GoRouter.of(context).go("/email");
                                    GoRouter.of(context).refresh();
                                  }
                                }),
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
                                icon: const Icon(Icons.email),
                                label: const Text("Login with Outlook"),
                                onPressed: null),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ReactiveForm(
                          formGroup: outlookPstForm,
                          child: Column(
                            children: <Widget>[
                              ReactiveTextField(
                                formControlName: 'file',
                                validationMessages: {'required': (error) => 'A valid file must be entered'},
                              ),
                              const ElevatedButton(onPressed: null, child: Text("Browse")),
                              const ElevatedButton(onPressed: null, child: Text("Import Emails"))
                            ],
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ReactiveForm(
                          formGroup: imapForm,
                          child: Column(
                            children: <Widget>[
                              ReactiveTextField(
                                formControlName: 'host',
                              ),
                              ReactiveTextField(
                                formControlName: 'port',
                              ),
                              ReactiveTextField(
                                formControlName: 'username',
                              ),
                              ReactiveTextField(
                                formControlName: 'password',
                                obscureText: true,
                              ),
                              const ElevatedButton(onPressed: null, child: Text("Import Emails"))
                            ],
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ReactiveForm(
                          formGroup: popForm,
                          child: Column(
                            children: <Widget>[
                              ReactiveTextField(
                                formControlName: 'host',
                              ),
                              ReactiveTextField(
                                formControlName: 'port',
                              ),
                              ReactiveTextField(
                                formControlName: 'username',
                              ),
                              ReactiveTextField(
                                formControlName: 'password',
                                obscureText: true,
                              ),
                              const ElevatedButton(onPressed: null, child: Text("Import Emails"))
                            ],
                          ),
                        )),
                  ],
                ))),
      ),
    ));
  }

  handleYahooMail(BuildContext context, List<Collection> collections) async {
    //Scopes:
    //https://www.googleapis.com/auth/gmail.readonly
    //todo: Security Assessment will be required
    //@see https://support.google.com/cloud/answer/9110914#zippy=%2Cgmail-api%2Cexceptions-to-verification-requirements%2Csteps-to-prepare-for-verification%2Csteps-for-apps-requesting-sensitive-scopes%2Csteps-for-apps-requesting-restricted-scopes%2Csteps-to-submit-your-app%2Csecurity-assessment
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      final provider = DesktopOAuthManager(loginProvider: LoginProvider.google);

      var client = await provider.login();
      //print('token=${client.credentials.accessToken}');

      /// Handle successful login by creating a new collection for the user or updating current collection
      var peopleUrl = Uri.parse("https://people.googleapis.com/v1/people/me?personFields=emailAddresses");
      var response = await http.get(peopleUrl, headers: {"Authorization": "Bearer ${client.credentials.accessToken}"});
      if (response.statusCode == 200) {
        Map<String, dynamic> user = jsonDecode(response.body);

        var userId = user['resourceName'].split("/")[1];
        var emails = user['emailAddresses'] as List;
        var email = emails.firstWhere((element) => (element['metadata']['primary'] ?? false) == true)['value'];

        //Find existing email
        var existingCollection = collections.firstWhereOrNull((element) => element.name == email);

        var id = existingCollection?.id ?? Uuid.v4().toString();
        var root = File(RealmRepository.instance.database.config.path).parent.parent;

        // Create/Update Collection with the following bits of oauth data
        Collection collection = Collection(
            id, email, "${root.path}/files/email/$email", "email", AppConstants.scannerEmailGmail, "pending",
            oauthService: "google",
            accessToken: client.credentials.accessToken,
            refreshToken: client.credentials.refreshToken,
            idToken: client.credentials.idToken,
            userId: userId,
            expiration: client.credentials.expiration);

        //Save collection
        CollectionRepository(RealmRepository.instance.database).addCollection(collection).then((value) {
          GetCollectionsService.instance.invoke(GetCollectionsServiceCommand("email")); //reload all
          //make new default selected collection
          EmailPage.selectedCollection.add(value);
          context.go("/email");
        });

        return Future(() => collection);
      } else {
        print("Error");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unsupported platform, open up the desktop version of this application to add new accounts.')));
    }
  }
}
