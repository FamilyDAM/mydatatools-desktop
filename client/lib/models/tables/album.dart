import 'package:drift/drift.dart';

//part 'album.g.dart';

@UseRowClass(Album, constructor: 'fromDb')
class Albums extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  // TODO: add reference to files
}

class Album implements Insertable<Album> {
  String id;
  String name;

  Album({required this.id, required this.name});

  Album.fromDb({required this.id, required this.name});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      name: Value(name),
    ).toColumns(nullToAbsent);
  }
}
