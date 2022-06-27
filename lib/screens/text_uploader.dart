//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ffi';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
//import 'package:game_demo/loading.dart';
//import 'package:game_demo/services/auth_function.dart';
//import 'package:tflite/tflite.dart';

import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:game_demo/services/global_colours.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';

final ImagePicker picker = ImagePicker();

class TextUpload extends StatefulWidget {
  TextUpload();

  @override
  State<StatefulWidget> createState() {
    return TextUploadScreenState();
  }
}

class TextUploadScreenState extends State<TextUpload> {
  var inputController = TextEditingController();
  var outputController = TextEditingController();
  Global globalColours = new Global();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var inputField = TextField(
        //initialValue: "I am not happy about what you did",
        controller: inputController,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: 'Entered text',
            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: globalColours.baseColour),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: globalColours.baseColour),
              borderRadius: BorderRadius.circular(15),
            )));
    var outputField = TextField(
        readOnly: true,
        controller: outputController,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: "Detected Emotions",
            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: globalColours.baseColour),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: globalColours.baseColour),
              borderRadius: BorderRadius.circular(15),
            )));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: 0.1,
              alignment: Alignment.bottomCenter,
              image: Image.asset("assets/images/login-screen-logo.png").image),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 55),
            Center(
              child: changePictureButton(),
            ),
            SizedBox(height: 15),
            Center(
              child: SizedBox(
                width: width * 0.9,
                height: 150,
                child: inputField,
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(12, 8, 12, 8))),
                icon: Icon(Icons.check),
                onPressed: () {
                  readEmotions();
                },
                label: Text("Check Text"),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: SizedBox(
                width: width * 0.9,
                height: 150,
                child: outputField,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePictureButton() {
    return ElevatedButton.icon(
        style: ButtonStyle(
            padding:
                MaterialStateProperty.all(EdgeInsets.fromLTRB(12, 8, 12, 8))),
        icon: Icon(Icons.add_box, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (builder) => bottomSheet());
        },
        label: Text("Choose Image"));
  }

  Future<void> readEmotions() async {
    //uses API to get emotions from textr
    var submission = inputController.text;
    var result = await emotionAPI(submission);
    outputController.text = result;
  }

  Future<void> convertToText(Uint8List imageBytes, String? extension) async {
    //uses API to get text from image
    String base64String = base64Encode(imageBytes);
    String text = "";
    final response = await http.post(
      Uri.parse('https://api.ocr.space/parse/image'),
      headers: <String, String>{
        'apikey': 'K86879642988957',
      },
      body: <String, String>{
        'base64image': 'data:image/' + extension! + ';base64,' + base64String,
      },
    );

    if (response.statusCode == 200) {
      text = jsonDecode(response.body)["ParsedResults"][0]["ParsedText"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
    inputController.text = text;
    readEmotions();
  }

  Future<String> emotionAPI(String text) async {
    //uses API to get text from image
    Map<String, String> queryParameters = {
      'text': text,
      'api_key': 'eU92DYndcenjg8JSfk07A3ndwLGrizz2p8aL16LlCCM',
    };
    var uri = Uri.parse('https://apis.paralleldots.com/v4/emotion?');
    uri = uri.replace(queryParameters: queryParameters);
    final response = await http.post(uri, body: queryParameters);
    var emotionBreakdown = "";
    Map<double, String> finalMap = {};
    List confidenceList = [];
    if (response.statusCode == 200) {
      var jsonResp = jsonDecode(response.body)["emotion"];
      for (String key in jsonResp.keys) {
        confidenceList.add(jsonResp[key]);
        confidenceList.sort((b, a) => a.compareTo(b));
        // emotionBreakdown +=
        //     key + ": " + ((jsonResp[key] * 100).round()).toString() + "% \n";
      }
      for (var i in confidenceList) {
        for (String key in jsonResp.keys) {
          if (i == jsonResp[key]) {
            finalMap.addAll({i: key});
          }
        }
      }
      for (var j in [0, 1, 2]) {
        emotionBreakdown += finalMap[finalMap.keys.elementAt(j)].toString() +
            ": " +
            (finalMap.keys.elementAt(j) * 100).round().toString() +
            "% \n";
      }
      // for (String key in jsonResp.keys) {
      //   emotionBreakdown +=
      //       key + ": " + ((jsonResp[key] * 100).round()).toString() + "% \n";
      // }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
    return emotionBreakdown;
  }

  String getFileExtension(String fileName) {
    return fileName.split('.').last;
  }

  void pickPhoto(ImageSource source) async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(initialDirectory: source.toString(), type: FileType.image);
      if (result != null && result.files.isNotEmpty) {
        String? extension = result.files.first.extension;
        var bytes = result.files.first.bytes!;
        await convertToText(bytes, extension);
      }
    } else {
      XFile? result = await picker.pickImage(source: source);
      if (result != null) {
        String extension = getFileExtension(result.path);
        var bytes = await File(result.path.toString()).readAsBytes();
        await convertToText(bytes, extension);
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

  // runModel() async {
  //   Tflite.run
  // }
}

// Import tflite_flutter

