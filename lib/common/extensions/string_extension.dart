extension StringExtension on String {
  bool isValidEmail() {
    return isNotEmpty && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }

  bool isValidPassword() {
    return isNotEmpty && RegExp(r"^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,12}$").hasMatch(this);
  }
}