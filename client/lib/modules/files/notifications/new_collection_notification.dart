import 'package:client/models/collection_model.dart';
import 'package:flutter/material.dart';

class NewCollectionNotification extends Notification {
  final Collection val;
  NewCollectionNotification(this.val);
}
