import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/design/multiplatform.dart';
import 'package:pluwar/ui/main/matching.entity.dart';
import 'package:rettulf/rettulf.dart';

class MatchingView extends StatefulWidget {
  const MatchingView({super.key});

  @override
  State<MatchingView> createState() => _MatchingViewState();
}

class _MatchingViewState extends State<MatchingView> {
  QueryRoomPayload? _room;
  final $roomNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    Connection.listenToChannel("checkMyRoom", (msg) {
      final payload = CheckMyRoomPayload.fromJson(msg.data);
      final roomId = payload.roomId;
      if (roomId != null) {
        Connection.sendMessage("queryRoom", {
          "roomId": roomId,
        });
      }
    });
    Connection.listenToChannels(["joinRoom", "queryRoom", "changeRoomPlayerStatus"], (msg) async {
      if (!mounted) return;
      final payload = QueryRoomPayload.fromJson(msg.data);
      setState(() {
        _room = payload;
      });
    });

    Connection.listenToChannel("leaveRoom", (msg) {
      if (!mounted) return;
      setState(() {
        _room = null;
      });
    });
    Connection.sendMessage("checkMyRoom");
  }

  @override
  Widget build(BuildContext context) {
    final room = _room;
    if (room == null) {
      return buildMatchingBody();
    } else {
      return RoomView(room: room);
    }
  }

  Widget buildMatchingBody() {
    return Center(
      child: Column(
        children: [
          menuTitle().center().flexible(flex: 1),
          [
            matchingBtn(),
            //createRoomBtn(),
            joinRoomBtn(),
          ].column(maa: MainAxisAlignment.spaceEvenly).center().flexible(flex: 2),
        ],
      ),
    );
  }

  Widget menuTitle() {
    return Text(
      "Pluwar",
      style: TextStyle(color: Colors.grey, fontSize: 115),
    );
  }

  Widget matchingBtn() {
    return ElevatedButton(
      onPressed: () async {
        await onMatch();
      },
      child: Text(
        "Match",
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget createRoomBtn() {
    return ElevatedButton(
      onPressed: () async {},
      child: Text(
        "Create",
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget joinRoomBtn() {
    return ElevatedButton(
      onPressed: () async {
        await onJoinRoom();
      },
      child: Text(
        "Join",
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Future<void> onMatch() async {
    Connection.sendMessage("joinRoom");
  }

  Future<void> onJoinRoom() async {
    final confirm = await context.show$Dialog$(make: (ctx) {
      return $Dialog$(
        title: "Join Room",
        make: (_) {
          return $TextField$(
            controller: $roomNumber,
            labelText: "Room Number",
          );
        },
        primary: $Action$(
          text: "Join",
          onPressed: () {
            ctx.navigator.pop(true);
          },
        ),
        secondary: $Action$(
          text: "Not Now",
          onPressed: () {
            ctx.navigator.pop(false);
          },
        ),
      );
    });
    if (confirm == true) {
      Connection.sendMessage("joinRoom", {
        "roomId": $roomNumber.text,
      });
    }
  }
}

enum ReadyStatus {
  ready,
  unready;
}

class RoomView extends StatefulWidget {
  final QueryRoomPayload room;

  const RoomView({super.key, required this.room});

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  QueryRoomPayload get room => widget.room;

  bool get isSelfReady {
    for (final entry in room.players) {
      if (entry.account == Connection.auth?.account) {
        return entry.isReady;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.videogame_asset_outlined),
        actions: [
          buildLeaveRoom(),
        ],
        title: room.roomId.text(),
      ),
      body: [
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          child: buildPlayerEntryArea(),
        ),
        const RoomChatArea().padAll(10).expanded(),
      ].column(),
    );
  }

  Widget buildLeaveRoom() {
    return CupertinoButton(
      onPressed: () async {
        await onLeaveRoom();
      },
      child: "Leave".text(),
    );
  }

  Widget buildReadyBtn() {
    if (isSelfReady) {
      return CupertinoButton(
        onPressed: () async {
          await onChangeReadyStatus(ReadyStatus.unready);
        },
        child: "Cancel".text(),
      );
    } else {
      return CupertinoButton(
        onPressed: () async {
          await onChangeReadyStatus(ReadyStatus.ready);
        },
        child: "Ready".text(),
      );
    }
  }

  Widget buildPlayerEntryArea() {
    final items = room.players.map((player) => buildPlayerEntry(player)).toList();
    return items.column();
  }

  Widget buildPlayerEntry(PlayerEntry entry) {
    final Widget? trailing;
    if (entry.account == Connection.auth?.account) {
      trailing = buildReadyBtn();
    } else {
      trailing = null;
    }
    final leading = AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: entry.isReady ? const Icon(Icons.check_rounded, color: Colors.green) : const Icon(Icons.pending_outlined),
    );
    return ListTile(
      title: entry.account.text(style: context.textTheme.titleLarge),
      leading: leading,
      trailing: trailing,
    );
  }

  Future<void> onLeaveRoom() async {
    Connection.sendMessage("leaveRoom", {});
  }

  Future<void> onChangeReadyStatus(ReadyStatus status) async {
    Connection.sendMessage("changeRoomPlayerStatus", {
      "status": status.name,
    });
  }
}

class RoomChatArea extends StatefulWidget {
  const RoomChatArea({super.key});

  @override
  State<RoomChatArea> createState() => _RoomChatAreaState();
}

class _RoomChatAreaState extends State<RoomChatArea> {
  List<RoomChatEntry> chats = [];
  final $chat = TextEditingController();
  final chatScrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    Connection.listenToChannel("chatInRoom", (msg) {
      final chat = RoomChatEntry.fromJson(msg.data);
      if (!mounted) return;
      setState(() {
        chats.add(chat);
      });
      scrollToEnd();
    });
    Connection.listenToChannel("checkChatInRoom", (msg) {
      final payload = RoomChatsPayload.fromJson(msg.data);
      if (!mounted) return;
      setState(() {
        chats = payload.chats;
      });
      scrollToEnd();
    });
    Connection.sendMessage("checkChatInRoom");
  }

  void scrollToEnd() {
    chatScrollCtrl
        .animateTo(
      chatScrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
    )
        .then((value) {
      chatScrollCtrl.animateTo(
        chatScrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      ListView.separated(
        controller: chatScrollCtrl,
        itemCount: chats.length,
        itemBuilder: (ctx, i) {
          return buildEntry(chats[i]);
        },
        separatorBuilder: (_, i) => Divider(thickness: 0),
      ).expanded(),
      buildTextArea(),
    ].column();
  }

  Widget buildTextArea() {
    return [
      TextFormField(
        controller: $chat,
      ).flexible(flex: 3),
      $chat <<
          (_, v, ___) => CupertinoButton(
                onPressed: !canSendSuchText(v.text)
                    ? null
                    : () async {
                        await onSendChat();
                      },
                child: "Send".text(),
              ).inCard(elevation: 3).flexible(flex: 1),
    ].row(maa: MainAxisAlignment.spaceBetween).padFromLTRB(8, 2, 4, 2).inCard(elevation: 2);
  }

  bool canSendSuchText(String text) {
    return text.trim().isNotEmpty;
  }

  Widget buildEntry(RoomChatEntry entry) {
    if (entry.sender == Connection.auth?.account) {
      return [
        [
          entry.ts.toLocal().toString().text(style: context.textTheme.bodySmall),
          entry.sender.text(style: context.textTheme.bodySmall),
        ].row(maa: MainAxisAlignment.spaceBetween, caa: CrossAxisAlignment.end),
        entry.content.text(),
      ].column(caa: CrossAxisAlignment.end);
    } else {
      return [
        [
          entry.sender.text(style: context.textTheme.bodySmall),
          entry.ts.toLocal().toString().text(style: context.textTheme.bodySmall),
        ].row(maa: MainAxisAlignment.spaceBetween),
        entry.content.text(),
      ].column(caa: CrossAxisAlignment.start);
    }
  }

  Future<void> onSendChat() async {
    final text = $chat.text;
    $chat.clear();
    Connection.sendMessage("chatInRoom", {
      "content": text,
    });
  }

  @override
  void dispose() {
    chatScrollCtrl.dispose();
    $chat.dispose();
    super.dispose();
  }
}
