import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnemyStatus extends StatelessWidget {
  const EnemyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: const HealthBar(
        currentHealth: 400,
        maxHealth: 1200,
      ),
    );
  }
}

class EnemyHPBar extends StatelessWidget {
  const EnemyHPBar({super.key});
class HealthBar extends StatelessWidget {
  final double currentHealth;
  final double maxHealth;

  const HealthBar({
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
