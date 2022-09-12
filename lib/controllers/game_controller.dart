import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku_flutter/models/box_chart.dart';
import 'package:sudoku_flutter/screens/home_page.dart';
import 'package:sudokuer/sudokuer.dart' as s;

class GameController extends GetxController {
  RxList<List<SudokuCell>> sudoku = RxList<List<SudokuCell>>();
  RxInt mistakes = 3.obs;
  RxInt hints = 3.obs;
  SudokuCell selectedSudoku = SudokuCell(
      text: 0,
      correctText: 0,
      row: 100,
      col: 100,
      isFocus: false,
      isCorrect: false,
      isDefault: false,
      isExist: false,
      note: []);
  RxBool isNote = false.obs;

  void restart(int difficultyLevel) {
    mistakes.value = 3;
    hints.value = 3;
    sudoku.clear();
    List<List<int>> boxValues = s.generator(difficultyLevel: difficultyLevel);
    List<List<int>> boxValueSolution = s.toSudokuList(boxValues);
    s.solver(boxValueSolution);
    for (var i = 0; i < 9; i++) {
      sudoku.add([]);
      for (var j = 0; j < 9; j++) {
        SudokuCell value = SudokuCell(
            text: boxValues[i][j],
            correctText: boxValueSolution[i][j],
            row: i,
            col: j,
            isFocus: false,
            isCorrect: boxValues[i][j] == boxValueSolution[i][j],
            isDefault: boxValues[i][j] != 0,
            isExist: false,
            note: []);
        sudoku[i].add(value);
      }
    }
  }

  void isComplete() {
    bool isComplete = true;
    for (var i = 0; i < sudoku.length; i++) {
      for (var j = 0; j < sudoku.length; j++) {
        if (sudoku[i][j].text == 0) {
          isComplete = false;
        }
      }
    }
    if (isComplete) {
      Get.offAll(HomePage());
    }
  }

  void onErase() {
    if (_unChangable()) return;
    sudoku[selectedSudoku.row][selectedSudoku.col].text = 0;
    sudoku[selectedSudoku.row][selectedSudoku.col].isCorrect = false;
    sudoku[selectedSudoku.row][selectedSudoku.col].note.clear();
    selectedSudoku.text = 0;
    selectedSudoku.isCorrect = false;
    selectedSudoku.note.clear();
    update();
  }

  void onNoteFill() {
    if (_unChangable()) return;
    sudoku[selectedSudoku.row][selectedSudoku.col].note =
        List.generate(9, (index) => index + 1);
    selectedSudoku.note = List.generate(9, (index) => index + 1);
    update();
  }

  void onHint() {
    if (_unChangable()) return;
    if (hints == 0) return;
    sudoku[selectedSudoku.row][selectedSudoku.col].text =
        sudoku[selectedSudoku.row][selectedSudoku.col].correctText;
    sudoku[selectedSudoku.row][selectedSudoku.col].isCorrect = true;
    isComplete();
    hints--;
  }

  void onNumberClick(int index) {
    if (selectedSudoku.row == 100) return;
    if (isNote.value) {
      if (sudoku[selectedSudoku.row][selectedSudoku.col]
          .note
          .contains(index + 1)) {
        sudoku[selectedSudoku.row][selectedSudoku.col].note.remove((index + 1));
      } else {
        sudoku[selectedSudoku.row][selectedSudoku.col].note.add((index + 1));
      }
    } else {
      if (selectedSudoku.isCorrect) return;
      selectedSudoku.text = index + 1;
      selectedSudoku.isCorrect =
          selectedSudoku.text == selectedSudoku.correctText;
      sudoku[selectedSudoku.row][selectedSudoku.col] = selectedSudoku;
      if (selectedSudoku.correctText != (index + 1)) {
        mistakes--;
        if (mistakes == 0) {
          showRestartDialogue('Life Over!');
        }
      }
      isComplete();
    }
    update();
  }

  bool _unChangable() {
    if (selectedSudoku.row == 100) return true;
    if (selectedSudoku.isDefault) return true;
    return false;
  }

  void showRestartDialogue(String text) => Get.defaultDialog(
        title: text,
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    restart(1);
                    Get.back();
                  },
                  child: Text('Beginner')),
              TextButton(
                  onPressed: () {
                    restart(2);
                    Get.back();
                  },
                  child: Text('Easy')),
              TextButton(
                  onPressed: () {
                    restart(3);
                    Get.back();
                  },
                  child: Text('Medium')),
              TextButton(
                  onPressed: () {
                    restart(4);
                    Get.back();
                  },
                  child: Text('Hard')),
            ],
          ),
        ),
      );
  //  showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Center(child: Text(text)),
  //         content: SizedBox(
  //           height: 200,
  //           child: Column(
  //             children: [
  //               TextButton(
  //                   onPressed: () {
  //                     controller.restart(1);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Beginner')),
  //               TextButton(
  //                   onPressed: () {
  //                     controller.restart(2);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Easy')),
  //               TextButton(
  //                   onPressed: () {
  //                     controller.restart(3);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Medium')),
  //               TextButton(
  //                   onPressed: () {
  //                     controller.restart(4);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Hard')),
  //             ],
  //           ),
  //         ),
  //       );
  //     });
}
