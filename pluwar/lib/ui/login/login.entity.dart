import 'package:json_annotation/json_annotation.dart';

part 'login.entity.g.dart';

@JsonEnum()
enum LoginStatus {
  incorrectCredential,
  ok;
}

@JsonSerializable()
class LoginPayload {
  final LoginStatus status;
  final String? token;
  final DateTime? expired;

  const LoginPayload(this.status, this.token, this.expired);

  factory LoginPayload.fromJson(Map<String, dynamic> json) => _$LoginPayloadFromJson(json);
}
