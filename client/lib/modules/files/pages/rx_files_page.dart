import 'dart:async';

import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/file_asset.dart';
import 'package:client/models/tables/folder.dart';
import 'package:client/modules/files/notifications/file_notification.dart';
import 'package:client/modules/files/notifications/path_changed_notification.dart';
import 'package:client/modules/files/notifications/sort_changed_notification.dart';
import 'package:client/modules/files/pages/new_file_collection_page.dart';
import 'package:client/modules/files/services/get_files_and_folders_service.dart';
import 'package:client/modules/files/widgets/file_table.dart';
import 'package:client/scanners/scanner_manager.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:rxdart/rxdart.dart';

class RxFilesPage extends StatefulWidget {
  const RxFilesPage({super.key});

  static PublishSubject selectedCollection = PublishSubject();
  static PublishSubject selectedPath = PublishSubject();
  static BehaviorSubject<String> sortColumn = BehaviorSubject.seeded("name");
  static BehaviorSubject<bool> sortDirection = BehaviorSubject.seeded(true);

  //String sortColumn, bool direction

  @override
  State<RxFilesPage> createState() => _RxFilesPage();
}

class _RxFilesPage extends State<RxFilesPage> {
  AppLogger logger = AppLogger(null);
  GetFileAndFoldersService? _filesAndFoldersService;
  GetCollectionsService? _collectionService;
  StreamSubscription<List<FileAsset>>? _fileServiceSub;
  StreamSubscription<List<Collection>>? _collectionsServiceSub;
  StreamSubscription? _selectedCollectionSub;

  List<FileAsset> filesAndFolders = [];
  List<Collection> collections = [];
  Collection? collection;
  String? path;
  String sortColumn = "name";
  bool sortAsc = true;

  @override
  void initState() {
    _collectionService = GetCollectionsService.instance;

    _collectionsServiceSub = _collectionService!.sink.listen((value) {
      setState(() {
        collections = value;
      });
      if (value.isNotEmpty) {
        //select default collection
        RxFilesPage.selectedCollection.add(value.first);
      }
    });

    _selectedCollectionSub = RxFilesPage.selectedCollection.listen((value) {
      if (value != null && collection != value) {
        //create new sub for emails in this collection
        _filesAndFoldersService = GetFileAndFoldersService();
        //close old subscription
        if (_fileServiceSub != null) _fileServiceSub?.cancel();
        //listen for changes while visible
        _fileServiceSub = _filesAndFoldersService!.sink.listen((value) {
          setState(() {
            filesAndFolders = _mergeAndSortRowData(value, sortColumn, sortAsc);
          });
        });

        _filesAndFoldersService!.invoke(GetFileServiceCommand(value, value.path));
      }
      setState(() {
        collection = value;
        path = value?.path;
      });
    });

    _collectionService!.invoke(GetCollectionsServiceCommand(null)); //load all
    super.initState();
  }

  @override
  void dispose() {
    _fileServiceSub?.cancel();
    _collectionsServiceSub?.cancel();
    _selectedCollectionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    if (collections.isEmpty) {
      return const NewFileCollectionPage();
    }

    if (collection == null) {
      return Container();
    }
    //parse path into a breadcrumb

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.secondaryHeaderColor,
          centerTitle: false,
          shadowColor: theme.scaffoldBackgroundColor,
          title: getBreadcrumb(collection!, path ?? collection!.path),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              tooltip: 'Upload file',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('todo: add file to current folder')));
              },
            ),
            IconButton(
              // TODO: disable is no files are checked
              icon: const Icon(Icons.download, color: Colors.black),
              tooltip: 'Download File(s)',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('todo: download single file or zip of multiple')));
              },
            ),
            IconButton(
              // TODO: disable is no files are checked
              icon: const Icon(Icons.refresh, color: Colors.black),
              tooltip: 'Refresh',
              onPressed: () {
                //reset date
                // collectionRepository.updateLastScanDate(collection, null);
                //refresh path
                if (collection != null) {
                  logger.s("refresh file list");
                  ScannerManager.getInstance().getScanner(collection!)?.start(collection!, null, true, true);
                }
              },
            ),
            IconButton(
              // TODO: disable is no files are checked
              icon: const Icon(Icons.delete, color: Colors.black),
              tooltip: 'Delete File(s)',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('todo: delete file or set of files')));
              },
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 3,
                      child: NotificationListener<FiledNotification>(
                          child: Column(children: [FileTable(data: filesAndFolders)]),
                          onNotification: (FiledNotification n) {
                            if (n is PathChangedNotification) {
                              if (n.asset.path != collection?.path) {
                                //make sure path changed before triggering reload
                                path = n.asset.path;
                                _filesAndFoldersService!.invoke(GetFileServiceCommand(collection!, n.asset.path));
                                return true;
                              }
                            }
                            if (n is SortChangedNotification) {
                              sortColumn = n.sortColumn;
                              sortAsc = n.sortAsc;
                              setState(() {
                                filesAndFolders = _mergeAndSortRowData(filesAndFolders, sortColumn, sortAsc);
                              });
                              return true;
                            }
                            return false;
                          }))
                ],
              ),
            ),
          ],
        ));
  }

  BreadCrumb getBreadcrumb(Collection collection, String path) {
    List<String> pathParts = path.split(":").last.split('/');
    List<String> collectionParts = collection.path.split('/');
    List<String> parts = [];
    for (var i = 0; i < pathParts.length; ++i) {
      var p = pathParts[i];
      var cp = (collectionParts.length > i) ? collectionParts[i] : "";
      if (p != cp) {
        parts.add(pathParts[i]);
      }
    }

    List<String> workingPath = [];

    return BreadCrumb(
      items: <BreadCrumbItem>[
        BreadCrumbItem(
            content: const Icon(Icons.home, color: Colors.black),
            onTap: () {
              //return null, to unselect a collection and have app go back to pick collection (home) page
              //return dummy FileCollection
              path = collection.path;
              _filesAndFoldersService!.invoke(GetFileServiceCommand(collection, path));
            }),
        BreadCrumbItem(
            content: Text(collection.name),
            onTap: () {
              //go back to root of collection
              path = collection.path;
              _filesAndFoldersService!.invoke(GetFileServiceCommand(collection, path));
            }),
        ...parts.where((e) => e != '').map((e) {
          workingPath.add(e);
          String p = '${collection.path}/${workingPath.join("/")}';
          return BreadCrumbItem(
              content: Text(e),
              onTap: () {
                //drill into sub folder path
                path = p;
                _filesAndFoldersService!.invoke(GetFileServiceCommand(collection, path));
              });
        })
      ],
      divider: const Icon(
        Icons.chevron_right,
        color: Colors.black,
      ),
      overflow: const WrapOverflow(
        keepLastDivider: false,
        direction: Axis.horizontal,
      ),
    );
  }

  List<FileAsset> _mergeAndSortRowData(List<FileAsset> fileAssets, String sortColumn, bool sortAsc) {
    fileAssets.sort((a, b) {
      if (a is File && b is Folder) {
        return 1;
      } else if (a is Folder && b is File) {
        return -1;
      } else {
        if (sortAsc) {
          if (a is File && b is File && sortColumn == "size") {
            return a.size.compareTo(b.size);
          } else if (sortColumn == "date_created") {
            return a.dateCreated.compareTo(b.dateCreated);
          } else {
            return a.name.compareTo(b.name);
          }
        } else {
          if (a is File && b is File && sortColumn == "size") {
            return b.size.compareTo(a.size);
          } else if (sortColumn == "date_created") {
            return b.dateCreated.compareTo(a.dateCreated);
          } else {
            return b.name.compareTo(a.name);
          }
        }
      }
    });

    return fileAssets;
  }
}
