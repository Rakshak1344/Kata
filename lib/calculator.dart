typedef R = RegEx;

class RegEx {
  static final RegExp number = RegExp(r'[0-9]');
  static final RegExp nonNumber = RegExp(r'[^0-9]');
}

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
    /// [/, /, *, *, 3, 7, 1, ,, 2, /, f, 9, 8]
    /// previous -> *
    /// current -> *
    /// next -> 3
    // find and remove \n in the string
    value = value.replaceAll('\n', '');
    var charList = value.runes.map((c) => String.fromCharCode(c)).toList();

    if (charList.isEmpty) {
      return [];
    }

    if (charList.length == 1) {
      return [charList.first];
    }

    var cursor = 0;
    var temp = "";
    List<String> tempList = [];

    while (charList.length > cursor) {
      var currentChar = charList[cursor];
      var isFirstChar = cursor == 0;
      // var isLastChar = cursor == charList.length - 1;

      // var previousChar = (cursor > 0) ? charList[cursor - 1] : '|';
      var nextChar = cursor != charList.length - 1 ? charList[cursor + 1] : '|';
      // var hasNegativeSign = previousChar == '-';

      // var isPreviousCharANumber = cursor > 0 && R.number.hasMatch(previousChar);
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

extension StringHelper on String {
  bool isInteger() => int.tryParse(this) != null;

  int toInteger() => int.parse(this);

  bool isNegativeInteger() => isInteger() && startsWith('-');
}
