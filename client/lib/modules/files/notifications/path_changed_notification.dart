import 'package:client/models/module_models.dart';
import 'package:client/modules/files/notifications/file_notification.dart';

class PathChangedNotification extends FiledNotification {
  final FileAsset asset;
  final String sortColumn;
  final bool sortAsc;
  PathChangedNotification(this.asset, this.sortColumn, this.sortAsc);
}
