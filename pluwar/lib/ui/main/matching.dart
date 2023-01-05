import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/ui/main/matching.entity.dart';
import 'package:rettulf/rettulf.dart';

class MatchingView extends StatefulWidget {
  const MatchingView({super.key});

  @override
  State<MatchingView> createState() => _MatchingViewState();
}

class _MatchingViewState extends State<MatchingView> {
  QueryRoomPayload? _room;

  @override
  void initState() {
    super.initState();
    Connection.listenToChannel("queryRoom", (msg) async {
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
          matchingBtn().center().flexible(flex: 2),
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

  Future<void> onMatch() async {
    Connection.sendMessage("joinRoom");
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
