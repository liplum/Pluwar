import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  @JsonKey()
  final String account;

  const Player(this.account);

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
