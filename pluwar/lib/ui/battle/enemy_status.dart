import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnemyStatus extends StatelessWidget{
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

        child: BloodBar(),
        padding: const EdgeInsets.all(20),


      ),
    );
  }
}


/*
class BloodBar extends StatelessWidget{
  const BloodBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("12345",style: TextStyle(fontSize: 30,color:Colors.black),),
        Text("12345",style: TextStyle(fontSize: 30,color:Colors.black),),
      ],
    );
      Container(

      alignment: Alignment.bottomRight,
      child: Container(
        width: 300,
        height: 30,
        color: Colors.red,

      ),
    );
  }

}

 */
