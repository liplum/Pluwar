import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenuPageState();
}

class _Page {
  static const match = 0;
  static const backpack = 1;
  static const mine = 2;
}

class _MainMenuPageState extends State<MainMenuPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: buildMain(),
      ).safeArea(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (newIndex) {
          if (currentPage != newIndex) {
            setState(() {
              currentPage = newIndex;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Match",
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
    if (currentPage == _Page.match) {
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
    } else if (currentPage == _Page.backpack) {
      return "Backup".text(style: TextStyle(fontSize: 40));
    } else {
      return "Mine".text(style: TextStyle(fontSize: 40));
    }
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
