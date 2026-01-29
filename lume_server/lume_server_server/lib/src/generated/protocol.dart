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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'frame_event.dart' as _i5;
import 'greetings/greeting.dart' as _i6;
import 'lume_group.dart' as _i7;
import 'lume_session.dart' as _i8;
import 'pointer/pointer_event.dart' as _i9;
import 'session_message.dart' as _i10;
import 'session_status.dart' as _i11;
import 'package:lume_server_server/src/generated/lume_session.dart' as _i12;
export 'frame_event.dart';
export 'greetings/greeting.dart';
export 'lume_group.dart';
export 'lume_session.dart';
export 'pointer/pointer_event.dart';
export 'session_message.dart';
export 'session_status.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'lume_group',
      dartName: 'LumeGroup',
      schema: 'public',
      module: 'lume_server',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'lume_group_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptedAiConfig',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'knowledgeBase',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'adminHash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'lume_group_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'lume_session',
      dartName: 'LumeSession',
      schema: 'public',
      module: 'lume_server',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'lume_session_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'roomId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'groupId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SessionStatus',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'lume_session_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.FrameEvent) {
      return _i5.FrameEvent.fromJson(data) as T;
    }
    if (t == _i6.Greeting) {
      return _i6.Greeting.fromJson(data) as T;
    }
    if (t == _i7.LumeGroup) {
      return _i7.LumeGroup.fromJson(data) as T;
    }
    if (t == _i8.LumeSession) {
      return _i8.LumeSession.fromJson(data) as T;
    }
    if (t == _i9.PointerEvent) {
      return _i9.PointerEvent.fromJson(data) as T;
    }
    if (t == _i10.SessionMessage) {
      return _i10.SessionMessage.fromJson(data) as T;
    }
    if (t == _i11.SessionStatus) {
      return _i11.SessionStatus.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.FrameEvent?>()) {
      return (data != null ? _i5.FrameEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Greeting?>()) {
      return (data != null ? _i6.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.LumeGroup?>()) {
      return (data != null ? _i7.LumeGroup.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.LumeSession?>()) {
      return (data != null ? _i8.LumeSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PointerEvent?>()) {
      return (data != null ? _i9.PointerEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SessionMessage?>()) {
      return (data != null ? _i10.SessionMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.SessionStatus?>()) {
      return (data != null ? _i11.SessionStatus.fromJson(data) : null) as T;
    }
    if (t == List<_i12.LumeSession>) {
      return (data as List)
              .map((e) => deserialize<_i12.LumeSession>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.FrameEvent => 'FrameEvent',
      _i6.Greeting => 'Greeting',
      _i7.LumeGroup => 'LumeGroup',
      _i8.LumeSession => 'LumeSession',
      _i9.PointerEvent => 'PointerEvent',
      _i10.SessionMessage => 'SessionMessage',
      _i11.SessionStatus => 'SessionStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('lume_server.', '');
    }

    switch (data) {
      case _i5.FrameEvent():
        return 'FrameEvent';
      case _i6.Greeting():
        return 'Greeting';
      case _i7.LumeGroup():
        return 'LumeGroup';
      case _i8.LumeSession():
        return 'LumeSession';
      case _i9.PointerEvent():
        return 'PointerEvent';
      case _i10.SessionMessage():
        return 'SessionMessage';
      case _i11.SessionStatus():
        return 'SessionStatus';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'FrameEvent') {
      return deserialize<_i5.FrameEvent>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i6.Greeting>(data['data']);
    }
    if (dataClassName == 'LumeGroup') {
      return deserialize<_i7.LumeGroup>(data['data']);
    }
    if (dataClassName == 'LumeSession') {
      return deserialize<_i8.LumeSession>(data['data']);
    }
    if (dataClassName == 'PointerEvent') {
      return deserialize<_i9.PointerEvent>(data['data']);
    }
    if (dataClassName == 'SessionMessage') {
      return deserialize<_i10.SessionMessage>(data['data']);
    }
    if (dataClassName == 'SessionStatus') {
      return deserialize<_i11.SessionStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i7.LumeGroup:
        return _i7.LumeGroup.t;
      case _i8.LumeSession:
        return _i8.LumeSession.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'lume_server';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
