import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_demo/models/player.dart';
import "package:game_demo/models/firebase_collection.dart";

class DatabaseService {
  final String uid;
  final FirebaseCollection firebaseCollection;
  late CollectionReference collectionOfUsers;
  
  DatabaseService({required this.uid, required this.firebaseCollection}) {
    collectionOfUsers = firebaseCollection.firebaseFirestore.collection("Users");
  }

  Future updateUserData(String? fullName, String bio, String imagePath,
      String email, int cfLevel, int lfLevel, int mfLevel) async {
    return await collectionOfUsers.doc(uid).set({
      'name': fullName,
      'bio': bio,
      'path': imagePath,
      'email': email,
      'chooseFaceLevel': cfLevel,
      'learnFaceLevel': lfLevel,
      'makeFaceLevel': mfLevel,
}, SetOptions(merge: true));
  }

  Future updateFirstLoad(bool firstLoad) async {
    return await collectionOfUsers.doc(uid).set({
      'firstLoad': firstLoad,
    }, SetOptions(merge:true));
  }

  Future updateName(
    String? fullName,
  ) async {
    return await collectionOfUsers.doc(uid).set({
      'name': fullName,
    }, SetOptions(merge: true));
  }

  PlayerData _playerDataFromSnapshot(DocumentSnapshot snapshot) {
    return PlayerData(
        playerId: uid,
        playerName: snapshot['name'],
        firebaseCollection: firebaseCollection,
        email: snapshot['email'],
        bio: snapshot['bio'],
        imagePath: snapshot['path'],
        chooseFaceLevel: snapshot['chooseFaceLevel'],
        learnFaceLevel: snapshot['learnFaceLevel'],
        makeFaceLevel: snapshot['makeFaceLevel'],
        firstLoad: snapshot['firstLoad']);
  }

  Stream<PlayerData> get userData {
    return collectionOfUsers.doc(uid).snapshots().map(_playerDataFromSnapshot);
  }

  Stream<QuerySnapshot> get userList {
    return collectionOfUsers.snapshots();
  }
}
