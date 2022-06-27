import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_demo/screens/choose_a_face.dart';
import 'package:game_demo/screens/game_screen.dart';
import 'package:game_demo/screens/learn_a_face.dart';

import 'package:game_demo/models/player.dart';
import "package:game_demo/models/firebase_collection.dart";

// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
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
    "name": "tester", 
    "path": "",
    "chooseFaceLevel": 1,
    "firstLoad": false,
    "learnFaceLevel": 1,
    "makeFaceLevel": 1
  });

  testWidgets("Displays choose a face game", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(500, 1000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final chooseAFaceOption = find.byKey(ValueKey("choose-a-face-option"));

    //Act
    await tester.pumpWidget(MaterialApp(       
      home: Provider<Player?>.value(
        value: Player(playerId: "someuid"),
        child: GameScreen(firebaseCollection: firebaseCollection)
      )
    )); 

    //Assert
    expect(chooseAFaceOption, findsOneWidget); 
  });

  testWidgets("Displays learn a face game", (WidgetTester tester) async {
    //Arrange
    final learnAFaceOption = find.byKey(ValueKey("learn-a-face-option"));

    //Act
    await tester.pumpWidget(MaterialApp(home: GameScreen(firebaseCollection: firebaseCollection,))); 

    //Assert
    expect(learnAFaceOption, findsOneWidget); 
  });

  testWidgets("Displays make a face game", (WidgetTester tester) async {
    //Arrange
    final makeAFaceOption = find.byKey(ValueKey("make-a-face-option"));

    //Act
    await tester.pumpWidget(MaterialApp(home: GameScreen(firebaseCollection: firebaseCollection,),));

    //Assert
    expect(makeAFaceOption, findsOneWidget); 
  });
}