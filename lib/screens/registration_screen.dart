// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:game_demo/loading.dart';

import 'package:game_demo/custom_widget/input_widget.dart';

import 'package:game_demo/models/validators.dart';
import "package:game_demo/models/firebase_collection.dart";

import 'package:game_demo/services/global_colours.dart';
import 'package:game_demo/services/auth_function.dart';

class RegistrationScreen extends StatefulWidget {
  final Function toggle;
  final FirebaseCollection firebaseCollection;
  RegistrationScreen({required this.toggle, required this.firebaseCollection});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreenState(firebaseCollection: firebaseCollection);
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {    
  final _formKey = GlobalKey<FormState>();
  late AuthFunction _auth;
  final FirebaseCollection firebaseCollection;  bool loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  var error = "";

  _RegistrationScreenState({required this.firebaseCollection}) {
    _auth = AuthFunction(firebaseCollection: firebaseCollection);
  }

  @override
  Widget build(BuildContext context) {
    Global globalColours = new Global();
    var nameField = InputWidget(
        _nameController,
        TextInputAction.next,
        TextInputType.name,
        "First Name",
        false,
        Icons.person,
        (value) => NameFieldValidator.validate(value),
        key: Key("first-name-field")
        );

    var emailField = InputWidget(
        _emailController,
        TextInputAction.next,
        TextInputType.emailAddress,
        "Email",
        false,
        Icons.email,
        (value) => EmailFieldValidator.validate(value),
        key: Key("email-field")
        );

    var passwordField = InputWidget(
        _passwordController,
        TextInputAction.next,
        TextInputType.text,
        "Password",
        true,
        Icons.password,
        (value) => PasswordFieldValidator.validate(value),
        key: Key("password-field")
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
        key: Key("confirm-password-field")
        );

    var registerButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            loading = true;
          });
          var player = await _auth.signUp(_nameController.text,
              _emailController.text, _passwordController.text);
          if (player == null) {
            setState(() {
              error = "Invalid sign up credentials, please try again";
              loading = false;
            });
          }
        }
      },
      child: Text(
        "Sign Up",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50)),
      key: Key("sign-up")
    );
    return loading
        ? Loading()
        : Scaffold(
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
                              height: 120,
                              child: Text(
                                "MOTUS",
                                style:
                                    TextStyle(fontFamily: "TypoRound", fontSize: 80, color: globalColours.baseColour, fontWeight: FontWeight.w900),
                              )),
                          Text(error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16)),
                          SizedBox(height: 25),
                          nameField,
                          SizedBox(height: 25),
                          emailField,
                          SizedBox(height: 25),
                          passwordField,
                          SizedBox(height: 25),
                          confirmPasswordField,
                          SizedBox(height: 15),
                          registerButton,
                          SizedBox(height: 15),
                          TextButton(
                            key: Key("log-in-button"),
                              child: Text("Already have an account? Log in"),
                              onPressed: (() {
                                widget.toggle();
                              })),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
