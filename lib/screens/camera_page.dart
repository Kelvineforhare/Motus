import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraImage? cameraImage;
  CameraController? camControl;
  String output = "";
  List<CameraDescription>? cameras;
  File? photo;

  defineCameras() async {
    cameras = await availableCameras();
  }

  Future<void> setupCamera() async {
    cameras = await availableCameras();
    // var controller = await selectCamera();
    // setState(() => _controller = controller);
  }

  loadCamera() async {
    await setupCamera();

    camControl = CameraController(cameras![0], ResolutionPreset.high);
    camControl!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          camControl!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Page"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: !camControl!.value.isInitialized
                  ? Container()
                  : AspectRatio(
                      aspectRatio: camControl!.value.aspectRatio,
                      child: CameraPreview(camControl!),
                    ),
            ),
          ),
          Text(output)
        ],
      ),
    );
  }

  void runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          //rotation: 90,
          numResults: 3,
          threshold: 0.1,
          asynch: true);
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/tensor_flow/face_model.tflite",
        labels: "assets/label.txt");
  }
}
