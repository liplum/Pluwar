// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPayload _$RegisterPayloadFromJson(Map<String, dynamic> json) =>
    RegisterPayload(
      $enumDecode(_$RegisterStateEnumMap, json['state']),
    );

const _$RegisterStateEnumMap = {
  RegisterState.passwordTooWeek: 'passwordTooWeek',
  RegisterState.done: 'done',
  RegisterState.accountOccupied: 'accountOccupied',
};
