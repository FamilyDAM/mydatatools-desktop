import 'package:flutter/material.dart';

class EmailSortChangedNotification extends Notification {
  final String sortColumn;
  final bool sortAsc;

  EmailSortChangedNotification(this.sortColumn, this.sortAsc);
}
