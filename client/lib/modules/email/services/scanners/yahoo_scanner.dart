import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/scanners/collection_scanner.dart';
import 'package:realm/realm.dart';

class YahooScanner implements CollectionScanner {
  final Realm realm;
  final Collection collection;
  final int repeatFrequency;
  late String accessToken;
  late String refreshToken;
  late String appDir;
  bool isStopped = false;

  final AppLogger logger = AppLogger();

  YahooScanner(this.realm, this.collection, this.appDir, this.repeatFrequency) {
    accessToken = collection.accessToken ?? '';
    refreshToken = collection.refreshToken ?? '';
  }

  @override
  void stop() async {
    isStopped = true;
  }

  @override
  Future<int> scanDirectory(String path) async {
    //do nothing
    print('scan gmail');
    return Future(() => 0);
  }

  @override
  void start(bool recursive, bool force) async {
    //skip on restart
    if (!force && collection.lastScanDate != null) return;

    EmailRepository emailRepository = EmailRepository(realm);

    DateTime? minDate = emailRepository.getMinEmailDate(collection.id);
    String? minQuery;
    if (minDate != null) {
      minQuery = "before:${minDate.millisecondsSinceEpoch}";
    }
    print(minQuery);
  }
}
