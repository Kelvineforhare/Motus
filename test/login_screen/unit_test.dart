import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/models/validators.dart';

main() {
  test("Empty email field returns error string", () {
    //Arrange
    var result = EmailFieldValidator.validate(""); 

    //Act

    //Assert
    expect(result, "Enter an email address"); 
  });

  test("Email in wrong format gives error string", () {
    //Arrange
    var result = EmailFieldValidator.validate("email"); 

    //Act

    //Assert
    expect(result, "Enter a valid email address"); 
  });


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
}