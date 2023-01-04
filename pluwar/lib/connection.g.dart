// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMessageFromServer _$ChannelMessageFromServerFromJson(
        Map<String, dynamic> json) =>
    ChannelMessageFromServer(
      json['channel'] as String,
      $enumDecode(_$ChannelStatusEnumMap, json['status']),
      json['data'],
    );

const _$ChannelStatusEnumMap = {
  ChannelStatus.ok: 'ok',
  ChannelStatus.failed: 'failed',
};

Map<String, dynamic> _$ChannelMessageToServerToJson(
        ChannelMessageToServer instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'token': instance.token,
      'data': instance.data,
    };
