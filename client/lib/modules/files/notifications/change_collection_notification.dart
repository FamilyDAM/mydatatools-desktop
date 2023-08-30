import 'package:client/models/collection_model.dart';
import 'package:flutter/material.dart';

class ChangeCollectionNotification extends Notification {
  final Collection? val;
  ChangeCollectionNotification(this.val);
}
