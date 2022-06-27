import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:game_demo/models/firebase_collection.dart";

class Storage {
  final bool _isLoading = false;
  final FirebaseCollection firebaseCollection;
  late FirebaseStorage _storage;
  late User? user;

  Storage({required this.firebaseCollection}) {
    _storage = firebaseCollection.firebaseStorage;
    user = firebaseCollection.firebaseAuth.currentUser;
  }

  Future<String> uploadFile(File file) async {
    var userID = user!.uid;

    var storageRef = _storage.ref().child("user/profile/${userID.toString()}");
    UploadTask uploadTask = storageRef.putFile(file);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadBytes(Uint8List fileBytes) async {
    var userID = user!.uid;
    var storageRef = _storage.ref().child("user/profile/${userID.toString()}");
    UploadTask uploadTask = storageRef.putData(fileBytes);
    return await (await uploadTask).ref.getDownloadURL();
  }

  Future<String> getUserProfileImageUrl(String uid) async {
    var storageRef = (_storage.ref().child("user/profile/$uid"));
    var newUrl = (await storageRef.getDownloadURL());
    return newUrl.toString();
  }

  Future<String> downloadEmotionImageUrl(String emotion) async {
    var rng = Random();

    ListResult result =
        await firebaseCollection.firebaseStorage.ref(emotion).listAll();
    List<Reference> resultList = result.items;
    Reference test = resultList[rng.nextInt(resultList.length - 1)];
    return test.getDownloadURL();
  }

  Future<String> getImageURL(String imageName) async {
    String url = await firebaseCollection.firebaseStorage
        .ref(imageName)
        .getDownloadURL();
    return url;
  }
}
