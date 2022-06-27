import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/input_widget.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;



bool keyExists(Key key) {
  return find.byKey(key).evaluate().isNotEmpty;
}


bool isLoggedIn()  {
  return keyExists(Key("navbar"));
}


Future<void> signOut(WidgetTester tester) async {
  if (isLoggedIn()) {
    await tester.tap(find.byKey(Key("profile-link")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("sign-out")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("sign-out-option")));
    await tester.pumpAndSettle();
  }
}


List<Key> getAllIncorrect() {
  if (!keyExists(Key("incorrect1"))) {
    return [Key("incorrect2"), Key("incorrect3"), Key("incorrect4")];
  }
  else if (!keyExists(Key("incorrect2"))) {
    return [Key("incorrect1"), Key("incorrect3"), Key("incorrect4")];
  }
  else if (!keyExists(Key("incorrect3"))) {
    return [Key("incorrect1"), Key("incorrect2"), Key("incorrect4")];
  }
  else {
    return [Key("incorrect1"), Key("incorrect2"), Key("incorrect3")];
  }
}


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("emotions load", (WidgetTester tester) async {
  	app.main();

    await tester.pumpAndSettle(Duration(milliseconds: 1500)); 
    await signOut(tester);

    await tester.enterText(find.byKey(Key("email-field")), "test@login.com");
    await tester.enterText(find.byKey(Key("password-field")), "123456");
  	await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("learn-a-face")));
    await tester.pumpAndSettle(Duration(milliseconds: 1000));

    expect(find.byKey(Key("emotion-image")), findsOneWidget);
    expect(find.byKey(Key("answer")), findsOneWidget);

    final incorrectKeys = getAllIncorrect();
    expect(find.byKey(incorrectKeys[0]), findsOneWidget);
    expect(find.byKey(incorrectKeys[1]), findsOneWidget);  
    expect(find.byKey(incorrectKeys[2]), findsOneWidget);   
  });

  testWidgets("pressing the correct answer", (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle(Duration(milliseconds: 1500));   
    await signOut(tester);
  
    await tester.enterText(find.byKey(Key("email-field")), "test@login.com");
    await tester.enterText(find.byKey(Key("password-field")), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("learn-a-face")));
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    
    await tester.tap(find.byKey(Key("answer")));
    await tester.pumpAndSettle();
    
    expect(find.text("1 / 5"), findsOneWidget);
  });

  testWidgets("pressing the incorrect answer", (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle(Duration(milliseconds: 1500));   
    await signOut(tester);

    await tester.enterText(find.byKey(Key("email-field")), "test@login.com");
    await tester.enterText(find.byKey(Key("password-field")), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("learn-a-face")));
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    
    final incorrectKeys = getAllIncorrect();
    await tester.tap(find.byKey(incorrectKeys[0]));
    await tester.pumpAndSettle();

    expect(find.text("0 / 5"), findsOneWidget);
  });
}