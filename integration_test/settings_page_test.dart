import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Edit profile option takers user to edit profile page ", (WidgetTester tester) async {
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

    //sign in
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //go to settings page
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Settings")); 
    await tester.pumpAndSettle(Duration(seconds: 3));

    //Act 
    await tester.tap(find.byKey(Key("edit-profile"))); 
    await tester.pumpAndSettle(Duration(seconds: 3)); 

    //Assert
    expect(find.byKey(Key("edit-profile-screen")), findsOneWidget); 
  });
  
  testWidgets("Dark mode option displayed to user", (WidgetTester tester) async {
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

    //sign in
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //go to settings page
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Settings")); 
    await tester.pumpAndSettle(Duration(seconds: 3));

    //Act 

    //Assert
    expect(find.byKey(Key("dark-mode")), findsOneWidget); 
  });

  testWidgets("Displays edit profile option", (WidgetTester tester) async {
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

    //sign in
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //go to settings page
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Settings")); 
    await tester.pumpAndSettle(Duration(seconds: 3));

    //Act 

    //Assert
    expect(find.byKey(Key("edit-profile")), findsOneWidget); 
  });

  testWidgets("Displays change password option", (WidgetTester tester) async {
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

    //sign in
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //go to settings page
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Settings")); 
    await tester.pumpAndSettle(Duration(seconds: 3));

    //Act 

    //Assert
    expect(find.byKey(Key("change-password")), findsOneWidget); 
  });

  testWidgets("User is shown 'Settings' on app bar", (WidgetTester tester) async {
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

    //sign in
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //go to settings page
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Settings")); 
    await tester.pumpAndSettle(Duration(seconds: 3));

    //Act 

    //Assert
    expect(find.byKey(Key("settings-display")), findsOneWidget); 
  });

  testWidgets("Change password option takers user to change password page", (WidgetTester tester) async {
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

    //sign in
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button"));
    await tester.enterText(emailField, "test@login.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //go to settings page
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Settings")); 
    await tester.pumpAndSettle(Duration(seconds: 3));

    //Act 

    //Assert
    expect(find.byKey(Key("change-password")), findsOneWidget); 
  });
}
