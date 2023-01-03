import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pluwar/ui/battle/battle_menu.dart';
import 'package:pluwar/ui/battle/battle_status.dart';
import 'package:pluwar/ui/login/login.dart';
import 'ui/main/menu.dart';

class PluwarApp extends StatelessWidget {
  const PluwarApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MaterialApp(
        title: 'Pluwar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:LoginPage());
            /*
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  height: 100,
                  color: Colors.grey,
                  child: EnemyStatus(),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      height: 100,
                      color: Colors.grey,
                      child: AlliedStatus(),
                    )
                  ],
                ),
                BattleMenu(),
              ],
            ),
          ],
        )




    );

             */
  }
}
