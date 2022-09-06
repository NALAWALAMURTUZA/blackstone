import "package:collection/collection.dart";
import 'package:problemslovingcase/extention/extention.dart';

import 'csv_model.dart';

/*
ID1,Minneapolis,shoes,2,Air
ID2,Chicago,shoes,1,Air
ID3,Central Department Store,shoes,5,BonPied
ID4,Quail Hollow,forks,3,Pfitzcraft
*/
List<CsvModel> getInputFileNameData() {
  List<CsvModel> l = [];
  l.add(
    CsvModel().copyWith(
        id: "ID1",
        area: "Minneapolis",
        name: "shoes",
        quantity: 2,
        brand: "Air"),
  );
  l.add(
    CsvModel().copyWith(
        id: "ID2", area: "Chicago", name: "shoes", quantity: 1, brand: "Air"),
  );
  l.add(
    CsvModel().copyWith(
        id: "ID3",
        area: "Central Department Store",
        name: "shoes",
        quantity: 5,
        brand: "BonPied"),
  );
  l.add(
    CsvModel().copyWith(
        id: "ID4",
        area: "Quail Hollow",
        name: "forks",
        quantity: 3,
        brand: "Pfitzcraft"),
  );
  return l;
}

/*
ID944806,Willard Vista,Intelligent Copper Knife,3,Hilll-Gorczany
ID644525,Roger Centers,Intelligent Copper Knife,1,Kunze-Bernhard
ID348204,Roger Centers,Small Granite Shoes,4,Rowe and Legros
ID710139,Roger Centers,Intelligent Copper Knife,4,Hilll-Gorczany
ID426632,Willa Hollow,Intelligent Copper Knife,4,Hilll-Gorczany
 */
List<CsvModel> getSampleFileNameData() {
  List<CsvModel> l = [];
  l.add(
    CsvModel().copyWith(
      id: "ID944806",
      area: "Willard Vista",
      name: "Intelligent Copper Knife",
      quantity: 3,
      brand: "Hilll-Gorczany",
    ),
  );
  //ID644525,Roger Centers,Intelligent Copper Knife,1,Kunze-Bernhard
  l.add(
    CsvModel().copyWith(
      id: "ID644525",
      area: "Roger Centers",
      name: "Intelligent Copper Knife",
      quantity: 1,
      brand: "Kunze-Bernhard",
    ),
  );
  //ID348204,Roger Centers,Small Granite Shoes,4,Rowe and Legros
  l.add(
    CsvModel().copyWith(
      id: "ID348204",
      area: "Roger Centers",
      name: "Small Granite Shoes",
      quantity: 4,
      brand: "Rowe and Legros",
    ),
  );
  //ID710139,Roger Centers,Intelligent Copper Knife,4,Hilll-Gorczany
  l.add(
    CsvModel().copyWith(
      id: "ID710139",
      area: "Roger Centers",
      name: "Intelligent Copper Knife",
      quantity: 4,
      brand: "Hilll-Gorczany",
    ),
  );
  //ID426632,Willa Hollow,Intelligent Copper Knife,4,Hilll-Gorczany
  l.add(
    CsvModel().copyWith(
      id: "ID426632",
      area: "Willa Hollow",
      name: "Intelligent Copper Knife",
      quantity: 4,
      brand: "Hilll-Gorczany",
    ),
  );
  return l;
}

class CsvListModel {
  List<CsvModel> list;

  List<CsvModel> mapListToCsvModel(List<List> l) {
    if (list == null) {
      list = [];
    }
    l.forEach((element) {
      list.add(
        CsvModel(
          id: element[0] as String,
          name: element[1] as String,
          area: element[2] as String,
          quantity: element[3] as int,
          brand: element[4] as String,
        ),
      );
    });
  }

  List<CsvModel> fileZeroOutput() {
    final Map<String, dynamic> groupByMonthly = groupBy(
      list,
      (CsvModel event) => event.name.toString(),
    );
    List<CsvModel> l = [];
    if (groupByMonthly.isNotEmpty) {
      groupByMonthly.forEach((key, value) {
        num v =
            (value as List<CsvModel>).map((e) => e.quantity).sum / list.length;
        l.add(CsvModel(name: key, quantity: v));
      });
    }
    return l;
  }

  List<CsvModel> fileOneOutput() {
    final Map<String, dynamic> groupByMonthly = groupBy(
      list,
      (CsvModel event) => event.name.toString(),
    );
    List<CsvModel> l = [];
    if (groupByMonthly.isNotEmpty) {
      groupByMonthly.forEach((key, value) {
        String v = (value as List<CsvModel>)
            .map((e) => e.brand)
            .mostPopularItems()
            .first;
        l.add(CsvModel(name: key, brand: v));
      });
    }
    return l;
  }
}
