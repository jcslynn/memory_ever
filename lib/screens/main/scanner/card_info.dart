import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({this.info, this.onClose, this.url});

  final List<Map<String, dynamic>> info;

  final Function onClose;

  final String url;

  void openUrl() {
    launch('https://$url');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage('assets/bgSky2.png'),
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
                  children: info
                      .map((item) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                                child: Image.network(
                                  item['image'],
                                  semanticLabel: '${item['name']} 的遺照',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 5,
                                  ),
                                ),
                              ),
                              Text(
                                item['hometown'].split('：')[1],
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 3,
                                ),
                              ),
                              Text(
                                item['age'],
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
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
                '他們於1944年在香港離島長洲結婚，婚後育有兩名兒子周炳全、周炳篡，壹名女兒周...',
                style: TextStyle(
                  fontSize: 15,
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
                        Color(0xFF00E2FF),
                        Color(0xFF0259FF),
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
    );
  }
}
