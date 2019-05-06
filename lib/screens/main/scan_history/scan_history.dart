import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memory_ever/screens/main/bottom_bar/bottom_bar.dart';

class ScanHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '掃描歷史',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      letterSpacing: 5,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue,
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
              child: CarouselSlider(
                height: 600,
                enlargeCenterPage: true,
                autoPlay: false,
                items: <int>[0, 1, 2, 3, 4]
                    .map((_) => Builder(
                          builder: (context) => Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                        ))
                    .toList(),
              ),
            ),
            BottomBar(activeRoute: '/history'),
          ],
        ),
      ),
    );
  }
}
