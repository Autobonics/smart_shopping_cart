import 'package:flutter/material.dart';
import 'package:smart_shopping_cart_flutter/ui/smart_widgets/online_status.dart';
import 'package:smart_shopping_cart_flutter/ui/views/widgets/invoice.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConditionButton(
                text1: "Stop shopping",
                text2: "Start Shopping",
                isTrue: viewModel.isShopping,
                onTap: viewModel.setShopping,
              ),
              // verticalSpaceLarge,
              if (viewModel.isShopping)
                Column(
                  children: [
                    YourInvoiceWidget(
                      products: viewModel.products,
                      totalCost: viewModel.totalCost,
                      onProductSelected: viewModel.onProductSelected,
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}

class ConditionButton extends StatelessWidget {
  final String text1;
  final String text2;
  final bool isTrue;
  final VoidCallback onTap;

  const ConditionButton({
    required this.text1,
    required this.text2,
    required this.isTrue,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isTrue ? Colors.red : Colors.green,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                isTrue ? text1 : text2,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
