import 'dart:async';

import 'package:client/models/collection_model.dart';
import 'package:client/modules/files/pages/rx_files_page.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FileDrawer extends StatefulWidget {
  const FileDrawer({super.key});

  @override
  State<FileDrawer> createState() => _FileDrawer();
}

class _FileDrawer extends State<FileDrawer> {
  GetCollectionsService? _collectionService;
  StreamSubscription<List<Collection>>? _collectionsServiceSub;
  StreamSubscription? _selectedCollectionSub;

  List<Collection> collections = [];
  Collection? collection;

  @override
  void initState() {
    _collectionService = GetCollectionsService.instance;

    _collectionsServiceSub = _collectionService!.sink.listen((value) {
      setState(() {
        collections = value;
      });
    });

    _selectedCollectionSub = RxFilesPage.selectedCollection.listen((value) {
      setState(() {
        collection = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _collectionsServiceSub?.cancel();
    _selectedCollectionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //split into two set so we can show them in groups in the list
    List<Collection> filesC = collections.where((element) => element.type == 'file').toList();
    List<Collection> emailC = collections.where((element) => element.type == 'email').toList();

    return SizedBox.expand(
        child: Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.all(8),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: FloatingActionButton(
                tooltip: "Add File Collection",
                child: const Icon(Icons.add),
                onPressed: () {
                  GoRouter.of(context).go("/files/add");
                },
              ),
              body: Column(children: [
                const SizedBox(
                  height: 8,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Files:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: filesC.length * 50,
                  child: ListView.builder(
                    itemCount: filesC.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filesC[index].name),
                        onTap: () {
                          //update before redirection
                          RxFilesPage.selectedCollection.add(filesC[index]);
                          RxFilesPage.selectedPath.add(filesC[index].path);
                          GoRouter.of(context).go('/files');
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Emails:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 150, //emailC.length * 50,
                  child: ListView.builder(
                    itemCount: emailC.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(emailC[index].name),
                        onTap: () {
                          //update before redirection
                          RxFilesPage.selectedCollection.add(emailC[index]);
                          RxFilesPage.selectedPath.add(emailC[index].path);
                          //GoRouter.of(context).go('/files/${emailC[index].id}');
                        },
                      );
                    },
                  ),
                ),
              ]),
            )));
  }
}
