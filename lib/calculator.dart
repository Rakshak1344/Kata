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



    // var charList = value.runes.map((c) => String.fromCharCode(c)).toList();

    // var number = charList.firstWhereOrNull((e) => R.number.hasMatch(e));
    // var numberIndex = charList.indexOf(number!);
    // var nextNumber = int.tryParse(charList[numberIndex + 1]);
    // if (numberIndex != -1 && nextNumber != null && !nextNumber.isNaN) {
    //   number = number + nextNumber.toString();
    // }
    //
    // print(number);

    // var specialCharList = [];
    // var numberCharList =
    // charList.where((e) {
    //   var isNumber = R.number.hasMatch(e);
    //   if (!isNumber) {
    //     specialCharList.add(e);
    //   }
    //
    //   return isNumber;
    // }).toList();
    // print(specialCharList);
    // print(numberCharList);

    // reduce method on numberCharList to sum the numbers

    return 0;
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

      // Handle the first character blindly
      if (isFirstChar) {
        temp += currentChar;
        cursor++;
        continue;
      }

      // var previousChar = (cursor > 0) ? charList[cursor - 1] : '|';
      var nextChar = cursor != charList.length - 1 ? charList[cursor + 1] : '|';
      // var hasNegativeSign = previousChar == '-';

      // var isPreviousCharANumber = cursor > 0 && R.number.hasMatch(previousChar);
      var isCurrentCharANumber = R.number.hasMatch(currentChar);
      var isNextCharANumber =
          cursor < charList.length - 1 && R.number.hasMatch(nextChar);

      /// When to reset the temp variable
      if ((isCurrentCharANumber && !isNextCharANumber) ||
          (!isCurrentCharANumber && isNextCharANumber)) {
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


