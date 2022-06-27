import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Clicking choose a face takes user to choose a face game", (WidgetTester tester) async {
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
    await tester.enterText(find.byKey(ValueKey("email-field")), "test@login.com"); 
    await tester.enterText(find.byKey(ValueKey("password-field")), "123456");
    await tester.pump();
    await tester.tap(find.byKey(ValueKey("login-button"))); 
    await tester.pumpAndSettle(Duration(seconds: 4));

    //Act 
    await tester.tap(find.byKey(ValueKey("choose-a-face-option")));
    await tester.pumpAndSettle(Duration(seconds: 4)); 

    //Assert
    expect(find.byKey(ValueKey("choose-a-face-screen")), findsOneWidget); 
  });

  testWidgets("Clicking learn a face takes user to learn a face game", (WidgetTester tester) async {
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
    await tester.enterText(find.byKey(ValueKey("email-field")), "test@login.com"); 
    await tester.enterText(find.byKey(ValueKey("password-field")), "123456");
    await tester.pump();
    await tester.tap(find.byKey(ValueKey("login-button"))); 
    await tester.pumpAndSettle();

    //Act 
    await tester.tap(find.byKey(ValueKey("learn-a-face-option")));
    await tester.pumpAndSettle(Duration(seconds: 4)); 

    //Assert
    expect(find.byKey(ValueKey("learn-a-face-screen")), findsOneWidget); 
  });

  testWidgets("Clicking make a face takes user to make a face game", (WidgetTester tester) async {
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
    await tester.enterText(find.byKey(ValueKey("email-field")), "test@login.com"); 
    await tester.enterText(find.byKey(ValueKey("password-field")), "123456");
    await tester.pump();
    await tester.tap(find.byKey(ValueKey("login-button"))); 
    await tester.pumpAndSettle();

    //Act 
    await tester.tap(find.byKey(ValueKey("make-a-face-option")));
    await tester.pumpAndSettle(Duration(seconds: 4)); 

    //Assert
    expect(find.byKey(Key("make-a-face-screen")), findsOneWidget); 
  });
}
