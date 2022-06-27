import 'package:flutter/material.dart';
import 'package:game_demo/screens/learn_a_face.dart';
import 'package:game_demo/screens/make_a_face.dart';
import 'package:game_demo/screens/text_uploader.dart';
import 'package:game_demo/screens/user_profile.dart';
import 'package:game_demo/services/auth_function.dart';
import 'package:game_demo/models/player.dart';
import 'package:game_demo/screens/choose_a_face.dart';
import 'package:provider/provider.dart';
import "package:game_demo/models/firebase_collection.dart";
import '../custom_widget/menu_bar.dart';
import 'package:game_demo/services/global_colours.dart';

class GameScreen extends StatelessWidget {
  final FirebaseCollection firebaseCollection;

  GameScreen({Key? key, required this.firebaseCollection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Global globalColours = new Global();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final player = Provider.of<Player?>(context);
    return Scaffold(
        key: Key("home-screen"),
        appBar: AppBar(
            //  leading: Image.asset('assets/logo.png'),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login-screen-logo.png',
                    width: 35,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "MOTUS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: globalColours.baseColour),
                  )
                ])),
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const SizedBox(height: 20),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.lightGreen, width: 1),
                                top: BorderSide(
                                    color: Colors.lightGreen, width: 1),
                                left: BorderSide(
                                    color: Colors.lightGreen, width: 1),
                                right: BorderSide(
                                    color: Colors.lightGreen, width: 1)),
                            shape: BoxShape.circle,
                            color: globalColours.cfColour),
                        child: IconButton(
                            key: Key("choose-a-face"),
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChooseAFace(
                                        firebaseCollection:
                                            firebaseCollection))),
                            icon: Image.asset(
                              'assets/images/Choose-a-face-game.png',
                              width: 150,
                              height: 150,
                            ),
                            iconSize: 125)),
                    Text(
                      "Choose a Face",
                      key: Key("choose-a-face-option"),
                      style: TextStyle(
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-1, -1),
                                color: Colors.lightGreen),
                            Shadow(
                                // bottomRight
                                offset: Offset(1, -1),
                                color: Colors.lightGreen),
                            Shadow(
                                // topRight
                                offset: Offset(1, 1),
                                color: Colors.lightGreen),
                            Shadow(
                                // topLeft
                                offset: Offset(-1, 1),
                                color: Colors.lightGreen),
                          ],
                          fontSize: 20,
                          color: globalColours.cfColour,
                          fontFamily: "TypoRound",
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.orangeAccent, width: 1),
                                top: BorderSide(
                                    color: Colors.orangeAccent, width: 1),
                                left: BorderSide(
                                    color: Colors.orangeAccent, width: 1),
                                right: BorderSide(
                                    color: Colors.orangeAccent, width: 1)),
                            shape: BoxShape.circle,
                            color: globalColours.lfColour),
                        child: IconButton(
                            key: Key("learn-a-face"),
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LearnAFace(
                                        firebaseCollection:
                                            firebaseCollection))),
                            icon: Image.asset(
                              'assets/images/Learn-a-face-game.png',
                              width: 150,
                              height: 150,
                            ),
                            iconSize: 125)),
                    Text(
                      "Learn a Face",
                      key: Key("learn-a-face-option"),
                      style: TextStyle(
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-1, -1),
                                color: Colors.orangeAccent),
                            Shadow(
                                // bottomRight
                                offset: Offset(1, -1),
                                color: Colors.orangeAccent),
                            Shadow(
                                // topRight
                                offset: Offset(1, 1),
                                color: Colors.orangeAccent),
                            Shadow(
                                // topLeft
                                offset: Offset(-1, 1),
                                color: Colors.orangeAccent),
                          ],
                          fontSize: 20,
                          color: globalColours.lfColour,
                          fontFamily: "TypoRound",
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.redAccent, width: 1),
                              top:
                                  BorderSide(color: Colors.redAccent, width: 1),
                              left:
                                  BorderSide(color: Colors.redAccent, width: 1),
                              right: BorderSide(
                                  color: Colors.redAccent, width: 1)),
                          shape: BoxShape.circle,
                          color: globalColours.mfColour),
                      child: IconButton(
                          padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MakeAFace(
                                      firebaseCollection: firebaseCollection))),
                          icon: Image.asset(
                            'assets/images/Make-a-face-game.png',
                            width: 120,
                            height: 120,
                          ),
                          iconSize: 125),
                    ),
                    Text("Make a Face",
                        key: Key(
                            "make-a-face-option"), // remove "TO BE ADDED" text once MakeAFace is complete
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1, -1),
                                  color: Colors.redAccent),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1, -1),
                                  color: Colors.redAccent),
                              Shadow(
                                  // topRight
                                  offset: Offset(1, 1),
                                  color: Colors.redAccent),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1, 1),
                                  color: Colors.redAccent),
                            ],
                            fontSize: 20,
                            color: globalColours.mfColour,
                            fontFamily: "TypoRound",
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 20),
                  ])),
            ],
          ),
        ));
  }
}
