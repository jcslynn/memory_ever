import 'package:flutter/widgets.dart';

import 'bottom_bar_button.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({this.activeRoute});

  final String activeRoute;

  void switchPage({BuildContext context, String route}) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    print('route $activeRoute');

    return Container(
      color: Color(0xCCFFFFFF),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          BottomBarButton(
            label: '掃描歷史',
            isSelected: activeRoute == '/history',
            iconName: 'icCard',
            onTap: () {
              switchPage(context: context, route: '/history');
            },
          ),
          SizedBox(width: 50),
          BottomBarButton(
            label: '掃描暮誌銘',
            isSelected: activeRoute == '/scan',
            iconName: 'icQrcode',
            onTap: () {
              switchPage(context: context, route: '/scan');
            },
          ),
        ],
      ),
    );
  }
}
