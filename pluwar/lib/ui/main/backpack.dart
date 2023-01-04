import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class _BackpackPage {
  static const item = 0;
  static const elf = 1;
}

class BackpackView extends StatefulWidget {
  const BackpackView({super.key});

  @override
  State<StatefulWidget> createState() => _BackpackViewState();
}

class _BackpackViewState extends State<BackpackView>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.brown,
            child: TabBar(
              controller: _tabController,
              onTap: (newIndex) {
                if (currentPage != newIndex) {
                  setState(() {
                    currentPage = newIndex;
                  });
                }
              },
              tabs: [
                Tab(
                  icon: Icon(Icons.star),
                ),
                Tab(
                  icon: Icon(Icons.push_pin_rounded),
                )
              ],
            ),

        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 2),
          child: buildState(),
        ).safeArea(),
      ],
    );
    /*DefaultTabController(

        child: Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 2),
            child: buildState(),
          ).safeArea(),

          appBar: AppBar(
            bottom: TabBar(

              onTap: (newIndex) {
                if (currentPage != newIndex) {
                  setState(() {
                    currentPage = newIndex;
                  });
                }
              },
              tabs: [
                Tab(icon: Icon(Icons.star),),
                Tab(icon: Icon(Icons.push_pin_rounded),)
              ],
            ),
          ),
        ),
      length: 3,

    )

    ;
       */
  }

  Widget buildState() {
    //final Map xxx;
    if (currentPage == _BackpackPage.item) {
      return Text("ItemBackpack");
      //ItemBackpack(selfItemDate: xxx);
    } else if (currentPage == _BackpackPage.elf) {
      return Text("ElfBackpack");
      //ElfBackpack(selfElfDate: selfElfDate)
    } else {
      return Text("不然就报错了");
    }
  }
}

class ItemBackpack extends StatelessWidget {
  final Map selfItemDate;

  const ItemBackpack({super.key, required this.selfItemDate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //selfItemDate.map(
        //(key, value) =>)
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 50),
          child: Container(
            color: Colors.green,
            child: Row(
              children: [
                Text("ItemImage"),
                Text("ItemName"),
                Text("ItemCount"),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ElfBackpack extends StatelessWidget {
  final Map selfElfDate;

  const ElfBackpack({super.key, required this.selfElfDate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //selfElfDate.map(
        //(key, value) =>)
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 150),
          child: Container(
            color: Colors.blue,
            child: Row(
              children: [
                Text("ElfImage"),
                Column(
                  children: [
                    Text("ElfName"),
                    Text("ElfHP"),
                    Text("ElfLevel"),
                  ],
                ),
                Text("I:详情"),
              ],
            ),
          ),
        )
      ],
    );
  }
}
