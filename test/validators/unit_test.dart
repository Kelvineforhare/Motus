import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/models/validators.dart';

main() {
  test("Password less than 6 characters long returns error string", () {
    var result = PasswordFieldValidator.validate(""); 
    expect(result, "Password must be 6+ characters"); 
  });

  test("Password with 6+ characters long does not return error string", () {
    var result = PasswordFieldValidator.validate("Password123"); 
    expect(result, null); 
  });

  test("Error returned when passwords entered do not match", () {
    var result = ConfirmPasswordFieldValidator.validate("Password123", "Password");
    expect(result, "Confirmation must match password"); 
  }); 

  test("No error returned when passwords entered do match", () {
    var result = ConfirmPasswordFieldValidator.validate("Password123", "Password123");
    expect(result, null); 
  }); 

  test("Empty email field returns error string", () {
    var result = EmailFieldValidator.validate(""); 
    expect(result, "Enter an email address"); 
  });

  test("Email in wrong format gives error string", () {
    var result = EmailFieldValidator.validate("email"); 
    expect(result, "Enter a valid email address"); 
  });

  test("No error returned for valid email", () {
    var result = EmailFieldValidator.validate("valid@email.com"); 
    expect(result,  null); 
  });

  test("Error returned when name is empty", () {
    var result = NameFieldValidator.validate(""); 
    expect(result,  "Enter a name");
  });

  test("Error returned when name has leading or trailing whitespaces", () {
    var result = NameFieldValidator.validate(" between spaces "); 
    expect(result, "Name must not have leading or trailing whitespaces");
  });

  test("No error returned for valid name", () {
    var result = NameFieldValidator.validate("valid name"); 
    expect(result, null);
  });
}