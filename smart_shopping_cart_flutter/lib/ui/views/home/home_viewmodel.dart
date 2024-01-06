import 'dart:async';

import 'package:smart_shopping_cart_flutter/app/app.locator.dart';
import 'package:smart_shopping_cart_flutter/app/app.router.dart';
import 'package:smart_shopping_cart_flutter/models/appuser.dart';
import 'package:smart_shopping_cart_flutter/models/purchase.dart';
import 'package:smart_shopping_cart_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.logger.dart';
import '../../../models/device.dart';
import '../../../models/product.dart';
import '../../../services/database_service.dart';
import '../../../services/firestore_service.dart';

class HomeViewModel extends StreamViewModel<List<Product>> {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();

  AppUser? get user => _userService.user;

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  DeviceReading? get node => _dbService.node;

  @override
  List<DatabaseService> get listenableServices => [_dbService];

  final _firestoreService = locator<FirestoreService>();

  @override
  Stream<List<Product>> get stream => _firestoreService.getAllProducts();

  //Device data
  DeviceData _deviceData = DeviceData(l1: "", l2: "");

  DeviceData get deviceData => _deviceData;

  void setDeviceData() {
    _dbService.setDeviceData(_deviceData);
  }

  bool _isShopping = false;

  bool get isShopping => _isShopping;

  void setShopping() {
    if (!_isShopping) {
      startShopping();
    } else {
      stopShopping();
    }
    _isShopping = !_isShopping;
    notifyListeners();
  }

  void getDeviceData() async {
    setBusy(true);
    DeviceData? deviceData = await _dbService.getDeviceData();
    if (deviceData != null) {
      _deviceData = DeviceData(
        l1: deviceData.l1,
        l2: deviceData.l2,
      );
    } else {
      _deviceData = DeviceData(l1: "", l2: "");
    }
    setBusy(false);
  }

  void setMessageLine1(String value) {
    _deviceData.l1 = value;
    notifyListeners();
    setDeviceData();
  }

  void setMessageLine2(String value) {
    _deviceData.l2 = value;
    notifyListeners();
    setDeviceData();
  }

  void onModelReady() {
    getDeviceData();
  }

  late Timer timer;

  void startShopping() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        checkShopping();
      },
    );
    setMessageLine1("Welcome: ${user!.fullName}");
    setMessageLine2("Add items to cart");
  }

  void stopShopping() async {
    timer.cancel();
    if (_products.isEmpty) return;
    String? id = await _firestoreService.generatePurchaseDocumentId();
    if (id != null) {
      bool isSuccess = await _firestoreService.addPurchase(
          Purchase(id: id, productList: _products, totalCost: totalCost));
      if (isSuccess) {
        setMessageLine1("Shopping completed");
        setMessageLine2("Waiting new user!");
        log.i('Purchase data updated');
        showDialog(title: "Success", description: "Purchase recorded!");
      } else {
        showDialog(title: "Error", description: "Please try again!");
        log.e('Failed to add repair to service');
      }
    }

    _products = <Product>[];
    notifyListeners();
  }

  void showDialog({required String title, required String description}) {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
    );
  }

  List<Product> _products = <Product>[];

  List<Product> get products => _products;

  double get totalCost => calculateTotalCost();

  double calculateTotalCost() {
    double totalCost = 0.0;

    for (var product in _products) {
      totalCost += product.cost;
    }

    return totalCost;
  }

  DateTime lastUpdate = DateTime.now();

  void checkShopping() {
    final DateTime now = DateTime.now();
    final difference =
        now.difference(node?.lastSeen ?? DateTime.now()).inSeconds;

    if (difference.abs() > 1) {
      return; // No need to continue if the condition is not met
    }

    final difference2 = now.difference(lastUpdate).inMilliseconds;
    log.i(difference2);
    if (difference2 < 1500) {
      return;
    }

    lastUpdate = now;

    log.i(node?.rfid);

    if (data == null) {
      return; // No need to continue if data is null
    }

    List<Product> ps =
        data!.where((element) => element.rfid == node!.rfid).toList();

    if (ps.isNotEmpty) {
      _products.add(ps.first);
      setMessageLine1("Product added:");
      setMessageLine2("${ps.first.name}: ${ps.first.cost}");
      notifyListeners();
    }
  }

  void onProductSelected(Product product) {
    // Log the selected product name
    log.i(product.name);
    // Remove the selected product from the list
    _products.remove(product);
    notifyListeners();
  }
}
