// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/profile_pic.dart';
import 'package:game_demo/loading.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/models/player.dart';
import 'package:game_demo/screens/authentication_screen.dart';
import 'package:game_demo/screens/settings_page.dart';
import 'package:game_demo/services/auth_function.dart';
import 'package:game_demo/services/database.dart';
import 'package:game_demo/services/global_colours.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseCollection firebaseCollection;
  const ProfilePage({Key? key, required this.firebaseCollection})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(firebaseCollection: firebaseCollection);
  }
}

class ProfilePageState extends State<ProfilePage> {
  late AuthFunction _auth;
  final FirebaseCollection firebaseCollection;
  bool loading = false;

  ProfilePageState({required this.firebaseCollection}) {
    _auth = AuthFunction(firebaseCollection: firebaseCollection);
  }

  Global globalColours = new Global();

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player?>(context);
    // User? user = FirebaseAuth.instance.currentUser;
    // Player? player = AuthFunction().playerFromUser(user);
    if (player == null) {
      _auth.signOut();
      return AuthenticationScreen(firebaseCollection: firebaseCollection);
    }
    return StreamBuilder<PlayerData?>(
        key: Key("profile-page"),
        stream: DatabaseService(
                uid: player.playerId, firebaseCollection: firebaseCollection)
            .userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  "PROFILE",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: globalColours.baseColour),
                ),
                actions: [
                  IconButton(
                    key: Key("sign-out"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: Text("Would you like to sign out?"),
                                actions: [
                                  TextButton(
                                      key: Key("stay-signed-in-option"),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("No")),
                                  TextButton(
                                      key: Key("sign-out-option"),
                                      onPressed: () {
                                        _auth.signOut();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Sign out"))
                                ],
                              ));
                    },
                    icon: Icon(Icons.exit_to_app),
                    color: globalColours.baseColour,
                    tooltip: "Sign out",
                  )
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover),
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    buildName(snapshot.data),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  Widget buildName(PlayerData? user) {
    String imagePth;

    imagePth = user!.imagePath;

    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        ProfileWidget(imagePth, onClicked: () {}, key: Key("profile-picture")),
        SizedBox(
          height: 5,
        ),
        Text(user.playerName,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
            key: Key("name")),
        SizedBox(
          height: 5,
        ),
        Text(user.email,
            style: TextStyle(color: Colors.black54), key: Key("email")),
        SizedBox(
          height: 5,
        ),
        Text(user.bio, style: TextStyle(color: Colors.black), key: Key("bio")),
        SizedBox(
          height: 100,
        ),
        OutlinedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Game Statistics"),
                        content: SingleChildScrollView(
                            child: Column(
                          children: [
                            SizedBox(height: 35),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                WidgetSpan(
                                    child: Container(
                                  child: IntrinsicWidth(
                                    child: Text("Choose a Face Level",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(137, 226, 25, 1),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                )),
                              ]),
                            ),
                            SizedBox(height: 3),
                            Text(
                              user.chooseFaceLevel.toString(),
                              style: TextStyle(
                                  color: Color.fromRGBO(137, 226, 25, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                WidgetSpan(
                                    child: Container(
                                  child: IntrinsicWidth(
                                    child: Text("Learn a Face Level",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                )),
                              ]),
                            ),
                            SizedBox(height: 3),
                            Text(
                              user.learnFaceLevel.toString(),
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                WidgetSpan(
                                    child: Container(
                                  child: IntrinsicWidth(
                                    child: Text("Make a Face Level",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 75, 75, 1),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                )),
                              ]),
                            ),
                            SizedBox(height: 3),
                            Text(
                              user.makeFaceLevel.toString(),
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Ok"))
                        ],
                      ));
            },
            child: Text("Statistics",
                style: TextStyle(
                  color: globalColours.baseColour,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            style: ElevatedButton.styleFrom(fixedSize: Size(200, 50))),
        SizedBox(
          height: 50,
        ),
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                          firebaseCollection: firebaseCollection)));
            },
            child: Text("Settings",
                style: TextStyle(
                  color: globalColours.baseColour,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            style: ElevatedButton.styleFrom(fixedSize: Size(200, 50))),
      ],
    );
  }
}
