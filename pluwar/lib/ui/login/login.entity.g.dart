// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPayload _$LoginPayloadFromJson(Map<String, dynamic> json) => LoginPayload(
      $enumDecode(_$LoginStateEnumMap, json['state']),
    );

Map<String, dynamic> _$LoginPayloadToJson(LoginPayload instance) =>
    <String, dynamic>{
      'state': _$LoginStateEnumMap[instance.state]!,
    };

const _$LoginStateEnumMap = {
  LoginState.incorrectCredential: 'incorrectCredential',
  LoginState.ok: 'ok',
};
