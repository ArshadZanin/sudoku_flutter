import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku_flutter/controllers/game_controller.dart';

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
  final controller = Get.put(GameController());

  @override
  void initState() {
    controller.restart(widget.difficult);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.sudoku.isEmpty) return Container();
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(flex: 1, child: _buildHeader()),
              Expanded(
                flex: 6,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildSudokuGrid(),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildOptions(),
                    SizedBox(
                      height: 20,
                    ),
                    _buildNumberButtons(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            Text(controller.mistakes.toString()),
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
          onTap: () => controller.showRestartDialogue('Difficulty Level'),
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
    );
  }

  Widget _buildSudokuGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        9,
        (row) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            9,
            (col) => GetBuilder<GameController>(builder: (controller) {
              return InkWell(
                onTap: () {
                  controller.selectedSudoku = controller.sudoku[row][col];
                  controller.update();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(
                    bottom: row % 3 == 2 ? 2 : 0,
                    right: col % 3 == 2 ? 2 : 0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: row % 3 == 2 ? 2 : 0),
                      right: BorderSide(width: col % 3 == 2 ? 2 : 0),
                      top: BorderSide(width: row % 3 == 0 ? 2 : 0),
                      left: BorderSide(width: col % 3 == 0 ? 2 : 0),
                    ),
                    color: _selectCellColor(row, col),
                  ),
                  alignment: Alignment.center,
                  child: controller.sudoku[row][col].text == 0
                      ? _buildNotes(row, col)
                      : _buildCellValue(row, col),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: controller.onErase,
          child: const Icon(
            Icons.delete_sweep_outlined,
          ),
        ),
        InkWell(
          onTap: controller.onNoteFill,
          child: Icon(Icons.grid_on_rounded),
        ),
        InkWell(
          onTap: () {
            controller.isNote.value = !controller.isNote.value;
          },
          child: Icon(
            Icons.draw_rounded,
            color: !controller.isNote.value ? Colors.black : Colors.blue,
          ),
        ),
        InkWell(
          onTap: controller.onHint,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
              ),
              Text(
                '${controller.hints}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          9,
          (index) => InkWell(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: controller.isNote.value &&
                            controller.selectedSudoku.row != 100 &&
                            controller
                                .sudoku[controller.selectedSudoku.row]
                                    [controller.selectedSudoku.col]
                                .note
                                .contains(index + 1)
                        ? Colors.grey[400]
                        : Colors.white,
                    border: Border.all(
                        color: controller.isNote.value
                            ? Colors.black
                            : Colors.blue),
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
    );
  }

  Widget _buildNotes(int row, int col) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, noteIndex) {
          return Container(
            alignment: Alignment.center,
            child: !controller.sudoku[row][col].note.contains(noteIndex + 1)
                ? const Offstage()
                : Text(
                    (noteIndex + 1).toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: controller.selectedSudoku.row != 100 &&
                              controller.selectedSudoku.text == (noteIndex + 1)
                          ? Colors.blue
                          : Colors.black,
                      fontWeight: controller.selectedSudoku.row != 100 &&
                              controller.selectedSudoku.text == (noteIndex + 1)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCellValue(int row, int col) {
    return Text(
      controller.sudoku[row][col].text.toString(),
      style: TextStyle(
        fontSize: 25,
        color: controller.sudoku[row][col].isDefault
            ? Colors.black
            : controller.sudoku[row][col].isCorrect
                ? Colors.blue
                : Colors.red,
      ),
    );
  }

  Color? _selectCellColor(int row, int col) {
    if (col == controller.selectedSudoku.col &&
        row == controller.selectedSudoku.row) {
      return Colors.grey[400];
    } else if (row == controller.selectedSudoku.row ||
        controller.selectedSudoku.col == controller.sudoku[row][col].col ||
        controller.selectedSudoku.row == controller.sudoku[row][col].row) {
      return Colors.grey[300];
    } else {
      return Colors.white;
    }
  }
}
