// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_demo/models/predictor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ImPred extends StatefulWidget {
  @override
  ImPredState createState() => ImPredState();
}

class ImPredState extends State<ImPred> {
  Predictor predictor = Predictor();
  Image? jam;
  String pred1 = "";
  String pred2 = "";
  String pred3 = "";
  String output = "";
  bool _isLoading = true;
  File _image = File("");
  List _output = [];
  final picker = ImagePicker();

  void loadModelB() async {
    await Tflite.loadModel(
        model: "assets/tensor_flow/face_emotion_model_2.tflite",
        labels: "assets/tensor_flow/label.txt");
  }

  @override
  void initState() {
    super.initState();
    predictor.loadPictureModel();
  }

  detectImage(File image) async {
    var predictions = await predictor.runPictureModel(image.path);

    setState(() {
      _isLoading = false;
      _output = predictions as List<dynamic>;

      pred1 =
          "${predictions[0]['label']} with ${(predictions[0]['confidence'] * 100).toStringAsFixed(2)}% confidence";
      pred2 =
          "${predictions[1]['label']} with ${(predictions[1]['confidence'] * 100).toStringAsFixed(2)}% confidence";
      pred3 =
          "${predictions[2]['label']} with ${(predictions[2]['confidence'] * 100).toStringAsFixed(2)}% confidence";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _isLoading = false;
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _isLoading = false;
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 75.0,
                ),
                Center(
                  child: Text(
                    'What emotion is your picture?',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Center(
                  child: _isLoading
                      ? Container(
                          width: 250,
                          height: 250,
                          foregroundDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.lightBlue, width: 3),
                                  left: BorderSide(
                                      color: Colors.lightBlue, width: 3),
                                  right: BorderSide(
                                      color: Colors.lightBlue, width: 3),
                                  bottom: BorderSide(
                                      color: Colors.lightBlue, width: 3))),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/default profile.png"),
                                  fit: BoxFit.cover)))
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                  width: 250,
                                  height: 250,
                                  foregroundDecoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 3),
                                          left: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 3),
                                          right: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 3),
                                          bottom: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 3))),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(_image),
                                          fit: BoxFit.cover))),
                              SizedBox(
                                height: 20.0,
                              ),
                              _output != null
                                  ? Container(
                                      child: Column(children: [
                                        Text(
                                          pred1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        Text(
                                          pred2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        Text(
                                          pred3,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                      ]),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            pickImage();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15.0),
                            child: Text(
                              'Take a picture',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pickGalleryImage();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 15.0),
                            child: Text(
                              'Select from gallery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
