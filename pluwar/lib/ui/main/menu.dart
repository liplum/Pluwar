import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMain().safeArea(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Main",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.backpack_outlined),
            activeIcon: Icon(Icons.backpack),
            label: "Backpack",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: "Mine",
          ),
        ],
      ),
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
