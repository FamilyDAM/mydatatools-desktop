import 'package:client/models/tables/collection.dart';
import 'package:client/scanners/collection_scanner.dart';

// TODO
//@see https://pub.dev/packages/driven
class GoogleFileScanner implements CollectionScanner {
  final String path;
  final String collectionId;
  final int repeatFrequency;
  GoogleFileScanner(this.path, this.collectionId, this.repeatFrequency);

  @override
  Future<int> start(Collection collection, String? path, bool recursive, bool force) async {
    return Future(() => -1);
  }

  @override
  void stop() async {}
}
