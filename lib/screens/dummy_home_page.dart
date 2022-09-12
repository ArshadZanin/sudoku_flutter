import 'package:flutter/material.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            9,
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  9,
                  (col) => Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(
                          bottom: row % 3 == 2 ? 2 : 0,
                          right: col % 3 == 2 ? 2 : 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: row % 3 == 2 ? 2 : 1),
                            right: BorderSide(width: col % 3 == 2 ? 2 : 1),
                            top: BorderSide(width: row % 3 == 0 ? 2 : 1),
                            left: BorderSide(width: col % 3 == 0 ? 2 : 1),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text('1'),
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
