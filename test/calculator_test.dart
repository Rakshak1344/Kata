import 'package:flutter_test/flutter_test.dart';
import 'package:kata/calculator.dart';


void main() {
  group("Calculator Test", () {
    late Calculator calculator;

    setUp(() {
      calculator = Calculator();
    });

    group("when calling add(value)", () {
      /// Case 1
      test("should return 0 when given string is empty", () {
        var value = calculator.add("");
        expect(value, 0);
      });

      /// Case 2
      test("should return 1 when given number is 1", () {
        var value = calculator.add("1");
        expect(value, 1);
      });

      /// Case 2
      test("should return 3 when given string is '1,2'", () {
        var value = calculator.add("1,2");
        expect(value, 3);
      });

      // /// Case 2
      test("should return 471 when given string is '//**371,2/f98'", () {
        var value = calculator.parser('//**371,2/f98');
        expect(value, ['//**', '371', ',', '2', '/f', '98']);
      });

      // test("should return 471 when given string is '//**371,2/f98'", () {
      //   var value = calculator.parser(
      //       ['/', '/', '3', '7', '1',',', '2', '/', 'f', '9', '8'], 0);
      //   expect(value, ['371', '2', '9', '8']);
      // });
    });
  });
}
