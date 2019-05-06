import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:image_picker/image_picker.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:memory_ever/screens/main/scanner/parseContent.dart';
import 'package:memory_ever/screens/main/scanner/saveData.dart';
import 'card_info.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  bool openCardInfo = false;

  String barcode = '';

  Future openImageGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }

  void handleScannerCallback(String result) async {
    print(result);

    if (RegExp(r'^(www.memoryever.com/).*')
        .allMatches(result)
        .isNotEmpty) {
//      new HttpClient().getUrl(Uri.parse('https://'+result))
//          .then((HttpClientRequest request) => request.close())
//          .then((HttpClientResponse response) => response.transform(new Utf8Decoder()).listen((contents) => saveContents(contents)));
      String data = await initiate('https://'+result+'/');
      print(data);
      print(await saveScannedData(data));
    } else {
      print('no matches');
    }
  }

  void saveContents(contents){
    print(contents);
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: QrCamera(
              qrCodeCallback: handleScannerCallback,
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '掃描暮誌銘二維碼',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 5,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Text(
                          '我未擁有任何暮誌銘',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: openImageGallery,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              openCardInfo ? CardInfo() : null,
            ].where((widget) => widget != null).toList(),
          )
        ],
      ),
    );
//    return Scaffold(
//        body: new Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//          child: RaisedButton(
//            color: Colors.blue,
//            textColor: Colors.white,
//            splashColor: Colors.blueGrey,
//            onPressed: scan,
//            child: const Text('START CAMERA SCAN'),
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//          child: Text(
//            barcode,
//            textAlign: TextAlign.center,
//          ),
//        ),
//        Container(
//          color: Colors.white,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              FlatButton(
//                onPressed: null,
//                padding: EdgeInsets.all(0.0),
//                child: Container(
//                    decoration: BoxDecoration(
//                  image: DecorationImage(
//                    image: AssetImage('assets/isCard.png'),
//                    fit: BoxFit.fitWidth,
//                  ),
//                )),
//              ),
//            ],
//          ),
//        )
//      ],
//    ));
  }

//  Future scan() async {
//    try {
//      String barcode = await BarcodeScanner.scan();
//      setState(() => this.barcode = barcode);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        setState(() {
//          this.barcode = 'The user did not grant the camera permission!';
//        });
//      } else {
//        setState(() => this.barcode = 'Unknown error: $e');
//      }
//    } on FormatException {
//      setState(() => this.barcode =
//          'null (User returned using the "back"-button before scanning anything. Result)');
//    } catch (e) {
//      setState(() => this.barcode = 'Unknown error: $e');
//    }
//  }
}
