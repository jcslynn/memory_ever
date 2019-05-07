import 'package:flutter/material.dart';
import 'package:memory_ever/constants.dart';

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    @required this.label,
    @required this.iconName,
    @required this.isSelected,
    @required this.onTap,
  });

  final String label;

  final String iconName;

  final bool isSelected;

  final Function onTap;

  Container renderDot() => isSelected
      ? Container(
          height: 5,
          width: 5,
          color: primaryColor,
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/$iconName${isSelected ? 'Selected' : ''}.png'),
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            renderDot(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? primaryColor : Colors.grey,
                  letterSpacing: 4,
                ),
              ),
            ),
            renderDot(),
          ].where((widget) => widget != null).toList(),
        )
      ],
    );
  }
}
