import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/input_widget.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("sign up button leads to the home page", (WidgetTester tester) async {
  	app.main();

    await tester.pumpAndSettle(Duration(milliseconds: 2000));  	

  	await tester.tap(find.byKey(Key("sign-up-link")));
  	await tester.pumpAndSettle();

  	await tester.enterText(find.byKey(Key("first-name-field")), "tester");
    await tester.enterText(find.byKey(Key("email-field")), "nathan@nathan.com");
    await tester.enterText(find.byKey(Key("password-field")), "123456");
    await tester.enterText(find.byKey(Key("confirm-password-field")), "123456");  
    await tester.tap(find.byKey(Key("sign-up")));

    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    expect(find.byKey(Key("home-screen")), findsOneWidget);
  });
}
