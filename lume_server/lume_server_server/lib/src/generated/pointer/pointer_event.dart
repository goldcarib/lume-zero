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

abstract class PointerEvent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PointerEvent._({
    required this.x,
    required this.y,
    this.scrollX,
    this.scrollY,
    required this.sessionId,
    required this.type,
    this.action,
    this.message,
    required this.timestamp,
    this.userId,
  });

  factory PointerEvent({
    required double x,
    required double y,
    double? scrollX,
    double? scrollY,
    required String sessionId,
    required String type,
    String? action,
    String? message,
    required DateTime timestamp,
    String? userId,
  }) = _PointerEventImpl;

  factory PointerEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PointerEvent(
      x: (jsonSerialization['x'] as num).toDouble(),
      y: (jsonSerialization['y'] as num).toDouble(),
      scrollX: (jsonSerialization['scrollX'] as num?)?.toDouble(),
      scrollY: (jsonSerialization['scrollY'] as num?)?.toDouble(),
      sessionId: jsonSerialization['sessionId'] as String,
      type: jsonSerialization['type'] as String,
      action: jsonSerialization['action'] as String?,
      message: jsonSerialization['message'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      userId: jsonSerialization['userId'] as String?,
    );
  }

  /// Normalized X coordinate (0.0 to 1.0)
  double x;

  /// Normalized Y coordinate (0.0 to 1.0)
  double y;

  /// Normalized horizontal scroll offset (0.0 to 1.0)
  double? scrollX;

  /// Normalized vertical scroll offset (0.0 to 1.0)
  double? scrollY;

  /// Session/Room identifier
  String sessionId;

  /// Event type: 'move', 'click', 'ping', 'action'
  String type;

  /// Action type for 'action' events: 'look_here', 'check_box', 'scroll'
  String? action;

  /// Optional message or data for the action
  String? message;

  /// Timestamp for event ordering
  DateTime timestamp;

  /// User identifier
  String? userId;

  /// Returns a shallow copy of this [PointerEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PointerEvent copyWith({
    double? x,
    double? y,
    double? scrollX,
    double? scrollY,
    String? sessionId,
    String? type,
    String? action,
    String? message,
    DateTime? timestamp,
    String? userId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PointerEvent',
      'x': x,
      'y': y,
      if (scrollX != null) 'scrollX': scrollX,
      if (scrollY != null) 'scrollY': scrollY,
      'sessionId': sessionId,
      'type': type,
      if (action != null) 'action': action,
      if (message != null) 'message': message,
      'timestamp': timestamp.toJson(),
      if (userId != null) 'userId': userId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PointerEvent',
      'x': x,
      'y': y,
      if (scrollX != null) 'scrollX': scrollX,
      if (scrollY != null) 'scrollY': scrollY,
      'sessionId': sessionId,
      'type': type,
      if (action != null) 'action': action,
      if (message != null) 'message': message,
      'timestamp': timestamp.toJson(),
      if (userId != null) 'userId': userId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PointerEventImpl extends PointerEvent {
  _PointerEventImpl({
    required double x,
    required double y,
    double? scrollX,
    double? scrollY,
    required String sessionId,
    required String type,
    String? action,
    String? message,
    required DateTime timestamp,
    String? userId,
  }) : super._(
         x: x,
         y: y,
         scrollX: scrollX,
         scrollY: scrollY,
         sessionId: sessionId,
         type: type,
         action: action,
         message: message,
         timestamp: timestamp,
         userId: userId,
       );

  /// Returns a shallow copy of this [PointerEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PointerEvent copyWith({
    double? x,
    double? y,
    Object? scrollX = _Undefined,
    Object? scrollY = _Undefined,
    String? sessionId,
    String? type,
    Object? action = _Undefined,
    Object? message = _Undefined,
    DateTime? timestamp,
    Object? userId = _Undefined,
  }) {
    return PointerEvent(
      x: x ?? this.x,
      y: y ?? this.y,
      scrollX: scrollX is double? ? scrollX : this.scrollX,
      scrollY: scrollY is double? ? scrollY : this.scrollY,
      sessionId: sessionId ?? this.sessionId,
      type: type ?? this.type,
      action: action is String? ? action : this.action,
      message: message is String? ? message : this.message,
      timestamp: timestamp ?? this.timestamp,
      userId: userId is String? ? userId : this.userId,
    );
  }
}
