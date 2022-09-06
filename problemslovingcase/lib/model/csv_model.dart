class CsvModel {
  CsvModel({
    this.id,
    this.area,
    this.name,
    this.quantity,
    this.brand,
  });

  String id;
  String area;
  String name;
  num quantity;
  String brand;

  CsvModel copyWith({
    String id,
    String area,
    String name,
    int quantity,
    String brand,
  }) =>
      CsvModel(
        id: id ?? this.id,
        area: area ?? this.area,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        brand: brand ?? this.brand,
      );

  String getCsvWriteString() {
    String value = "";
    if (id != null) {
      value = value + id + ",";
    }
    if (name != null) {
      value = value + name + ",";
    }
    if (area != null) {
      value = value + area + ",";
    }
    if (quantity != null) {
      value = value + quantity.toString() + ",";
    }
    if (brand != null) {
      value = value + brand + ",";
    }
    if (value.endsWith(",")) {
      value = value.substring(0, value.length - 1);
    }
    return value + "\r\n";
  }
}
