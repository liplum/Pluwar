import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/convert.dart';
import 'package:pluwar/design/dialog.dart';
import 'package:pluwar/r.dart';
import 'package:pluwar/ui/login/login.entity.dart';

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
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext ctx) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }

  Future<void> onLogin() async {
    final response = await DIO.post("${R.serverAuthUri}/login", data: {
      "account": $account.text,
      "password": $password.text,
    });
    final payload = response.data.toString().fromJson(LoginPayload.fromJson);
    if (payload == null) return;
    if (!mounted) return;
    switch (payload.state) {
      case LoginState.incorrectCredential:
        await context.showTip(
          title: "Error",
          desc: "Account or password is incorrect, please retry.",
          ok: "OK",
        );
        break;
      // TODO: enter the main menu after logging in
      case LoginState.ok:
        await context.showTip(
          title: "Logged in",
          desc: "Welcome.",
          ok: "OK",
        );
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
  }
}
