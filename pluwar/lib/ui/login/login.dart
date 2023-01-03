import 'package:flutter/material.dart';
import 'package:pluwar/connection.dart';
import 'package:pluwar/r.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final $account = TextEditingController();

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
          LoginButton(
            text: "Login",
            onTap: () async {
              await onLogin();
            },
          )
        ],
      ),
    );
  }

  Future<void> onLogin() async {
   final response = await DIO.post(R.serverLoginUri, data: {});
   print(response);
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const LoginButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}

class LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const LoginField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: textStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller,
                style: textStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
