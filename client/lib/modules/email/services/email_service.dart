import 'package:client/app_logger.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/models/tables/email.dart';
import 'package:client/modules/email/services/email_repository.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:client/services/rx_service.dart';

class EmailService extends RxService<EmailServiceCommand, List<Email>> {
  final AppLogger logger = AppLogger(null);
  EmailRepository? emailRepository;

  static final EmailService _instance = EmailService();
  static get instance => _instance;

  @override
  Future<List<Email>> invoke(EmailServiceCommand command) async {
    isLoading.add(true);
    emailRepository = EmailRepository(DatabaseRepository.instance.database!);

    //first check for newest emails

    //load files and folders from db
    List<Email> emails = await emailRepository!.emails(command.collection.id, command.sortColumn, command.sortAsc);
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
