import 'dart:convert' show base64Decode;

import 'package:flutter/material.dart';
import 'package:memory_ever/classes/person/person.dart';
import 'package:memory_ever/classes/history/history.dart';
import 'package:url_launcher/url_launcher.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({this.info, this.onClose});

  final History info;

  final Function onClose;

  void openUrl() {
    launch(info.url);
  }

  Future<bool> handleBackButtonPress() {
    onClose();
    return Future.value(false);
  }

  String getBackgroundPath() {
    print('theme ${info.theme}');
    switch (info.theme) {
      case 'sky':
        return 'assets/bgSky1.png';
      case '星空風格':
        return 'assets/bgSky1.png';
      case 'sky2':
        return 'assets/bgSky2.png';
      case '藍天風格':
        return 'assets/bgSky2.png';
      case 'sea':
        return 'assets/bgSea.png';
      case '晨海風格':
        return 'assets/bgSea.png';
      case 'deepsea':
        return 'assets/bgDeepSea.png';
      case '深海風格':
        return 'assets/bgDeepSea.png';
      case 'flower':
        return 'assets/bgFlower.png';
      case '花田風格':
        return 'assets/bgFlower.png';
      case 'story':
        return 'assets/bgStory.png';
      case '童話風格':
        return 'assets/bgStory.png';
      default:
        return 'assets/bgSky2.png';
    }
  }

  Column renderPerson(Person person) {
    print('person.name ${person.name}');
    print('person.image ${person.imageBase64}');
    print('person.age ${person.age}');
    print('person.hometown ${person.hometown}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 240,
          width: 180,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
          child: Image.memory(
            base64Decode(person.imageBase64),
            semanticLabel: '${person.name} 的遺照',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            person.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 5,
            ),
          ),
        ),
        Text(
          person.hometown,
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 3,
          ),
        ),
        Text(
          person.age.toString(),
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleBackButtonPress,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: ExactAssetImage(getBackgroundPath()),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: onClose,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ExactAssetImage('assets/icClose.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: info.people.map(renderPerson).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Text(
                  info.getTrimmedDescription(),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: openUrl,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0259FF),
                          Color(0xFF00E2FF),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '進入先人暮誌銘',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
