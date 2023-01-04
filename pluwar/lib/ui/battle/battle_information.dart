import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class Information extends StatelessWidget {
  final int currentRounds;
  final String actionStatus;

  const Information(
      {super.key, required this.currentRounds, required this.actionStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("现在是 $currentRounds 回合"),
          Text("$actionStatus... "),
        ],
      ),
    );
  }
}
