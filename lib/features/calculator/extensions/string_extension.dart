extension StringExtension on String {
  bool isInteger() => int.tryParse(this) != null;

  int toInteger() => int.parse(this);

  bool isNegativeInteger() => isInteger() && startsWith('-');
}
