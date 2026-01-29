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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'frame_event.dart' as _i2;
import 'greetings/greeting.dart' as _i3;
import 'lume_group.dart' as _i4;
import 'lume_session.dart' as _i5;
import 'pointer/pointer_event.dart' as _i6;
import 'session_message.dart' as _i7;
import 'session_status.dart' as _i8;
import 'package:lume_server_client/src/protocol/lume_session.dart' as _i9;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i10;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i11;
export 'frame_event.dart';
export 'greetings/greeting.dart';
export 'lume_group.dart';
export 'lume_session.dart';
export 'pointer/pointer_event.dart';
export 'session_message.dart';
export 'session_status.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.FrameEvent) {
      return _i2.FrameEvent.fromJson(data) as T;
    }
    if (t == _i3.Greeting) {
      return _i3.Greeting.fromJson(data) as T;
    }
    if (t == _i4.LumeGroup) {
      return _i4.LumeGroup.fromJson(data) as T;
    }
    if (t == _i5.LumeSession) {
      return _i5.LumeSession.fromJson(data) as T;
    }
    if (t == _i6.PointerEvent) {
      return _i6.PointerEvent.fromJson(data) as T;
    }
    if (t == _i7.SessionMessage) {
      return _i7.SessionMessage.fromJson(data) as T;
    }
    if (t == _i8.SessionStatus) {
      return _i8.SessionStatus.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.FrameEvent?>()) {
      return (data != null ? _i2.FrameEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Greeting?>()) {
      return (data != null ? _i3.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.LumeGroup?>()) {
      return (data != null ? _i4.LumeGroup.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.LumeSession?>()) {
      return (data != null ? _i5.LumeSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.PointerEvent?>()) {
      return (data != null ? _i6.PointerEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.SessionMessage?>()) {
      return (data != null ? _i7.SessionMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.SessionStatus?>()) {
      return (data != null ? _i8.SessionStatus.fromJson(data) : null) as T;
    }
    if (t == List<_i9.LumeSession>) {
      return (data as List).map((e) => deserialize<_i9.LumeSession>(e)).toList()
          as T;
    }
    try {
      return _i10.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i11.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.FrameEvent => 'FrameEvent',
      _i3.Greeting => 'Greeting',
      _i4.LumeGroup => 'LumeGroup',
      _i5.LumeSession => 'LumeSession',
      _i6.PointerEvent => 'PointerEvent',
      _i7.SessionMessage => 'SessionMessage',
      _i8.SessionStatus => 'SessionStatus',
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
      case _i2.FrameEvent():
        return 'FrameEvent';
      case _i3.Greeting():
        return 'Greeting';
      case _i4.LumeGroup():
        return 'LumeGroup';
      case _i5.LumeSession():
        return 'LumeSession';
      case _i6.PointerEvent():
        return 'PointerEvent';
      case _i7.SessionMessage():
        return 'SessionMessage';
      case _i8.SessionStatus():
        return 'SessionStatus';
    }
    className = _i10.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i11.Protocol().getClassNameForObject(data);
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
      return deserialize<_i2.FrameEvent>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i3.Greeting>(data['data']);
    }
    if (dataClassName == 'LumeGroup') {
      return deserialize<_i4.LumeGroup>(data['data']);
    }
    if (dataClassName == 'LumeSession') {
      return deserialize<_i5.LumeSession>(data['data']);
    }
    if (dataClassName == 'PointerEvent') {
      return deserialize<_i6.PointerEvent>(data['data']);
    }
    if (dataClassName == 'SessionMessage') {
      return deserialize<_i7.SessionMessage>(data['data']);
    }
    if (dataClassName == 'SessionStatus') {
      return deserialize<_i8.SessionStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i10.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i11.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

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
      return _i10.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i11.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
