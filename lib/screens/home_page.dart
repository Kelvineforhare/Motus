import 'package:flutter/material.dart';
import 'package:game_demo/services/theme.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/screens/ai_screen.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';
import 'game_screen.dart';
import 'package:game_demo/services/global_colours.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  final FirebaseCollection firebaseCollection;
  const HomePage({Key? key, required this.firebaseCollection}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(firebaseCollection: firebaseCollection);
}

class _HomePageState extends State<HomePage> {
  PersistentTabController tabController = PersistentTabController(initialIndex: 1);

  final FirebaseCollection firebaseCollection;
  _HomePageState({required this.firebaseCollection});
  
  final Global globalColours = new Global();

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = Provider.of<ThemeManager>(context, listen: false);
    
    return PersistentTabView(context,
        backgroundColor: themeManager.themeMode == themeManager.darkTheme ? Color.fromRGBO(72, 68, 68, 1): Colors.white,
        screens: _buildScreens(),
        controller: tabController,
        decoration: NavBarDecoration(boxShadow: [BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
            ),]),
        items: _navigationBarItems(),
        resizeToAvoidBottomInset: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 200), curve: Curves.ease),
        screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            duration: Duration(
                milliseconds:
                    100), // keep duration time LOW otherwise there is a black screen if tabs are switched quickly.
            curve: Curves.fastLinearToSlowEaseIn),
        navBarStyle: NavBarStyle.style6,
        key: Key("navbar")
      );
  }

  List<Widget> _buildScreens() {
    return [AIScreen(),GameScreen(firebaseCollection: firebaseCollection), ProfilePage(firebaseCollection: firebaseCollection)];
  }

  List<PersistentBottomNavBarItem> _navigationBarItems() {
    return [
       PersistentBottomNavBarItem(
          icon: Icon(Icons.camera_alt),
          title: "Capture",
          activeColorPrimary: globalColours.baseColour,
          inactiveColorPrimary: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.games),
          title: "Learn",
          activeColorPrimary: globalColours.baseColour,
          inactiveColorPrimary: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person, key: Key("profile-link")),
          title: "Profile",
          activeColorPrimary: globalColours.baseColour,
          inactiveColorPrimary: Colors.grey),
    ];
  }

  // NOT PERSISTENT NAV BAR

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: PageView(
  //       controller: pageController,
  //       children: [HomeScreen(), ProfilePage()],
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       mouseCursor: SystemMouseCursors.grab,
  //       currentIndex: _currentIndex,
  //       onTap: onTapped,
  //       items: [
  //         BottomNavigationBarItem(icon: Icon(Icons.games), label: "Learn"),
  //         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
  //       ],
  //     ),
  //   );
  // }

  // void onTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 850),
  //       curve: Curves.fastLinearToSlowEaseIn);
  // }
}
