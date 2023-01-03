import 'package:flutter/material.dart';

class BattleStatusPage extends StatelessWidget {
  final String elfName;

  //final Image Image;
  final String playerName;
  final double maxHp;
  final double hp;

  //final double AlliedAttribute = ;

  const BattleStatusPage({
    super.key,
    required this.hp,
    required this.maxHp,
    required this.elfName,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 150, maxWidth: 300),
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              " $playerName ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " $elfName ",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      " $hp / $maxHp ",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
                BattleHealthBar(
                  currentHealth: hp,
                  maxHealth: maxHp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlliedStatus extends StatelessWidget {
  const AlliedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300,maxHeight: 200),
      child: Container(

        alignment: Alignment.topLeft,
        child: BattleStatusPage(
          hp: 114,
          maxHp: 514,
          elfName: "李萝莉",
          playerName: "土豆奴隶主",
        ),
      ),
    );
  }
}

class EnemyStatus extends StatelessWidget {
  const EnemyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300,maxHeight: 200),
      child: Container(

        alignment: Alignment.topLeft,
        child: BattleStatusPage(
          hp: 810,
          maxHp: 1919,
          elfName: "土人",
          playerName: "黑恶势力",
        ),
      ),
    );
  }
}

class BattleHealthBar extends StatelessWidget {
  final double currentHealth;
  final double maxHealth;

  const BattleHealthBar({
    super.key,
    required this.currentHealth,
    required this.maxHealth,
  });

  double get progress => currentHealth / maxHealth;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 20,
      value: progress,
      color: Colors.redAccent,
    );
  }
}
