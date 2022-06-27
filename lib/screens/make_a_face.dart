import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:game_demo/loading.dart';
import 'package:game_demo/models/face_loader.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/models/player.dart';
import 'package:game_demo/models/predictor.dart';
import 'package:game_demo/screens/home_page.dart';
import 'package:game_demo/services/auth_function.dart';
import 'package:game_demo/services/database.dart';
import 'package:game_demo/services/global_colours.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MakeAFace extends StatefulWidget {
  final FirebaseCollection firebaseCollection;

  const MakeAFace({Key? key, required this.firebaseCollection})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MakeAFaceLogic(firebaseCollection: firebaseCollection);
  }
}

//enum Emotion { Angry, Disgust, Fear, Happy, Neutral, Sad, Suprise }

class MakeAFaceLogic extends State<MakeAFace> {
  String pred1 = "";
  String pred2 = "";
  String pred3 = "";
  String output = "";
  late FaceLoader faceLoader;
  late AuthFunction authFunction;
  late final FirebaseCollection firebaseCollection;
  final picker = ImagePicker();
  bool _isLoading = true;
  File _image = File("");
  List _output = [];

  bool firstLoad = true;
  int score = 0;
  int level = 1;
  int scoreForNewLevel = 3;

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

  MakeAFaceLogic({required this.firebaseCollection}) {
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
      generateRandomEmotionToSelectAndScore();
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
            if (_isLoading) {
              level = playerData!.makeFaceLevel;
            } else {
              DatabaseService(
                      firebaseCollection: firebaseCollection,
                      uid: player.playerId)
                  .updateUserData(
                      playerData!.playerName,
                      (playerData.bio).toString(),
                      (playerData.imagePath).toString(),
                      (playerData.email).toString(),
                      playerData.chooseFaceLevel,
                      playerData.learnFaceLevel,
                      level);
            }
            return Scaffold(
                body: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/makefacebackground.png"),
                          fit: BoxFit.cover),
                    ),
                    child: Center(
                        child: Column(children: [
                      const SizedBox(height: 75),
                      Text("- Make the emotion with your face -",
                          key: Key("make-a-face-screen"),
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
                          key: Key("user-level"),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 40),
                      Container(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: _isLoading
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Column(
                                        children: [
                                          Container(
                                              width: 250,
                                              height: 250,
                                              foregroundDecoration:
                                                  BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border(
                                                          top: BorderSide(
                                                              color: Colors
                                                                  .redAccent,
                                                              width: 3),
                                                          left: BorderSide(
                                                              color: Colors
                                                                  .redAccent,
                                                              width: 3),
                                                          right: BorderSide(
                                                              color: Colors
                                                                  .redAccent,
                                                              width: 3),
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .redAccent,
                                                              width: 3))),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/default profile.png"),
                                                      fit: BoxFit.cover))),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                              key: Key("take-a-picture-button"),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.redAccent)),
                                              onPressed: () {
                                                pickImage();
                                                DatabaseService(
                                                        firebaseCollection:
                                                            firebaseCollection,
                                                        uid: player.playerId)
                                                    .updateUserData(
                                                        playerData.playerName,
                                                        (playerData.bio)
                                                            .toString(),
                                                        (playerData.imagePath)
                                                            .toString(),
                                                        (playerData.email)
                                                            .toString(),
                                                        playerData
                                                            .chooseFaceLevel,
                                                        playerData
                                                            .learnFaceLevel,
                                                        level);
                                              },
                                              child: Text("Take a Picture")),
                                          SizedBox(height: 10),
                                          Text(
                                            score.toString() +
                                                " / " +
                                                scoreForNewLevel.toString(),
                                            key: Key("user-score"),
                                            style: TextStyle(
                                                shadows: [
                                                  Shadow(
                                                      // bottomLeft
                                                      offset: Offset(-2, -2),
                                                      color: globalColours
                                                          .mfColour),
                                                  Shadow(
                                                      // bottomRight
                                                      offset: Offset(2, -2),
                                                      color: globalColours
                                                          .mfColour),
                                                  Shadow(
                                                      // topRight
                                                      offset: Offset(2, 2),
                                                      color: globalColours
                                                          .mfColour),
                                                  Shadow(
                                                      // topLeft
                                                      offset: Offset(-2, 2),
                                                      color: globalColours
                                                          .mfColour),
                                                ],
                                                color: Colors.white,
                                                fontFamily: 'TypoRound',
                                                fontSize: 35,
                                                fontWeight: FontWeight.w900),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      child: Column(
                                      children: [
                                        Container(
                                            height: 250,
                                            child: Container(
                                                width: 250,
                                                height: 250,
                                                foregroundDecoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border(
                                                        top: BorderSide(
                                                            color: Colors
                                                                .redAccent,
                                                            width: 3),
                                                        left: BorderSide(
                                                            color: Colors
                                                                .redAccent,
                                                            width: 3),
                                                        right: BorderSide(
                                                            color: Colors
                                                                .redAccent,
                                                            width: 3),
                                                        bottom: BorderSide(
                                                            color: Colors
                                                                .redAccent,
                                                            width: 3))),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image:
                                                            FileImage(_image),
                                                        fit: BoxFit.cover)))),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          child: Column(children: [
                                            Text(
                                              "1 - $pred1",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0),
                                            ),
                                            Text(
                                              "2 - $pred2",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0),
                                            ),
                                            Text(
                                              "3 - $pred3",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0),
                                            ),
                                          ]),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.redAccent)),
                                            onPressed: () async {
                                              await pickImage();
                                              DatabaseService(
                                                      firebaseCollection:
                                                          firebaseCollection,
                                                      uid: player.playerId)
                                                  .updateUserData(
                                                      playerData.playerName,
                                                      playerData.bio,
                                                      playerData.imagePath,
                                                      playerData.email,
                                                      playerData
                                                          .chooseFaceLevel,
                                                      playerData.learnFaceLevel,
                                                      level);
                                            },
                                            child: Text("Take a Picture")),
                                        SizedBox(height: 10),
                                        Text(
                                          score.toString() +
                                              " / " +
                                              scoreForNewLevel.toString(),
                                          style: TextStyle(
                                              shadows: [
                                                Shadow(
                                                    // bottomLeft
                                                    offset: Offset(-2, -2),
                                                    color:
                                                        globalColours.mfColour),
                                                Shadow(
                                                    // bottomRight
                                                    offset: Offset(2, -2),
                                                    color:
                                                        globalColours.mfColour),
                                                Shadow(
                                                    // topRight
                                                    offset: Offset(2, 2),
                                                    color:
                                                        globalColours.mfColour),
                                                Shadow(
                                                    // topLeft
                                                    offset: Offset(-2, 2),
                                                    color:
                                                        globalColours.mfColour),
                                              ],
                                              color: Colors.white,
                                              fontFamily: 'TypoRound',
                                              fontSize: 35,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ))))
                    ]))));
          } else {
            return Loading();
          }
        });
  }

  detectImage(File image) async {
    Predictor predictor = Predictor();
    predictor.loadPictureModel();

    var predictions = await predictor.runPictureModel(image.path);

    setState(() {
      _isLoading = false;

      pred1 = predictions![0]['label'];
      pred2 = predictions[1]['label'];
      pred3 = predictions[2]['label'];
      _output = [
        pred1.toLowerCase().trim(),
        pred2.toLowerCase().trim(),
        pred3.toLowerCase().trim()
      ];
      generateRandomEmotionToSelectAndScore();
    });
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _isLoading = false;
      _image = File(image.path);
    });

    detectImage(_image);
  }

  void playSuccess() async {
    AudioCache cache = new AudioCache();
    await cache.play('sounds/success-1-6297.mp3');
  }

  void playFailure() async {
    AudioCache cache = new AudioCache();
    await cache.play('sounds/fail.mp3');
  }

  void generateRandomEmotionToSelect() {
    setState(() {
      var rng = Random();
      List<String> emotionOptions = List<String>.from(emotionOption);

      if (level < emotionOption.length - 1) {
        emotionOptions = emotionOptions.sublist(0, level + 1);
      }
      emotionToPick = emotionOptions[rng.nextInt(emotionOptions.length)];
    });
  }

  void generateRandomEmotionToSelectAndScore() {
    int tempScore = score;
    if (_output.contains(emotionToPick.toLowerCase())) {
      playSuccess();
      score++;
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
                  title: Text("Level up!\nYou have unlocked Level $level!"),
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
}
