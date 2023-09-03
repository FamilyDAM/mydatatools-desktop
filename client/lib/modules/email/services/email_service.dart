import 'package:client/app_logger.dart';
import 'package:client/models/collection_model.dart';
import 'package:client/models/module_models.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/repositories/realm_repository.dart';
import 'package:client/services/rx_service.dart';

class EmailService extends RxService<EmailServiceCommand, List<Email>> {
  final AppLogger logger = AppLogger(null);

  static final EmailService _instance = EmailService();
  static get instance => _instance;

  @override
  Future<List<Email>> invoke(EmailServiceCommand command) async {
    isLoading.add(true);
    EmailRepository repo = EmailRepository(RealmRepository.instance.database);

    //first check for newest emails

    //load files and folders from db
    List<Email> emails = repo.emails(command.collection.id, command.sortColumn, command.sortAsc);
    sink.add(emails);
    isLoading.add(false);
    return Future(() => emails);
  }
}

class EmailServiceCommand extends RxCommand {
  Collection collection;
  String sortColumn;
  bool sortAsc;
  EmailServiceCommand(this.collection, this.sortColumn, this.sortAsc);
}
