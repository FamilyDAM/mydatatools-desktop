// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io' as io;

import 'package:client/models/tables/file.dart';
import 'package:client/models/tables/file_asset.dart';
import 'package:client/modules/files/files_constants.dart';
import 'package:client/modules/files/notifications/path_changed_notification.dart';
import 'package:client/modules/files/notifications/sort_changed_notification.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:open_filex/open_filex.dart';

class FileTable extends StatefulWidget {
  const FileTable({super.key, required this.data});
  final List<FileAsset> data;

  @override
  State<FileTable> createState() => _FileTable();
}

class _FileTable extends State<FileTable> {
  int sortColumnIndex = 0;
  String sortColumn = 'name';
  bool sortAsc = true;
  List<String> selectedRows = [];

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

    List<DataColumn> columns = getColumns(context);
    List<DataRow> rows = getRows(context, widget.data);

    return Expanded(
        flex: 1,
        child: Container(
            constraints: const BoxConstraints.expand(),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: columns,
                  rows: rows,
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAsc,
                  showCheckboxColumn: true,
                ))));
  }

  List<DataColumn> getColumns(BuildContext context) {
    return <DataColumn>[
      DataColumn(
          label: const Expanded(
              flex: 2,
              child: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          onSort: (columnIndex, sortAscending) {
            sortColumnIndex = columnIndex;
            sortColumn = 'name';
            sortAsc = sortAscending;
            SortChangedNotification(sortColumn, sortAscending).dispatch(context);
          }),
      DataColumn(
          numeric: true,
          label: const Expanded(
              flex: 1,
              child: Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.normal),
              )),
          onSort: (columnIndex, sortAscending) {
            sortColumnIndex = columnIndex;
            sortColumn = 'contentType';
            sortAsc = sortAscending;
            SortChangedNotification(sortColumn, sortAscending).dispatch(context);
          }),
      DataColumn(
          numeric: true,
          label: const Expanded(
              flex: 1,
              child: Text(
                'Size',
                style: TextStyle(fontWeight: FontWeight.normal),
              )),
          onSort: (columnIndex, sortAscending) {
            sortColumnIndex = columnIndex;
            sortColumn = 'size';
            sortAsc = sortAscending;
            SortChangedNotification(sortColumn, sortAscending).dispatch(context);
          }),
      DataColumn(
          label: const Expanded(
            flex: 1,
            child: Text(
              'Date Created',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          onSort: (columnIndex, sortAscending) {
            sortColumnIndex = columnIndex;
            sortColumn = 'date_created';
            sortAsc = sortAscending;
            SortChangedNotification(sortColumn, sortAscending).dispatch(context);
          }),
      const DataColumn(
          label: Center(
        child: Text(
          'Actions',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      )),
    ];
  }

  List<DataRow> getRows(BuildContext context, List<FileAsset> assets) {
    //DateFormat df = DateFormat('yyyy-MM-dd HH:mm');
    List<DataRow> rows = [];

    //Create a row for every item returns from DB
    for (var f in assets) {
      if (f is File) {
        //File Cells
        var moment = Moment.fromMillisecondsSinceEpoch(f.dateCreated.millisecondsSinceEpoch, isUtc: true);
        bool isImage = f.contentType == FilesConstants.mimeTypeImage;

        rows.add(DataRow(
            selected: selectedRows.contains(f.path),
            cells: [
              DataCell(
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 200), //SET max width
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        !isImage ? Icon(getIconForMimeType(f.contentType)) : getImageComponent(isImage, f),
                        const SizedBox(width: 8),
                        Text(f.name, overflow: TextOverflow.ellipsis),
                      ],
                    )),
                onTap: () {
                  debugPrint("todo: show file metadata");
                },
              ),
              DataCell(ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100), //SET max width
                  child: Text(f.contentType.split("/").last, overflow: TextOverflow.clip))),
              DataCell(ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100), //SET max width
                  child: Text('${f.size}kb', overflow: TextOverflow.clip))),
              DataCell(
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150), //SET max width
                      child: Tooltip(
                          message: f.dateCreated.toLocal().toString(),
                          child: Text(
                              moment.fromNowPrecise(
                                form: Abbreviation.full,
                                includeWeeks: true,
                              ),
                              overflow: TextOverflow.clip))),
                  showEditIcon: false),
              DataCell(ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100), //SET max width
                  child: Row(children: [
                    IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () async {
                          //download
                          ///io.File file = await dataProvider.fileService.fileRepository.downloadFile(f);
                          //show message
                          //var msg = ScaffoldMessenger.of(context);
                          //msg.showSnackBar(SnackBar(content: Text('File download to: ${file.path}')));
                          //then open
                          // TODO: trigger open in default app
                          await OpenFilex.open(f.path);
                        }),
                    const IconButton(icon: Icon(Icons.delete), onPressed: null),
                  ]))),
            ],
            onSelectChanged: (bool? e) {
              if (e != null && e) {
                selectedRows.add(f.path);
              } else {
                selectedRows.remove(f.path);
              }
            }));
      } else {
        //Folder Row (mostly empty cells)
        rows.add(DataRow(
            selected: selectedRows.contains(f.path),
            cells: [
              DataCell(
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 300), //SET max width
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.folder),
                        const SizedBox(width: 8),
                        Text(f.name, overflow: TextOverflow.ellipsis),
                      ],
                    )),
                onTap: () {
                  // TODO
                  //context.go('/files/${f.collectionId}/${f.path}');
                  //alert parent of new path, to show in breadcrumb
                  PathChangedNotification(f, sortColumn, sortAsc).dispatch(context);
                },
              ),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
            ],
            onSelectChanged: (bool? e) {
              if (e != null && e) {
                selectedRows.add(f.path);
              } else {
                selectedRows.remove(f.path);
              }
            }));
      }
    }
    return rows;
  }

  Widget getImageComponent(bool isImage, File file) {
    if (isImage) {
      try {
        if (file.thumbnail != null) {
          return Padding(
              padding: const EdgeInsets.all(4),
              child: Image(image: ResizeImage(MemoryImage(base64Decode(file.thumbnail!)), width: 100, height: 64)));
        } else {
          return Padding(
              padding: const EdgeInsets.all(4),
              child: Image(image: ResizeImage(FileImage(io.File(file.path)), width: 100, height: 64)));
        }
      } catch (err) {
        //do nothing, return placeholder
      }
    }
    return const Placeholder();
  }

  IconData? getIconForMimeType(String contentType) {
    switch (contentType) {
      case FilesConstants.mimeTypeImage:
        return Icons.image;
      case FilesConstants.mimeTypePdf:
        return Icons.picture_as_pdf;
      default:
        return Icons.file_present;
    }
  }
}
