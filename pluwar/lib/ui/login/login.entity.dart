import 'package:json_annotation/json_annotation.dart';

part 'login.entity.g.dart';

@JsonEnum()
enum LoginState {
  incorrectCredential,
  ok;
}

@JsonSerializable()
class LoginPayload {
  final LoginState state;

  const LoginPayload(this.state);

  factory LoginPayload.fromJson(Map<String, dynamic> json) => _$LoginPayloadFromJson(json);
}
