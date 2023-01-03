import 'package:json_annotation/json_annotation.dart';

part 'register.entity.g.dart';

@JsonEnum()
enum RegisterState {
  passwordTooWeek,
  done,
  accountOccupied;
}

@JsonSerializable(createToJson: false)
class RegisterPayload {
  @JsonKey()
  final RegisterState state;

  const RegisterPayload(this.state);

  factory RegisterPayload.fromJson(Map<String, dynamic> json) => _$RegisterPayloadFromJson(json);
}
