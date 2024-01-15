import 'package:client/models/tables/email.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

class EmailRepository {
  final AppDatabase database;
  EmailRepository(this.database);

  Future<List<Email>> emails(String collectionId, String? sortColumn, bool? sortAsc) async {
    sortColumn ??= "date";
    sortAsc ??= false;
    //var sortDirection = sortAsc ? 'asc' : 'desc';
    // TODO: add collectionId to filter
    return await (database.select(database.emails)..where((e) => e.collectionId.equals(collectionId))).get();

    // TODO: add sort SORT($sortColumn $sortDirection)
  }

  Future<int> emailCount(String collectionId) async {
    // TODO: add collectionId to filter
    return await database
        .customSelect(
          'SELECT COUNT(*) AS c FROM emails WHERE collectionId = ?',
          variables: [Variable.withString(collectionId)],
          readsFrom: {database.emails},
        )
        .map((row) => row.read<int>('c'))
        .getSingle();
  }

  Future<DateTime?> getMinEmailDate(String collectionId) async {
    Email? email =
        await (database.select(database.emails)..where((e) => e.collectionId.equals(collectionId))).getSingleOrNull();
    return email?.date;
    // TODO add sort  SORT(date asc)
  }

  Future<DateTime?> getMaxEmailDate(String collectionId) async {
    Email? email =
        await (database.select(database.emails)..where((e) => e.collectionId.equals(collectionId))).getSingleOrNull();
    return email?.date;
    // TODO: add sort SORT(date desc);
  }

  Future<List<Email>> getAllById(List<String> ids) async {
    List<Email> emails = [];
    if (ids.isNotEmpty) {
      emails = await (database.select(database.emails)..where((e) => e.id.isIn(ids))).get();
    }

    return emails;
  }

  void addEmails(String collectionId, List<Email> emails) async {
    //make sure every email is linked to collection
    for (var e in emails) {
      e.collectionId = collectionId;
      database.into(database.emails).insertOnConflictUpdate(e);
    }
  }

  void deleteEmails(String collectionId, List<Email> emails) {
    for (var e in emails) {
      database.delete(database.emails).delete(e);
    }
  }
}
