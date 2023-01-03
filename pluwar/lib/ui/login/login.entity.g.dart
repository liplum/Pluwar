// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPayload _$LoginPayloadFromJson(Map<String, dynamic> json) => LoginPayload(
      $enumDecode(_$LoginStatusEnumMap, json['status']),
      json['token'] as String?,
      json['expired'] == null
          ? null
          : DateTime.parse(json['expired'] as String),
    );

Map<String, dynamic> _$LoginPayloadToJson(LoginPayload instance) =>
    <String, dynamic>{
      'status': _$LoginStatusEnumMap[instance.status]!,
      'token': instance.token,
      'expired': instance.expired?.toIso8601String(),
    };

const _$LoginStatusEnumMap = {
  LoginStatus.incorrectCredential: 'incorrectCredential',
  LoginStatus.ok: 'ok',
};
