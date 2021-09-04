import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class remainingPrizesWidget extends StatelessWidget {
  final String position;
  final String remainingPrizes;
  const remainingPrizesWidget({
    Key key,
    this.position,
    this.remainingPrizes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(brRadius)),
        boxShadow: [
          BoxShadow(color: shadowColor, offset: Offset(1, 1), blurRadius: 3, spreadRadius: 1)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$position : $remainingPrizes',
          style: redClickableTextStyle,
        ),
      ),
    );
  }
}
