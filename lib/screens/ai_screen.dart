import 'package:flutter/material.dart';
import 'package:game_demo/screens/image_prediction.dart';
import 'package:game_demo/screens/text_uploader.dart';
import 'package:game_demo/services/global_colours.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Global globalColours = new Global();
    return Scaffold(
        appBar: AppBar(
            //  leading: Image.asset('assets/logo.png'),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  Text(
                    "A.I EMOTION CAPTURE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: globalColours.baseColour),
                  )
                ])),
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.orangeAccent, width: 1),
                              top:
                                  BorderSide(color: Colors.orangeAccent, width: 1),
                              left:
                                  BorderSide(color: Colors.orangeAccent, width: 1),
                              right: BorderSide(color: Colors.orangeAccent, width: 1)),
                          shape: BoxShape.circle,
                          color: globalColours.lfColour),
                      child: IconButton(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextUpload())),
                          icon: Icon(Icons.abc),
                          iconSize: 125),
                    ),
                    Text("Read Text",
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1, -1),
                                  color: Colors.orangeAccent),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1, -1),
                                  color: Colors.orangeAccent),
                              Shadow(
                                  // topRight
                                  offset: Offset(1, 1),
                                  color: Colors.orangeAccent),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1, 1),
                                  color: Colors.orangeAccent),
                            ],
                            fontSize: 20,
                            color: globalColours.lfColour,
                            fontFamily: "TypoRound",
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.redAccent, width: 1),
                              top:
                                  BorderSide(color: Colors.redAccent, width: 1),
                              left:
                                  BorderSide(color: Colors.redAccent, width: 1),
                              right: BorderSide(
                                  color: Colors.redAccent, width: 1)),
                          shape: BoxShape.circle,
                          color: globalColours.mfColour),
                      child: IconButton(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImPred())),
                          icon: Icon(Icons.camera_alt, size: 100),
                          iconSize: 125),
                    ),
                    Text("Take a Picture",
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1, -1),
                                  color: Colors.redAccent),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1, -1),
                                  color: Colors.redAccent),
                              Shadow(
                                  // topRight
                                  offset: Offset(1, 1),
                                  color: Colors.redAccent),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1, 1),
                                  color: Colors.redAccent),
                            ],
                            fontSize: 20,
                            color: globalColours.mfColour,
                            fontFamily: "TypoRound",
                            fontWeight: FontWeight.w900)),
                            const SizedBox(height: 20),
                   
                  ])),
            ],
          ),
        ));
  }
}
