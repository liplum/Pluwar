import 'package:flutter/material.dart';

class BattleStatus extends StatelessWidget {
  final String elfName;
  //final Image Image;
  final String playerName;
  final double maxHp;
  final double hp;

  //final double AlliedAttribute = ;

  const BattleStatus(
      {super.key,
      required this.hp,
      required this.maxHp,
      required this.elfName,
      required this.playerName,
      });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 250,maxWidth: 500),
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(80, 0, 0, 0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(" $elfName ",style: TextStyle(fontSize: 15,color: Colors.white),),
                  Text(" $hp / $maxHp ",style: TextStyle(fontSize: 15,color: Colors.white),),
                ],
              ),

              BattleHealthBar(
                currentHealth: hp,
                maxHealth: maxHp,
              ),
            ],
          ),
        ),

    );
  }
}







class AlliedStatus extends StatelessWidget{
  const AlliedStatus({super.key});
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class EmenyStatus extends StatelessWidget{
  const EmenyStatus({super.key});
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
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
