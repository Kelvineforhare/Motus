import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:game_demo/models/firebase_collection.dart";

// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_demo/screens/change_password.dart';
import 'package:game_demo/screens/user_profile.dart';

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

    testWidgets("Password input field shown to screen", (WidgetTester tester) async {
    //Arrange
    final passwordField = find.byKey(ValueKey("password-field")); 

    //Act
    await tester.pumpWidget(MaterialApp(home: ChangePassword(firebaseCollection: firebaseCollection,),)); 

    //Assert
    expect(passwordField, findsOneWidget); 
  });

  testWidgets("Confirm password input field shown to screen", (WidgetTester tester) async {
    //Arrange
    final confirmPasswordField = find.byKey(ValueKey("confirm-password-field")); 

    //Act
    await tester.pumpWidget(MaterialApp(home: ChangePassword(firebaseCollection: firebaseCollection,)));

    //Assert
    expect(confirmPasswordField, findsOneWidget);
  });

  testWidgets("Change password button shown to screen", (WidgetTester tester) async {
    //Arrange
    final loginButton = find.byKey(ValueKey("change-password-button")); 

    //Act
    await tester.pumpWidget(MaterialApp(home: ChangePassword(firebaseCollection: firebaseCollection,)));

    //Assert
    expect(loginButton, findsOneWidget);
  });

  testWidgets("Error thrown for password input that is less than 6 characters", (WidgetTester tester) async {
    //Arrange
    final loginButton = find.byKey(ValueKey("change-password-button"));

    //Act
    await tester.pumpWidget(MaterialApp(home: ChangePassword(firebaseCollection: firebaseCollection,))); 
    await tester.tap(loginButton); 
    await tester.pump(); 

    //Assert
    expect(find.text("Password must be 6+ characters"), findsOneWidget);
  });

  testWidgets("Password must match confirmation password", (WidgetTester tester) async {
    //Arrange
    final passwordField = find.byKey(ValueKey("password-field")); 
    final confirmPasswordField = find.byKey(ValueKey("confirm-password-field")); 
    final loginButton = find.byKey(ValueKey("change-password-button"));

    //Act
    await tester.pumpWidget(MaterialApp(home: ChangePassword(firebaseCollection: firebaseCollection,))); 
    await tester.enterText(passwordField, "Password123"); 
    await tester.enterText(confirmPasswordField, "Passwrod1234546"); 
    await tester.pump();
    await tester.tap(loginButton); 
    await tester.pump(); 

    //Assert
    expect(find.text("Confirmation must match password"), findsOneWidget);
  });
}