import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const LoginField({
    super.key,
    required this.controller,
    required this.label,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return TextField(
      controller: controller,
      style: textStyle,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(fontSize: 25)),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return TextField(
      controller: widget.controller,
      style: textStyle,
      obscureText: !visible,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(fontSize: 25),
        suffixIcon: IconButton(
          icon: visible ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
          onPressed: () {
            setState(() {
              visible = !visible;
            });
          },
        ),
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
      child: Text(text),
    );
  }
}
