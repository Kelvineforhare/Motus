import 'package:flutter/material.dart';
import "package:game_demo/models/firebase_collection.dart";
import 'package:game_demo/screens/game_screen.dart';
import 'package:game_demo/screens/settings_page.dart';

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, FirebaseCollection firebaseCollection) {
    switch (item) {
      case MenuItems.home:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GameScreen(firebaseCollection: firebaseCollection)));
        break;
      case MenuItems.settings:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage(firebaseCollection: firebaseCollection)));
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
