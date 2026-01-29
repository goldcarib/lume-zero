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
import 'session_status.dart' as _i2;

abstract class LumeSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LumeSession._({
    this.id,
    required this.roomId,
    this.groupId,
    required this.status,
    required this.createdAt,
  });

  factory LumeSession({
    int? id,
    required String roomId,
    String? groupId,
    required _i2.SessionStatus status,
    required DateTime createdAt,
  }) = _LumeSessionImpl;

  factory LumeSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return LumeSession(
      id: jsonSerialization['id'] as int?,
      roomId: jsonSerialization['roomId'] as String,
      groupId: jsonSerialization['groupId'] as String?,
      status: _i2.SessionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = LumeSessionTable();

  static const db = LumeSessionRepository._();

  @override
  int? id;

  String roomId;

  String? groupId;

  _i2.SessionStatus status;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LumeSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LumeSession copyWith({
    int? id,
    String? roomId,
    String? groupId,
    _i2.SessionStatus? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LumeSession',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (groupId != null) 'groupId': groupId,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LumeSession',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (groupId != null) 'groupId': groupId,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static LumeSessionInclude include() {
    return LumeSessionInclude._();
  }

  static LumeSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<LumeSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LumeSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LumeSessionTable>? orderByList,
    LumeSessionInclude? include,
  }) {
    return LumeSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LumeSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LumeSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LumeSessionImpl extends LumeSession {
  _LumeSessionImpl({
    int? id,
    required String roomId,
    String? groupId,
    required _i2.SessionStatus status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         roomId: roomId,
         groupId: groupId,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LumeSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LumeSession copyWith({
    Object? id = _Undefined,
    String? roomId,
    Object? groupId = _Undefined,
    _i2.SessionStatus? status,
    DateTime? createdAt,
  }) {
    return LumeSession(
      id: id is int? ? id : this.id,
      roomId: roomId ?? this.roomId,
      groupId: groupId is String? ? groupId : this.groupId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LumeSessionUpdateTable extends _i1.UpdateTable<LumeSessionTable> {
  LumeSessionUpdateTable(super.table);

  _i1.ColumnValue<String, String> roomId(String value) => _i1.ColumnValue(
    table.roomId,
    value,
  );

  _i1.ColumnValue<String, String> groupId(String? value) => _i1.ColumnValue(
    table.groupId,
    value,
  );

  _i1.ColumnValue<_i2.SessionStatus, _i2.SessionStatus> status(
    _i2.SessionStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class LumeSessionTable extends _i1.Table<int?> {
  LumeSessionTable({super.tableRelation}) : super(tableName: 'lume_session') {
    updateTable = LumeSessionUpdateTable(this);
    roomId = _i1.ColumnString(
      'roomId',
      this,
    );
    groupId = _i1.ColumnString(
      'groupId',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final LumeSessionUpdateTable updateTable;

  late final _i1.ColumnString roomId;

  late final _i1.ColumnString groupId;

  late final _i1.ColumnEnum<_i2.SessionStatus> status;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    roomId,
    groupId,
    status,
    createdAt,
  ];
}

class LumeSessionInclude extends _i1.IncludeObject {
  LumeSessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LumeSession.t;
}

class LumeSessionIncludeList extends _i1.IncludeList {
  LumeSessionIncludeList._({
    _i1.WhereExpressionBuilder<LumeSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LumeSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LumeSession.t;
}

class LumeSessionRepository {
  const LumeSessionRepository._();

  /// Returns a list of [LumeSession]s matching the given query parameters.
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
  Future<List<LumeSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LumeSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LumeSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LumeSessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LumeSession>(
      where: where?.call(LumeSession.t),
      orderBy: orderBy?.call(LumeSession.t),
      orderByList: orderByList?.call(LumeSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [LumeSession] matching the given query parameters.
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
  Future<LumeSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LumeSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<LumeSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LumeSessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<LumeSession>(
      where: where?.call(LumeSession.t),
      orderBy: orderBy?.call(LumeSession.t),
      orderByList: orderByList?.call(LumeSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [LumeSession] by its [id] or null if no such row exists.
  Future<LumeSession?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<LumeSession>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [LumeSession]s in the list and returns the inserted rows.
  ///
  /// The returned [LumeSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LumeSession>> insert(
    _i1.Session session,
    List<LumeSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LumeSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LumeSession] and returns the inserted row.
  ///
  /// The returned [LumeSession] will have its `id` field set.
  Future<LumeSession> insertRow(
    _i1.Session session,
    LumeSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LumeSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LumeSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LumeSession>> update(
    _i1.Session session,
    List<LumeSession> rows, {
    _i1.ColumnSelections<LumeSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LumeSession>(
      rows,
      columns: columns?.call(LumeSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LumeSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LumeSession> updateRow(
    _i1.Session session,
    LumeSession row, {
    _i1.ColumnSelections<LumeSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LumeSession>(
      row,
      columns: columns?.call(LumeSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LumeSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LumeSession?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LumeSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LumeSession>(
      id,
      columnValues: columnValues(LumeSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LumeSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LumeSession>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LumeSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LumeSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LumeSessionTable>? orderBy,
    _i1.OrderByListBuilder<LumeSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LumeSession>(
      columnValues: columnValues(LumeSession.t.updateTable),
      where: where(LumeSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LumeSession.t),
      orderByList: orderByList?.call(LumeSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LumeSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LumeSession>> delete(
    _i1.Session session,
    List<LumeSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LumeSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LumeSession].
  Future<LumeSession> deleteRow(
    _i1.Session session,
    LumeSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LumeSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LumeSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LumeSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LumeSession>(
      where: where(LumeSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LumeSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LumeSession>(
      where: where?.call(LumeSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
