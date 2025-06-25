import 'package:kata/features/calculator/services/regex.dart';
import 'package:kata/features/calculator/extensions/string_extension.dart';

class Calculator {
  int add(String value) {
    if (value.isEmpty) {
      return 0;
    }

    var intNumber = int.tryParse(value);
    if (value.length == 1 && intNumber != null && !intNumber.isNaN) {
      return intNumber;
    }

    var parsedList = parser(value);
    if (parsedList.isEmpty) {
      return 0;
    }

    var negativeIntegerList = [];
    var integerList =
        parsedList.where((n) {
          if (n.isNegativeInteger()) {
            negativeIntegerList.add(n);
            return false;
          }

          if (n.isInteger() && n.toInteger() > 1000) {
            return false;
          }

          return n.isInteger();
        }).toList();

    if (negativeIntegerList.isNotEmpty) {
      throw Exception(
        negativeIntegerList.length == 1
            ? "Negative number is not allowed: ${negativeIntegerList.first}"
            : "Negative numbers are not allowed: ${negativeIntegerList.join(', ')}",
      );
    }

    return integerList.map((e) => e.toInteger()).reduce((a, b) => a + b);
  }

  List<String> parser(String value) {
    value = value.replaceAll('\n', '');
    var charList = value.runes.map((c) => String.fromCharCode(c)).toList();

    if (charList.isEmpty) {
      return [];
    }

    if (charList.length == 1) {
      return [charList.first];
    }

    int cursor = 0;
    String temp = "";
    List<String> tempList = [];

    while (charList.length > cursor) {
      var currentChar = charList[cursor];
      var isFirstChar = cursor == 0;
      var nextChar = cursor != charList.length - 1 ? charList[cursor + 1] : '|';
      var isCurrentCharANumber = R.number.hasMatch(currentChar);
      var isNextCharANumber =
          cursor < charList.length - 1 && R.number.hasMatch(nextChar);
      var shouldReset =
          (isCurrentCharANumber && !isNextCharANumber) ||
          (!isCurrentCharANumber && isNextCharANumber);

      // Handle the first character blindly
      if (isFirstChar) {
        temp += currentChar;
        if (shouldReset) {
          tempList.add(temp);
          temp = "";
        }
        cursor++;
        continue;
      }

      /// When to reset the temp variable
      if (shouldReset) {
        var isCurrentCharNegative = currentChar == '-';
        if (!isCurrentCharNegative) {
          temp += currentChar;
        }
        tempList.add(temp);
        temp = isCurrentCharNegative ? "-" : "";
        cursor++;
        continue;
      }

      temp += currentChar;

      cursor++;
    }

    tempList = tempList.where((e) => e.isNotEmpty).toList();

    return tempList;
  }
}
