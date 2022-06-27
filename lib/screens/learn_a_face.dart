import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/emotion_image_widget.dart';
import 'package:game_demo/loading.dart';
import 'package:game_demo/models/face_loader.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/models/player.dart';
import 'package:game_demo/screens/home_page.dart';
import 'package:game_demo/services/auth_function.dart';
import 'package:game_demo/services/database.dart';
import 'package:game_demo/services/global_colours.dart';
import 'package:provider/provider.dart';

class LearnAFace extends StatefulWidget {
  final FirebaseCollection firebaseCollection;

  const LearnAFace({Key? key, required this.firebaseCollection})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LearnAFaceLogic(firebaseCollection: firebaseCollection);
  }
}

//enum Emotion { Angry, Disgust, Fear, Happy, Neutral, Sad, Suprise }

class LearnAFaceLogic extends State<LearnAFace> {
  final FirebaseCollection firebaseCollection;
  late FaceLoader faceLoader;
  late AuthFunction authFunction;

  AudioCache cache = new AudioCache();

  bool firstLoad = true;
  int score = 0;
  int level = 1;
  int scoreForNewLevel = 5;

  String emotionToPick = "";
  String emotion1 = "";
  String emotion2 = "";
  String emotion3 = "";
  String emotion4 = "";

  Map<String, Color> getColour = {
    "Angry": Colors.red,
    "Disgust": Colors.green,
    "Fear": Colors.purple,
    "Happy": Colors.yellow,
    "Neutral": Colors.grey,
    "Sad": Colors.blue,
    "Surprise": Colors.pink,
  };

  List<String> emotionOption = [
    "Sad",
    "Happy",
    "Angry",
    "Disgust",
    "Fear",
    "Neutral",
    "Surprise",
  ];

  final height = window.physicalSize.height / 4;
  final width = window.physicalSize.width;

  LearnAFaceLogic({required this.firebaseCollection}) {
    faceLoader = FaceLoader(firebaseCollection: firebaseCollection);
    authFunction = AuthFunction(firebaseCollection: firebaseCollection);
  }

  //able to go back?
  //Tick and cross screen when answering questions
  @override
  Widget build(BuildContext context) {
    Global globalColours = new Global();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final player = Provider.of<Player?>(context);
    if (firstLoad) {
      cache.loadAll([
        'sounds/success-1-6297.mp3',
        'sounds/fail.mp3',
      ]);
      generateRandomEmotionToSelect();
      firstLoad = false;
    }
    return StreamBuilder<PlayerData>(
        stream: DatabaseService(
                uid: player!.playerId, firebaseCollection: firebaseCollection)
            .userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            authFunction.signOut();
          }
          if (snapshot.hasData) {
            PlayerData? playerData = snapshot.data;
            level = playerData!.learnFaceLevel;
            return Scaffold(
                body: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/learnfacebackground.png"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 75),
                    Text("- Match the picture to one of the emotions -",
                        key: Key("learn-a-face-screen"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TypoRound')),
                    const SizedBox(height: 10),
                    Text("LEVEL: $level",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.center,
                      child: FutureBuilder(
                        future: faceLoader.loadRandomFace(emotionToPick),
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return SizedBox(
                              child: Container(
                                  key: Key("emotion-image"),
                                  child: EmotionImage(
                                      Colors.white, snapshot.data!)),
                              height: 275,
                              width: 275,
                            );
                          }
                          return Container(
                            width: 275,
                            height: 275,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 200.0,
                                  minWidth: 200.0,
                                  maxHeight: 1000.0,
                                  maxWidth: 1000.0,
                                ),
                                child: CircularProgressIndicator(
                                    color: Colors.orangeAccent,
                                    backgroundColor: globalColours.lfColour),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.all(10),
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 2,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        ElevatedButton(
                          key: emotionIsAnswer(1),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  getColour[emotion1]),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(255, 255, 255, 0.7)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2.5)))),
                          onPressed: () {
                            generateRandomEmotionToSelectAndScore(1);
                            DatabaseService(
                                    firebaseCollection: firebaseCollection,
                                    uid: player.playerId)
                                .updateUserData(
                                    playerData.playerName,
                                    playerData.bio,
                                    playerData.imagePath,
                                    playerData.email,
                                    playerData.chooseFaceLevel,
                                    level,
                                    playerData.makeFaceLevel);
                          },
                          child: Text(emotion1.toUpperCase(),
                              style: TextStyle(
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1, 1),
                                        color: Colors.black),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1, 1),
                                        color: Colors.black),
                                  ],
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'TypoRound')),
                        ),
                        ElevatedButton(
                          key: emotionIsAnswer(2),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  getColour[emotion2]),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(255, 255, 255, 0.7)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2.5)))),
                          onPressed: () {
                            generateRandomEmotionToSelectAndScore(2);
                            DatabaseService(
                                    firebaseCollection: firebaseCollection,
                                    uid: player.playerId)
                                .updateUserData(
                                    playerData.playerName,
                                    playerData.bio,
                                    playerData.imagePath,
                                    playerData.email,
                                    playerData.chooseFaceLevel,
                                    level,
                                    playerData.makeFaceLevel);
                          },
                          child: Text(emotion2.toUpperCase(),
                              style: TextStyle(
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1, 1),
                                        color: Colors.black),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1, 1),
                                        color: Colors.black),
                                  ],
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'TypoRound')),
                        ),
                        ElevatedButton(
                          key: emotionIsAnswer(3),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  getColour[emotion3]),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(255, 255, 255, 0.7)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2.5)))),
                          onPressed: () {
                            generateRandomEmotionToSelectAndScore(3);
                            DatabaseService(
                                    firebaseCollection: firebaseCollection,
                                    uid: player.playerId)
                                .updateUserData(
                                    playerData.playerName,
                                    playerData.bio,
                                    playerData.imagePath,
                                    playerData.email,
                                    playerData.chooseFaceLevel,
                                    level,
                                    playerData.makeFaceLevel);
                          },
                          child: Text(emotion3.toUpperCase(),
                              style: TextStyle(
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1, 1),
                                        color: Colors.black),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1, 1),
                                        color: Colors.black),
                                  ],
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'TypoRound')),
                        ),
                        ElevatedButton(
                          key: emotionIsAnswer(4),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  getColour[emotion4]),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(255, 255, 255, 0.7)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2.5)))),
                          onPressed: () {
                            generateRandomEmotionToSelectAndScore(4);
                            DatabaseService(
                                    firebaseCollection: firebaseCollection,
                                    uid: player.playerId)
                                .updateUserData(
                                    playerData.playerName,
                                    playerData.bio,
                                    playerData.imagePath,
                                    playerData.email,
                                    playerData.chooseFaceLevel,
                                    level,
                                    playerData.makeFaceLevel);
                          },
                          child: Text(emotion4.toUpperCase(),
                              style: TextStyle(
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1, -1),
                                        color: Colors.black),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1, 1),
                                        color: Colors.black),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1, 1),
                                        color: Colors.black),
                                  ],
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'TypoRound')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      score.toString() + " / " + scoreForNewLevel.toString(),
                      style: TextStyle(
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-2, -2),
                                color: globalColours.lfColour),
                            Shadow(
                                // bottomRight
                                offset: Offset(2, -2),
                                color: globalColours.lfColour),
                            Shadow(
                                // topRight
                                offset: Offset(2, 2),
                                color: globalColours.lfColour),
                            Shadow(
                                // topLeft
                                offset: Offset(-2, 2),
                                color: globalColours.lfColour),
                          ],
                          color: Colors.white,
                          fontFamily: 'TypoRound',
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ));
          } else {
            return Loading();
          }
        });
  }

  void generateRandomFaces() {
    var rng = Random();
    List<String> emotionOptions = List<String>.from(emotionOption);
    List<int> emotion = [1, 2, 3, 4];
    int num = rng.nextInt(4) + 1;
    assignEmotionNumberAnEmotion(num, emotionToPick);
    emotion.remove(num);
    emotionOptions.remove(emotionToPick);
    String emotionToSelect;
    while (emotion.isNotEmpty) {
      num = emotion.removeLast();
      // try {
      emotionToSelect = emotionOptions[rng.nextInt(emotionOptions.length - 1)];
      // } on RangeError {
      //   emotionToSelect = emotionOptions[0];
      // }
      assignEmotionNumberAnEmotion(num, emotionToSelect);
      emotion.remove(num);
      emotionOptions.remove(
          emotionToSelect); //can add back if all emotions shown should be unique
    }
  }

  void assignEmotionNumberAnEmotion(int num, String emotion) {
    switch (num) {
      case 1:
        emotion1 = emotion;
        break;
      case 2:
        emotion2 = emotion;
        break;
      case 3:
        emotion3 = emotion;
        break;
      case 4:
        emotion4 = emotion;
        break;
    }
  }

  void playSuccess() async {
    //AudioCache cache = new AudioCache();
    await cache.play('sounds/success-1-6297.mp3');
  }

  void playFailure() async {
    await cache.play('sounds/fail.mp3', volume: 1.5);
  }

  void generateRandomEmotionToSelectAndScore(int i) {
    int tempScore = score;
    switch (i) {
      case 0:
        break;
      case 1:
        if (emotion1 == emotionToPick) {
          playSuccess();
          score++;
        }
        break;
      case 2:
        if (emotion2 == emotionToPick) {
          playSuccess();
          score++;
        }
        break;
      case 3:
        if (emotion3 == emotionToPick) {
          playSuccess();
          score++;
        }
        break;
      case 4:
        if (emotion4 == emotionToPick) {
          playSuccess();
          score++;
        }
        break;
    }
    if (!firstLoad && tempScore == score) {
      score = 0;
      playFailure();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Incorrect emotion!\nTry again?"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                  firebaseCollection: firebaseCollection))),
                      child: Text("No")),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Yes"))
                ],
              ));
    } else if (!firstLoad) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Correct!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white)),
          duration: Duration(milliseconds: 500)));
    }

    if (score >= scoreForNewLevel) {
      score = 0;
      if (level < emotionOption.length - 1) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                      "Level up!\nYou have unlocked a new emotion ${emotionOption[level]}!"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ok"))
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Level up!\nYou have unlocked Level $level!"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ok"))
                  ],
                ));
      }
      level++;
    }
    generateRandomEmotionToSelect();
  }

  void generateRandomEmotionToSelect() {
    setState(() {
      var rng = Random();
      List<String> emotionOptions = List<String>.from(emotionOption);

      if (level < emotionOption.length - 1) {
        emotionOptions = emotionOptions.sublist(0, level + 1);
      }
      emotionToPick = emotionOptions[rng.nextInt(emotionOptions.length)];
      generateRandomFaces();
    });
  }

  Key emotionIsAnswer(int index) {
    switch (index) {
      case 1:
        return Key((emotion1 == emotionToPick) ? "answer" : "incorrect1");
      case 2:
        return Key((emotion2 == emotionToPick) ? "answer" : "incorrect2");
      case 3:
        return Key((emotion3 == emotionToPick) ? "answer" : "incorrect3");
      case 4:
        return Key((emotion4 == emotionToPick) ? "answer" : "incorrect4");
      default:
        return Key("wrong index");
    }
  }
}
