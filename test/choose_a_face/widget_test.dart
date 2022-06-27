import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import "package:game_demo/models/firebase_collection.dart";

main() async {
  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final firebaseCollection = FirebaseCollection(
      firebaseAuth: MockFirebaseAuth(mockUser: user, signedIn: true),
      firebaseFirestore: FakeFirebaseFirestore(),
      firebaseStorage: MockFirebaseStorage());

  await firebaseCollection.firebaseFirestore
      .collection("Users")
      .doc("someuid")
      .set({
    "bio": "",
    "email": "bob@somedomain.com",
    "name": "Test",
    "path": ""
  });

  // testWidgets("Emotion to pick shown to screen", (WidgetTester tester) async {
  //   //Arrange
  //   final emotionToPick = find.byKey(ValueKey("emotion-to-pick"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(firebaseCollection: firebaseCollection)));

  //   //Assert
  //   expect(emotionToPick, findsOneWidget);
  // });

  // testWidgets("Widget to display facial expressions shown to screen", (WidgetTester tester) async {
  //   //Arrange
  //   final facialExpressionDisplayer = find.byKey(ValueKey("facial-expressions"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(firebaseCollection: firebaseCollection,)));

  //   //Assert
  //   expect(facialExpressionDisplayer, findsOneWidget);
  // });

  // testWidgets("Score shown to screen", (WidgetTester tester) async {
  //   //Arrange
  //   final scoreOutput = find.byKey(ValueKey("score"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(firebaseCollection: firebaseCollection,),));

  //   //Assert
  //   expect(scoreOutput, findsOneWidget);
  // });

  // testWidgets("Menu bar displayed on screen during game", (WidgetTester tester) async {
  //   //Arrange
  //   final menuBar = find.byType(MenuBar);

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(firebaseCollection: firebaseCollection,)));

  //   //Assert
  //   expect(menuBar, findsOneWidget);
  // });

  // testWidgets("Player level shown to screen", (WidgetTester tester) async {
  //   //Arrange
  //   final playerLevelDisplay = find.byKey(Key("player-level-display"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(firebaseCollection: firebaseCollection,)));

  //   //Assert
  //   expect(playerLevelDisplay, findsOneWidget);
  // });

  // testWidgets("When correct emotion selected score goes up 1", (WidgetTester tester) async {
  //   //Arrange
  //   final score = find.byKey(ValueKey("score"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(firebaseCollection: firebaseCollection,)));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(IconButton).first);
  //   await tester.pumpAndSettle();

  //   //Assert
  //   expect(score, findsOneWidget);
  // });

  // testWidgets("4 facial expression images shown to screen", (WidgetTester tester) async {
  //   //Arrange
  //   final facialExpression = find.byKey(ValueKey("facial-expression"));

  //   //Act
  //   await tester.pumpWidget(MaterialApp(home: ChooseAFace(),), Duration(seconds: 15));

  //   //Assert
  //   expect(facialExpression, findsNWidgets(4));
  // });
}
