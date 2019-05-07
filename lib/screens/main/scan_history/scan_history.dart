import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memory_ever/classes/history/history.dart';
import 'package:memory_ever/classes/person/person.dart';
import 'package:memory_ever/constants.dart';
import 'package:memory_ever/screens/main/bottom_bar/bottom_bar.dart';
import 'package:memory_ever/screens/main/card_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanHistory extends StatefulWidget {
  @override
  _ScanHistoryState createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory> {
  bool showCardInfo = false;

  History selectedHistory;

  List<History> histories = [];

  String selectedUrl = '';

  void fetchHistoryFromStorage() async {
    var prefs = await SharedPreferences.getInstance();
    print('history ${prefs.getStringList('history')}');

    setState(() {
      histories = prefs
          .getStringList('history')
          .where((item) => item != 'null')
          .map(
            (string) => History.fromJson(jsonDecode(string)),
          )
          .toList();
    });
  }

  void closeCardInfo() {
    setState(() {
      showCardInfo = false;
    });
  }

  void openScanner(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/scan');
  }

  List<Builder> renderCards() => histories
      .map((history) => Builder(
            builder: (context) => GestureDetector(
                  onTap: () {
                    setState(() {
                      showCardInfo = true;
                      selectedHistory = history;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ExactAssetImage('assets/bgSky2.png'),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: history.people.map(renderPerson).toList(),
                    ),
                  ),
                ),
          ))
      .toList();

  Column renderPerson(Person person) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 5,
              ),
            ),
            child: Image.network(
              person.imageUrl,
              semanticLabel: '${person.name} 的遺照',
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
            person.getHometown(),
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 3,
            ),
          ),
          Text(
            person.getAge(),
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 3,
            ),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();

    fetchHistoryFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '掃描歷史',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          letterSpacing: 5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          openScanner(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: primaryColor,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: histories.isEmpty
                        ? SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          )
                        : CarouselSlider(
                            height: 600,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                            items: renderCards(),
                          ),
                  ),
                ),
                BottomBar(activeRoute: '/history'),
              ],
            ),
            showCardInfo
                ? CardInfo(
                    info: selectedHistory,
                    onClose: closeCardInfo,
                  )
                : null,
          ].where((widget) => widget != null).toList(),
        ),
      ),
    );
  }
}
