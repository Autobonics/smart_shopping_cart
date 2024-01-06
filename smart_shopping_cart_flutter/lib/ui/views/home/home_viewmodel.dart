import 'dart:async';

import 'package:smart_shopping_cart_flutter/app/app.locator.dart';
import 'package:smart_shopping_cart_flutter/app/app.router.dart';
import 'package:smart_shopping_cart_flutter/models/appuser.dart';
import 'package:smart_shopping_cart_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.logger.dart';
import '../../../services/database_service.dart';
import '../../../models/device.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();
  final _userService = locator<UserService>();
  AppUser? get user => _userService.user;
  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  DeviceReading? get node => _dbService.node;

  @override
  List<DatabaseService> get listenableServices => [_dbService];

  //Device data
  DeviceData _deviceData = DeviceData(l1: "", l2: "");

  DeviceData get deviceData => _deviceData;

  void setDeviceData() {
    _dbService.setDeviceData(_deviceData);
  }

  bool _isShopping = false;
  bool get isShopping => _isShopping;

  void setShopping() {
    _isShopping = !_isShopping;
    notifyListeners();
    if (!_isShopping) {
      startShopping();
    } else {
      stopShopping();
    }
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
  }

  void stopShopping() {
    timer.cancel();
  }

  void checkShopping() {}
}
