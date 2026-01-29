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
import 'dart:typed_data' as _i2;

abstract class FrameEvent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FrameEvent._({
    required this.sessionId,
    required this.data,
    required this.timestamp,
    this.width,
    this.height,
  });

  factory FrameEvent({
    required String sessionId,
    required _i2.ByteData data,
    required DateTime timestamp,
    int? width,
    int? height,
  }) = _FrameEventImpl;

  factory FrameEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return FrameEvent(
      sessionId: jsonSerialization['sessionId'] as String,
      data: _i1.ByteDataJsonExtension.fromJson(jsonSerialization['data']),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      width: jsonSerialization['width'] as int?,
      height: jsonSerialization['height'] as int?,
    );
  }

  /// Session identifier
  String sessionId;

  /// Compressed image data (JPEG/WebP)
  _i2.ByteData data;

  /// Frame numbering or timestamp
  DateTime timestamp;

  /// Optional: Dimensions (if needed for scaling)
  int? width;

  int? height;

  /// Returns a shallow copy of this [FrameEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FrameEvent copyWith({
    String? sessionId,
    _i2.ByteData? data,
    DateTime? timestamp,
    int? width,
    int? height,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FrameEvent',
      'sessionId': sessionId,
      'data': data.toJson(),
      'timestamp': timestamp.toJson(),
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FrameEvent',
      'sessionId': sessionId,
      'data': data.toJson(),
      'timestamp': timestamp.toJson(),
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FrameEventImpl extends FrameEvent {
  _FrameEventImpl({
    required String sessionId,
    required _i2.ByteData data,
    required DateTime timestamp,
    int? width,
    int? height,
  }) : super._(
         sessionId: sessionId,
         data: data,
         timestamp: timestamp,
         width: width,
         height: height,
       );

  /// Returns a shallow copy of this [FrameEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FrameEvent copyWith({
    String? sessionId,
    _i2.ByteData? data,
    DateTime? timestamp,
    Object? width = _Undefined,
    Object? height = _Undefined,
  }) {
    return FrameEvent(
      sessionId: sessionId ?? this.sessionId,
      data: data ?? this.data.clone(),
      timestamp: timestamp ?? this.timestamp,
      width: width is int? ? width : this.width,
      height: height is int? ? height : this.height,
    );
  }
}
