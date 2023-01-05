import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/convert.dart';
import 'package:pluwar/design/dialog.dart';
import 'package:pluwar/r.dart';
import 'package:pluwar/ui/login/login.entity.dart';
import 'package:pluwar/ui/main/menu.dart';
import 'package:rettulf/rettulf.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'register.dart';
import 'shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final $account = TextEditingController();
  final $password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext ctx) {
    return [
      Text(
        "Pluwar",
        style: ctx.textTheme.headlineLarge,
      ).center().expanded(),
      [
        LoginField(
          controller: $account,
          label: "Account",
        ),
        PasswordField(
          controller: $password,
          label: "Password",
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LoginButton(
              text: "Login",
              onTap: () async {
                await onLogin();
              },
            ),
            LoginButton(
              text: "Sign up",
              onTap: () {
                Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
            ),
          ],
        )
      ].column().expanded()
    ].column();
  }

  Future<void> onLogin() async {
    final account = $account.text;
    final response = await DIO.post("${R.serverAuthUri}/login", data: {
      "account": account,
      "password": $password.text,
    });
    final payload = response.data.toString().fromJson(LoginPayload.fromJson);
    if (payload == null) return;
    if (!mounted) return;
    switch (payload.status) {
      case LoginStatus.incorrectCredential:
        await context.showTip(
          title: "Error",
          desc: "Account or password is incorrect, please retry.",
          ok: "OK",
        );
        break;
      case LoginStatus.ok:
        final token = payload.token;
        final expired = payload.expired;
        if (token == null || expired == null) return;
        Connection.auth = Auth(account: account, token: token, expired: expired);
        Connection.connectToGameServer();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainMenuPage()));
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
  }
}
