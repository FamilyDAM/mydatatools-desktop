import 'dart:async';

import 'package:client/models/tables/collection.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhotoDrawer extends StatefulWidget {
  const PhotoDrawer({super.key});

  @override
  State<PhotoDrawer> createState() => _PhotoDrawerState();
}

class _PhotoDrawerState extends State<PhotoDrawer> {
  GetCollectionsService? _getCollectionsService;
  StreamSubscription? _collectionsSub;
  List<Collection> collections = [];

  @override
  void initState() {
    _getCollectionsService = GetCollectionsService.instance;
    _collectionsSub = _getCollectionsService!.sink.listen((value) {
      setState(() {
        collections = value;
      });
    });

    _getCollectionsService!.invoke(GetCollectionsServiceCommand("album"));
    super.initState();
  }

  @override
  void dispose() {
    _collectionsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.expand(
        child: Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Collections",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 8,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Albums:",
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(collections[index].name),
                      onTap: () {
                        GoRouter.of(context).go("/photos/${collections[index].id}");
                      },
                    );
                  },
                ),
              )
            ])));
  }
}
