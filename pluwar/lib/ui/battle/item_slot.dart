import 'package:flutter/material.dart';
import 'package:pluwar/entity/item.dart';

class ItemSlot extends StatelessWidget{
  final Map itemData;

  const ItemSlot({super.key, required this.itemData, });


  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [

        //itemDate.map((key, value) => null)
      ],
    );
  }


}