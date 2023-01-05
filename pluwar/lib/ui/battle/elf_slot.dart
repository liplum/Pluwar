import 'package:flutter/material.dart';

class ElfSlot extends StatelessWidget{
  final Map elfData;

  const ElfSlot({super.key, required this.elfData, });


  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [

        //elfDate.map((key, value) => null)
      ],
    );
  }


}