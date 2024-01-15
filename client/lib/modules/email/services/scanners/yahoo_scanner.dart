import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/scanners/collection_scanner.dart';

class YahooScanner implements CollectionScanner {
  final AppDatabase database;
  final Collection collection;
  final int repeatFrequency;
  late String accessToken;
  late String refreshToken;
  late String appDir;
  bool isStopped = false;

  final AppLogger logger = AppLogger(null);

  YahooScanner(this.database, this.collection, this.appDir, this.repeatFrequency) {
    accessToken = collection.accessToken ?? '';
    refreshToken = collection.refreshToken ?? '';
  }

  @override
  Future<int> start(Collection collection, String? path, bool recursive, bool force) async {
    //skip on restart
    if (!force && collection.lastScanDate != null) return Future(() => 0);

    EmailRepository emailRepository = EmailRepository(database);

    DateTime? minDate = await emailRepository.getMinEmailDate(collection.id);
    String? minQuery;
    if (minDate != null) {
      minQuery = "before:${minDate.millisecondsSinceEpoch}";
    }
    print(minQuery);

    return Future(() => -1);
  }

  @override
  void stop() async {
    isStopped = true;
  }
}
