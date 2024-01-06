class Product {
  final String rfid;
  final String name;
  final int cost;

  Product({
    required this.rfid,
    required this.name,
    required this.cost,
  });

  Product.fromMap(Map<String, dynamic> data)
      : rfid = data['rfid'] ?? "",
        name = data['name'] ?? "nil",
        cost = data['cost'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'rfid': rfid,
      'name': name,
      'cost': cost,
    };
  }
}
