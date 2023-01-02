import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlayerSetting(),
            Bag(),
          ],
        )
      ],
    );
  }
}

class MenuTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Pluwar",
      style: TextStyle(color: Colors.grey, fontSize: 115),
    );
  }
}

class MatchingBatton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 280),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.brown),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
        child: Text(
          "找人打",
          style: TextStyle(color: Colors.blue, fontSize: 40),
        ),
      ),
    );
  }
}

class PlayerSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.topLeft,
      child: CircleAvatar(
        //backgroundImage: (),
        backgroundColor: Colors.blue,
        radius: 50.0,
      ),
    );
  }
}

class Bag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100, maxHeight: 100),
      child: Container(
        color: Colors.brown,
      ),
    );
  }
}

class Option extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 50, maxHeight: 50),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey),
        child: Text(
          "设",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        padding: EdgeInsets.all(5),
      ),
    );
  }
}
