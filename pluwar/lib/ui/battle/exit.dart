import 'package:flutter/material.dart';

class Exit extends StatelessWidget {
  const Exit({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
              color: Colors.black26,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("是否选择投降\n",style: TextStyle(
                    fontSize: 40,
                    color: Colors.white
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 60),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "投降",
                              style: TextStyle(fontSize: 40, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 60),
                          child: Container(
                            color: Colors.blueGrey,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "取消",
                              style:
                                  TextStyle(fontSize: 40, color: Colors.green),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
              //Text("12345"),

              ),
        ),
      ),
    );
  }
}
