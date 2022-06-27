class EmailFieldValidator {
  static String? validate(String? value) {
    String str = value.toString();
    if(str.isEmpty) {
      return "Enter an email address"; 
    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(str);
    return !emailValid ? "Enter a valid email address" : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String? value) {
    return value!.length < 6 ? "Password must be 6+ characters" : null;  
  }
}

class ConfirmPasswordFieldValidator {
  static String? validate(String? value, String? pwControllerTxt) {
    return value != pwControllerTxt ? "Confirmation must match password" : null;
  }
}

class NameFieldValidator {
  static String? validate(String? value) {
    if (value!.isEmpty) return "Enter a name";
    String str = value.toString();
    return (str[0] == ' ' || str[str.length - 1] == ' ') ? "Name must not have leading or trailing whitespaces" : null;
  }
}