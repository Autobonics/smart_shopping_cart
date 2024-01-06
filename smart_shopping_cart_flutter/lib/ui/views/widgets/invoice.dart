import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/product.dart';
import 'product_table.dart';

class YourInvoiceWidget extends StatelessWidget {
  final List<Product> products;
  final double totalCost;
  final Function(Product)? onProductSelected;


  const YourInvoiceWidget({
    super.key,
    required this.products,
    required this.totalCost,
    this.onProductSelected,
  });

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['RFID', 'Name', 'Cost'],
                for (var product in products)
                  [product.rfid, product.name, product.cost.toString()],
              ],
            ),
            pw.SizedBox(height: 50),
            pw.Text("Total: Rs ${totalCost.round()}/-"),
          ]);
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _printPdf(BuildContext context) async {
    Uint8List pdfBytes = await generatePdf();

    final tempDir = await getTemporaryDirectory();
    final pdfPath = '${tempDir.path}/product_list.pdf';
    final file = File(pdfPath);
    await file.writeAsBytes(pdfBytes);

    OpenFile.open(pdfPath, type: 'application/pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProductTable(
                products: products, onProductSelected: onProductSelected),
            Text(
              "Total: ₹${totalCost.round()}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _printPdf(context);
              },
              child: const Text("Download Invoice"),
            ),
          ],
        ),
      ),
    );
  }
}
