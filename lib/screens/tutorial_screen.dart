import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_demo/models/firebase_collection.dart';
import 'package:game_demo/models/player.dart';
import 'package:game_demo/screens/home_page.dart';
import 'package:game_demo/services/database.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/global_colours.dart';

class TutorialScreen extends StatefulWidget {
  final FirebaseCollection firebaseCollection;
  const TutorialScreen({Key? key, required this.firebaseCollection})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorialScreenState(firebaseCollection: firebaseCollection);
  }
}

class TutorialScreenState extends State<TutorialScreen> {
  final FirebaseCollection firebaseCollection;
  final carouselController = CarouselController();
  String pID = "";
  int activeIndex = 0;
  final assetImages = [
    'assets/images/tutorial1.png',
    'assets/images/tutorial2.png',
    'assets/images/tutorial3.png',
    'assets/images/tutorial4.png',
    'assets/images/tutorial5.png',
    'assets/images/tutorial6.png',
    'assets/images/tutorial7.png',
  ];

  Global globalColours = new Global();
  TutorialScreenState({required this.firebaseCollection});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player?>(context);
    final height = MediaQuery.of(context).size.height;
    pID = player!.playerId;
    return StreamBuilder<PlayerData?>(
        stream: DatabaseService(
                uid: player.playerId, firebaseCollection: firebaseCollection)
            .userData,
        builder: (context, snapshot) {
          return Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: activeIndex == assetImages.length - 1 ? Text('Continue') : Text("Skip"),
                    onPressed: () {
                      DatabaseService(
                              firebaseCollection: firebaseCollection,
                              uid: player.playerId)
                          .updateFirstLoad(false);
                    },
                  ),
                ),
                SizedBox(height: 10),
                CarouselSlider.builder(
                  carouselController: carouselController,
                  options: CarouselOptions(
                      height: height * 0.75,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      }),
                  itemCount: assetImages.length,
                  itemBuilder: (context, index, realIndex) {
                    final assetImage = assetImages[index];

                    return buildImage(assetImage, index);
                  },
                ),
                SizedBox(height: 10),
                buildIndicator(),
                SizedBox(height: 20),
                buildButtons(),
              ],
            ),
          ));
        });
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: assetImages.length,
        effect: WormEffect(
          activeDotColor: globalColours.baseColour,
        ));
  }

  Widget buildImage(String assetImage, int index) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.grey,
        child: Image.asset(
          assetImage,
          fit: BoxFit.cover,
        ));
  }

  Widget buildButtons({bool stretch = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5)),
          child: Icon(Icons.arrow_back, size: 32),
          onPressed: previous,
        ),
        stretch ? Spacer() : SizedBox(width: 70),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5)),
          child: Icon(Icons.arrow_forward, size: 32),
          onPressed: next,
        )
      ],
    );
  }

  void next() {
    if (activeIndex == assetImages.length - 1) {
      DatabaseService(
              firebaseCollection: firebaseCollection, uid: pID)
          .updateFirstLoad(false);
    } else {
      carouselController.nextPage();
    }
  }

  void previous() {
    carouselController.previousPage();
  }
}
