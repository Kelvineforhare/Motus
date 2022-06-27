import 'package:flutter/material.dart';

import 'global_colours.dart';

final Global globalColours = new Global();

class ThemeManager extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData lightTheme = ThemeData(
      appBarTheme: AppBarTheme(color: Colors.white),
      brightness: Brightness.light,
      fontFamily: "Nunito",
      primaryColor: globalColours.baseColour,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.white, fontFamily: "TypoRound")),
              backgroundColor:
                  MaterialStateProperty.all(globalColours.baseColour))));

  ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Nunito",
      primaryColor: globalColours.baseColour,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(72, 68, 68, 1))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(globalColours.baseColour),
              textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.white, fontFamily: "TypoRound")))));

  ThemeManager({required bool isDark}) {
    this._selectedTheme = isDark ? darkTheme : lightTheme;
  }

  get themeMode => _selectedTheme;

  toggleTheme() {
    _selectedTheme = _selectedTheme == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
  }
}
