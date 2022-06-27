import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_demo/screens/change_password.dart';
import 'package:game_demo/services/database.dart';
import 'package:game_demo/services/auth_function.dart';
import 'package:game_demo/models/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_demo/screens/edit_profile.dart';
import 'package:game_demo/services/theme.dart';
import 'package:provider/provider.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/services/global_colours.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseCollection firebaseCollection;
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade600,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  SettingsPage({required this.firebaseCollection});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player?>(context, listen: false);
    ThemeManager themeManager =
        Provider.of<ThemeManager>(context, listen: false);
    Global globalColours = new Global();

    return StreamBuilder<PlayerData?>(
        stream: DatabaseService(
                uid: player!.playerId, firebaseCollection: firebaseCollection)
            .userData,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text("SETTINGS",
                      key: Key("settings-display"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: globalColours.baseColour))),
              body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "ACCOUNT",
                          style: headerStyle,
                          key: Key("account-display"),
                        ),
                        const SizedBox(height: 10.0),
                        Card(
                          elevation: 0.5,
                          margin: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 0,
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.edit_note,
                                  size: 30,
                                ),
                                title: Text("Edit your profile"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(
                                                  firebaseCollection:
                                                      firebaseCollection)));
                                },
                                key: Key("edit-profile"),
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(Icons.password),
                                title: Text("Change your password"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChangePassword(
                                              firebaseCollection:
                                                  firebaseCollection)));
                                },
                                key: Key("change-password"),
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(Icons.brightness_6),
                                title: themeManager.themeMode ==
                                        themeManager.darkTheme
                                    ? Text("Light mode")
                                    : Text("Dark mode"),
                                onTap: () {
                                  themeManager.toggleTheme();
                                },
                                key: Key("dark-mode"),
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(Icons.help),
                                title: Text("Help"),
                                onTap: () {
                                  DatabaseService(
                                          firebaseCollection:
                                              firebaseCollection,
                                          uid: player.playerId)
                                      .updateFirstLoad(true);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0)
                      ])));
        });
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
