import 'dart:async';
import 'dart:core';

import 'package:client/models/module_models.dart';
import 'package:client/modules/photos/services/photos_by_date_service.dart';
import 'package:client/modules/photos/widgets/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PhotosApp extends StatefulWidget {
  const PhotosApp({super.key});

  //String sortColumn, bool direction

  @override
  State<PhotosApp> createState() => _PhotosApp();
}

class _PhotosApp extends State<PhotosApp> {
  PhotosByDateService? _photosByDateService;
  StreamSubscription? _photosSub;

  Map<String, List<File>> photos = {};

  @override
  void initState() {
    _photosByDateService = PhotosByDateService.instance;

    _photosSub = _photosByDateService!.sink.listen((value) {
      setState(() {
        photos = value;
      });
    });

    _photosByDateService!.invoke(PhotosByDateServiceCommand()); //load all
    super.initState();
  }

  @override
  void dispose() {
    _photosSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final authService = Provider.of<AuthProvider>(context, listen: false);
    //final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    //layout props
    double dateW = 210;
    double imgW = 125;
    //double columnsW = ((size.width - 150) / imgW);
    double ratio = 1 - ((size.width - dateW) / size.width);

    List<String> keys = photos.keys.toList();
    keys.sort((a, b) => b.compareTo(a));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.secondaryHeaderColor,
          centerTitle: false,
          shadowColor: theme.scaffoldBackgroundColor,
          title: const Text("My Photos"),
          actions: <Widget>[
            IconButton(
              //todo: disable is no files are checked
              icon: const Icon(Icons.filter_list, color: Colors.black),
              tooltip: 'Download File(s)',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('todo: show filter')));
              },
            ),
            IconButton(
              //todo: disable is no files are checked
              icon: const Icon(Icons.search, color: Colors.black),
              tooltip: 'Delete File(s)',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('todo: show search')));
              },
            )
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            itemCount: keys.length,
            itemBuilder: (BuildContext ctxt, int indx) {
              //get all files linked to date key
              List<File> files = photos[keys[indx]] ?? [];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: ratio,
                  isFirst: indx == 0,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    indicatorXY: 0,
                    color: Colors.purple,
                    padding: const EdgeInsets.all(8),
                    iconStyle: IconStyle(
                      color: Colors.white,
                      iconData: Icons.calendar_month,
                    ),
                  ),
                  startChild: SizedBox(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              keys[indx],
                              textWidthBasis: TextWidthBasis.longestLine,
                            )),
                      )),
                  endChild: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    direction: Axis.horizontal,
                    children: [
                      ...files.map((f) {
                        return PhotoCard(file: f, width: imgW);
                      })
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
