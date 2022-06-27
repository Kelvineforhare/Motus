import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Login", () {
  testWidgets("Valid login takes user to home screen", (WidgetTester tester) async {
    //Arrange
    app.main(); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //if user logged in
    if(find.byKey(Key("choose-a-face-option")).evaluate().isNotEmpty) {
    
      //sign out
      await tester.tap(find.text("Profile"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign-out")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign-out-option")));
      await tester.pumpAndSettle(); 
    }

    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button")); 

    //Act
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle();

    //Assert
    expect(find.byKey(ValueKey("choose-a-face-option")), findsOneWidget);  
  });

  testWidgets("Clicking 'Dont have an account?' takes user to registration page", (WidgetTester tester) async {
    //Arrange
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 4)); 

    if(find.byKey(Key("choose-a-face-option")).evaluate().isNotEmpty) {
    
      //sign out
      await tester.tap(find.text("Profile"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign-out")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign-out-option")));
      await tester.pumpAndSettle(); 
    } 

    final register = find.byKey(ValueKey("register")); 

    //Act
    await tester.tap(register); 
    await tester.pumpAndSettle(Duration(seconds: 4)); 

    //Assert 
    expect(find.text("Already have an account? Log in"), findsOneWidget);
  });

  });
}
