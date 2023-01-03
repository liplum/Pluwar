import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BattleMenu extends StatelessWidget {
  const BattleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 3, child: SlotBar()),
            Expanded(flex: 1, child: MenuBar()),
          ],
        ),
      ],
    );
  }
}

class SlotBar extends StatelessWidget {
  const SlotBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.blueGrey),
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
      child: Container(
        width: 200,
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(color: Colors.indigo),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(buttomName: "战斗"),
                MenuButton(buttomName: "道具"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(buttomName: "精灵"),
                MenuButton(buttomName: "投降"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String buttomName;

  const MenuButton({super.key, required this.buttomName});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 75,
      height: 75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(10),
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            child: Text(
              " $buttomName ",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
