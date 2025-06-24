typedef R = RegEx;

class RegEx {
  static final RegExp number = RegExp(r'[0-9]');
  static final RegExp nonNumber = RegExp(r'[^0-9]');
}