extension StringExtension on String {
  static String empty() {
    return '';
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  bool isValidEmail() {
    return isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(this);
  }

  bool isValidPassword() {
    return isNotEmpty &&
        RegExp(r"^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,12}$").hasMatch(this);
  }
}
