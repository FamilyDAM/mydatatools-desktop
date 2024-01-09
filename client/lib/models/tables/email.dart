import 'package:client/models/tables/file.dart';
import 'package:drift/drift.dart';

part 'email.g.dart';

@UseRowClass(Email, constructor: 'fromDb')
@TableIndex(name: 'email_id_idx', columns: {#id})
@TableIndex(name: 'email_collectionid_idx', columns: {#collectionId})
@TableIndex(name: 'email_date_idx', columns: {#date})
@TableIndex(name: 'email_from_idx', columns: {#from})
class Emails extends Table {
  TextColumn get id => text()();
  TextColumn get collectionId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn? get from => text()();
  //List<String> to = [];
  //List<String> cc = [];
  TextColumn? get subject => text()();
  TextColumn? get snippet => text()();
  TextColumn? get htmlBody => text()();
  TextColumn? get plainBody => text()();
  //List<String> labels = [];
  TextColumn? get headers => text()();
  //List<File> attachments = [];
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Email {
  late String id;
  late String collectionId;
  late DateTime date;
  late String? from;
  late List<String> to = [];
  late List<String> cc = [];
  late String? subject;
  late String? snippet;
  late String? htmlBody;
  late String? plainBody;
  late List<String> labels = [];
  late String? headers;
  late List<File> attachments = [];
  late bool isDeleted = false;
  bool isSelected = false;

  Email.fromDb(
      {required this.id,
      required this.collectionId,
      required this.date,
      this.from,
      //required this.to,
      //required this.cc,
      this.subject,
      this.snippet,
      this.htmlBody,
      this.plainBody,
      //this.labels,
      this.headers,
      //required this.attachments,
      required this.isDeleted});

  @override
  String toString() {
    return '_Email{id: $id, from: $from, to: $to, cc: $cc, subject: $subject}';
  } //json of map
}
