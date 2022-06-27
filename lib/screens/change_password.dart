import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:game_demo/loading.dart';

import 'package:game_demo/custom_widget/input_widget.dart';
import 'package:game_demo/custom_widget/profile_pic.dart';

import 'package:game_demo/models/player.dart';
import 'package:game_demo/models/validators.dart';
import "package:game_demo/models/firebase_collection.dart";

import 'package:game_demo/screens/home_page.dart';
import 'package:game_demo/screens/settings_page.dart';
import 'package:game_demo/screens/user_profile.dart';

import 'package:game_demo/services/global_colours.dart';
import 'package:game_demo/services/database.dart';
import 'package:game_demo/services/storage.dart';
import 'package:game_demo/services/auth_function.dart';

class ChangePassword extends StatefulWidget {
  //final Function toggle;
  final FirebaseCollection firebaseCollection;
  ChangePassword({required this.firebaseCollection});

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreenState(firebaseCollection: firebaseCollection);
  }
}

class _ChangePasswordScreenState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  late AuthFunction _auth;
  final FirebaseCollection firebaseCollection;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _ChangePasswordScreenState({required this.firebaseCollection}) {
    _auth = AuthFunction(firebaseCollection: firebaseCollection);
  }

  @override
  Widget build(BuildContext context) {
    Global globalColours = new Global();
    var passwordField = InputWidget(
      _passwordController,
      TextInputAction.next,
      TextInputType.text,
      "Password",
      true,
      Icons.password,
      (value) => PasswordFieldValidator.validate(value),
      key: Key("password-field"),
    );

    var confirmPasswordField = InputWidget(
      _confirmPasswordController,
      TextInputAction.done,
      TextInputType.text,
      "Confirm Password",
      true,
      Icons.password,
      (value) => ConfirmPasswordFieldValidator.validate(
          value, _passwordController.text),
      key: Key("confirm-password-field"),
    );
    User? user = firebaseCollection.firebaseAuth.currentUser;

    changePassword(String pass) async {
      await user!.updatePassword(pass);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your password has been changed"),
          duration: Duration(milliseconds: 750)));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(firebaseCollection: firebaseCollection)));
    }

    var confirmButton = ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          changePassword(_passwordController.text.toString());
        }
      },
      child: Text("Change Password"),
      key: Key("change-password-button"),
    );

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 100,
                      child: Text(
                        "MOTUS",
                        style: TextStyle(
                            fontFamily: "TypoRound",
                            fontWeight: FontWeight.w900,
                            fontSize: 80,
                            color: globalColours.baseColour),
                      )),
                  SizedBox(height: 25),
                  passwordField,
                  SizedBox(height: 25),
                  confirmPasswordField,
                  SizedBox(height: 25),
                  confirmButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
