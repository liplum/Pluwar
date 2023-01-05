import 'package:flutter/material.dart';
import 'package:pluwar/entity/skill.dart';

class SkillSlot extends StatelessWidget {
  final Skill skill;

  const SkillSlot({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 45, maxWidth: 55),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: Colors.black26,
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Text("skillAttributeImage"),
                Column(
                  children: [
                    Text("SkillName"),
                    Text("Skill伤害"),
                    Text("skillpp"),

                  ],
                )
              ],
            ),
          ),
          //Text("12345"),
        ),
      ),
    );
  }
}
