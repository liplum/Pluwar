import 'package:json_annotation/json_annotation.dart';

part 'register.entity.g.dart';

@JsonEnum()
enum RegisterStatus {
  passwordTooWeek,
  done,
  accountOccupied;
}

@JsonSerializable(createToJson: false)
class RegisterPayload {
  @JsonKey()
  final RegisterStatus status;

  const RegisterPayload(this.status);

  factory RegisterPayload.fromJson(Map<String, dynamic> json) => _$RegisterPayloadFromJson(json);
}
