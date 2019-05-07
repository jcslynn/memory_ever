import 'dart:async';
import 'dart:convert' show jsonEncode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:image_picker/image_picker.dart';
import 'package:memory_ever/classes/history/history.dart';
import 'package:memory_ever/screens/main/bottom_bar/bottom_bar.dart';
import 'package:memory_ever/screens/main/card_info.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

import 'parse_content.dart';
import 'save_data.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  bool openCardInfo = false;

  String barcode = '';

  String url = '';

  History history;

  Future openImageGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }

  void handleScannerCallback(String result) async {
    print(result);

    if (RegExp(r'^(www.memoryever.com/).*').allMatches(result).isNotEmpty) {
      HapticFeedback.vibrate();

      var scannedHistory = await initiate('https://' + result + '/');
      if (scannedHistory != null)
        await saveScannedData(jsonEncode(scannedHistory));

      setState(() {
        history = scannedHistory;
        openCardInfo = true;
        url = result;
      });
    }
  }

  void saveContents(contents) {
    print(contents);
  }

  void closeCardInfo() {
    setState(() {
      openCardInfo = false;
    });
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
              BottomBar(activeRoute: '/scan'),
            ],
          ),
          openCardInfo ? CardInfo(info: history, onClose: closeCardInfo) : null,
        ].where((widget) => widget != null).toList(),
      ),
    );
  }
}
