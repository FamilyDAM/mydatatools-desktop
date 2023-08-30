import 'package:client/scanners/collection_scanner.dart';

//todo
//@see https://pub.dev/packages/driven
class GoogleFileScanner implements CollectionScanner {
  final String path;
  final String collectionId;
  final int repeatFrequency;
  GoogleFileScanner(this.path, this.collectionId, this.repeatFrequency);

  @override
  Future<int> scanDirectory(String path) async {
    return Future(() => 0);
  }

  @override
  void start(bool recursive, bool force) async {}
  @override
  void stop() async {}
}
