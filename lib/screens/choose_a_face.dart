import 'dart:math';

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

class ChooseAFace extends StatefulWidget {
  final FirebaseCollection firebaseCollection;

  const ChooseAFace({Key? key, required this.firebaseCollection})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChooseAFaceLogic(firebaseCollection: firebaseCollection);
  }
}

//enum Emotion { Angry, Disgust, Fear, Happy, Neutral, Sad, Suprise }

class ChooseAFaceLogic extends State<ChooseAFace> {
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
  //levels, each new level introduces a new emotion
  //emotion cant be displayed twice in a row
  //can change order of emotions to change which one is displayed
  List<String> emotionOption = [
    "Sad",
    "Happy",
    "Angry",
    "Disgust",
    "Fear",
    "Neutral",
    "Surprise",
  ];

  ChooseAFaceLogic({required this.firebaseCollection}) {
    faceLoader = FaceLoader(firebaseCollection: firebaseCollection);
    authFunction = AuthFunction(firebaseCollection: firebaseCollection);
  }

  //able to go back? DONE
  //Tick and cross screen when answering questions MAYBE
  //border around photo DONE
  //title of emotion colour DONE
  //all caps DONE
  //depending on emotion can have different colour - create map from emotion to colour DONE
  @override
  Widget build(BuildContext context) {
    Global globalColours = new Global();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    final player = Provider.of<Player?>(context);

    if (firstLoad) {
      cache.loadAll([
        'sounds/success-1-6297.mp3',
        'sounds/fail.mp3',
      ]);
      generateRandomEmotionToSelectAndScore(0);
      firstLoad = false;
    }
    return StreamBuilder<PlayerData>(
        stream: DatabaseService(
                firebaseCollection: firebaseCollection, uid: player!.playerId)
            .userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            authFunction.signOut();
          }
          if (snapshot.hasData) {
            PlayerData? playerData = snapshot.data;
            level = playerData!.chooseFaceLevel;
            return Scaffold(
                body: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/choosefacebackground.png"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 75),
                    Text("- Match the emotion to one of the pictures -",
                        key: Key("choose-a-face-screen"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TypoRound')),
                    Text(emotionToPick.toUpperCase(),
                        key: Key("emotion-to-pick"),
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
                            fontWeight: FontWeight.w900,
                            color: getColour[emotionToPick],
                            fontFamily: 'TypoRound',
                            fontSize: 55)),
                    Text("LEVEL: $level",
                        key: Key("player-level-display"),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                    FutureBuilder(
                        key: Key("facial-expressions"),
                        future: faceLoader.loadRandomFaces(
                            emotion1, emotion2, emotion3, emotion4),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Widget>> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: (snapshot.data!)
                                    .map((img) => IconButton(
                                        onPressed: () {
                                          generateRandomEmotionToSelectAndScore(
                                              snapshot.data!.indexOf(img) + 1);
                                          DatabaseService(
                                                  firebaseCollection:
                                                      firebaseCollection,
                                                  uid: player.playerId)
                                              .updateUserData(
                                                  playerData.playerName,
                                                  playerData.bio,
                                                  playerData.imagePath,
                                                  playerData.email,
                                                  level,
                                                  playerData.learnFaceLevel,
                                                  playerData.makeFaceLevel);
                                        },
                                        icon: EmotionImage(Colors.white, img),
                                        iconSize: 150,
                                        key: emotionIsAnswer(
                                            snapshot.data!.indexOf(img) + 1)))
                                    .toList());
                          }
                          return Container(
                            width: 400,
                            height: 423,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 250.0,
                                  minWidth: 250.0,
                                  maxHeight: 1000.0,
                                  maxWidth: 1000.0,
                                ),
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                  backgroundColor: globalColours.cfColour,
                                ),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 20),
                    Text(
                      score.toString() + " / " + scoreForNewLevel.toString(),
                      key: Key("score"),
                      style: TextStyle(
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-2, -2),
                                color: globalColours.cfColour),
                            Shadow(
                                // bottomRight
                                offset: Offset(2, -2),
                                color: globalColours.cfColour),
                            Shadow(
                                // topRight
                                offset: Offset(2, 2),
                                color: globalColours.cfColour),
                            Shadow(
                                // topLeft
                                offset: Offset(-2, 2),
                                color: globalColours.cfColour),
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

  void generateRandomFaces(List<String> emotionOptions) {
    var rng = Random();
    List<int> emotion = [1, 2, 3, 4];
    int num = rng.nextInt(4) + 1;
    assignEmotionNumberAnEmotion(num, emotionToPick);
    emotion.remove(num);
    emotionOptions.remove(emotionToPick);
    String emotionToSelect;
    while (emotion.isNotEmpty) {
      num = emotion.removeLast();
      try {
        emotionToSelect =
            emotionOptions[rng.nextInt(emotionOptions.length - 1)];
      } on RangeError {
        emotionToSelect = emotionOptions[0];
      }
      assignEmotionNumberAnEmotion(num, emotionToSelect);
      emotion.remove(num);
      if (emotionOptions.length > 1) {
        emotionOptions.remove(
            emotionToSelect); //can add back if all emotions shown should be unique
      }
    }
  }

  void generateAnyFace() {
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
      emotionToSelect = emotionOptions[rng.nextInt(emotionOptions.length - 1)];
      assignEmotionNumberAnEmotion(num, emotionToSelect);
      emotion.remove(num);
      //emotionOptions.remove(emotionToPick); //can add back if all emotions shown should be unique
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

  void checkScore(int i) {
    switch (i) {
      case 1:
        if (emotion1 == emotionToPick) {
          score++;
        }
        break;
      case 2:
        if (emotion2 == emotionToPick) {
          score++;
        }
        break;
      case 3:
        if (emotion3 == emotionToPick) {
          score++;
        }
        break;
      case 4:
        if (emotion4 == emotionToPick) {
          score++;
        }
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
    if (tempScore == score && !firstLoad) {
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text("Level up!\nYou have unlocked Level ${level}!"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ok"))
                  ],
                ));
      }
      level++;
    }
    setState(() {
      selectRandomEmotion();
    });
  }

  void selectRandomEmotion() {
    var rng = Random();
    List<String> emotionOptions = List<String>.from(emotionOption);

    if (level < emotionOption.length - 1) {
      emotionOptions = emotionOptions.sublist(0, level + 1);
    }

    emotionToPick = emotionOptions[rng.nextInt(emotionOptions.length)];
    generateRandomFaces(emotionOptions);
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
