import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/models/validators.dart';

main() {
  test("Password less than 6 characters long returns error string", () {
    //Arrange
    var result = PasswordFieldValidator.validate(""); 

    //Act

    //Assert
    expect(result, "Password must be 6+ characters"); 
  });

  test("Password with 6+ characters long does not return error string", () {
    //Arrange
    var result = PasswordFieldValidator.validate("Password123"); 

    //Act

    //Assert
    expect(result, null); 
  });

  test("Error returned when passwords entered do not match", () {
    //Arrange
    var result = ConfirmPasswordFieldValidator.validate("Password123", "Password");

    //Act

    //Assert
    expect(result, "Confirmation must match password"); 
  }); 

  test("No error returned when passwords entered do match", () {
    //Arrange
    var result = ConfirmPasswordFieldValidator.validate("Password123", "Password123");

    //Act

    //Assert
    expect(result, null); 
  }); 
}