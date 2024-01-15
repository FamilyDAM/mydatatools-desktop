import 'dart:async';

import 'package:client/models/tables/collection.dart';
import 'package:client/modules/email/pages/email_page.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailDrawer extends StatefulWidget {
  const EmailDrawer({super.key});

  @override
  State<EmailDrawer> createState() => _EmailDrawer();
}

class _EmailDrawer extends State<EmailDrawer> {
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
    final theme = Theme.of(context);

    return SizedBox.expand(
        child: Container(
            height: double.infinity,
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.all(8),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: FloatingActionButton(
                  tooltip: "Add Email",
                  child: const Icon(Icons.add),
                  onPressed: () {
                    debugPrint("fab pressed");
                    GoRouter.of(context).go("/email/add");
                  },
                ),
                body: Column(children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Email Accounts:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(collections[index].name),
                          onTap: () {
                            EmailPage.selectedCollection.add(collections[index]);
                            context.go('/email');

                            ///${collections[index].id}
                          },
                        );
                      },
                    ),
                  )
                ]))));
  }
}
