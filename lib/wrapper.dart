import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_demo/screens/authentication_screen.dart';
import 'package:game_demo/screens/text_uploader.dart';
import 'package:game_demo/screens/home_page.dart';
import 'package:game_demo/screens/user_profile.dart';
import 'package:game_demo/screens/tutorial_screen.dart';
import 'package:game_demo/services/database.dart';
import 'package:provider/provider.dart';

import 'loading.dart';
import 'screens/game_screen.dart';
import './models/player.dart';
import "package:game_demo/models/firebase_collection.dart";

class Wrapper extends StatelessWidget {
  final FirebaseCollection firebaseCollection;

  const Wrapper({Key? key, required this.firebaseCollection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player?>(context);

    if (player == null) {
      return AuthenticationScreen(firebaseCollection: firebaseCollection);
    } else {
      return StreamBuilder<PlayerData?>(
        stream: DatabaseService(
                uid: player.playerId, firebaseCollection: firebaseCollection)
            .userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PlayerData? playerData = snapshot.data;
            if (playerData!.firstLoad) {
              return TutorialScreen(firebaseCollection: firebaseCollection);
            } else {
              return HomePage(firebaseCollection: firebaseCollection);
            }
          } else {
            return Loading();
          }
        },
      );
    }
  }
}
