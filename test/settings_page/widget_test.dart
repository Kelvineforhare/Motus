import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/screens/change_password.dart';
import 'package:game_demo/screens/edit_profile.dart';
import 'package:game_demo/screens/settings_page.dart';

import "package:game_demo/models/firebase_collection.dart";

// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_demo/screens/user_profile.dart';

void main() async{
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

  // testWidgets("Displays edit profile option", (WidgetTester tester) async {
  //   //Arrange
  //   final editProfileOption = find.byKey(ValueKey("edit-profile"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: SettingsPage(firebaseCollection: firebaseCollection))); 

  //   //Assert 
  //   expect(editProfileOption, findsOneWidget); 
  // });

  // testWidgets("Displays change password option", (WidgetTester tester) async {
  //   //Arrange
  //   final changePasswordOption = find.byKey(ValueKey("change-password"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: SettingsPage(firebaseCollection: firebaseCollection))); 

  //   //Assert 
  //   expect(changePasswordOption, findsOneWidget); 
  // });

  // testWidgets("User is shown 'Settings' on app bar", (WidgetTester tester) async {
  //   //Arrange
  //   final profileDisplay = find.byKey(ValueKey("settings-display"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: SettingsPage(firebaseCollection: firebaseCollection),));

  //   //Assert 
  //   expect(profileDisplay, findsOneWidget);
  // });

  // testWidgets("User is shown 'account' on top of page", (WidgetTester tester) async {
  //   //Arrange
  //   final accountDisplay = find.byKey(ValueKey("account-display"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: SettingsPage(firebaseCollection: firebaseCollection),));

  //   //Assert 
  //   expect(accountDisplay, findsOneWidget);
  // });

  // testWidgets("Change password option takers user to change password page", (WidgetTester tester) async {
  //   //Arrange
  //   final changePasswordOption = find.byKey(ValueKey("change-password"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: SettingsPage(firebaseCollection: firebaseCollection),));
  //   await tester.tap(changePasswordOption); 
  //   await tester.pumpAndSettle(); 

  //   //Assert
  //   expect(find.byKey(Key("change-password-button")), findsOneWidget);
  // });
}