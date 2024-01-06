import 'package:flutter_test/flutter_test.dart';
import 'package:smart_shopping_cart_flutter/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AdminViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
