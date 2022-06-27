import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_demo/services/theme.dart';
import 'services/global_colours.dart';
import 'package:flutter/material.dart';
import 'package:game_demo/splash.dart';
import 'package:provider/provider.dart';

import 'services/auth_function.dart';
import './models/player.dart';
import "package:game_demo/models/firebase_collection.dart";

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseCollection firebaseCollection = FirebaseCollection(
    firebaseAuth: FirebaseAuth.instance, 
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseStorage: FirebaseStorage.instance
  );
  runApp(ChangeNotifierProvider(create: (context) => ThemeManager(isDark: false),child: MyApp(firebaseCollection: firebaseCollection)));
}

class MyApp extends StatelessWidget {
  final FirebaseCollection firebaseCollection;
  const MyApp({Key? key, required this.firebaseCollection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Global globalColours = new Global();    
    return StreamProvider<Player?>.value(
        catchError: (_, __) => null,
        value: AuthFunction(firebaseCollection: firebaseCollection).player,
        initialData: null,
        child: Consumer<ThemeManager>(
          builder: (context, themeManager,child) {
            return MaterialApp(
              theme: themeManager.themeMode,
              home: Splash());
          }),
        );
  }
}
