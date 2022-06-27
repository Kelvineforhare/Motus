// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/input_widget.dart';
import 'package:game_demo/custom_widget/profile_pic.dart';
import 'package:game_demo/loading.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/models/player.dart';
import 'package:game_demo/screens/user_profile.dart';
import 'package:game_demo/services/auth_function.dart';
import 'package:game_demo/services/database.dart';
import 'package:game_demo/services/global_colours.dart';
import 'package:game_demo/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  //final Function toggle;
  final FirebaseCollection firebaseCollection;
  EditProfileScreen({required this.firebaseCollection});

  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreenState(firebaseCollection: firebaseCollection);
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late AuthFunction _auth;
  final FirebaseCollection firebaseCollection;
  bool changed = false;

  //late String actualImage;

  var error = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  late Storage profileStore;
  late User? user;

  _EditProfileScreenState({required this.firebaseCollection}) {
    _auth = AuthFunction(firebaseCollection: firebaseCollection);
    user = firebaseCollection.firebaseAuth.currentUser;
    profileStore = Storage(firebaseCollection: firebaseCollection);
  }

  @override
  Widget build(BuildContext context) {
    Global globalColours = new Global();
    final player = Provider.of<Player?>(context, listen: false);

    return StreamBuilder<PlayerData?>(
        stream: DatabaseService(
                uid: player!.playerId, firebaseCollection: firebaseCollection)
            .userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            _auth.signOut();
          }
          if (snapshot.hasData) {
            PlayerData? playerData = snapshot.data;

            return Scaffold(
                key: Key("edit-profile-screen"),
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
                              Text(error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                              imageProfile(playerData!.imagePath),
                              SizedBox(height: 25),
                              changePictureButton(),
                              SizedBox(height: 25),
                              InputWidget(
                                  _nameController,
                                  TextInputAction.next,
                                  TextInputType.name,
                                  playerData.playerName,
                                  false,
                                  Icons.person,
                                  (value) => value!.length > 36
                                      ? "Username too long ( over 36 characters )"
                                      : null),
                              SizedBox(height: 25),
                              InputWidget(
                                  _bioController,
                                  TextInputAction.next,
                                  TextInputType.multiline,
                                  "Your bio",
                                  false,
                                  Icons.person,
                                  (value) => value!.length > 100
                                      ? "Bio too long ( over 100 characters )"
                                      : null),
                              SizedBox(height: 25),
                              ElevatedButton(
                                onPressed: () async {
                                  String accImage = playerData.imagePath;
                                  if (_formKey.currentState!.validate()) {
                                    var newName = _nameController.text;
                                    var newBio = _bioController.text;
                                    if (newName.isEmpty) {
                                      newName = playerData.playerName;
                                    }
                                    if (changed) {
                                      accImage = await (await getDownloadUrl())
                                          .toString();
                                    }
                                    if (newBio.isEmpty) {
                                      newBio = playerData.bio;
                                    }

                                    await DatabaseService(
                                            uid: player.playerId,
                                            firebaseCollection:
                                                firebaseCollection)
                                        .updateUserData(
                                            newName,
                                            newBio,
                                            accImage,
                                            playerData.email,
                                            playerData.chooseFaceLevel,
                                            playerData.learnFaceLevel,
                                            playerData.makeFaceLevel);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Your profile has been edited"),
                                            duration:
                                                Duration(milliseconds: 750)));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                firebaseCollection:
                                                    firebaseCollection)));
                                  }
                                },
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width, 50)),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }

  Widget imageProfile(String imagePath) {
    String image;
    if (changed == true) {
      image = imagePath;
    } else {
      image = imagePath;
    }

    return Stack(
      children: [
        ProfileWidget(
          image,
        ),
        // Image.asset(
        //   imagePath,
        //   width: 200,
        //   height: 200,
        //   alignment: Alignment.center,
        //   fit: BoxFit.cover,
        // ),
        // Positioned(
        //   bottom: 20.0,
        //   right: 5.0,
        //   child: Icon(
        //     Icons.camera_alt,
        //     color: Colors.blue,
        //     size: 28.0,
        //   ),
        // )
      ],
    );
  }

  Widget changePictureButton() {
    return ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (builder) => bottomSheet());
        },
        child: Text("Change Profile Picture"));
  }

  Future<void> uploadProfilePicture(File image) async {
    await profileStore.uploadFile(image);
  }

  Future<void> uploadProfilePictureBytes(Uint8List imageBytes) async {
    await profileStore.uploadBytes(imageBytes);
  }

  Future<String> getDownloadUrl() {
    String downURl = "";
    return profileStore.getUserProfileImageUrl(user!.uid);
  }

  void pickPhoto(ImageSource source) async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(initialDirectory: source.toString(), type: FileType.image);
      if (result != null && result.files.isNotEmpty) {
        changed = true;
        uploadProfilePictureBytes(result.files.first.bytes!);
      }
    } else {
      XFile? result = await picker.pickImage(source: source);
      if (result != null) {
        changed = true;
        uploadProfilePicture(File(result.path.toString()));
      }
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: [
        Text("Choose Profile Photo"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                pickPhoto(ImageSource.camera);
              },
              icon: Icon(Icons.camera),
              label: Text("Camera"),
            ),
            TextButton.icon(
              onPressed: () {
                pickPhoto(ImageSource.gallery);
              },
              icon: Icon(Icons.image),
              label: Text("Gallery"),
            ),
          ],
        )
      ]),
    );
  }
}
