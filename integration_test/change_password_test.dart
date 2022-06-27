import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("When password changed user is taken to user profile screen", (WidgetTester tester) async {
      //Arrange
      app.main(); 
      await tester.pumpAndSettle(Duration(seconds: 4));
      
      //if user is signed in
      if(find.byKey(Key("choose-a-face-option")).evaluate().isNotEmpty) {

        //sign out
        await tester.tap(find.text("Profile"));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key("sign-out")));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key("sign-out-option")));
        await tester.pumpAndSettle(); 
    }
      
      //sign in 
      final passwordField = find.byKey(ValueKey("password-field"));  
      final emailField = find.byKey(ValueKey("email-field")); 
      final loginButton = find.byKey(ValueKey("login-button"));
      await tester.enterText(emailField, "changepasswordtest@gmail.com");
      await tester.enterText(passwordField, "password123");
      await tester.pump();
      await tester.tap(loginButton); 
      await tester.pumpAndSettle(Duration(seconds: 4));

      //go to change password screen
      await tester.tap(find.text("Profile"));
      await tester.pumpAndSettle(Duration(seconds: 4));
      await tester.tap(find.text("Settings")); 
      await tester.pumpAndSettle(Duration(seconds: 4));
      await tester.tap(find.byKey(Key("change-password"))); 
      await tester.pumpAndSettle(Duration(seconds: 4));

      //Act 
      await tester.enterText(find.byKey(Key("password-field")), "password123456");
      await tester.enterText(find.byKey(Key("confirm-password-field")), "password123456");
      await tester.pump();
      await tester.tap(find.byKey(Key("change-password-button")));
      await tester.pumpAndSettle(Duration(seconds: 4));

      //Assert
      expect(find.byKey(Key("profile-page")), findsOneWidget); 
  });

  testWidgets("New password is valid in sign in once password has been successfully changed", (WidgetTester tester) async{
    //Arrange
    app.main(); 
    await tester.pumpAndSettle(Duration(seconds: 4));
    
    //if user is signed in
    if(find.byKey(Key("choose-a-face-option")).evaluate().isNotEmpty) {

      //sign out
      await tester.tap(find.text("Profile"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign-out")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign-out-option")));
      await tester.pumpAndSettle(); 
    }

    //Act
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "changepasswordtest@gmail.com");
    await tester.enterText(passwordField, "password123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //Assert
    expect(find.byKey(Key("choose-a-face-option")), findsOneWidget);
  });
}
