import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: buildMain(),
    );
  }

  Widget buildMain() {
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
          Flexible(flex: 1, child: MenuTitle()),
          Flexible(
            flex: 2,
            child: Center(
              child: MatchingButton(),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Bag(),
                Row(
                  children: [
                    Text("AAA"),
                    Option(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MenuTitle extends StatelessWidget {
  const MenuTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Pluwar",
      style: TextStyle(color: Colors.grey, fontSize: 115),
    );
  }
}

class MatchingButton extends StatelessWidget {
  const MatchingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 280, maxHeight: 80),
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
  const PlayerSetting({super.key});

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
  const Bag({super.key});

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
  const Option({super.key});

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
