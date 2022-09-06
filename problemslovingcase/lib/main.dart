import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  _openFile();
}

void _openFile() async {
  /*String textasset = "assets/csv/input_file_name.txt"; //path to text file asset
  String text = await rootBundle.loadString(textasset);
  print(text);
  return;*/
  final input = File('assets/csv/input_file_name.csv').openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();
  print(fields);
}
