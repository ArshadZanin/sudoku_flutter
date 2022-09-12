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
      team: 100,
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
        int team = 0;
        if (i < 3 && j < 3) {
          team = 1;
        } else if (i < 3 && j < 6) {
          team = 2;
        } else if (i < 3 && j < 9) {
          team = 3;
        } else if (i < 6 && j < 3) {
          team = 4;
        } else if (i < 6 && j < 6) {
          team = 5;
        } else if (i < 6 && j < 9) {
          team = 6;
        } else if (i < 9 && j < 3) {
          team = 7;
        } else if (i < 9 && j < 6) {
          team = 8;
        } else if (i < 9 && j < 9) {
          team = 9;
        }
        SudokuCell value = SudokuCell(
            text: boxValues[i][j],
            correctText: boxValueSolution[i][j],
            row: i,
            col: j,
            team: team,
            isFocus: false,
            isCorrect: boxValues[i][j] == boxValueSolution[i][j],
            isDefault: boxValues[i][j] != 0,
            isExist: false,
            note: []);
        sudoku[i].add(value);
      }
      // print(sudoku[i].map((e) => e.correctText));
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
    fetchSafeValues();
    update();
  }

  void onHint() {
    if (_unChangable()) return;
    if (hints == 0) return;
    sudoku[selectedSudoku.row][selectedSudoku.col].text =
        sudoku[selectedSudoku.row][selectedSudoku.col].correctText;
    sudoku[selectedSudoku.row][selectedSudoku.col].isCorrect = true;
    removeNoteValue(sudoku[selectedSudoku.row][selectedSudoku.col].correctText);
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
      fetchSafeValues();
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
      } else {
        removeNoteValue(index + 1);
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

  bool isSafe(int row, int col) {
    return selectedSudoku.col == sudoku[row][col].col ||
        selectedSudoku.row == sudoku[row][col].row ||
        selectedSudoku.team == sudoku[row][col].team;
  }

  void fetchSafeValues() {
    List<int> safeValues = [];
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (selectedSudoku.row == i) {
          safeValues.add(sudoku[i][j].text);
        } else if (selectedSudoku.col == j) {
          safeValues.add(sudoku[i][j].text);
        } else if (selectedSudoku.team == sudoku[i][j].team) {
          safeValues.add(sudoku[i][j].text);
        }
      }
    }
    safeValues.removeWhere((element) => element == 0);
    for (var value in safeValues) {
      sudoku[selectedSudoku.row][selectedSudoku.col].note.remove(value);
      selectedSudoku.note.remove(value);
    }
  }

  void removeNoteValue(int number) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (isSafe(i, j)) {
          sudoku[i][j].note.remove(number);
        }
      }
    }
  }

  void onSettings() {
    Get.defaultDialog(
      title: 'Settings',
      content: SizedBox(
        height: 150,
        child: Center(
          child: InkWell(
            onTap: () => Get.offAll(HomePage()),
            child: Text('Exit Game'),
          ),
        ),
      ),
    );
  }
}
