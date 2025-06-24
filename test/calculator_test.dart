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

      /// Case 3
      test("should return 6 when given string is '1,5'", () {
        var value = calculator.add("1,5");
        expect(value, 6);
      });

      /// Case 4
      test("should return 3 when given string is '//;\n1;2'", () {
        var value = calculator.add("//;\n1;2");
        expect(value, 3);
      });

      /// Case 5
      test("should return 6 when given string is '//;\n1;2'", () {
        var value = calculator.add("//;\n1;2");
        expect(value, 3);
      });

      /// Case 6
      test("should throw error when one negative number is present", () {
        expect(
          () => calculator.add("//;\n-100;5"),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains("Negative number is not allowed: -100"),
            ),
          ),
        );
      });

      /// Case 7
      test("should throw error when multiple negative numbers are present", () {
        expect(
          () => calculator.add("//;\n-10;-5\n-2"),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains(
                    "Negative numbers are not allowed: -10, -5, -2",
                  ),
            ),
          ),
        );
      });

      /// Case 8
      test("should return 2 when given string is '2+1001'", () {
        var value = calculator.add("2+1001");
        expect(value, 2);
      });
    });

    group("Test Parser should return expected list", () {
      /// Case 1
      test("when given string is '//**371,2/f98'", () {
        var value = calculator.parser('//**371,2/f98');
        expect(value, ['//**', '371', ',', '2', '/f', '98']);
      });

      /// Case 2
      test("when given string is '//**-371,-2/f98'", () {
        var value = calculator.parser('//**-371,-2/f98');
        expect(value, ['//**', '-371', ',', '-2', '/f', '98']);
      });

      /// Case 3
      test("when given string is '//**-371,-2/f9-8'", () {
        var value = calculator.parser('//**-371,-2/f9-8');
        expect(value, ['//**', '-371', ',', '-2', '/f', '9', '-8']);
      });
    });
  });
}
