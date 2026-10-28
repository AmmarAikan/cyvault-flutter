// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VaultRecordsTable extends VaultRecords
    with TableInfo<$VaultRecordsTable, VaultRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<String> nonce = GeneratedColumn<String>(
    'nonce',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ciphertextMeta = const VerificationMeta(
    'ciphertext',
  );
  @override
  late final GeneratedColumn<String> ciphertext = GeneratedColumn<String>(
    'ciphertext',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authenticationTagMeta = const VerificationMeta(
    'authenticationTag',
  );
  @override
  late final GeneratedColumn<String> authenticationTag =
      GeneratedColumn<String>(
        'authentication_tag',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _riskScoreMeta = const VerificationMeta(
    'riskScore',
  );
  @override
  late final GeneratedColumn<int> riskScore = GeneratedColumn<int>(
    'risk_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _breachedMeta = const VerificationMeta(
    'breached',
  );
  @override
  late final GeneratedColumn<bool> breached = GeneratedColumn<bool>(
    'breached',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("breached" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    payloadVersion,
    nonce,
    ciphertext,
    authenticationTag,
    favorite,
    riskScore,
    breached,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('nonce')) {
      context.handle(
        _nonceMeta,
        nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta),
      );
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('ciphertext')) {
      context.handle(
        _ciphertextMeta,
        ciphertext.isAcceptableOrUnknown(data['ciphertext']!, _ciphertextMeta),
      );
    } else if (isInserting) {
      context.missing(_ciphertextMeta);
    }
    if (data.containsKey('authentication_tag')) {
      context.handle(
        _authenticationTagMeta,
        authenticationTag.isAcceptableOrUnknown(
          data['authentication_tag']!,
          _authenticationTagMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authenticationTagMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('risk_score')) {
      context.handle(
        _riskScoreMeta,
        riskScore.isAcceptableOrUnknown(data['risk_score']!, _riskScoreMeta),
      );
    }
    if (data.containsKey('breached')) {
      context.handle(
        _breachedMeta,
        breached.isAcceptableOrUnknown(data['breached']!, _breachedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      nonce: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nonce'],
      )!,
      ciphertext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciphertext'],
      )!,
      authenticationTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authentication_tag'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      riskScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}risk_score'],
      )!,
      breached: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}breached'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VaultRecordsTable createAlias(String alias) {
    return $VaultRecordsTable(attachedDatabase, alias);
  }
}

class VaultRecord extends DataClass implements Insertable<VaultRecord> {
  final String id;
  final int payloadVersion;
  final String nonce;
  final String ciphertext;
  final String authenticationTag;
  final bool favorite;
  final int riskScore;
  final bool breached;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VaultRecord({
    required this.id,
    required this.payloadVersion,
    required this.nonce,
    required this.ciphertext,
    required this.authenticationTag,
    required this.favorite,
    required this.riskScore,
    required this.breached,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['nonce'] = Variable<String>(nonce);
    map['ciphertext'] = Variable<String>(ciphertext);
    map['authentication_tag'] = Variable<String>(authenticationTag);
    map['favorite'] = Variable<bool>(favorite);
    map['risk_score'] = Variable<int>(riskScore);
    map['breached'] = Variable<bool>(breached);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VaultRecordsCompanion toCompanion(bool nullToAbsent) {
    return VaultRecordsCompanion(
      id: Value(id),
      payloadVersion: Value(payloadVersion),
      nonce: Value(nonce),
      ciphertext: Value(ciphertext),
      authenticationTag: Value(authenticationTag),
      favorite: Value(favorite),
      riskScore: Value(riskScore),
      breached: Value(breached),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VaultRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultRecord(
      id: serializer.fromJson<String>(json['id']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      nonce: serializer.fromJson<String>(json['nonce']),
      ciphertext: serializer.fromJson<String>(json['ciphertext']),
      authenticationTag: serializer.fromJson<String>(json['authenticationTag']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      riskScore: serializer.fromJson<int>(json['riskScore']),
      breached: serializer.fromJson<bool>(json['breached']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'nonce': serializer.toJson<String>(nonce),
      'ciphertext': serializer.toJson<String>(ciphertext),
      'authenticationTag': serializer.toJson<String>(authenticationTag),
      'favorite': serializer.toJson<bool>(favorite),
      'riskScore': serializer.toJson<int>(riskScore),
      'breached': serializer.toJson<bool>(breached),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VaultRecord copyWith({
    String? id,
    int? payloadVersion,
    String? nonce,
    String? ciphertext,
    String? authenticationTag,
    bool? favorite,
    int? riskScore,
    bool? breached,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VaultRecord(
    id: id ?? this.id,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    nonce: nonce ?? this.nonce,
    ciphertext: ciphertext ?? this.ciphertext,
    authenticationTag: authenticationTag ?? this.authenticationTag,
    favorite: favorite ?? this.favorite,
    riskScore: riskScore ?? this.riskScore,
    breached: breached ?? this.breached,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VaultRecord copyWithCompanion(VaultRecordsCompanion data) {
    return VaultRecord(
      id: data.id.present ? data.id.value : this.id,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      ciphertext: data.ciphertext.present
          ? data.ciphertext.value
          : this.ciphertext,
      authenticationTag: data.authenticationTag.present
          ? data.authenticationTag.value
          : this.authenticationTag,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      riskScore: data.riskScore.present ? data.riskScore.value : this.riskScore,
      breached: data.breached.present ? data.breached.value : this.breached,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultRecord(')
          ..write('id: $id, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('nonce: $nonce, ')
          ..write('ciphertext: $ciphertext, ')
          ..write('authenticationTag: $authenticationTag, ')
          ..write('favorite: $favorite, ')
          ..write('riskScore: $riskScore, ')
          ..write('breached: $breached, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    payloadVersion,
    nonce,
    ciphertext,
    authenticationTag,
    favorite,
    riskScore,
    breached,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultRecord &&
          other.id == this.id &&
          other.payloadVersion == this.payloadVersion &&
          other.nonce == this.nonce &&
          other.ciphertext == this.ciphertext &&
          other.authenticationTag == this.authenticationTag &&
          other.favorite == this.favorite &&
          other.riskScore == this.riskScore &&
          other.breached == this.breached &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaultRecordsCompanion extends UpdateCompanion<VaultRecord> {
  final Value<String> id;
  final Value<int> payloadVersion;
  final Value<String> nonce;
  final Value<String> ciphertext;
  final Value<String> authenticationTag;
  final Value<bool> favorite;
  final Value<int> riskScore;
  final Value<bool> breached;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VaultRecordsCompanion({
    this.id = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.nonce = const Value.absent(),
    this.ciphertext = const Value.absent(),
    this.authenticationTag = const Value.absent(),
    this.favorite = const Value.absent(),
    this.riskScore = const Value.absent(),
    this.breached = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultRecordsCompanion.insert({
    required String id,
    this.payloadVersion = const Value.absent(),
    required String nonce,
    required String ciphertext,
    required String authenticationTag,
    this.favorite = const Value.absent(),
    this.riskScore = const Value.absent(),
    this.breached = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nonce = Value(nonce),
       ciphertext = Value(ciphertext),
       authenticationTag = Value(authenticationTag),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VaultRecord> custom({
    Expression<String>? id,
    Expression<int>? payloadVersion,
    Expression<String>? nonce,
    Expression<String>? ciphertext,
    Expression<String>? authenticationTag,
    Expression<bool>? favorite,
    Expression<int>? riskScore,
    Expression<bool>? breached,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (nonce != null) 'nonce': nonce,
      if (ciphertext != null) 'ciphertext': ciphertext,
      if (authenticationTag != null) 'authentication_tag': authenticationTag,
      if (favorite != null) 'favorite': favorite,
      if (riskScore != null) 'risk_score': riskScore,
      if (breached != null) 'breached': breached,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultRecordsCompanion copyWith({
    Value<String>? id,
    Value<int>? payloadVersion,
    Value<String>? nonce,
    Value<String>? ciphertext,
    Value<String>? authenticationTag,
    Value<bool>? favorite,
    Value<int>? riskScore,
    Value<bool>? breached,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VaultRecordsCompanion(
      id: id ?? this.id,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      nonce: nonce ?? this.nonce,
      ciphertext: ciphertext ?? this.ciphertext,
      authenticationTag: authenticationTag ?? this.authenticationTag,
      favorite: favorite ?? this.favorite,
      riskScore: riskScore ?? this.riskScore,
      breached: breached ?? this.breached,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    if (ciphertext.present) {
      map['ciphertext'] = Variable<String>(ciphertext.value);
    }
    if (authenticationTag.present) {
      map['authentication_tag'] = Variable<String>(authenticationTag.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (riskScore.present) {
      map['risk_score'] = Variable<int>(riskScore.value);
    }
    if (breached.present) {
      map['breached'] = Variable<bool>(breached.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultRecordsCompanion(')
          ..write('id: $id, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('nonce: $nonce, ')
          ..write('ciphertext: $ciphertext, ')
          ..write('authenticationTag: $authenticationTag, ')
          ..write('favorite: $favorite, ')
          ..write('riskScore: $riskScore, ')
          ..write('breached: $breached, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BreachCacheEntriesTable extends BreachCacheEntries
    with TableInfo<$BreachCacheEntriesTable, BreachCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreachCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyedLookupMeta = const VerificationMeta(
    'keyedLookup',
  );
  @override
  late final GeneratedColumn<String> keyedLookup = GeneratedColumn<String>(
    'keyed_lookup',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [keyedLookup, count, checkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breach_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BreachCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('keyed_lookup')) {
      context.handle(
        _keyedLookupMeta,
        keyedLookup.isAcceptableOrUnknown(
          data['keyed_lookup']!,
          _keyedLookupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_keyedLookupMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {keyedLookup};
  @override
  BreachCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BreachCacheEntry(
      keyedLookup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyed_lookup'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
    );
  }

  @override
  $BreachCacheEntriesTable createAlias(String alias) {
    return $BreachCacheEntriesTable(attachedDatabase, alias);
  }
}

class BreachCacheEntry extends DataClass
    implements Insertable<BreachCacheEntry> {
  final String keyedLookup;
  final int count;
  final DateTime checkedAt;
  const BreachCacheEntry({
    required this.keyedLookup,
    required this.count,
    required this.checkedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['keyed_lookup'] = Variable<String>(keyedLookup);
    map['count'] = Variable<int>(count);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    return map;
  }

  BreachCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return BreachCacheEntriesCompanion(
      keyedLookup: Value(keyedLookup),
      count: Value(count),
      checkedAt: Value(checkedAt),
    );
  }

  factory BreachCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BreachCacheEntry(
      keyedLookup: serializer.fromJson<String>(json['keyedLookup']),
      count: serializer.fromJson<int>(json['count']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'keyedLookup': serializer.toJson<String>(keyedLookup),
      'count': serializer.toJson<int>(count),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
    };
  }

  BreachCacheEntry copyWith({
    String? keyedLookup,
    int? count,
    DateTime? checkedAt,
  }) => BreachCacheEntry(
    keyedLookup: keyedLookup ?? this.keyedLookup,
    count: count ?? this.count,
    checkedAt: checkedAt ?? this.checkedAt,
  );
  BreachCacheEntry copyWithCompanion(BreachCacheEntriesCompanion data) {
    return BreachCacheEntry(
      keyedLookup: data.keyedLookup.present
          ? data.keyedLookup.value
          : this.keyedLookup,
      count: data.count.present ? data.count.value : this.count,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BreachCacheEntry(')
          ..write('keyedLookup: $keyedLookup, ')
          ..write('count: $count, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(keyedLookup, count, checkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BreachCacheEntry &&
          other.keyedLookup == this.keyedLookup &&
          other.count == this.count &&
          other.checkedAt == this.checkedAt);
}

class BreachCacheEntriesCompanion extends UpdateCompanion<BreachCacheEntry> {
  final Value<String> keyedLookup;
  final Value<int> count;
  final Value<DateTime> checkedAt;
  final Value<int> rowid;
  const BreachCacheEntriesCompanion({
    this.keyedLookup = const Value.absent(),
    this.count = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BreachCacheEntriesCompanion.insert({
    required String keyedLookup,
    required int count,
    required DateTime checkedAt,
    this.rowid = const Value.absent(),
  }) : keyedLookup = Value(keyedLookup),
       count = Value(count),
       checkedAt = Value(checkedAt);
  static Insertable<BreachCacheEntry> custom({
    Expression<String>? keyedLookup,
    Expression<int>? count,
    Expression<DateTime>? checkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (keyedLookup != null) 'keyed_lookup': keyedLookup,
      if (count != null) 'count': count,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BreachCacheEntriesCompanion copyWith({
    Value<String>? keyedLookup,
    Value<int>? count,
    Value<DateTime>? checkedAt,
    Value<int>? rowid,
  }) {
    return BreachCacheEntriesCompanion(
      keyedLookup: keyedLookup ?? this.keyedLookup,
      count: count ?? this.count,
      checkedAt: checkedAt ?? this.checkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (keyedLookup.present) {
      map['keyed_lookup'] = Variable<String>(keyedLookup.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BreachCacheEntriesCompanion(')
          ..write('keyedLookup: $keyedLookup, ')
          ..write('count: $count, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecurityEventsTable extends SecurityEvents
    with TableInfo<$SecurityEventsTable, SecurityEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecurityEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, occurredAt, details];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'security_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SecurityEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SecurityEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecurityEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
    );
  }

  @override
  $SecurityEventsTable createAlias(String alias) {
    return $SecurityEventsTable(attachedDatabase, alias);
  }
}

class SecurityEvent extends DataClass implements Insertable<SecurityEvent> {
  final int id;
  final String kind;
  final DateTime occurredAt;
  final String? details;
  const SecurityEvent({
    required this.id,
    required this.kind,
    required this.occurredAt,
    this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  SecurityEventsCompanion toCompanion(bool nullToAbsent) {
    return SecurityEventsCompanion(
      id: Value(id),
      kind: Value(kind),
      occurredAt: Value(occurredAt),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory SecurityEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecurityEvent(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'details': serializer.toJson<String?>(details),
    };
  }

  SecurityEvent copyWith({
    int? id,
    String? kind,
    DateTime? occurredAt,
    Value<String?> details = const Value.absent(),
  }) => SecurityEvent(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    occurredAt: occurredAt ?? this.occurredAt,
    details: details.present ? details.value : this.details,
  );
  SecurityEvent copyWithCompanion(SecurityEventsCompanion data) {
    return SecurityEvent(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecurityEvent(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, occurredAt, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecurityEvent &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.occurredAt == this.occurredAt &&
          other.details == this.details);
}

class SecurityEventsCompanion extends UpdateCompanion<SecurityEvent> {
  final Value<int> id;
  final Value<String> kind;
  final Value<DateTime> occurredAt;
  final Value<String?> details;
  const SecurityEventsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.details = const Value.absent(),
  });
  SecurityEventsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required DateTime occurredAt,
    this.details = const Value.absent(),
  }) : kind = Value(kind),
       occurredAt = Value(occurredAt);
  static Insertable<SecurityEvent> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<DateTime>? occurredAt,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (details != null) 'details': details,
    });
  }

  SecurityEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<DateTime>? occurredAt,
    Value<String?>? details,
  }) {
    return SecurityEventsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      occurredAt: occurredAt ?? this.occurredAt,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecurityEventsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VaultRecordsTable vaultRecords = $VaultRecordsTable(this);
  late final $BreachCacheEntriesTable breachCacheEntries =
      $BreachCacheEntriesTable(this);
  late final $SecurityEventsTable securityEvents = $SecurityEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vaultRecords,
    breachCacheEntries,
    securityEvents,
  ];
}

typedef $$VaultRecordsTableCreateCompanionBuilder =
    VaultRecordsCompanion Function({
      required String id,
      Value<int> payloadVersion,
      required String nonce,
      required String ciphertext,
      required String authenticationTag,
      Value<bool> favorite,
      Value<int> riskScore,
      Value<bool> breached,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VaultRecordsTableUpdateCompanionBuilder =
    VaultRecordsCompanion Function({
      Value<String> id,
      Value<int> payloadVersion,
      Value<String> nonce,
      Value<String> ciphertext,
      Value<String> authenticationTag,
      Value<bool> favorite,
      Value<int> riskScore,
      Value<bool> breached,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$VaultRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $VaultRecordsTable> {
  $$VaultRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authenticationTag => $composableBuilder(
    column: $table.authenticationTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get riskScore => $composableBuilder(
    column: $table.riskScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get breached => $composableBuilder(
    column: $table.breached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultRecordsTable> {
  $$VaultRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authenticationTag => $composableBuilder(
    column: $table.authenticationTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get riskScore => $composableBuilder(
    column: $table.riskScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get breached => $composableBuilder(
    column: $table.breached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultRecordsTable> {
  $$VaultRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<String> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authenticationTag => $composableBuilder(
    column: $table.authenticationTag,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<int> get riskScore =>
      $composableBuilder(column: $table.riskScore, builder: (column) => column);

  GeneratedColumn<bool> get breached =>
      $composableBuilder(column: $table.breached, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VaultRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultRecordsTable,
          VaultRecord,
          $$VaultRecordsTableFilterComposer,
          $$VaultRecordsTableOrderingComposer,
          $$VaultRecordsTableAnnotationComposer,
          $$VaultRecordsTableCreateCompanionBuilder,
          $$VaultRecordsTableUpdateCompanionBuilder,
          (
            VaultRecord,
            BaseReferences<_$AppDatabase, $VaultRecordsTable, VaultRecord>,
          ),
          VaultRecord,
          PrefetchHooks Function()
        > {
  $$VaultRecordsTableTableManager(_$AppDatabase db, $VaultRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> nonce = const Value.absent(),
                Value<String> ciphertext = const Value.absent(),
                Value<String> authenticationTag = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<int> riskScore = const Value.absent(),
                Value<bool> breached = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultRecordsCompanion(
                id: id,
                payloadVersion: payloadVersion,
                nonce: nonce,
                ciphertext: ciphertext,
                authenticationTag: authenticationTag,
                favorite: favorite,
                riskScore: riskScore,
                breached: breached,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> payloadVersion = const Value.absent(),
                required String nonce,
                required String ciphertext,
                required String authenticationTag,
                Value<bool> favorite = const Value.absent(),
                Value<int> riskScore = const Value.absent(),
                Value<bool> breached = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VaultRecordsCompanion.insert(
                id: id,
                payloadVersion: payloadVersion,
                nonce: nonce,
                ciphertext: ciphertext,
                authenticationTag: authenticationTag,
                favorite: favorite,
                riskScore: riskScore,
                breached: breached,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VaultRecordsTable, VaultRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $VaultRecordsTable,
                    VaultRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultRecordsTable,
      VaultRecord,
      $$VaultRecordsTableFilterComposer,
      $$VaultRecordsTableOrderingComposer,
      $$VaultRecordsTableAnnotationComposer,
      $$VaultRecordsTableCreateCompanionBuilder,
      $$VaultRecordsTableUpdateCompanionBuilder,
      (
        VaultRecord,
        BaseReferences<_$AppDatabase, $VaultRecordsTable, VaultRecord>,
      ),
      VaultRecord,
      PrefetchHooks Function()
    >;
typedef $$BreachCacheEntriesTableCreateCompanionBuilder =
    BreachCacheEntriesCompanion Function({
      required String keyedLookup,
      required int count,
      required DateTime checkedAt,
      Value<int> rowid,
    });
typedef $$BreachCacheEntriesTableUpdateCompanionBuilder =
    BreachCacheEntriesCompanion Function({
      Value<String> keyedLookup,
      Value<int> count,
      Value<DateTime> checkedAt,
      Value<int> rowid,
    });

class $$BreachCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BreachCacheEntriesTable> {
  $$BreachCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get keyedLookup => $composableBuilder(
    column: $table.keyedLookup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BreachCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BreachCacheEntriesTable> {
  $$BreachCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get keyedLookup => $composableBuilder(
    column: $table.keyedLookup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BreachCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreachCacheEntriesTable> {
  $$BreachCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get keyedLookup => $composableBuilder(
    column: $table.keyedLookup,
    builder: (column) => column,
  );

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);
}

class $$BreachCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BreachCacheEntriesTable,
          BreachCacheEntry,
          $$BreachCacheEntriesTableFilterComposer,
          $$BreachCacheEntriesTableOrderingComposer,
          $$BreachCacheEntriesTableAnnotationComposer,
          $$BreachCacheEntriesTableCreateCompanionBuilder,
          $$BreachCacheEntriesTableUpdateCompanionBuilder,
          (
            BreachCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $BreachCacheEntriesTable,
              BreachCacheEntry
            >,
          ),
          BreachCacheEntry,
          PrefetchHooks Function()
        > {
  $$BreachCacheEntriesTableTableManager(
    _$AppDatabase db,
    $BreachCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreachCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BreachCacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreachCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> keyedLookup = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BreachCacheEntriesCompanion(
                keyedLookup: keyedLookup,
                count: count,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String keyedLookup,
                required int count,
                required DateTime checkedAt,
                Value<int> rowid = const Value.absent(),
              }) => BreachCacheEntriesCompanion.insert(
                keyedLookup: keyedLookup,
                count: count,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BreachCacheEntriesTable, BreachCacheEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BreachCacheEntriesTable,
                    BreachCacheEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BreachCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BreachCacheEntriesTable,
      BreachCacheEntry,
      $$BreachCacheEntriesTableFilterComposer,
      $$BreachCacheEntriesTableOrderingComposer,
      $$BreachCacheEntriesTableAnnotationComposer,
      $$BreachCacheEntriesTableCreateCompanionBuilder,
      $$BreachCacheEntriesTableUpdateCompanionBuilder,
      (
        BreachCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $BreachCacheEntriesTable,
          BreachCacheEntry
        >,
      ),
      BreachCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$SecurityEventsTableCreateCompanionBuilder =
    SecurityEventsCompanion Function({
      Value<int> id,
      required String kind,
      required DateTime occurredAt,
      Value<String?> details,
    });
typedef $$SecurityEventsTableUpdateCompanionBuilder =
    SecurityEventsCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<DateTime> occurredAt,
      Value<String?> details,
    });

class $$SecurityEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SecurityEventsTable> {
  $$SecurityEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SecurityEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SecurityEventsTable> {
  $$SecurityEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SecurityEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecurityEventsTable> {
  $$SecurityEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$SecurityEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SecurityEventsTable,
          SecurityEvent,
          $$SecurityEventsTableFilterComposer,
          $$SecurityEventsTableOrderingComposer,
          $$SecurityEventsTableAnnotationComposer,
          $$SecurityEventsTableCreateCompanionBuilder,
          $$SecurityEventsTableUpdateCompanionBuilder,
          (
            SecurityEvent,
            BaseReferences<_$AppDatabase, $SecurityEventsTable, SecurityEvent>,
          ),
          SecurityEvent,
          PrefetchHooks Function()
        > {
  $$SecurityEventsTableTableManager(
    _$AppDatabase db,
    $SecurityEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecurityEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecurityEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecurityEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> details = const Value.absent(),
              }) => SecurityEventsCompanion(
                id: id,
                kind: kind,
                occurredAt: occurredAt,
                details: details,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required DateTime occurredAt,
                Value<String?> details = const Value.absent(),
              }) => SecurityEventsCompanion.insert(
                id: id,
                kind: kind,
                occurredAt: occurredAt,
                details: details,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SecurityEventsTable, SecurityEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SecurityEventsTable,
                    SecurityEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SecurityEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SecurityEventsTable,
      SecurityEvent,
      $$SecurityEventsTableFilterComposer,
      $$SecurityEventsTableOrderingComposer,
      $$SecurityEventsTableAnnotationComposer,
      $$SecurityEventsTableCreateCompanionBuilder,
      $$SecurityEventsTableUpdateCompanionBuilder,
      (
        SecurityEvent,
        BaseReferences<_$AppDatabase, $SecurityEventsTable, SecurityEvent>,
      ),
      SecurityEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VaultRecordsTableTableManager get vaultRecords =>
      $$VaultRecordsTableTableManager(_db, _db.vaultRecords);
  $$BreachCacheEntriesTableTableManager get breachCacheEntries =>
      $$BreachCacheEntriesTableTableManager(_db, _db.breachCacheEntries);
  $$SecurityEventsTableTableManager get securityEvents =>
      $$SecurityEventsTableTableManager(_db, _db.securityEvents);
}
