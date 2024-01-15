// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_repository.dart';

// ignore_for_file: type=lint
class $AppsTable extends Apps with TableInfo<$AppsTable, App> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const String $name = 'apps';
  @override
  VerificationContext validateIntegrity(Insertable<App> instance,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  App map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return App.fromDb(
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
  $AppsTable createAlias(String alias) {
    return $AppsTable(attachedDatabase, alias);
  }
}

class AppsCompanion extends UpdateCompanion<App> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> group;
  final Value<int> order;
  final Value<int?> icon;
  final Value<String> route;
  final Value<int> rowid;
  const AppsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.group = const Value.absent(),
    this.order = const Value.absent(),
    this.icon = const Value.absent(),
    this.route = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppsCompanion.insert({
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
  static Insertable<App> custom({
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

  AppsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? group,
      Value<int>? order,
      Value<int?>? icon,
      Value<String>? route,
      Value<int>? rowid}) {
    return AppsCompanion(
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
    return (StringBuffer('AppsCompanion(')
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

class $AppUsersTable extends AppUsers with TableInfo<$AppUsersTable, AppUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const String $name = 'app_users';
  @override
  VerificationContext validateIntegrity(Insertable<AppUser> instance,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUser.fromDb(
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
  $AppUsersTable createAlias(String alias) {
    return $AppUsersTable(attachedDatabase, alias);
  }
}

class AppUsersCompanion extends UpdateCompanion<AppUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> localStoragePath;
  final Value<int> rowid;
  const AppUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.localStoragePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppUsersCompanion.insert({
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
  static Insertable<AppUser> custom({
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

  AppUsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? password,
      Value<String>? localStoragePath,
      Value<int>? rowid}) {
    return AppUsersCompanion(
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
    return (StringBuffer('AppUsersCompanion(')
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

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scannerMeta =
      const VerificationMeta('scanner');
  @override
  late final GeneratedColumn<String> scanner = GeneratedColumn<String>(
      'scanner', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scanStatusMeta =
      const VerificationMeta('scanStatus');
  @override
  late final GeneratedColumn<String> scanStatus = GeneratedColumn<String>(
      'scan_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oauthServiceMeta =
      const VerificationMeta('oauthService');
  @override
  late final GeneratedColumn<String> oauthService = GeneratedColumn<String>(
      'oauth_service', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accessTokenMeta =
      const VerificationMeta('accessToken');
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
      'access_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idTokenMeta =
      const VerificationMeta('idToken');
  @override
  late final GeneratedColumn<String> idToken = GeneratedColumn<String>(
      'id_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expirationMeta =
      const VerificationMeta('expiration');
  @override
  late final GeneratedColumn<DateTime> expiration = GeneratedColumn<DateTime>(
      'expiration', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastScanDateMeta =
      const VerificationMeta('lastScanDate');
  @override
  late final GeneratedColumn<DateTime> lastScanDate = GeneratedColumn<DateTime>(
      'last_scan_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needsReAuthMeta =
      const VerificationMeta('needsReAuth');
  @override
  late final GeneratedColumn<bool> needsReAuth = GeneratedColumn<bool>(
      'needs_re_auth', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("needs_re_auth" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        path,
        type,
        scanner,
        scanStatus,
        oauthService,
        accessToken,
        refreshToken,
        idToken,
        userId,
        expiration,
        lastScanDate,
        needsReAuth
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(Insertable<Collection> instance,
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
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('scanner')) {
      context.handle(_scannerMeta,
          scanner.isAcceptableOrUnknown(data['scanner']!, _scannerMeta));
    } else if (isInserting) {
      context.missing(_scannerMeta);
    }
    if (data.containsKey('scan_status')) {
      context.handle(
          _scanStatusMeta,
          scanStatus.isAcceptableOrUnknown(
              data['scan_status']!, _scanStatusMeta));
    } else if (isInserting) {
      context.missing(_scanStatusMeta);
    }
    if (data.containsKey('oauth_service')) {
      context.handle(
          _oauthServiceMeta,
          oauthService.isAcceptableOrUnknown(
              data['oauth_service']!, _oauthServiceMeta));
    }
    if (data.containsKey('access_token')) {
      context.handle(
          _accessTokenMeta,
          accessToken.isAcceptableOrUnknown(
              data['access_token']!, _accessTokenMeta));
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    }
    if (data.containsKey('id_token')) {
      context.handle(_idTokenMeta,
          idToken.isAcceptableOrUnknown(data['id_token']!, _idTokenMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('expiration')) {
      context.handle(
          _expirationMeta,
          expiration.isAcceptableOrUnknown(
              data['expiration']!, _expirationMeta));
    }
    if (data.containsKey('last_scan_date')) {
      context.handle(
          _lastScanDateMeta,
          lastScanDate.isAcceptableOrUnknown(
              data['last_scan_date']!, _lastScanDateMeta));
    }
    if (data.containsKey('needs_re_auth')) {
      context.handle(
          _needsReAuthMeta,
          needsReAuth.isAcceptableOrUnknown(
              data['needs_re_auth']!, _needsReAuthMeta));
    } else if (isInserting) {
      context.missing(_needsReAuthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collection.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      scanner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scanner'])!,
      scanStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scan_status'])!,
      oauthService: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oauth_service']),
      accessToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_token']),
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token']),
      idToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_token']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      expiration: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiration']),
      lastScanDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_scan_date']),
      needsReAuth: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}needs_re_auth'])!,
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> path;
  final Value<String> type;
  final Value<String> scanner;
  final Value<String> scanStatus;
  final Value<String?> oauthService;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<String?> idToken;
  final Value<String?> userId;
  final Value<DateTime?> expiration;
  final Value<DateTime?> lastScanDate;
  final Value<bool> needsReAuth;
  final Value<int> rowid;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.scanner = const Value.absent(),
    this.scanStatus = const Value.absent(),
    this.oauthService = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.idToken = const Value.absent(),
    this.userId = const Value.absent(),
    this.expiration = const Value.absent(),
    this.lastScanDate = const Value.absent(),
    this.needsReAuth = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionsCompanion.insert({
    required String id,
    required String name,
    required String path,
    required String type,
    required String scanner,
    required String scanStatus,
    this.oauthService = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.idToken = const Value.absent(),
    this.userId = const Value.absent(),
    this.expiration = const Value.absent(),
    this.lastScanDate = const Value.absent(),
    required bool needsReAuth,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        path = Value(path),
        type = Value(type),
        scanner = Value(scanner),
        scanStatus = Value(scanStatus),
        needsReAuth = Value(needsReAuth);
  static Insertable<Collection> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? path,
    Expression<String>? type,
    Expression<String>? scanner,
    Expression<String>? scanStatus,
    Expression<String>? oauthService,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<String>? idToken,
    Expression<String>? userId,
    Expression<DateTime>? expiration,
    Expression<DateTime>? lastScanDate,
    Expression<bool>? needsReAuth,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (scanner != null) 'scanner': scanner,
      if (scanStatus != null) 'scan_status': scanStatus,
      if (oauthService != null) 'oauth_service': oauthService,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (idToken != null) 'id_token': idToken,
      if (userId != null) 'user_id': userId,
      if (expiration != null) 'expiration': expiration,
      if (lastScanDate != null) 'last_scan_date': lastScanDate,
      if (needsReAuth != null) 'needs_re_auth': needsReAuth,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? path,
      Value<String>? type,
      Value<String>? scanner,
      Value<String>? scanStatus,
      Value<String?>? oauthService,
      Value<String?>? accessToken,
      Value<String?>? refreshToken,
      Value<String?>? idToken,
      Value<String?>? userId,
      Value<DateTime?>? expiration,
      Value<DateTime?>? lastScanDate,
      Value<bool>? needsReAuth,
      Value<int>? rowid}) {
    return CollectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      scanner: scanner ?? this.scanner,
      scanStatus: scanStatus ?? this.scanStatus,
      oauthService: oauthService ?? this.oauthService,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      idToken: idToken ?? this.idToken,
      userId: userId ?? this.userId,
      expiration: expiration ?? this.expiration,
      lastScanDate: lastScanDate ?? this.lastScanDate,
      needsReAuth: needsReAuth ?? this.needsReAuth,
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
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (scanner.present) {
      map['scanner'] = Variable<String>(scanner.value);
    }
    if (scanStatus.present) {
      map['scan_status'] = Variable<String>(scanStatus.value);
    }
    if (oauthService.present) {
      map['oauth_service'] = Variable<String>(oauthService.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (idToken.present) {
      map['id_token'] = Variable<String>(idToken.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (expiration.present) {
      map['expiration'] = Variable<DateTime>(expiration.value);
    }
    if (lastScanDate.present) {
      map['last_scan_date'] = Variable<DateTime>(lastScanDate.value);
    }
    if (needsReAuth.present) {
      map['needs_re_auth'] = Variable<bool>(needsReAuth.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('scanner: $scanner, ')
          ..write('scanStatus: $scanStatus, ')
          ..write('oauthService: $oauthService, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('idToken: $idToken, ')
          ..write('userId: $userId, ')
          ..write('expiration: $expiration, ')
          ..write('lastScanDate: $lastScanDate, ')
          ..write('needsReAuth: $needsReAuth, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailsTable extends Emails with TableInfo<$EmailsTable, Email> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _collectionIdMeta =
      const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
      'collection_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fromMeta = const VerificationMeta('from');
  @override
  late final GeneratedColumn<String> from = GeneratedColumn<String>(
      'from', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toMeta = const VerificationMeta('to');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> to =
      GeneratedColumn<String>('to', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($EmailsTable.$converterto);
  static const VerificationMeta _ccMeta = const VerificationMeta('cc');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> cc =
      GeneratedColumn<String>('cc', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($EmailsTable.$convertercc);
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snippetMeta =
      const VerificationMeta('snippet');
  @override
  late final GeneratedColumn<String> snippet = GeneratedColumn<String>(
      'snippet', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _htmlBodyMeta =
      const VerificationMeta('htmlBody');
  @override
  late final GeneratedColumn<String> htmlBody = GeneratedColumn<String>(
      'html_body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _plainBodyMeta =
      const VerificationMeta('plainBody');
  @override
  late final GeneratedColumn<String> plainBody = GeneratedColumn<String>(
      'plain_body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelsMeta = const VerificationMeta('labels');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> labels =
      GeneratedColumn<String>('labels', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($EmailsTable.$converterlabels);
  static const VerificationMeta _headersMeta =
      const VerificationMeta('headers');
  @override
  late final GeneratedColumn<String> headers = GeneratedColumn<String>(
      'headers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        collectionId,
        date,
        from,
        to,
        cc,
        subject,
        snippet,
        htmlBody,
        plainBody,
        labels,
        headers,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emails';
  @override
  VerificationContext validateIntegrity(Insertable<Email> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
          _collectionIdMeta,
          collectionId.isAcceptableOrUnknown(
              data['collection_id']!, _collectionIdMeta));
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('from')) {
      context.handle(
          _fromMeta, from.isAcceptableOrUnknown(data['from']!, _fromMeta));
    } else if (isInserting) {
      context.missing(_fromMeta);
    }
    context.handle(_toMeta, const VerificationResult.success());
    context.handle(_ccMeta, const VerificationResult.success());
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    }
    if (data.containsKey('snippet')) {
      context.handle(_snippetMeta,
          snippet.isAcceptableOrUnknown(data['snippet']!, _snippetMeta));
    }
    if (data.containsKey('html_body')) {
      context.handle(_htmlBodyMeta,
          htmlBody.isAcceptableOrUnknown(data['html_body']!, _htmlBodyMeta));
    }
    if (data.containsKey('plain_body')) {
      context.handle(_plainBodyMeta,
          plainBody.isAcceptableOrUnknown(data['plain_body']!, _plainBodyMeta));
    }
    context.handle(_labelsMeta, const VerificationResult.success());
    if (data.containsKey('headers')) {
      context.handle(_headersMeta,
          headers.isAcceptableOrUnknown(data['headers']!, _headersMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Email map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Email.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      collectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      from: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from'])!,
      to: $EmailsTable.$converterto.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to'])!),
      cc: $EmailsTable.$convertercc.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cc'])!),
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject']),
      snippet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet']),
      htmlBody: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}html_body']),
      plainBody: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plain_body']),
      labels: $EmailsTable.$converterlabels.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}labels'])!),
      headers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headers']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $EmailsTable createAlias(String alias) {
    return $EmailsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterto =
      const StringArrayConverter();
  static TypeConverter<List<String>, String> $convertercc =
      const StringArrayConverter();
  static TypeConverter<List<String>, String> $converterlabels =
      const StringArrayConverter();
}

class EmailsCompanion extends UpdateCompanion<Email> {
  final Value<String> id;
  final Value<String> collectionId;
  final Value<DateTime> date;
  final Value<String> from;
  final Value<List<String>> to;
  final Value<List<String>> cc;
  final Value<String?> subject;
  final Value<String?> snippet;
  final Value<String?> htmlBody;
  final Value<String?> plainBody;
  final Value<List<String>> labels;
  final Value<String?> headers;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const EmailsCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.date = const Value.absent(),
    this.from = const Value.absent(),
    this.to = const Value.absent(),
    this.cc = const Value.absent(),
    this.subject = const Value.absent(),
    this.snippet = const Value.absent(),
    this.htmlBody = const Value.absent(),
    this.plainBody = const Value.absent(),
    this.labels = const Value.absent(),
    this.headers = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmailsCompanion.insert({
    required String id,
    required String collectionId,
    required DateTime date,
    required String from,
    required List<String> to,
    required List<String> cc,
    this.subject = const Value.absent(),
    this.snippet = const Value.absent(),
    this.htmlBody = const Value.absent(),
    this.plainBody = const Value.absent(),
    required List<String> labels,
    this.headers = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        collectionId = Value(collectionId),
        date = Value(date),
        from = Value(from),
        to = Value(to),
        cc = Value(cc),
        labels = Value(labels);
  static Insertable<Email> custom({
    Expression<String>? id,
    Expression<String>? collectionId,
    Expression<DateTime>? date,
    Expression<String>? from,
    Expression<String>? to,
    Expression<String>? cc,
    Expression<String>? subject,
    Expression<String>? snippet,
    Expression<String>? htmlBody,
    Expression<String>? plainBody,
    Expression<String>? labels,
    Expression<String>? headers,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (date != null) 'date': date,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      if (cc != null) 'cc': cc,
      if (subject != null) 'subject': subject,
      if (snippet != null) 'snippet': snippet,
      if (htmlBody != null) 'html_body': htmlBody,
      if (plainBody != null) 'plain_body': plainBody,
      if (labels != null) 'labels': labels,
      if (headers != null) 'headers': headers,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmailsCompanion copyWith(
      {Value<String>? id,
      Value<String>? collectionId,
      Value<DateTime>? date,
      Value<String>? from,
      Value<List<String>>? to,
      Value<List<String>>? cc,
      Value<String?>? subject,
      Value<String?>? snippet,
      Value<String?>? htmlBody,
      Value<String?>? plainBody,
      Value<List<String>>? labels,
      Value<String?>? headers,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return EmailsCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      date: date ?? this.date,
      from: from ?? this.from,
      to: to ?? this.to,
      cc: cc ?? this.cc,
      subject: subject ?? this.subject,
      snippet: snippet ?? this.snippet,
      htmlBody: htmlBody ?? this.htmlBody,
      plainBody: plainBody ?? this.plainBody,
      labels: labels ?? this.labels,
      headers: headers ?? this.headers,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (from.present) {
      map['from'] = Variable<String>(from.value);
    }
    if (to.present) {
      map['to'] = Variable<String>($EmailsTable.$converterto.toSql(to.value));
    }
    if (cc.present) {
      map['cc'] = Variable<String>($EmailsTable.$convertercc.toSql(cc.value));
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (snippet.present) {
      map['snippet'] = Variable<String>(snippet.value);
    }
    if (htmlBody.present) {
      map['html_body'] = Variable<String>(htmlBody.value);
    }
    if (plainBody.present) {
      map['plain_body'] = Variable<String>(plainBody.value);
    }
    if (labels.present) {
      map['labels'] =
          Variable<String>($EmailsTable.$converterlabels.toSql(labels.value));
    }
    if (headers.present) {
      map['headers'] = Variable<String>(headers.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailsCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('date: $date, ')
          ..write('from: $from, ')
          ..write('to: $to, ')
          ..write('cc: $cc, ')
          ..write('subject: $subject, ')
          ..write('snippet: $snippet, ')
          ..write('htmlBody: $htmlBody, ')
          ..write('plainBody: $plainBody, ')
          ..write('labels: $labels, ')
          ..write('headers: $headers, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FilesTable extends Files with TableInfo<$FilesTable, File> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
      'parent', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateLastModifiedMeta =
      const VerificationMeta('dateLastModified');
  @override
  late final GeneratedColumn<DateTime> dateLastModified =
      GeneratedColumn<DateTime>('date_last_modified', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _collectionIdMeta =
      const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
      'collection_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentTypeMeta =
      const VerificationMeta('contentType');
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
      'content_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _thumbnailMeta =
      const VerificationMeta('thumbnail');
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
      'thumbnail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        path,
        parent,
        dateCreated,
        dateLastModified,
        collectionId,
        contentType,
        size,
        isDeleted,
        thumbnail,
        latitude,
        longitude
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'files';
  @override
  VerificationContext validateIntegrity(Insertable<File> instance,
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
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta,
          parent.isAcceptableOrUnknown(data['parent']!, _parentMeta));
    } else if (isInserting) {
      context.missing(_parentMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (data.containsKey('date_last_modified')) {
      context.handle(
          _dateLastModifiedMeta,
          dateLastModified.isAcceptableOrUnknown(
              data['date_last_modified']!, _dateLastModifiedMeta));
    } else if (isInserting) {
      context.missing(_dateLastModifiedMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
          _collectionIdMeta,
          collectionId.isAcceptableOrUnknown(
              data['collection_id']!, _collectionIdMeta));
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
          _contentTypeMeta,
          contentType.isAcceptableOrUnknown(
              data['content_type']!, _contentTypeMeta));
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('thumbnail')) {
      context.handle(_thumbnailMeta,
          thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  File map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return File.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      parent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateLastModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_last_modified'])!,
      collectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!,
      contentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_type'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      thumbnail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
    );
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(attachedDatabase, alias);
  }
}

class FilesCompanion extends UpdateCompanion<File> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> path;
  final Value<String> parent;
  final Value<DateTime> dateCreated;
  final Value<DateTime> dateLastModified;
  final Value<String> collectionId;
  final Value<String> contentType;
  final Value<int> size;
  final Value<bool> isDeleted;
  final Value<String?> thumbnail;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> rowid;
  const FilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.parent = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateLastModified = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.size = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FilesCompanion.insert({
    required String id,
    required String name,
    required String path,
    required String parent,
    required DateTime dateCreated,
    required DateTime dateLastModified,
    required String collectionId,
    required String contentType,
    required int size,
    this.isDeleted = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        path = Value(path),
        parent = Value(parent),
        dateCreated = Value(dateCreated),
        dateLastModified = Value(dateLastModified),
        collectionId = Value(collectionId),
        contentType = Value(contentType),
        size = Value(size);
  static Insertable<File> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? path,
    Expression<String>? parent,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateLastModified,
    Expression<String>? collectionId,
    Expression<String>? contentType,
    Expression<int>? size,
    Expression<bool>? isDeleted,
    Expression<String>? thumbnail,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (parent != null) 'parent': parent,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateLastModified != null) 'date_last_modified': dateLastModified,
      if (collectionId != null) 'collection_id': collectionId,
      if (contentType != null) 'content_type': contentType,
      if (size != null) 'size': size,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? path,
      Value<String>? parent,
      Value<DateTime>? dateCreated,
      Value<DateTime>? dateLastModified,
      Value<String>? collectionId,
      Value<String>? contentType,
      Value<int>? size,
      Value<bool>? isDeleted,
      Value<String?>? thumbnail,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<int>? rowid}) {
    return FilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      parent: parent ?? this.parent,
      dateCreated: dateCreated ?? this.dateCreated,
      dateLastModified: dateLastModified ?? this.dateLastModified,
      collectionId: collectionId ?? this.collectionId,
      contentType: contentType ?? this.contentType,
      size: size ?? this.size,
      isDeleted: isDeleted ?? this.isDeleted,
      thumbnail: thumbnail ?? this.thumbnail,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateLastModified.present) {
      map['date_last_modified'] = Variable<DateTime>(dateLastModified.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('parent: $parent, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateLastModified: $dateLastModified, ')
          ..write('collectionId: $collectionId, ')
          ..write('contentType: $contentType, ')
          ..write('size: $size, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
      'parent', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateLastModifiedMeta =
      const VerificationMeta('dateLastModified');
  @override
  late final GeneratedColumn<DateTime> dateLastModified =
      GeneratedColumn<DateTime>('date_last_modified', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _collectionIdMeta =
      const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
      'collection_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, path, parent, dateCreated, dateLastModified, collectionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
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
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta,
          parent.isAcceptableOrUnknown(data['parent']!, _parentMeta));
    } else if (isInserting) {
      context.missing(_parentMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (data.containsKey('date_last_modified')) {
      context.handle(
          _dateLastModifiedMeta,
          dateLastModified.isAcceptableOrUnknown(
              data['date_last_modified']!, _dateLastModifiedMeta));
    } else if (isInserting) {
      context.missing(_dateLastModifiedMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
          _collectionIdMeta,
          collectionId.isAcceptableOrUnknown(
              data['collection_id']!, _collectionIdMeta));
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      parent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateLastModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_last_modified'])!,
      collectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> path;
  final Value<String> parent;
  final Value<DateTime> dateCreated;
  final Value<DateTime> dateLastModified;
  final Value<String> collectionId;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.parent = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateLastModified = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    required String path,
    required String parent,
    required DateTime dateCreated,
    required DateTime dateLastModified,
    required String collectionId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        path = Value(path),
        parent = Value(parent),
        dateCreated = Value(dateCreated),
        dateLastModified = Value(dateLastModified),
        collectionId = Value(collectionId);
  static Insertable<Folder> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? path,
    Expression<String>? parent,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateLastModified,
    Expression<String>? collectionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (parent != null) 'parent': parent,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateLastModified != null) 'date_last_modified': dateLastModified,
      if (collectionId != null) 'collection_id': collectionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? path,
      Value<String>? parent,
      Value<DateTime>? dateCreated,
      Value<DateTime>? dateLastModified,
      Value<String>? collectionId,
      Value<int>? rowid}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      parent: parent ?? this.parent,
      dateCreated: dateCreated ?? this.dateCreated,
      dateLastModified: dateLastModified ?? this.dateLastModified,
      collectionId: collectionId ?? this.collectionId,
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
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateLastModified.present) {
      map['date_last_modified'] = Variable<DateTime>(dateLastModified.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('parent: $parent, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateLastModified: $dateLastModified, ')
          ..write('collectionId: $collectionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Album> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumsCompanion copyWith(
      {Value<String>? id, Value<String>? name, Value<int>? rowid}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AppsTable apps = $AppsTable(this);
  late final $AppUsersTable appUsers = $AppUsersTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $EmailsTable emails = $EmailsTable(this);
  late final $FilesTable files = $FilesTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final Index collectionsIdIdx = Index('collections_id_idx',
      'CREATE INDEX collections_id_idx ON collections (id)');
  late final Index collectionsPathIdx = Index('collections_path_idx',
      'CREATE INDEX collections_path_idx ON collections (path)');
  late final Index collectionsTypeIdx = Index('collections_type_idx',
      'CREATE INDEX collections_type_idx ON collections (type)');
  late final Index emailIdIdx =
      Index('email_id_idx', 'CREATE INDEX email_id_idx ON emails (id)');
  late final Index emailCollectionidIdx = Index('email_collectionid_idx',
      'CREATE INDEX email_collectionid_idx ON emails (collection_id)');
  late final Index emailDateIdx =
      Index('email_date_idx', 'CREATE INDEX email_date_idx ON emails (date)');
  late final Index emailFromIdx =
      Index('email_from_idx', 'CREATE INDEX email_from_idx ON emails ("from")');
  late final Index filePathIdx =
      Index('file_path_idx', 'CREATE INDEX file_path_idx ON files (path)');
  late final Index fileParentIdx = Index(
      'file_parent_idx', 'CREATE INDEX file_parent_idx ON files (parent)');
  late final Index fileCollectionIdIdx = Index('file_collection_id_idx',
      'CREATE INDEX file_collection_id_idx ON files (collection_id)');
  late final Index fileContenttypeIdx = Index('file_contenttype_idx',
      'CREATE INDEX file_contenttype_idx ON files (content_type)');
  late final Index folderPathIdx = Index(
      'folder_path_idx', 'CREATE INDEX folder_path_idx ON folders (path)');
  late final Index folderParentIdx = Index('folder_parent_idx',
      'CREATE INDEX folder_parent_idx ON folders (parent)');
  late final Index folderCollectionIdIdx = Index('folder_collection_id_idx',
      'CREATE INDEX folder_collection_id_idx ON folders (collection_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        apps,
        appUsers,
        collections,
        emails,
        files,
        folders,
        albums,
        collectionsIdIdx,
        collectionsPathIdx,
        collectionsTypeIdx,
        emailIdIdx,
        emailCollectionidIdx,
        emailDateIdx,
        emailFromIdx,
        filePathIdx,
        fileParentIdx,
        fileCollectionIdIdx,
        fileContenttypeIdx,
        folderPathIdx,
        folderParentIdx,
        folderCollectionIdIdx
      ];
}
