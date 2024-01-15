import 'package:client/models/tables/collection.dart';
import 'package:flutter/material.dart';

class NewCollectionNotification extends Notification {
  final Collection val;
  NewCollectionNotification(this.val);
}
