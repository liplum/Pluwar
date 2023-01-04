import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pluwar/convert.dart';
import 'package:pluwar/r.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:event_bus/event_bus.dart';

part 'connection.g.dart';

// ignore: non_constant_identifier_names
final Connection = ConnectionImpl();
// ignore: non_constant_identifier_names
final DIO = Dio();

class Auth {
  final String token;
  final DateTime expired;

  const Auth(this.token, this.expired);
}

@JsonEnum()
enum ChannelStatus {
  ok,
  failed;
}

@JsonSerializable(createToJson: false)
class ChannelMessageFromServer {
  @JsonKey()
  final String channel;
  @JsonKey()
  final ChannelStatus status;
  @JsonKey()
  final dynamic data;

  const ChannelMessageFromServer(this.channel, this.status, this.data);

  factory ChannelMessageFromServer.fromJson(Map<String, dynamic> json) => _$ChannelMessageFromServerFromJson(json);
}

@JsonSerializable(createFactory: false)
class ChannelMessageToServer {
  @JsonKey()
  final String channel;
  @JsonKey()
  final String token;
  @JsonKey()
  final dynamic data;

  const ChannelMessageToServer(this.channel, this.token, this.data);

  Map<String, dynamic> toJson() => _$ChannelMessageToServerToJson(this);
}

class ChannelMessageFromServerEvent {
  final String channel;
  final ChannelMessageFromServer msg;

  const ChannelMessageFromServerEvent(this.channel, this.msg);
}

class ConnectionImpl {
  final eventBus = EventBus();
  Auth? auth;
  WebSocketChannel? websocket;

  void connectToGameServer() {
    final connection = WebSocketChannel.connect(
      Uri.parse(R.serverGameWebsocketUri),
    );
    websocket = connection;
    connection.stream.listen((data) {
      if (data is String) {
        final payload = data.fromJson(ChannelMessageFromServer.fromJson);
        if (payload != null) {
          final channel = payload.channel;
          eventBus.fire(ChannelMessageFromServerEvent(channel, payload));
        }
      }
    });
  }

  void listenToChannel(String channel, void Function(ChannelMessageFromServer msg) onMsg) {
    eventBus.on<ChannelMessageFromServerEvent>().listen((event) {
      if (event.channel == channel) {
        onMsg(event.msg);
      }
    });
  }

  void sendMessage(String channel, Map<String, dynamic> payload) {
    final connection = websocket;
    if (connection != null) {
      final msg = ChannelMessageToServer(channel, auth!.token, payload);
      final msgPayload = msg.toJson();
      final msgPayloadJson = jsonEncode(msgPayload);
      connection.sink.add(msgPayloadJson);
    }
  }
}
