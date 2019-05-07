import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.pushReplacementNamed(context, '/scan');
    } else {
      prefs.setBool('seen', true);
      Navigator.pushReplacementNamed(context, '/intro1');
    }
  }


  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//        color: Colors.black,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/group227.png'),
                  fit: BoxFit.cover,
              ),
          ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/group228.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.56,
          ),
        ),
        ),
    );
  }
}
