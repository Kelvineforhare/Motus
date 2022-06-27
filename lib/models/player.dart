import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_demo/services/storage.dart';
import "package:game_demo/models/firebase_collection.dart";

class Player {
  final String playerId;

  Player({required this.playerId});
}

class PlayerData {
  final String playerId;
  final String playerName;
  final FirebaseCollection firebaseCollection;
  final int chooseFaceLevel;
  final int learnFaceLevel;
  final int makeFaceLevel;
  final String bio;
  final String email;
  String imagePath;
  late Storage store;
  bool firstLoad;

  PlayerData(
      {required this.playerId,
      required this.playerName,
      required this.firebaseCollection,
      this.bio = "",
      required this.email,
      this.imagePath = "",
      this.chooseFaceLevel = 1,
      this.learnFaceLevel = 1,
      this.makeFaceLevel = 1,
      this.firstLoad = true}
    ) {
    store = Storage(firebaseCollection: firebaseCollection);
    loadDefaults();
  }

  void loadDefaults() async {
    if (imagePath == "") {
      imagePath = await firebaseCollection.firebaseStorage.ref("PofilePicture/default profile.png").getDownloadURL();
    }
  }

  Future<String> getImageUrl() async {
    imagePath = await store.getUserProfileImageUrl(playerId);
    return imagePath;
  }

  Future<void> uploadProfilePicture() async {
    await store.uploadFile(File(imagePath));
  }
}
