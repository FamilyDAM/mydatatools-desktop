import 'package:client/models/tables/converters/string_array_convertor.dart';
import 'package:client/models/tables/file.dart';
import 'package:client/repositories/database_repository.dart';
import 'package:drift/drift.dart';

//part 'email.g.dart';

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
  TextColumn get to => text().map(const StringArrayConverter())();
  TextColumn get cc => text().map(const StringArrayConverter())();
  TextColumn? get subject => text().nullable()();
  TextColumn? get snippet => text().nullable()();
  TextColumn? get htmlBody => text().nullable()();
  TextColumn? get plainBody => text().nullable()();
  TextColumn get labels => text().map(const StringArrayConverter())();
  TextColumn? get headers => text().nullable()();
  //List<File> attachments = [];
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Email implements Insertable<Email> {
  String id;
  String collectionId;
  DateTime date;
  String from;
  List<String> to;
  List<String>? cc = [];
  String? subject;
  String? snippet;
  String? htmlBody;
  String? plainBody;
  List<String>? labels = [];
  String? headers;
  List<File>? attachments = [];
  bool isDeleted = false;

  //Not in db
  bool? isSelected = false;

  Email(
      {required this.id,
      required this.collectionId,
      required this.date,
      required this.from,
      required this.to,
      this.cc,
      this.subject,
      this.snippet,
      this.htmlBody,
      this.plainBody,
      this.labels,
      this.headers,
      this.attachments,
      required this.isDeleted,
      this.isSelected});

  Email.fromDb(
      {required this.id,
      required this.collectionId,
      required this.date,
      required this.from,
      required this.to,
      this.cc,
      this.subject,
      this.snippet,
      this.htmlBody,
      this.plainBody,
      this.labels,
      this.headers,
      //required this.attachments,
      required this.isDeleted});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return EmailsCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      date: Value(date),
      from: Value(from),
      to: Value(to),
      cc: Value(cc ?? []),
      subject: Value(subject),
      snippet: Value(snippet),
      htmlBody: Value(htmlBody),
      plainBody: Value(plainBody),
      labels: Value(labels ?? []),
      headers: Value(headers),
      isDeleted: Value(isDeleted),
    ).toColumns(nullToAbsent);
  }

  @override
  String toString() {
    return '_Email{id: $id, from: $from, to: $to, cc: $cc, subject: $subject}';
  } //json of map
}
