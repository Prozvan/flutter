import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prosen_final/firebase_options.dart';
import "pages/home_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: MaterialApp(
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        )
        // runApp(MaterialApp(home: App()));
        );
  }
}



//https://youtu.be/BUCCHdKwKxE?si=gxpzJeebiklhJltx
//8.20