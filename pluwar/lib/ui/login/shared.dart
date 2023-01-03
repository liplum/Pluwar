import 'package:flutter/material.dart';

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
    final textStyle = Theme
        .of(context)
        .textTheme
        .titleLarge;
    return Padding(
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
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme
        .of(context)
        .textTheme
        .titleLarge;
    return Padding(
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
              obscureText: true,
            ),
          )
        ],
      ),
    );
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
          style: Theme
              .of(context)
              .textTheme
              .headlineLarge,
        ));
  }
}