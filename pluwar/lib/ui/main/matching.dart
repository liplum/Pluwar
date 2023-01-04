import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/design/dialog.dart';
import 'package:rettulf/rettulf.dart';

class MatchingView extends StatefulWidget {
  const MatchingView({super.key});

  @override
  State<MatchingView> createState() => _MatchingViewState();
}

class _MatchingViewState extends State<MatchingView> {
  @override
  void initState() {
    super.initState();
    Connection.listenToChannel("queryRoom", (msg) async {
      if (!mounted) return;
      await context.showTip(title: "onMsg", desc: msg.data.toString(), ok: "OK");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircleAvatar(),
        ),
        buildBody(),
      ],
    );
  }

  Widget buildBody() {
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
    Connection.sendMessage("joinRoom", {});
  }
}
