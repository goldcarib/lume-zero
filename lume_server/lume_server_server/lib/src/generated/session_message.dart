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
import 'pointer/pointer_event.dart' as _i2;
import 'frame_event.dart' as _i3;
import 'package:lume_server_server/src/generated/protocol.dart' as _i4;

abstract class SessionMessage
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SessionMessage._({
    required this.sessionId,
    this.pointer,
    this.frame,
    required this.timestamp,
    this.signalingType,
    this.sdp,
    this.candidate,
    this.sdpMid,
    this.sdpMlineIndex,
    this.passcode,
  });

  factory SessionMessage({
    required String sessionId,
    _i2.PointerEvent? pointer,
    _i3.FrameEvent? frame,
    required DateTime timestamp,
    String? signalingType,
    String? sdp,
    String? candidate,
    String? sdpMid,
    int? sdpMlineIndex,
    String? passcode,
  }) = _SessionMessageImpl;

  factory SessionMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionMessage(
      sessionId: jsonSerialization['sessionId'] as String,
      pointer: jsonSerialization['pointer'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.PointerEvent>(
              jsonSerialization['pointer'],
            ),
      frame: jsonSerialization['frame'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.FrameEvent>(
              jsonSerialization['frame'],
            ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      signalingType: jsonSerialization['signalingType'] as String?,
      sdp: jsonSerialization['sdp'] as String?,
      candidate: jsonSerialization['candidate'] as String?,
      sdpMid: jsonSerialization['sdpMid'] as String?,
      sdpMlineIndex: jsonSerialization['sdpMlineIndex'] as int?,
      passcode: jsonSerialization['passcode'] as String?,
    );
  }

  /// The session/room ID
  String sessionId;

  /// Pointer event data
  _i2.PointerEvent? pointer;

  /// Frame data (Deprecated: shifting to WebRTC)
  _i3.FrameEvent? frame;

  /// Server timestamp
  DateTime timestamp;

  /// Signaling: Type (offer, answer, candidate, bye)
  String? signalingType;

  /// Signaling: Session Description Protocol (SDP)
  String? sdp;

  /// Signaling: ICE Candidate
  String? candidate;

  /// Signaling: ICE Candidate ID
  String? sdpMid;

  /// Signaling: ICE Candidate Index
  int? sdpMlineIndex;

  /// Optional session passcode for security
  String? passcode;

  /// Returns a shallow copy of this [SessionMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionMessage copyWith({
    String? sessionId,
    _i2.PointerEvent? pointer,
    _i3.FrameEvent? frame,
    DateTime? timestamp,
    String? signalingType,
    String? sdp,
    String? candidate,
    String? sdpMid,
    int? sdpMlineIndex,
    String? passcode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionMessage',
      'sessionId': sessionId,
      if (pointer != null) 'pointer': pointer?.toJson(),
      if (frame != null) 'frame': frame?.toJson(),
      'timestamp': timestamp.toJson(),
      if (signalingType != null) 'signalingType': signalingType,
      if (sdp != null) 'sdp': sdp,
      if (candidate != null) 'candidate': candidate,
      if (sdpMid != null) 'sdpMid': sdpMid,
      if (sdpMlineIndex != null) 'sdpMlineIndex': sdpMlineIndex,
      if (passcode != null) 'passcode': passcode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionMessage',
      'sessionId': sessionId,
      if (pointer != null) 'pointer': pointer?.toJsonForProtocol(),
      if (frame != null) 'frame': frame?.toJsonForProtocol(),
      'timestamp': timestamp.toJson(),
      if (signalingType != null) 'signalingType': signalingType,
      if (sdp != null) 'sdp': sdp,
      if (candidate != null) 'candidate': candidate,
      if (sdpMid != null) 'sdpMid': sdpMid,
      if (sdpMlineIndex != null) 'sdpMlineIndex': sdpMlineIndex,
      if (passcode != null) 'passcode': passcode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionMessageImpl extends SessionMessage {
  _SessionMessageImpl({
    required String sessionId,
    _i2.PointerEvent? pointer,
    _i3.FrameEvent? frame,
    required DateTime timestamp,
    String? signalingType,
    String? sdp,
    String? candidate,
    String? sdpMid,
    int? sdpMlineIndex,
    String? passcode,
  }) : super._(
         sessionId: sessionId,
         pointer: pointer,
         frame: frame,
         timestamp: timestamp,
         signalingType: signalingType,
         sdp: sdp,
         candidate: candidate,
         sdpMid: sdpMid,
         sdpMlineIndex: sdpMlineIndex,
         passcode: passcode,
       );

  /// Returns a shallow copy of this [SessionMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionMessage copyWith({
    String? sessionId,
    Object? pointer = _Undefined,
    Object? frame = _Undefined,
    DateTime? timestamp,
    Object? signalingType = _Undefined,
    Object? sdp = _Undefined,
    Object? candidate = _Undefined,
    Object? sdpMid = _Undefined,
    Object? sdpMlineIndex = _Undefined,
    Object? passcode = _Undefined,
  }) {
    return SessionMessage(
      sessionId: sessionId ?? this.sessionId,
      pointer: pointer is _i2.PointerEvent?
          ? pointer
          : this.pointer?.copyWith(),
      frame: frame is _i3.FrameEvent? ? frame : this.frame?.copyWith(),
      timestamp: timestamp ?? this.timestamp,
      signalingType: signalingType is String?
          ? signalingType
          : this.signalingType,
      sdp: sdp is String? ? sdp : this.sdp,
      candidate: candidate is String? ? candidate : this.candidate,
      sdpMid: sdpMid is String? ? sdpMid : this.sdpMid,
      sdpMlineIndex: sdpMlineIndex is int? ? sdpMlineIndex : this.sdpMlineIndex,
      passcode: passcode is String? ? passcode : this.passcode,
    );
  }
}
