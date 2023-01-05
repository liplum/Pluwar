import 'package:flutter/material.dart';
import 'package:pluwar/app.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/design/dialog.dart';
import 'package:pluwar/ui/login/login.dart';
import 'package:rettulf/rettulf.dart';

void initEventHandler() {
  Connection.eventBus.on<UnauthorizedEvent>().listen((event) async {
    await AppCtx.showTip(title: "Unauthorized", desc: "Your authorization is expired, please re-log in.", ok: "OK");
    final navigator = AppCtx.navigator;
    while (navigator.canPop()) {
      navigator.pop();
    }
    navigator.push(MaterialPageRoute(builder: (_) => const LoginPage()));
  });
}
