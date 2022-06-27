import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_function.dart';
import '../models/player.dart';
import 'package:game_demo/services/global_colours.dart';


class ProfileWidget extends StatelessWidget {
  late String imagePath;
  late var onClicked;

  ProfileWidget(
    this.imagePath, {
    Key? key,
    this.onClicked,
  }) : super(key: key);

  Global globalColours = new Global();

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Stack(
        children: [buildImage(this.imagePath)],
      ),
    );
  }

  Widget buildImage(String image) {
    String imagePth = image;

    return ClipOval(
        child: Material( 
          shape: CircleBorder(side: BorderSide(color:globalColours.navColour, width: 3)),
      color: Colors.transparent,
      child: Image.network(
        imagePth,
        width: 180,
        height: 180,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      ),
      //   imagePth,
      //   width: 200,
      //   height: 200,
      //   alignment: Alignment.center,
      //   fit: BoxFit.cover,
      // ),
      // Ink.image(

      //   image: image2,
      //   fit: BoxFit.cover,
      //   width: 128,
      //   height: 128,
      // )
    ));
  }
}
