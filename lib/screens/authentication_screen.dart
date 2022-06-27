import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_demo/screens/login_screen.dart';
import 'package:game_demo/screens/registration_screen.dart';
import "package:game_demo/models/firebase_collection.dart";

class AuthenticationScreen extends StatefulWidget {
  final FirebaseCollection firebaseCollection;
  const AuthenticationScreen({Key? key, required this.firebaseCollection}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState(firebaseCollection: firebaseCollection);
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  var authToggle = true;
  final FirebaseCollection firebaseCollection;
  _AuthenticationScreenState({required this.firebaseCollection});

  void toggleAuth() {
    setState(() {
      authToggle = !authToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (authToggle) {
      return LoginScreen(toggle: toggleAuth, firebaseCollection: firebaseCollection);
    } else {
      return RegistrationScreen(toggle: toggleAuth, firebaseCollection: firebaseCollection);
    }
  }
}
