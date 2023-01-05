import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/convert.dart';
import 'package:pluwar/design/dialog.dart';
import 'package:pluwar/r.dart';
import 'package:rettulf/rettulf.dart';

import 'shared.dart';
import 'register.entity.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final _pwdRegex = RegExp(r"^(?=.*?[A-Z,a-z])(?=.*?[0-9]).{6,}$");

class _RegisterPageState extends State<RegisterPage> {
  final $account = TextEditingController();
  final $password = TextEditingController();
  final $passwordAgain = TextEditingController();

  @override
  void initState() {
    super.initState();
    $password.addListener(() {
      setState(() {});
    });
    $passwordAgain.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
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
          PasswordField(
            controller: $passwordAgain,
            label: "Confirm Password",
          ),
          LoginButton(
            text: "Sign up",
            onTap: !isSignUpEnable
                ? null
                : () async {
                    await onRegister();
                  },
          )
        ],
      ),
    );
  }

  bool get isSignUpEnable {
    final pwd = $password.text;
    final pwd2 = $passwordAgain.text;
    return pwd.isNotEmpty && pwd2.isNotEmpty && pwd == pwd2;
  }

  Future<void> onRegister() async {
    final pwd = $password.text;
    final pwd2 = $passwordAgain.text;
    if (pwd.isEmpty || pwd2.isEmpty) {
      await context.showTip(title: "Error", desc: "Password can't be empty.", ok: "OK");
      return;
    }
    if (pwd != pwd2) {
      await context.showTip(title: "Error", desc: "Passwords do not match, please retype.", ok: "OK");
      return;
    }
    if (!_pwdRegex.hasMatch(pwd)) {
      await context.showTip(
        title: "Error",
        desc: "Password is too week, at least 6 characters including at least one digit and one letter.",
        ok: "OK",
      );
      return;
    }
    final response = await DIO.post("${R.serverAuthUri}/register", data: {
      "account": $account.text,
      "password": $password.text,
    });
    final payload = response.data.toString().fromJson(RegisterPayload.fromJson);
    if (payload == null) return;
    if (!mounted) return;
    switch (payload.status) {
      case RegisterStatus.accountOccupied:
        await context.showTip(
          title: "Error",
          desc: "This account already exists, please choose another one.",
          ok: "OK",
        );
        break;
      case RegisterStatus.passwordTooWeek:
        await context.showTip(
          title: "Error",
          desc: "The password is too week, at least 6 characters including at least one digit and one letter.",
          ok: "OK",
        );
        break;
      case RegisterStatus.done:
        await context.showTip(
          title: "Sign up",
          desc: "Your account was signed up, please memorize the password.",
          ok: "OK",
        );
        context.navigator.pop();
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
  }
}
