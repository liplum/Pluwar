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
      floatingActionButton: buildFAB(),
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverAppBar(
            actions: [
              buildLeaveRoom(),
            ],
            title: room.roomId.text(),
          ),
          buildPlayerEntryArea(),
        ],
      ),
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

  Widget buildFAB() {
    if (isSelfReady) {
      return FloatingActionButton.extended(
        onPressed: () async {
          await onChangeReadyStatus(ReadyStatus.unready);
        },
        label: "Cancel".text(),
        icon: Icon(Icons.cancel_outlined),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () async {
          await onChangeReadyStatus(ReadyStatus.ready);
        },
        label: "Ready".text(),
        icon: Icon(Icons.check_rounded),
      );
    }
  }

  Widget buildPlayerEntryArea() {
    final items = room.players.map((player) => buildPlayerEntry(player)).toList();
    return SliverList(delegate: SliverChildListDelegate(items));
  }

  Widget buildPlayerEntry(PlayerEntry entry) {
    return ListTile(
      title: entry.account.text(style: context.textTheme.titleLarge),
      trailing:
          entry.isReady ? const Icon(Icons.check_rounded, color: Colors.green) : const Icon(Icons.circle_outlined),
    );
  }

  Future<void> onLeaveRoom() async {
    Connection.sendMessage("leaveRoom", {
      "roomId": room.roomId,
    });
  }

  Future<void> onChangeReadyStatus(ReadyStatus status) async {
    Connection.sendMessage("changeRoomPlayerStatus", {
      "roomId": room.roomId,
      "status": status.name,
    });
  }
}
