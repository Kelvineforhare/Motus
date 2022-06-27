import 'package:tflite/tflite.dart';

class Predictor {
  var picPredictions;
  var textPredictions;

  loadPictureModel() async {
    //FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;

    await Tflite.loadModel(
        model: "assets/tensor_flow/face_emotion_model_2.tflite",
        labels: "assets/label.txt");
  }

  runPictureModel(String imagePath) async {
    picPredictions = await Tflite.runModelOnImage(
      asynch: true,
      path: imagePath,
      numResults: 3,
      threshold: 0.0,
      imageMean: 0,
      imageStd: 1,
    );
    return picPredictions;
  }
}
