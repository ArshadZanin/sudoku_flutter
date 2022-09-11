import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sudoku_flutter/screens/game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(child: Text('Difficulty Level')),
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const GamePage(
                                                    difficult: 1,
                                                  )));
                                    },
                                    child: Text('Beginner')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const GamePage(
                                                    difficult: 2,
                                                  )));
                                    },
                                    child: Text('Easy')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const GamePage(
                                                    difficult: 3,
                                                  )));
                                    },
                                    child: Text('Medium')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const GamePage(
                                                    difficult: 4,
                                                  )));
                                    },
                                    child: Text('Hard')),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Text('New Game')),
          ],
        ),
      ),
    );
  }
}
