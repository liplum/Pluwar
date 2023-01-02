import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnemyStatus extends StatelessWidget {
  const EnemyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      alignment: Alignment.topLeft,
      child: Container(
        width: 400,
        height: 100,
        color: Colors.grey,
        child: EnemyHPBar(),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}

class EnemyHPBar extends StatelessWidget {
  const EnemyHPBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Text(
          "12345",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        Center(
            child: LinearProgressIndicator(
          value: 0.1,
          backgroundColor: Colors.black,
          color: Colors.red,
          minHeight: 15,
        ))
      ],
    );
  }
}
