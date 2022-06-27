import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/screens/login_screen.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import "package:game_demo/models/firebase_collection.dart";

// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() async {

  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final firebaseCollection = FirebaseCollection(
    firebaseAuth: MockFirebaseAuth(mockUser: user, signedIn: true),
    firebaseFirestore: FakeFirebaseFirestore(),
    firebaseStorage: MockFirebaseStorage()
  );

  await firebaseCollection.firebaseFirestore.collection("Users").doc("someuid").set({
    "bio": "",
    "email": "bob@somedomain.com",
    "name": "Test", 
    "path": ""
  });


  testWidgets("Email, Password fields, and Login button present for user to input information and sign in", (WidgetTester tester) async {
    //Arrange 
    final emailField = find.byKey(ValueKey("email-field")); 
    final passwordField = find.byKey(ValueKey("password-field"));
    final loginButton = find.byKey(ValueKey("login-button"));

    //Act
    await tester.pumpWidget(MaterialApp(home: LoginScreen(toggle: () {}, firebaseCollection: firebaseCollection,)));

    //Assert
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget); 
  });

  testWidgets("Error message shown on screen if user inputs incorrect information", (WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen(toggle: () {}, firebaseCollection: firebaseCollection,)));
    final emailField = find.byKey(ValueKey("email-field")); 
    final passwordField = find.byKey(ValueKey("password-field")); 
    final loginButton = find.byKey(ValueKey("login-button")); 
    await tester.pump(); 

    //Act
    await tester.enterText(emailField, "email"); 
    await tester.enterText(passwordField, "Password123");
    await tester.tap(loginButton); 
    await tester.pump();  

    //Assert
    expect(find.byKey(ValueKey("invalid-email")), findsOneWidget); 

  });

  testWidgets("Error shows for empty email address", (WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen(toggle: () {}, firebaseCollection: firebaseCollection,)));
    final passwordField = find.byKey(ValueKey("password-field")); 
    final loginButton = find.byKey(ValueKey("login-button")); 
    await tester.pump();

    //Act
    await tester.enterText(passwordField, "Password123");
    await tester.tap(loginButton); 
    await tester.pump();

    //Assert
    expect(find.text("Enter an email address"), findsOneWidget); 
  });

  testWidgets("Error shows for empty password field", (WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen(toggle: () {}, firebaseCollection: firebaseCollection,)));
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button")); 
    await tester.pump();

    //Act
    await tester.enterText(emailField, "email@gmail.com");
    await tester.tap(loginButton); 
    await tester.pump();

    //Assert
    expect(find.text("Password must be 6+ characters"), findsOneWidget); 
  });

  testWidgets("Error shows for empty password field and email field", (WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen(toggle: () {}, firebaseCollection: firebaseCollection,)));
    final passwordField = find.byKey(ValueKey("password-field"));  
    final emailField = find.byKey(ValueKey("email-field")); 
    final loginButton = find.byKey(ValueKey("login-button")); 
    await tester.pump();

    //Act
    await tester.enterText(emailField, "");
    await tester.enterText(passwordField, "");
    await tester.tap(loginButton); 
    await tester.pump();

    //Assert
    expect(find.text("Enter an email address"), findsOneWidget);
    expect(find.text("Password must be 6+ characters"), findsOneWidget); 
  });

}