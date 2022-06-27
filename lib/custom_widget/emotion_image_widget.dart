import 'package:flutter/material.dart';
import 'dart:ui';

class EmotionImage extends StatelessWidget {
  final Widget image;
  final Color color;
  EmotionImage(this.color , this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        height: height,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 3, color: color),
              borderRadius: BorderRadius.circular(15.0)),
          child: ClipRRect(
            child: image,
            borderRadius: BorderRadius.circular(15.0),
          ),
        ));
  }
}
