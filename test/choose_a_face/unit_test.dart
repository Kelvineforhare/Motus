import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// Mock firebases
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/screens/choose_a_face.dart';

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

  ChooseAFaceLogic cfl =
      ChooseAFaceLogic(firebaseCollection: firebaseCollection);
  test("There are 7 base emotions to pick from", () {
    //Arrange
    int numOfEmotions = cfl.emotionOption.length;

    //Act

    //Assert
    expect(numOfEmotions, equals(7));
  });

  test("Generate random emotions", () {
    //Arrange
    cfl.selectRandomEmotion();
    cfl.generateAnyFace();
    String emotion1 = cfl.emotion1;
    String emotion2 = cfl.emotion2;
    String emotion3 = cfl.emotion3;
    String emotion4 = cfl.emotion4;

    //Act

    //Assert
    expect(cfl.emotionOption.contains(emotion1), true);
    expect(cfl.emotionOption.contains(emotion2), true);
    expect(cfl.emotionOption.contains(emotion3), true);
    expect(cfl.emotionOption.contains(emotion4), true);
  });

  test("Assign emotion number an emotion", () {
    //Arrange
    cfl.assignEmotionNumberAnEmotion(1, cfl.emotionOption[1]);
    cfl.assignEmotionNumberAnEmotion(2, cfl.emotionOption[2]);
    cfl.assignEmotionNumberAnEmotion(3, cfl.emotionOption[3]);
    cfl.assignEmotionNumberAnEmotion(4, cfl.emotionOption[4]);

    //Act
    bool emotion1Matches = (cfl.emotion1 == cfl.emotionOption[1]);
    bool emotion2Matches = (cfl.emotion2 == cfl.emotionOption[2]);
    bool emotion3Matches = (cfl.emotion3 == cfl.emotionOption[3]);
    bool emotion4Matches = (cfl.emotion4 == cfl.emotionOption[4]);

    //Assert
    expect(emotion1Matches, true);
    expect(emotion2Matches, true);
    expect(emotion3Matches, true);
    expect(emotion4Matches, true);
  });

  test("Generate random emotion to select and score", () {
    //Arrange
    cfl.assignEmotionNumberAnEmotion(1, cfl.emotionOption[1]);
    cfl.assignEmotionNumberAnEmotion(2, cfl.emotionOption[2]);
    cfl.assignEmotionNumberAnEmotion(3, cfl.emotionOption[3]);
    cfl.assignEmotionNumberAnEmotion(4, cfl.emotionOption[4]);
    cfl.emotionToPick = cfl.emotionOption[1];
    cfl.score = 0;

    //Act
    cfl.checkScore(1);
    cfl.checkScore(2);

    //Assert
    expect(cfl.score, equals(1));
    expect(cfl.score, equals(1));
  });

  test("Select random emotion to be picked", () {
    //Arrange
    cfl.selectRandomEmotion();
    String emotionPicked = cfl.emotionToPick;

    //Act

    //Assert
    expect(cfl.emotionOption.contains(emotionPicked), true);
  });
}
