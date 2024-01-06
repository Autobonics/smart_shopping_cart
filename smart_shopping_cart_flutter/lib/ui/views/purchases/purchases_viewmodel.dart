import 'package:smart_shopping_cart_flutter/models/purchase.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/firestore_service.dart';

class PurchasesViewModel extends StreamViewModel<List<Purchase>> {
  final log = getLogger('AdminViewModel');

  final _firestoreService = locator<FirestoreService>();

  @override
  Stream<List<Purchase>> get stream => _firestoreService.getAllPurchases();
}
