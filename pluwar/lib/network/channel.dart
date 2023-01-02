abstract class Channel {
  String get name;

  Future<void> onMessage(Map<String, dynamic> json);
}

class ChannelDispatcher {
  final Map<String, Channel> name2Channel = {};

  ChannelDispatcher();

  Future<void> onMessage(Map<String, dynamic> json) async {
    final channelName = json["channelName"];
    final channel = name2Channel[channelName];
    if (channel != null) {
      await channel.onMessage(json["data"]);
    }
  }
}
