import 'package:flutter/material.dart';
import 'package:game_demo/services/storage.dart';
import "package:game_demo/models/firebase_collection.dart";

class FaceLoader {
  final firebaseCollection;
  late Storage storage;

  FaceLoader({required this.firebaseCollection}) {
    storage = Storage(firebaseCollection: firebaseCollection);
  }

  Future<Widget> loadRandomFace(String imgName) async { 	 
    String url = await storage.downloadEmotionImageUrl(imgName);
    return Image.network(url, fit: BoxFit.cover);
  }

  Future<List<Widget>> loadRandomFaces(String emotion1, String emotion2, String emotion3, String emotion4) async {
    return Future.wait([
      loadRandomFace(emotion1),
      loadRandomFace(emotion2),
      loadRandomFace(emotion3),
      loadRandomFace(emotion4)
    ]);
  }
}