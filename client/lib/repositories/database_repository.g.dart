// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_repository.dart';

// ignore_for_file: type=lint
class $AppTable extends App with TableInfo<$AppTable, AppData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
      'group', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("collections"));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
      'icon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
      'route', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("/"));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, slug, group, order, icon, route];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app';
  @override
  VerificationContext validateIntegrity(Insertable<AppData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('group')) {
      context.handle(
          _groupMeta, group.isAcceptableOrUnknown(data['group']!, _groupMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('route')) {
      context.handle(
          _routeMeta, route.isAcceptableOrUnknown(data['route']!, _routeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AppData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      group: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon']),
      route: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route'])!,
    );
  }

  @override
  $AppTable createAlias(String alias) {
    return $AppTable(attachedDatabase, alias);
  }
}

class AppData extends DataClass implements Insertable<AppData> {
  final String id;
  final String name;
  final String slug;
  final String group;
  final int order;
  final int? icon;
  final String route;
  const AppData(
      {required this.id,
      required this.name,
      required this.slug,
      required this.group,
      required this.order,
      this.icon,
      required this.route});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['group'] = Variable<String>(group);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<int>(icon);
    }
    map['route'] = Variable<String>(route);
    return map;
  }

  AppCompanion toCompanion(bool nullToAbsent) {
    return AppCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      group: Value(group),
      order: Value(order),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      route: Value(route),
    );
  }

  factory AppData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      group: serializer.fromJson<String>(json['group']),
      order: serializer.fromJson<int>(json['order']),
      icon: serializer.fromJson<int?>(json['icon']),
      route: serializer.fromJson<String>(json['route']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'group': serializer.toJson<String>(group),
      'order': serializer.toJson<int>(order),
      'icon': serializer.toJson<int?>(icon),
      'route': serializer.toJson<String>(route),
    };
  }

  AppData copyWith(
          {String? id,
          String? name,
          String? slug,
          String? group,
          int? order,
          Value<int?> icon = const Value.absent(),
          String? route}) =>
      AppData(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        group: group ?? this.group,
        order: order ?? this.order,
        icon: icon.present ? icon.value : this.icon,
        route: route ?? this.route,
      );
  @override
  String toString() {
    return (StringBuffer('AppData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('group: $group, ')
          ..write('order: $order, ')
          ..write('icon: $icon, ')
          ..write('route: $route')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, slug, group, order, icon, route);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppData &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.group == this.group &&
          other.order == this.order &&
          other.icon == this.icon &&
          other.route == this.route);
}

class AppCompanion extends UpdateCompanion<AppData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> group;
  final Value<int> order;
  final Value<int?> icon;
  final Value<String> route;
  final Value<int> rowid;
  const AppCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.group = const Value.absent(),
    this.order = const Value.absent(),
    this.icon = const Value.absent(),
    this.route = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppCompanion.insert({
    required String id,
    required String name,
    required String slug,
    this.group = const Value.absent(),
    this.order = const Value.absent(),
    this.icon = const Value.absent(),
    this.route = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        slug = Value(slug);
  static Insertable<AppData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? group,
    Expression<int>? order,
    Expression<int>? icon,
    Expression<String>? route,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (group != null) 'group': group,
      if (order != null) 'order': order,
      if (icon != null) 'icon': icon,
      if (route != null) 'route': route,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? group,
      Value<int>? order,
      Value<int?>? icon,
      Value<String>? route,
      Value<int>? rowid}) {
    return AppCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      group: group ?? this.group,
      order: order ?? this.order,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (group.present) {
      map['group'] = Variable<String>(group.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('group: $group, ')
          ..write('order: $order, ')
          ..write('icon: $icon, ')
          ..write('route: $route, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppUserTable extends AppUser with TableInfo<$AppUserTable, AppUserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUserTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localStoragePathMeta =
      const VerificationMeta('localStoragePath');
  @override
  late final GeneratedColumn<String> localStoragePath = GeneratedColumn<String>(
      'local_storage_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, password, localStoragePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_user';
  @override
  VerificationContext validateIntegrity(Insertable<AppUserData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('local_storage_path')) {
      context.handle(
          _localStoragePathMeta,
          localStoragePath.isAcceptableOrUnknown(
              data['local_storage_path']!, _localStoragePathMeta));
    } else if (isInserting) {
      context.missing(_localStoragePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AppUserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUserData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      localStoragePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_storage_path'])!,
    );
  }

  @override
  $AppUserTable createAlias(String alias) {
    return $AppUserTable(attachedDatabase, alias);
  }
}

class AppUserData extends DataClass implements Insertable<AppUserData> {
  final String id;
  final String name;
  final String email;
  final String password;
  final String localStoragePath;
  const AppUserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.localStoragePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['local_storage_path'] = Variable<String>(localStoragePath);
    return map;
  }

  AppUserCompanion toCompanion(bool nullToAbsent) {
    return AppUserCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      localStoragePath: Value(localStoragePath),
    );
  }

  factory AppUserData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUserData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      localStoragePath: serializer.fromJson<String>(json['localStoragePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'localStoragePath': serializer.toJson<String>(localStoragePath),
    };
  }

  AppUserData copyWith(
          {String? id,
          String? name,
          String? email,
          String? password,
          String? localStoragePath}) =>
      AppUserData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        localStoragePath: localStoragePath ?? this.localStoragePath,
      );
  @override
  String toString() {
    return (StringBuffer('AppUserData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('localStoragePath: $localStoragePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, password, localStoragePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUserData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.password == this.password &&
          other.localStoragePath == this.localStoragePath);
}

class AppUserCompanion extends UpdateCompanion<AppUserData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> localStoragePath;
  final Value<int> rowid;
  const AppUserCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.localStoragePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppUserCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String password,
    required String localStoragePath,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        email = Value(email),
        password = Value(password),
        localStoragePath = Value(localStoragePath);
  static Insertable<AppUserData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? localStoragePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (localStoragePath != null) 'local_storage_path': localStoragePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppUserCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? password,
      Value<String>? localStoragePath,
      Value<int>? rowid}) {
    return AppUserCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      localStoragePath: localStoragePath ?? this.localStoragePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (localStoragePath.present) {
      map['local_storage_path'] = Variable<String>(localStoragePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUserCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('localStoragePath: $localStoragePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AppTable app = $AppTable(this);
  late final $AppUserTable appUser = $AppUserTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [app, appUser];
}

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
