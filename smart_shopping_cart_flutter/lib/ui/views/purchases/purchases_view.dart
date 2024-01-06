import 'package:flutter/material.dart';
import 'package:smart_shopping_cart_flutter/ui/views/widgets/invoice.dart';
import 'package:stacked/stacked.dart';

import '../../../models/purchase.dart';
import 'purchases_viewmodel.dart';

class PurchasesView extends StackedView<PurchasesViewModel> {
  const PurchasesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PurchasesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("Purchases"),
        ),
        body: viewModel.data != null
            ? ListView.builder(
                itemCount: viewModel.data!.length,
                itemBuilder: (context, index) {
                  Purchase purchase = viewModel.data![index];
                  return YourInvoiceWidget(
                    products: purchase.productList,
                    totalCost: purchase.totalCost,
                  );
                },
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ));
  }

  @override
  PurchasesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PurchasesViewModel();
}
