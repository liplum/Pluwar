import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BattleMenu extends StatelessWidget {
  const BattleMenu({super.key});


  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(

            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.brown),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
                child: Container(
                  width: 200,

                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(color: Colors.brown),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenuButton(buttomName: "战斗"),
                          MenuButton(buttomName: "道具"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenuButton(buttomName: "精灵"),
                          MenuButton(buttomName: "投降"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],


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
      color: Colors.greenAccent,
      child: Text(
        " $buttomName ", style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

}