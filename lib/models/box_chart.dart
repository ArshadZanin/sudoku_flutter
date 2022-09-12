class SudokuCell {
  int text;
  int correctText;
  int row;
  int col;
  bool isFocus;
  bool isCorrect;
  bool isDefault;
  bool isExist;
  List<int> note;

  SudokuCell({
    required this.text,
    required this.correctText,
    required this.row,
    required this.col,
    required this.isFocus,
    required this.isCorrect,
    required this.isDefault,
    required this.isExist,
    required this.note,
  });
}
