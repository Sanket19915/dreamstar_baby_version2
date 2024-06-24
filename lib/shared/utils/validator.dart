class ValidationsAll {
  static bool isAlphabet(String input) {
    return !onlyAlpha.hasMatch(input);
  }

  static bool isValidPassword(String input) {
    return !input.contains(" ") && input.length >= 6;
  }

  static bool isValidPhoneNumber(String value) {
    return phoneValidation.hasMatch(value);
  }

  static final onlyAlpha = RegExp(r'[0-9\s]');

  static final phoneValidation =
      RegExp(r'^\+?1?\d{9,15}$'); // Example for international phone numbers
}
