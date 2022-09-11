import 'package:flutter/material.dart';
import 'package:sudoku_flutter/models/box_chart.dart';
import 'package:sudoku_flutter/screens/home_page.dart';
import 'package:sudokuer/sudokuer.dart' as s;

class GamePage extends StatefulWidget {
  final int difficult;
  const GamePage({
    Key? key,
    required this.difficult,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<SudokuCell>> sudoku = [];
  int mistakes = 3;
  int hints = 3;
  SudokuCell? selectedSudoku;
  bool isNote = false;

  @override
  void initState() {
    restart(widget.difficult);
    setState(() {});
    super.initState();
  }

  void restart(int difficultyLevel) {
    mistakes = 3;
    hints = 3;
    sudoku.clear();
    List<List<int>> boxValues = s.generator(difficultyLevel: difficultyLevel);
    List<List<int>> boxValueSolution = s.toSudokuList(boxValues);
    s.solver(boxValueSolution);
    for (var i = 0; i < 9; i++) {
      sudoku.add([]);
      for (var j = 0; j < 9; j++) {
        int row = 0;
        int col = 0;
        // if (i < 3) {
        //   if (j < 3) {
        //     row = 0;
        //     col = j == 0 ? ((j + 1) % 3) - 1 : j % 3;
        //   } else if (j < 6) {
        //     row = 1;
        //     col = (j % 3) + 3;
        //   } else if (j < 9) {
        //     row = 2;
        //     col = (j % 3) + 6;
        //   }
        // } else if (i < 6) {
        //   if (j < 3) {
        //     row = 3;
        //     col = j + 3;
        //   } else if (j < 6) {
        //     row = 4;
        //     col = j + 3;
        //   } else if (j < 9) {
        //     row = 5;
        //     col = j + 3;
        //   }
        // } else if (i < 9) {
        //   if (j < 3) {
        //     row = 6;
        //     col = j + 6;
        //   } else if (j < 6) {
        //     row = 7;
        //     col = j + 6;
        //   } else if (j < 9) {
        //     row = 8;
        //     col = j + 6;
        //   }
        // }
        SudokuCell value = SudokuCell(
            text: boxValues[i][j],
            correctText: boxValueSolution[i][j],
            fIndex: i,
            sIndex: j,
            row: row,
            col: col,
            isFocus: false,
            isCorrect: boxValues[i][j] == boxValueSolution[i][j],
            isDefault: boxValues[i][j] != 0,
            isExist: false,
            note: []);
        sudoku[i].add(value);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (sudoku.isEmpty) return Container();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.heart_broken,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(mistakes.toString()),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                    ),
                  ),
                  InkWell(onTap: () {}, child: const Icon(Icons.pause_rounded)),
                  InkWell(
                    onTap: () {
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
                                          restart(1);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Beginner')),
                                    TextButton(
                                        onPressed: () {
                                          restart(2);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Easy')),
                                    TextButton(
                                        onPressed: () {
                                          restart(3);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Medium')),
                                    TextButton(
                                        onPressed: () {
                                          restart(4);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Hard')),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      Icons.restart_alt,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.settings,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, fIndex) {
                      return Container(
                        padding: const EdgeInsets.all(1),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.grey[800],
                        ),
                        child: GridView.builder(
                          itemCount: 9,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, sIndex) {
                            return InkWell(
                              onTap: () {
                                selectedSudoku = sudoku[fIndex][sIndex];
                                setState(() {});
                              },
                              child: Container(
                                // margin: const EdgeInsets.all(0.5),
                                alignment: Alignment.center,
                                color: selectedSudoku == null
                                    ? Colors.white
                                    : sIndex == selectedSudoku!.sIndex &&
                                            fIndex == selectedSudoku!.fIndex
                                        ? Colors.grey[400]
                                        : fIndex == selectedSudoku!.fIndex
                                            //  ||
                                            //         selectedSudoku!.col ==
                                            //             sudoku[fIndex][sIndex]
                                            //                 .col ||
                                            //         selectedSudoku!.row ==
                                            //             sudoku[fIndex][sIndex].row
                                            ? Colors.grey[300]
                                            : Colors.white,
                                child: sudoku[fIndex][sIndex].text == 0
                                    ? Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: GridView.builder(
                                          itemCount: 9,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1,
                                          ),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, noteIndex) {
                                            return Container(
                                              alignment: Alignment.center,
                                              child: !sudoku[fIndex][sIndex]
                                                      .note
                                                      .contains(noteIndex + 1)
                                                  ? const Offstage()
                                                  : Text(
                                                      (noteIndex + 1)
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: selectedSudoku !=
                                                                    null &&
                                                                selectedSudoku!
                                                                        .text ==
                                                                    (noteIndex +
                                                                        1)
                                                            ? Colors.blue
                                                            : Colors.black,
                                                        fontWeight: selectedSudoku !=
                                                                    null &&
                                                                selectedSudoku!
                                                                        .text ==
                                                                    (noteIndex +
                                                                        1)
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                            );
                                          },
                                        ),
                                      )
                                    : Text(
                                        sudoku[fIndex][sIndex].text.toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: sudoku[fIndex][sIndex]
                                                  .isDefault
                                              ? Colors.black
                                              : sudoku[fIndex][sIndex].isCorrect
                                                  ? Colors.blue
                                                  : Colors.red,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedSudoku == null) return;
                          if (selectedSudoku!.isDefault) return;
                          sudoku[selectedSudoku!.fIndex][selectedSudoku!.sIndex]
                              .text = 0;
                          sudoku[selectedSudoku!.fIndex][selectedSudoku!.sIndex]
                              .isCorrect = false;
                          sudoku[selectedSudoku!.fIndex][selectedSudoku!.sIndex]
                              .note
                              .clear();
                          selectedSudoku!.text = 0;
                          selectedSudoku!.isCorrect = false;
                          selectedSudoku!.note.clear();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.delete_sweep_outlined,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            if (selectedSudoku == null) return;
                            if (selectedSudoku!.isDefault) return;
                            sudoku[selectedSudoku!.fIndex]
                                    [selectedSudoku!.sIndex]
                                .note = List.generate(9, (index) => index + 1);
                            selectedSudoku!.note =
                                List.generate(9, (index) => index + 1);
                            setState(() {});
                          },
                          child: Icon(Icons.grid_on_rounded)),
                      InkWell(
                        onTap: () {
                          isNote = !isNote;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.draw_rounded,
                          color: !isNote ? Colors.black : Colors.blue,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (selectedSudoku == null) return;
                          if (selectedSudoku!.isDefault) return;
                          if (hints == 0) return;
                          sudoku[selectedSudoku!.fIndex][selectedSudoku!.sIndex]
                              .text = sudoku[selectedSudoku!.fIndex]
                                  [selectedSudoku!.sIndex]
                              .correctText;
                          sudoku[selectedSudoku!.fIndex][selectedSudoku!.sIndex]
                              .isCorrect = true;
                          isComplete();
                          hints--;
                          setState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                            ),
                            Text(
                              '$hints',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        9,
                        (index) => InkWell(
                              onTap: () {
                                if (selectedSudoku == null) return;
                                if (isNote) {
                                  if (sudoku[selectedSudoku!.fIndex]
                                          [selectedSudoku!.sIndex]
                                      .note
                                      .contains(index + 1)) {
                                    sudoku[selectedSudoku!.fIndex]
                                            [selectedSudoku!.sIndex]
                                        .note
                                        .remove((index + 1));
                                  } else {
                                    sudoku[selectedSudoku!.fIndex]
                                            [selectedSudoku!.sIndex]
                                        .note
                                        .add((index + 1));
                                  }
                                } else {
                                  if (selectedSudoku!.isCorrect) return;
                                  selectedSudoku!.text = index + 1;
                                  selectedSudoku!.isCorrect =
                                      selectedSudoku!.text ==
                                          selectedSudoku!.correctText;
                                  sudoku[selectedSudoku!.fIndex]
                                          [selectedSudoku!.sIndex] =
                                      selectedSudoku!;
                                  if (selectedSudoku!.correctText !=
                                      (index + 1)) {
                                    mistakes--;
                                    if (mistakes == 0) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Center(
                                                  child: Text('Life Over!')),
                                              content: SizedBox(
                                                height: 200,
                                                child: Column(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          restart(1);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            Text('Beginner')),
                                                    TextButton(
                                                        onPressed: () {
                                                          restart(2);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Easy')),
                                                    TextButton(
                                                        onPressed: () {
                                                          restart(3);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Medium')),
                                                    TextButton(
                                                        onPressed: () {
                                                          restart(4);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Hard')),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  }
                                  isComplete();
                                }
                                setState(() {});
                              },
                              child: Container(
                                width: 30,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: isNote &&
                                          selectedSudoku != null &&
                                          sudoku[selectedSudoku!.fIndex]
                                                  [selectedSudoku!.sIndex]
                                              .note
                                              .contains(index + 1)
                                      ? Colors.grey[400]
                                      : Colors.white,
                                  border: Border.all(
                                      color:
                                          isNote ? Colors.black : Colors.blue),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
    setState(() {});
  }
}
