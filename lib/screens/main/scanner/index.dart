import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_ever/screens/main/bottom_bar/bottom_bar.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:memory_ever/screens/main/scanner/parseContent.dart';
import 'card_info.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  bool openCardInfo = false;

  String barcode = '';

  String url = '';

  List<Map<String, dynamic>> personInfo = [];

  Future openImageGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }

  void handleScannerCallback(String result) async {
    print(result);

    if (RegExp(r'^(www.memoryever.com/).*').allMatches(result).isNotEmpty) {
      var info = await initiate('https://' + result + '/');

      setState(() {
        personInfo = List.of(jsonDecode(info))
            .map((item) => Map<String, dynamic>.of(item))
            .toList();
        openCardInfo = true;
        url = result;
      });
    } else {
      print('no matches');
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
              BottomBar(activeRoute: '/scan'),
            ],
          ),
          openCardInfo
              ? CardInfo(info: personInfo, url: url, onClose: closeCardInfo)
              : null,
        ].where((widget) => widget != null).toList(),
      ),
    );
  }
}
