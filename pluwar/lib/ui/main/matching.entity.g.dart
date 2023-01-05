// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerEntry _$PlayerEntryFromJson(Map<String, dynamic> json) => PlayerEntry(
      json['account'] as String,
      json['isReady'] as bool,
    );

Map<String, dynamic> _$PlayerEntryToJson(PlayerEntry instance) =>
    <String, dynamic>{
      'account': instance.account,
      'isReady': instance.isReady,
    };

QueryRoomPayload _$QueryRoomPayloadFromJson(Map<String, dynamic> json) =>
    QueryRoomPayload(
      json['roomId'] as String,
      $enumDecode(_$RoomStatusEnumMap, json['status']),
      (json['players'] as List<dynamic>)
          .map((e) => PlayerEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryRoomPayloadToJson(QueryRoomPayload instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'status': _$RoomStatusEnumMap[instance.status]!,
      'players': instance.players,
    };

const _$RoomStatusEnumMap = {
  RoomStatus.waiting: 'waiting',
  RoomStatus.battle: 'battle',
  RoomStatus.end: 'end',
};
