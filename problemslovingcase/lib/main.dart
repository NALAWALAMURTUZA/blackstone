import 'dart:io';

import 'package:csv/csv.dart';
import 'package:problemslovingcase/model/csv_list_model.dart';
import 'package:problemslovingcase/model/csv_model.dart';

void main() {
  String fileName = "input_file_name";
  _openFile(fileName, getInputFileNameData());
  fileName = "order_log00";
  _openFile(fileName, getSampleFileNameData());
}

void _openFile(String name, List<CsvModel> l) async {
  File f = File(name + ".csv");
  await Future.forEach(["", "0_", "1_"], (element) async {
    File fExist = File(element + name + ".csv");
    bool isExist = await fExist.exists();
    if (isExist) {
      await fExist.delete();
    }
  });
  _createCsv(f, l);
  CsvListModel objCsvListModel = CsvListModel();
  objCsvListModel.mapListToCsvModel(csvtoList(f));
  List<CsvModel> list = objCsvListModel.fileOneOutput();
  f = File("0_" + name + ".csv");
  _createCsv(f, list);
  list = objCsvListModel.fileZeroOutput();
  f = File("1_" + name + ".csv");
  _createCsv(f, list);
}

List<List> csvtoList(File file) {
  CsvToListConverter c = CsvToListConverter(eol: "\r\n", fieldDelimiter: ",");
  List<List> l = c.convert(file.readAsStringSync());
  return l;
}

void _createCsv(File file, List<CsvModel> list) {
  list.forEach((element) {
    StringBuffer buffer = StringBuffer();
    file.writeAsStringSync(element.getCsvWriteString(), mode: FileMode.append);
  });
}
