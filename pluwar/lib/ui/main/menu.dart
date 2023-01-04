import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'backpack.dart';
import 'matching.dart';
import 'mine.dart';

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
      return const MatchingView();
    } else if (currentPage == _Page.backpack) {
      return const BackpackView();
    } else {
      return const MineView();
    }
  }
}
