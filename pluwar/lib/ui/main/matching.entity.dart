import 'package:json_annotation/json_annotation.dart';
import 'package:pluwar/entity/player.dart';

part 'matching.entity.g.dart';

@JsonSerializable()
class PlayerEntry {
  @JsonKey()
  final String account;
  @JsonKey()
  final bool isReady;

  const PlayerEntry(this.account, this.isReady);

  factory PlayerEntry.fromJson(Map<String, dynamic> json) => _$PlayerEntryFromJson(json);
}

@JsonEnum()
enum RoomStatus {
  waiting,
  battle,
  end;
}

@JsonSerializable()
class QueryRoomPayload {
  @JsonKey()
  final String roomId;
  @JsonKey()
  final RoomStatus status;
  @JsonKey()
  final List<PlayerEntry> players;

  const QueryRoomPayload(this.roomId, this.status, this.players);

  factory QueryRoomPayload.fromJson(Map<String, dynamic> json) => _$QueryRoomPayloadFromJson(json);
}
