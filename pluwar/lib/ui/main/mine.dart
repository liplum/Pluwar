import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
  @override
  Widget build(BuildContext context) {
    return "Mine".text(style: TextStyle(fontSize: 40));
  }
}
