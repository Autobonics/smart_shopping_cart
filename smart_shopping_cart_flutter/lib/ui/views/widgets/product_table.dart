import 'package:flutter/material.dart';

import '../../../models/product.dart';

class ProductTable extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onProductSelected;

  const ProductTable({Key? key, required this.products, this.onProductSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('RFID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Cost')),
      ],
      rows: products
          .map((product) => DataRow(
                onLongPress: () {
                  if (onProductSelected != null) {
                    onProductSelected!(product);
                  }
                },
                cells: [
                  DataCell(Text(product.rfid)),
                  DataCell(Text(product.name)),
                  DataCell(Text(product.cost.toString())),
                ],
              ))
          .toList(),
    );
  }
}
