import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                                _buildTextButton('Beginner', 1),
                                _buildTextButton('Easy', 2),
                                _buildTextButton('Medium', 3),
                                _buildTextButton('Hard', 4),
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

  Widget _buildTextButton(String text, int difficult) => TextButton(
        onPressed: () {
          Get.to(GamePage(difficult: difficult));
        },
        child: Text(text),
      );
}
