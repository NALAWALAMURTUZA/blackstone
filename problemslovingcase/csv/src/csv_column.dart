import '../csv_sheet.dart';

class CsvColumn {
  final CsvSheet sheet;
  int row = 0;

  CsvColumn(this.sheet);

  // TODO: Should we have a CsvCell type? For now it's just strings.
  String operator [](index) => sheet.getValue(row, index - 1);
}
