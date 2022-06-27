import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/input_widget.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_demo/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("user's profile displayed", (WidgetTester tester) async {
  	app.main();

    await tester.pumpAndSettle(Duration(milliseconds: 1500)); 

    await tester.enterText(find.byKey(Key("email-field")), "test@login.com");
    await tester.enterText(find.byKey(Key("password-field")), "123456");
  	await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("profile-link")));
    await tester.pumpAndSettle(Duration(milliseconds: 1000));

    expect(find.byKey(Key("profile-picture")), findsOneWidget);
    expect(find.byKey(Key("name")), findsOneWidget);
    expect(find.byKey(Key("email")), findsOneWidget);
    expect(find.byKey(Key("bio")), findsOneWidget);
    expect(find.text("Statistics"), findsOneWidget);
    expect(find.text("Settings"), findsOneWidget);
    expect(find.byKey(Key("sign-out")), findsOneWidget); 

    await tester.tap(find.text("Statistics"));    
    await tester.pumpAndSettle(Duration(milliseconds: 1000));

    expect(find.text("Choose a Face Level"), findsOneWidget);
    expect(find.text("Learn a Face Level"), findsOneWidget);
    expect(find.text("Make a Face Level"), findsOneWidget);    
  });
}