import 'package:client/models/module_models.dart';
import 'package:collection/collection.dart';
import 'package:realm/realm.dart';

class EmailRepository {
  final Realm database;
  EmailRepository(this.database);

  List<Email> emails(String collectionId, String? sortColumn, bool? sortAsc) {
    sortColumn ??= "date";
    sortAsc ??= false;
    var sortDirection = sortAsc ? 'asc' : 'desc';
    //todo: add collectionId to filter
    return database.query<Email>("collectionId = '$collectionId' SORT($sortColumn $sortDirection)").toList();
  }

  int emailCount(String collectionId) {
    //todo: add collectionId to filter
    return database.query<Email>("collectionId = '$collectionId'").length;
  }

  DateTime? getMinEmailDate(String collectionId) {
    Email? email = database.query<Email>("collectionId = '$collectionId' SORT(date asc)").firstOrNull;
    return email?.date;
  }

  DateTime? getMaxEmailDate(String collectionId) {
    Email? email = database.query<Email>("collectionId = '$collectionId' SORT(date desc)").firstOrNull;
    return email?.date;
  }

  List<Email> getAllById(List<String> ids) {
    List<Email> emails = [];
    if (ids.isNotEmpty) {
      emails = database.query<Email>("id == \$0", ids).toList();
    }

    return emails;
  }

  void addEmails(String collectionId, List<Email> emails) {
    //make sure every email is linked to collection
    for (var e in emails) {
      e.collectionId = collectionId;
    }

    database.write(() => {database.addAll<Email>(emails, update: true)});
  }

  void deleteEmails(String collectionId, List<Email> emails) {
    database.write(() => {database.deleteMany<Email>(emails)});
  }
}
