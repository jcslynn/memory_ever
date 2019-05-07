import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_ever/classes/history/history.dart';
import 'package:memory_ever/constants.dart' show client, primaryColor;
import 'package:memory_ever/helper.dart';
import 'package:memory_ever/screens/main/bottom_bar/bottom_bar.dart';
import 'package:memory_ever/screens/main/card_info.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  AuthClient httpClient;

  bool openCardInfo = false;

  bool scanned = false;

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
      setState(() {
        scanned = true;
      });

      HapticFeedback.vibrate();

      var credentials = ServiceAccountCredentials.fromJson(client);
      var scopes = <String>[
        'https://www.googleapis.com/auth/drive.readonly',
        'https://www.googleapis.com/auth/spreadsheets.readonly',
      ];
      var authenticatedClient =
          await clientViaServiceAccount(credentials, scopes);

      setState(() {
        httpClient = authenticatedClient;
      });

      await getHistory(
        client: httpClient,
        url: 'https://$result/',
      );
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

  CardInfo renderCardInfo() =>
      openCardInfo ? CardInfo(info: history, onClose: closeCardInfo) : null;

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
            child: scanned
                ? Container(
                    color: primaryColor,
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                : QrCamera(
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
                      scanned ? '請稍候' : '掃描暮誌銘二維碼',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 5,
                      ),
                    ),
                    SizedBox(height: 20),
                    scanned
                        ? null
                        : GestureDetector(
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
                  ].where(notNull).toList(),
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
          renderCardInfo(),
        ].where(notNull).toList(),
      ),
    );
  }
}
