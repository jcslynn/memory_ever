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
import 'package:shared_preferences/shared_preferences.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  AuthClient httpClient;

  int numOfHistories = 0;

  bool openCardInfo = false;

  bool scanned = false;

  String barcode = '';

  String url = '';

  History history;

  @override
  void initState() {
    super.initState();

    getNumOfHistories();
  }

  Future getNumOfHistories() async {
    var prefs = await SharedPreferences.getInstance();
    var historyList = prefs.getStringList('history');

    setState(() {
      print('num of histories ${historyList.length}');
      numOfHistories = historyList != null ? historyList.length : 0;
    });
  }

  Future openImageGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }

  void handleScannerCallback(String result, BuildContext context) async {
    if (RegExp(r'.*memoryever.com.*')
        .allMatches(result)
        .isNotEmpty && !scanned) {
      try {
        setState(() {
          scanned = true;
        });

        HapticFeedback.vibrate();

        var credentials = new ServiceAccountCredentials.fromJson(client);
        var scopes = <String>[
          'https://www.googleapis.com/auth/drive.readonly',
          'https://www.googleapis.com/auth/spreadsheets.readonly',
        ];
        var authenticatedClient = await clientViaServiceAccount(credentials, scopes);
        print('Scanned result $result');

        var historyResponse = await getHistory(
          client: authenticatedClient,
          url: result.startsWith('http') ? result : 'https://$result',
        );

        await saveHistory(historyResponse);

        setState(() {
          httpClient = authenticatedClient;
          history = historyResponse;
          openCardInfo = true;
        });
      } catch (e) {
        print('Memory Ever Error: ${e.toString()}');
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: Text('未能獲得資訊'),
                content: Text('請稍後再試。'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('知道了'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      closeCardInfo();
                    },
                  ),
                ],
              ),
        );
      }
    }
  }

  void saveContents(contents) {
    print(contents);
  }

  void closeCardInfo() {
    setState(() {
      openCardInfo = false;
      scanned = false;
    });
  }

  void toHistory(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/history');
  }

  Future<bool> handleBackButtonPress() {
    if (openCardInfo) {
      closeCardInfo();
      return Future.value(false);
    }

    return Future.value(true);
  }

  CardInfo renderCardInfo() => openCardInfo ? CardInfo(info: history, onClose: closeCardInfo) : null;

  Widget renderCameraPreview() =>
      scanned
          ? Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : QrCamera(
        qrCodeCallback: (result) {
          handleScannerCallback(result, context);
        },
      );

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    var deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    String scanningText = scanned ? '請稍候' : '掃描暮誌銘二維碼';
    String numOfHistoriesText = numOfHistories > 0 ? '我已有 ${numOfHistories.toString()} 個暮誌銘' : '我未擁有任何暮誌銘';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: renderCameraPreview(),
          ),
          Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: scanned
                        ? null
                        : BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ExactAssetImage('assets/camShadow.png'),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                scanningText,
                                style: TextStyle(
                                  color: scanned ? primaryColor : Colors.white,
                                  fontSize: 25,
                                  letterSpacing: 5,
                                ),
                              ),
                              SizedBox(height: 350),
                              scanned
                                  ? Container()
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
                                    numOfHistoriesText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  toHistory(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ].where(notNull).toList(),
                    ),
                  )),
              BottomBar(activeRoute: '/scan'),
            ],
          ),
          renderCardInfo(),
        ].where(notNull).toList(),
      ),
    );
  }
}
