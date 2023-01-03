// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPayload _$RegisterPayloadFromJson(Map<String, dynamic> json) =>
    RegisterPayload(
      $enumDecode(_$RegisterStatusEnumMap, json['status']),
    );

const _$RegisterStatusEnumMap = {
  RegisterStatus.passwordTooWeek: 'passwordTooWeek',
  RegisterStatus.done: 'done',
  RegisterStatus.accountOccupied: 'accountOccupied',
};
