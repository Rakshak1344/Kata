import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

class Calculator {
  int add(String numberString) {
    if (numberString.isEmpty) {
      return 0;
    }

    var intNumber = int.tryParse(numberString);
    if (numberString.length == 1 && intNumber != null && !intNumber.isNaN) {
      return intNumber;
    }

    return 0;
  }
}

void main() {
  group("Calculator Test", () {
    late Calculator calculator;

    setUp(() {
      calculator = Calculator();
    });

    group("when calling add()", () {
      /// Case 1
      test("should return 0 when given string is empty", () {
        var value = calculator.add("");
        expect(value, 0);
      });

      /// Case 2
      test("should return 1 when given number is 1", () {
        var value = calculator.add("10s\\910uc");
        expect(value, 100);
      });
    });
  });
}
