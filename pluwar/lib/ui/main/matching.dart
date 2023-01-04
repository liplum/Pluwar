import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class MatchingView extends StatefulWidget {
  const MatchingView({super.key});

  @override
  State<MatchingView> createState() => _MatchingViewState();
}

class _MatchingViewState extends State<MatchingView> {
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
      onPressed: () {},
      child: Text(
        "Match",
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
