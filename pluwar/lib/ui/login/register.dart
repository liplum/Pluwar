import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/r.dart';

import 'shared.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final $account = TextEditingController();
  final $password = TextEditingController();
  final $passwordAgain = TextEditingController();

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
            label: "Password Again",
          ),
          LoginButton(
            text: "Sign up",
            onTap: () async {
              await onRegister();
            },
          )
        ],
      ),
    );
  }

  Future<void> onRegister() async {
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
  }
}
