import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memory_ever/screens/splash.dart';
import 'package:memory_ever/screens/intro/index.dart';
import 'package:memory_ever/screens/main/scan_history/scan_history.dart';
import 'package:memory_ever/screens/main/scanner/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Forever',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(),
//      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => new SplashScreen(),
        '/intro1': (BuildContext context) => new IntroPage(1),
        '/intro2': (BuildContext context) => new IntroPage(2),
        '/intro3': (BuildContext context) => new IntroPage(3),
        '/intro4': (BuildContext context) => new IntroPage(4),
        '/scan': (BuildContext context) => new ScanScreen(),
        '/history': (_) => ScanHistory(),
      }
    );
  }
}



