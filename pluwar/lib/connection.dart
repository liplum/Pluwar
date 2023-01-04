import 'package:dio/dio.dart';
import 'package:pluwar/r.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ignore: non_constant_identifier_names
final Connection = ConnectionImpl();
// ignore: non_constant_identifier_names
final DIO = Dio();

class ConnectionImpl {
  String? token;
  WebSocketChannel? websocket;

  void connectToGameServer() {
    websocket = WebSocketChannel.connect(
      Uri.parse(R.serverGameWebsocketUri),
    );
  }
}
