import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnStatus extends StatelessWidget {
  const OwnStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 400,
        height: 100,
        color: Colors.grey,
        child: OwnHPBar(),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}

class OwnHPBar extends StatelessWidget {
  const OwnHPBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Center(
          child: Text(
            "12345",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Center(
            child: LinearProgressIndicator(
          value: 0.1,
          backgroundColor: Colors.black,
          color: Colors.red,
          minHeight: 15,
        ))
      ],
    );
  }
}
