import 'package:firebase_auth/firebase_auth.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/services/database.dart';

import '../models/player.dart';

class AuthFunction {
  final FirebaseCollection firebaseCollection;

  AuthFunction({required this.firebaseCollection});

  Stream<Player?> get player {
    return firebaseCollection.firebaseAuth
        .authStateChanges()
        .map((User? user) => playerFromUser(user!));
  }

  Future<String> getCurrentUid() async {
    return (firebaseCollection.firebaseAuth.currentUser!.uid);
  }

  Player? playerFromUser(User? user) {
    return user != null ? Player(playerId: user.uid) : null;
  }

  Future signUp(
      String nameInput, String emailInput, String passwordInput) async {
    try {
      UserCredential credentials = await firebaseCollection.firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailInput, password: passwordInput);
      User? user = credentials.user;

      await DatabaseService(
              uid: user!.uid, firebaseCollection: firebaseCollection)
          .updateUserData(
              nameInput,
              '',
              (await firebaseCollection.firebaseStorage
                  .ref("PofilePicture/default profile.png")
                  .getDownloadURL()),
              emailInput,
              1,
              1,
              1);

      await DatabaseService(
              uid: user.uid, firebaseCollection: firebaseCollection)
          .updateFirstLoad(true);

      return playerFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logIn(String emailInput, String passwordInput) async {
    try {
      UserCredential credentials = await firebaseCollection.firebaseAuth
          .signInWithEmailAndPassword(
              email: emailInput, password: passwordInput);
      User? user = credentials.user;
      return playerFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await firebaseCollection.firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> validatePassword(String oldPassword) async {
    User? user = await firebaseCollection.firebaseAuth.currentUser;
    AuthCredential credentials = EmailAuthProvider.credential(
        email: user!.email.toString(), password: oldPassword);
    try {
      await user.reauthenticateWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return false;
      } else {
        print('firebase status error');
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }
}
