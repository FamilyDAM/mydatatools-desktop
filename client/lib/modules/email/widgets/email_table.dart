import 'package:client/models/module_models.dart';
import 'package:client/modules/email/notifications/email_sort_changed_notification.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

class EmailTable extends StatefulWidget {
  const EmailTable({Key? key, required this.count, required this.emails}) : super(key: key);

  final int count;
  final List<Email> emails;

  @override
  State<EmailTable> createState() => _EmailTable();
}

class _EmailTable extends State<EmailTable> {
  int sortColumnIndex = 0;
  String sortColumn = 'path';
  bool sortAsc = true;

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    List<DataColumn> columns = getColumns(context);

    return Expanded(
        flex: 1,
        child: Container(
            constraints: const BoxConstraints.expand(),
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              int calcRows = ((constraints.maxHeight - 75) / 50).floor();

              DataTableSource gridDate = GridData(widget.emails, widget.count, constraints.maxWidth);

              return SingleChildScrollView(
                child: PaginatedDataTable(
                  source: gridDate,
                  columns: columns,
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAsc,
                  showCheckboxColumn: true,
                  showFirstLastButtons: true,
                  rowsPerPage: calcRows,
                  /**
                   rowsPerPage: preferredRows
                   availableRowsPerPage: [calcRows, 10, 25, 50, 100, 250],
                   onRowsPerPageChanged: (value) {
                    setState(() {
                      preferredRows = value ?? calcRows;
                    });
                  },**/
                ),
              );
            })));
  }

  List<DataColumn> getColumns(BuildContext context) {
    return <DataColumn>[
      DataColumn(
          label: const Text(
            'From',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onSort: (columnIndex, sortAscending) {
            sortColumnIndex = columnIndex;
            sortColumn = 'from';
            sortAsc = sortAscending;
            EmailSortChangedNotification(sortColumn, sortAsc).dispatch(context);
          }),
      const DataColumn(
        numeric: false,
        label: Text(
          'Subject',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      DataColumn(
          numeric: true,
          label: const Text(
            'Date',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          onSort: (columnIndex, sortAscending) {
            sortColumnIndex = columnIndex;
            sortColumn = 'date';
            sortAsc = sortAscending;
            EmailSortChangedNotification(sortColumn, sortAsc).dispatch(context);
          }),
    ];
  }
}

class GridData extends DataTableSource {
  List<Email> emails = [];
  int count = 0;
  double width = 500;

  GridData(this.emails, this.count, this.width);

  @override
  DataRow? getRow(int index) {
    Email email = emails[index];
    String from = email.from!.split("<")[0].trim();
    Moment moment = Moment.fromMillisecondsSinceEpoch(email.date.toUtc().millisecondsSinceEpoch, isUtc: true);

    return DataRow(
        selected: email.isSelected,
        cells: [
          DataCell(
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200), //SET max width
                  child: Text(from, overflow: TextOverflow.clip, style: const TextStyle(fontWeight: FontWeight.bold))),
              onTap: () => print('tap from')),
          DataCell(
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width - 500), //SET max width
                  child: Text(email.subject ?? '', overflow: TextOverflow.ellipsis)),
              onTap: () => print('tap subject')),
          DataCell(
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100), //SET max width
                  child: Tooltip(
                      message: email.date.toLocal().toString(),
                      child: Text(
                          moment.fromNow(
                            form: UnitStringForm.short,
                          ),
                          overflow: TextOverflow.clip))),
              onTap: () => print('tap date')),
        ],
        onSelectChanged: (bool? e) {
          print("selection changed");
          email.isSelected = e ?? false;
          notifyListeners();
          /**
          if (e != null && e) {
            selectedRows.add(f.id);
          } else {
            selectedRows.remove(f.id);
          }
          setState(() {
            selectedRows = selectedRows;
          });
              **/
        });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
