import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';

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
//      home: Splash(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/intro1': (context) => IntroPage(1),
        '/intro2': (context) => IntroPage(2),
        '/intro3': (context) => IntroPage(3),
        '/intro4': (context) => IntroPage(4),
//        '/scan': (context) => ScanPage(),
      }
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.pushNamed(context, '/intro1');
    } else {
      prefs.setBool('seen', true);
      Navigator.pushNamed(context, '/intro1');
    }
  }


  @override
  void initState() {
    super.initState();
//    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final int stepNum;

  const IntroPage(this.stepNum);

  String getStepNum() {
    return this.stepNum.toString() + ' / 4';
  }

  String getStepText() {
    switch (this.stepNum) {
      case 1:
        return '先申請我們的計劃';
      case 2:
        return '獲得專用暮誌銘並掃描二維碼';
      case 3:
        return '輸入密碼查看先人墓誌銘頁面';
      case 4:
        return '把先人事蹟傳承下去';
      default:
        return '';
    }
  }

  String getStepImageUrl() {
    switch (this.stepNum) {
      case 1:
        return 'assets/shutterstock138342692.png';
      case 2:
        return 'assets/shutterstock635558846.png';
      case 3:
        return 'assets/shutterstock261845771.png';
      case 4:
        return 'assets/shutterstock333702980.png';
      default:
        return 'assets/shutterstock635558846.png';
    }
  }

  List<Widget> getControlButtons(BuildContext context) {
    return <Widget>[
      this.stepNum == 1 ? Icon(Icons.arrow_back, color: Colors.transparent, size: 40.0) :
      IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40.0),
        onPressed: () {Navigator.pop(context);},
      ),
      Expanded(
          flex: 1,
          child: Text(
            getStepNum(),
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30.0,
            ),
          )),
      this.stepNum == 4 ? Icon(Icons.arrow_forward, color: Colors.transparent, size: 40.0):
      IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.white, size: 40.0),
        onPressed: () { Navigator.pushNamed(context, '/intro' + (this.stepNum + 1).toString());},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
              image: ExactAssetImage(getStepImageUrl()),
              fit: BoxFit.cover,
            )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.733,
              height: MediaQuery.of(context).size.width * 0.733,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3.0,
                  )
              ),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                child: Text(
                    getStepText(),
                     textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
//                    overflow: TextOverflow.clip,

                  )
              )
            ),
            Padding(padding: EdgeInsets.only(top: 32.0),),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.733,
              child: Row(
                children: getControlButtons(context)
              )
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: this.stepNum == 4 ? FlatButton(
                color: Colors.blue,
                  onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/intro1', ModalRoute.withName('/splash'));},
                  child: Text('開始使用', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),)
              ) : null,
            )
          ],
        )
      )
    );
  }
}
//
//class ScanPage extends StatefulWidget {
//  @override
//  _ScanPageState createState() => _ScanPageState();
//}
//
//class _ScanPageState extends State<ScanPage> {
//  String qrcode = '';
//
//  @override
//  initState() {
//    super.initState();
//  }
//
//  Widget build(BuildContext context) {
//    return new Scaffold(
//          appBar: new AppBar(
//            title: new Text('Barcode Scanner Example'),
//          ),
//          body: new Center(
//            child: new Column(
//              children: <Widget>[
//                new Container(
//                  child: new MaterialButton(
//                      onPressed: scan, child: new Text("Scan")),
//                  padding: const EdgeInsets.all(8.0),
//                ),
//                new Text(qrcode),
//              ],
//            ),
//          )
//    );
//  }
//
//  Future scan() async {
//    try {
//      String qrcode = await BarcodeScanner.scan();
//      setState(() => this.qrcode = qrcode);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        setState(() {
//          this.qrcode = 'The user did not grant the camera permission!';
//        });
//      } else {
//        setState(() => this.qrcode = 'Unknown error: $e');
//      }
//    } on FormatException{
//      setState(() => this.qrcode = 'null (User returned using the "back"-button before scanning anything. Result)');
//    } catch (e) {
//      setState(() => this.qrcode = 'Unknown error: $e');
//    }
//  }
//}
