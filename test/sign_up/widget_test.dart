import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/custom_widget/input_widget.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/screens/registration_screen.dart';

void main() {
  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final firebaseCollection = FirebaseCollection(
      firebaseAuth: MockFirebaseAuth(mockUser: user),
      firebaseFirestore: FakeFirebaseFirestore(),
      firebaseStorage: MockFirebaseStorage());

  testWidgets('show input boxes', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));
    expect(find.byType(Form), findsOneWidget);
    expect(find.text("First Name"), findsOneWidget);
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    expect(find.text("Confirm Password"), findsOneWidget);
    expect(find.text("Sign Up"), findsOneWidget);
  });

  testWidgets('no input entered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Enter a name"), findsOneWidget);
    expect(find.text("Enter an email address"), findsOneWidget);
    expect(find.text("Password must be 6+ characters"), findsOneWidget);
  });

  testWidgets('no name entered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));
    //await tester.enterText(find.byType(InputWidget).at(0), "Nathan");
    await tester.enterText(find.byType(InputWidget).at(1), "nathan@nathan.com");
    await tester.enterText(find.byType(InputWidget).at(2), "123456");
    await tester.enterText(find.byType(InputWidget).at(3), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Enter a name"), findsOneWidget);
  });

  testWidgets('invalid name entered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));
    await tester.enterText(find.byType(InputWidget).at(0), " between spaces ");
    await tester.enterText(find.byType(InputWidget).at(1), "nathan@nathan.com");
    await tester.enterText(find.byType(InputWidget).at(2), "123456");
    await tester.enterText(find.byType(InputWidget).at(3), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Name must not have leading or trailing whitespaces"),
        findsOneWidget);
  });

  testWidgets('no email', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));

    await tester.enterText(find.byType(InputWidget).at(0), "Nathan");
    //await tester.enterText(find.byType(InputWidget).at(1), "nathan@nathan.com");
    await tester.enterText(find.byType(InputWidget).at(2), "123456");
    await tester.enterText(find.byType(InputWidget).at(3), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Enter an email address"), findsOneWidget);
  });

  testWidgets('invalid email format', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));

    await tester.enterText(find.byType(InputWidget).at(0), "Nathan");
    await tester.enterText(find.byType(InputWidget).at(1), "nathan.com");
    await tester.enterText(find.byType(InputWidget).at(2), "123456");
    await tester.enterText(find.byType(InputWidget).at(3), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Enter a valid email address"), findsOneWidget);
  });

  testWidgets('password less than 6 characters', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));

    await tester.enterText(find.byType(InputWidget).at(0), "Nathan");
    await tester.enterText(find.byType(InputWidget).at(1), "nathan@nathan.com");
    await tester.enterText(find.byType(InputWidget).at(2), "");
    await tester.enterText(find.byType(InputWidget).at(3), "123456");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Password must be 6+ characters"), findsOneWidget);
  });

  testWidgets('passwords not matching', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegistrationScreen(
            toggle: () => {}, firebaseCollection: firebaseCollection)));

    await tester.enterText(find.byType(InputWidget).at(0), "Nathan");
    await tester.enterText(find.byType(InputWidget).at(1), "nathan@nathan.com");
    await tester.enterText(find.byType(InputWidget).at(2), "123456");
    await tester.enterText(find.byType(InputWidget).at(3), "654321");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Confirmation must match password"), findsOneWidget);
  });
}
