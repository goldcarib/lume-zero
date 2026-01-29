/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class LumeGroup
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LumeGroup._({
    this.id,
    required this.name,
    required this.encryptedAiConfig,
    this.knowledgeBase,
    required this.adminHash,
  });

  factory LumeGroup({
    int? id,
    required String name,
    required String encryptedAiConfig,
    String? knowledgeBase,
    required String adminHash,
  }) = _LumeGroupImpl;

  factory LumeGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return LumeGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      encryptedAiConfig: jsonSerialization['encryptedAiConfig'] as String,
      knowledgeBase: jsonSerialization['knowledgeBase'] as String?,
      adminHash: jsonSerialization['adminHash'] as String,
    );
  }

  static final t = LumeGroupTable();

  static const db = LumeGroupRepository._();

  @override
  int? id;

  String name;

  String encryptedAiConfig;

  String? knowledgeBase;

  String adminHash;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LumeGroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LumeGroup copyWith({
    int? id,
    String? name,
    String? encryptedAiConfig,
    String? knowledgeBase,
    String? adminHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LumeGroup',
      if (id != null) 'id': id,
      'name': name,
      'encryptedAiConfig': encryptedAiConfig,
      if (knowledgeBase != null) 'knowledgeBase': knowledgeBase,
      'adminHash': adminHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LumeGroup',
      if (id != null) 'id': id,
      'name': name,
      'encryptedAiConfig': encryptedAiConfig,
      if (knowledgeBase != null) 'knowledgeBase': knowledgeBase,
      'adminHash': adminHash,
    };
  }

  static LumeGroupInclude include() {
    return LumeGroupInclude._();
  }

  static LumeGroupIncludeList includeList({
    _i1.WhereExpressionBuilder<LumeGroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LumeGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LumeGroupTable>? orderByList,
    LumeGroupInclude? include,
  }) {
    return LumeGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LumeGroup.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LumeGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LumeGroupImpl extends LumeGroup {
  _LumeGroupImpl({
    int? id,
    required String name,
    required String encryptedAiConfig,
    String? knowledgeBase,
    required String adminHash,
  }) : super._(
         id: id,
         name: name,
         encryptedAiConfig: encryptedAiConfig,
         knowledgeBase: knowledgeBase,
         adminHash: adminHash,
       );

  /// Returns a shallow copy of this [LumeGroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LumeGroup copyWith({
    Object? id = _Undefined,
    String? name,
    String? encryptedAiConfig,
    Object? knowledgeBase = _Undefined,
    String? adminHash,
  }) {
    return LumeGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      encryptedAiConfig: encryptedAiConfig ?? this.encryptedAiConfig,
      knowledgeBase: knowledgeBase is String?
          ? knowledgeBase
          : this.knowledgeBase,
      adminHash: adminHash ?? this.adminHash,
    );
  }
}

class LumeGroupUpdateTable extends _i1.UpdateTable<LumeGroupTable> {
  LumeGroupUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> encryptedAiConfig(String value) =>
      _i1.ColumnValue(
        table.encryptedAiConfig,
        value,
      );

  _i1.ColumnValue<String, String> knowledgeBase(String? value) =>
      _i1.ColumnValue(
        table.knowledgeBase,
        value,
      );

  _i1.ColumnValue<String, String> adminHash(String value) => _i1.ColumnValue(
    table.adminHash,
    value,
  );
}

class LumeGroupTable extends _i1.Table<int?> {
  LumeGroupTable({super.tableRelation}) : super(tableName: 'lume_group') {
    updateTable = LumeGroupUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    encryptedAiConfig = _i1.ColumnString(
      'encryptedAiConfig',
      this,
    );
    knowledgeBase = _i1.ColumnString(
      'knowledgeBase',
      this,
    );
    adminHash = _i1.ColumnString(
      'adminHash',
      this,
    );
  }

  late final LumeGroupUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString encryptedAiConfig;

  late final _i1.ColumnString knowledgeBase;

  late final _i1.ColumnString adminHash;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    encryptedAiConfig,
    knowledgeBase,
    adminHash,
  ];
}

class LumeGroupInclude extends _i1.IncludeObject {
  LumeGroupInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LumeGroup.t;
}

class LumeGroupIncludeList extends _i1.IncludeList {
  LumeGroupIncludeList._({
    _i1.WhereExpressionBuilder<LumeGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LumeGroup.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LumeGroup.t;
}

class LumeGroupRepository {
  const LumeGroupRepository._();

  /// Returns a list of [LumeGroup]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<LumeGroup>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LumeGroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LumeGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LumeGroupTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LumeGroup>(
      where: where?.call(LumeGroup.t),
      orderBy: orderBy?.call(LumeGroup.t),
      orderByList: orderByList?.call(LumeGroup.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [LumeGroup] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<LumeGroup?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LumeGroupTable>? where,
    int? offset,
    _i1.OrderByBuilder<LumeGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LumeGroupTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<LumeGroup>(
      where: where?.call(LumeGroup.t),
      orderBy: orderBy?.call(LumeGroup.t),
      orderByList: orderByList?.call(LumeGroup.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [LumeGroup] by its [id] or null if no such row exists.
  Future<LumeGroup?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<LumeGroup>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [LumeGroup]s in the list and returns the inserted rows.
  ///
  /// The returned [LumeGroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LumeGroup>> insert(
    _i1.Session session,
    List<LumeGroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LumeGroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LumeGroup] and returns the inserted row.
  ///
  /// The returned [LumeGroup] will have its `id` field set.
  Future<LumeGroup> insertRow(
    _i1.Session session,
    LumeGroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LumeGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LumeGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LumeGroup>> update(
    _i1.Session session,
    List<LumeGroup> rows, {
    _i1.ColumnSelections<LumeGroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LumeGroup>(
      rows,
      columns: columns?.call(LumeGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LumeGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LumeGroup> updateRow(
    _i1.Session session,
    LumeGroup row, {
    _i1.ColumnSelections<LumeGroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LumeGroup>(
      row,
      columns: columns?.call(LumeGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LumeGroup] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LumeGroup?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LumeGroupUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LumeGroup>(
      id,
      columnValues: columnValues(LumeGroup.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LumeGroup]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LumeGroup>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LumeGroupUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LumeGroupTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LumeGroupTable>? orderBy,
    _i1.OrderByListBuilder<LumeGroupTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LumeGroup>(
      columnValues: columnValues(LumeGroup.t.updateTable),
      where: where(LumeGroup.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LumeGroup.t),
      orderByList: orderByList?.call(LumeGroup.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LumeGroup]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LumeGroup>> delete(
    _i1.Session session,
    List<LumeGroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LumeGroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LumeGroup].
  Future<LumeGroup> deleteRow(
    _i1.Session session,
    LumeGroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LumeGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LumeGroup>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LumeGroupTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LumeGroup>(
      where: where(LumeGroup.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LumeGroupTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LumeGroup>(
      where: where?.call(LumeGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
