import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets("Game information shown to the user", (WidgetTester tester) async {
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
    expect(find.byKey(Key("make-a-face-screen")), findsOneWidget); // instruction
    expect(find.byKey(Key("emotion-to-pick")), findsOneWidget); // emotion
    expect(find.byKey(Key("user-level")), findsOneWidget); // level
    expect(find.byKey(Key("take-a-picture-button")), findsOneWidget); // take a picture
    expect(find.byKey(Key("user-score")), findsOneWidget); // score
  });
  
}
