import 'package:flutter/widgets.dart';
import 'package:pluwar/app.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/r.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  Connection.websocket = WebSocketChannel.connect(
    Uri.parse(R.serverWebsocketUri),
  );
  runApp(const PluwarApp());
}
