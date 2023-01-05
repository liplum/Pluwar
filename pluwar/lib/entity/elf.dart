
import 'package:pluwar/entity/attribute.dart';


class ElfMeta{
  late final String nickName;
  late final int id;
  late final Map currentSkillData;
  late final Map skillRepository;
  late final Attribute attribute;
  late final int maxHP;
  late final int level;
  late final int armor;
  late final int spellResistance;
}


class ElfState{
  late final int currentHP;
  late final int currentArmor;
  late final int currentSpellResistance;
  late final bool alive;
}