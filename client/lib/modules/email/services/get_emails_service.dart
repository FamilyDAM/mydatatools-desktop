import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/services/rx_service.dart';

class GetEmailsService extends RxService<EmailServiceCommand, List<Email>> {
  static final GetEmailsService _singleton = GetEmailsService();
  static get instance => _singleton;
  final AppLogger logger = AppLogger(null);

  @override
  Future<List<Email>> invoke(EmailServiceCommand command) async {
    isLoading.add(true);
    //first check for newest emails

    //load files and folders from db
    List<Email> emails = await EmailRepository().emails(command.collection.id, command.sortColumn, command.sortAsc);
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
