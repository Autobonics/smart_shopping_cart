import 'package:smart_shopping_cart_flutter/models/product.dart';

class Purchase {
  final String id;
  final List<Product> productList;
  final double totalCost;

  Purchase({
    required this.id,
    required this.productList,
    required this.totalCost,
  });

  Purchase.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? "",
        productList = (data['productList'] as List<dynamic>?)
                ?.map((productData) => Product.fromMap(productData))
                .toList() ??
            [],
        totalCost = data['totalCost'] ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productList': productList.map((product) => product.toJson()).toList(),
      'totalCost': totalCost,
    };
  }
}
