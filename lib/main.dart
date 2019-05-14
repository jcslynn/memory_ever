import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memory_ever/screens/splash.dart';
import 'package:memory_ever/screens/intro.dart';
import 'package:memory_ever/screens/main/scan_history/scan_history.dart';
import 'package:memory_ever/screens/scanner/scanner.dart';
import 'package:memory_ever/screens/webview.dart';

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
      home: SplashScreen(),
//      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/intro1': (BuildContext context) => IntroPage(1),
        '/intro2': (BuildContext context) => IntroPage(2),
        '/intro3': (BuildContext context) => IntroPage(3),
        '/intro4': (BuildContext context) => IntroPage(4),
        '/scan': (BuildContext context) => ScanScreen(),
        '/history': (_) => ScanHistory(),
        '/webview': (BuildContext context) => WebViewScreen(),
      }
    );
  }
}



