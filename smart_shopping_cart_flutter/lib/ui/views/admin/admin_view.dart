import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/product.dart';
import '../../smart_widgets/online_status.dart';
import 'admin_viewmodel.dart';

class AdminView extends StackedView<AdminViewModel> {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AdminViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
            "Welcome ${viewModel.user != null ? viewModel.user!.fullName : ""}"),
        actions: [
          const IsOnlineWidget(),
          IconButton(
            onPressed: viewModel.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          if(viewModel.node!=null)
          Center(child: Card(child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text("RFID Reading: ${viewModel.node!.rfid}"),
                Text("Time: ${DateFormat('MM/dd/yyyy, hh:mm a').format(viewModel.node!.lastSeen)}"),
              ],
            ),
          ))),
          const SizedBox(height: 20),
            if(viewModel.dataReady && viewModel.data!=null)
              ProductTable(products: viewModel.data!)
            else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 20),

          ElevatedButton(
            onPressed: (){
              viewModel.showAddProductBottomSheet(context);
            },
            child: const Text('Add product'),
          ),
        ],),
      ),
    );
  }

  @override
  AdminViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AdminViewModel();
}



class ProductAddBottomSheet extends StatefulWidget {
  final Function(Product) onProductAdded;

  const ProductAddBottomSheet({Key? key, required this.onProductAdded})
      : super(key: key);

  @override
  _ProductAddBottomSheetState createState() => _ProductAddBottomSheetState();
}

class _ProductAddBottomSheetState extends State<ProductAddBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rfidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _rfidController,
              decoration: const InputDecoration(labelText: 'RFID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter RFID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Cost';
                }
                // You can add more specific validation for cost if needed
                return null;
              },
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Validation successful
                  Product product = Product(
                    rfid: _rfidController.text,
                    name: _nameController.text,
                    cost: int.parse(_costController.text),
                  );

                  widget.onProductAdded(product);
                  Navigator.of(context).pop(); // Close the bottom sheet
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}




class ProductTable extends StatelessWidget {
  final List<Product> products;

  const ProductTable({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('RFID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Cost')),
      ],
      rows: products
          .map((product) => DataRow(cells: [
        DataCell(Text(product.rfid)),
        DataCell(Text(product.name)),
        DataCell(Text(product.cost.toString())),
      ]))
          .toList(),
    );
  }
}
