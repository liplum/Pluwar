import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: buildMain(),
    );
  }

  Widget buildMain() {
    return Stack(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircleAvatar(),
        ),
        buildBody(),
      ],
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        children: [
          Flexible(flex: 1, child: menuTitle()),
          Flexible(
            flex: 2,
            child: Center(
              child: matchingBtn(),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backpackBtn(),
                Row(
                  children: [
                    Text("AAA"),
                    settingsBtn(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget menuTitle() {
    return Text(
      "Pluwar",
      style: TextStyle(color: Colors.grey, fontSize: 115),
    );
  }

  Widget playerSettingBtn() {
    return CircleAvatar(
      //backgroundImage: (),
      backgroundColor: Colors.blue,
      radius: 50.0,
    );
  }

  Widget backpackBtn() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 80, maxHeight: 80),
      child: Container(
        color: Colors.brown,
        child: Text(
          "背包",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }

  Widget settingsBtn() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 50, maxHeight: 50),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey),
        child: Text(
          "设",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        padding: EdgeInsets.all(5),
      ),
    );
  }

  Widget matchingBtn() {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        "找人打",
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
