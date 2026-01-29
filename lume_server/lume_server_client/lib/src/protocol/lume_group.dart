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

abstract class LumeGroup implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String encryptedAiConfig;

  String? knowledgeBase;

  String adminHash;

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
