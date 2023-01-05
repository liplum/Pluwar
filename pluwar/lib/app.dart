import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pluwar/ui/battle/battle_menu.dart';
import 'package:pluwar/ui/battle/battle_status.dart';
import 'package:pluwar/ui/login/login.dart';
import 'ui/main/menu.dart';
import 'ui/main/backpack.dart';

// ignore: non_constant_identifier_names
final AppKey = GlobalKey<NavigatorState>();
// ignore: non_constant_identifier_names
BuildContext get AppCtx => AppKey.currentState!.context;

class PluwarApp extends StatefulWidget {
  const PluwarApp({super.key});

  @override
  State<StatefulWidget> createState() => _PluwarAppState();
}

class _PluwarAppState extends State<PluwarApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MaterialApp(
      title: 'Pluwar',
      navigatorKey: AppKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
