import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class SmallLuckyDrawBall extends StatelessWidget {
  final String number;
  final Color borderColor;
  const SmallLuckyDrawBall({
    Key key,
    this.number,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          transform: Matrix4.identity()
            ..rotateX(math.pi / 2.2)
            ..rotateY(math.pi),
          origin: Offset(4, 20),
          child: Container(
            width: 6,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    // blurRadius: 7,
                    spreadRadius: 2,
                    color: Colors.black87 //Colors.grey.withOpacity(0.6)
                    )
              ],
            ),
          ),
        ),
        Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
              color: white,
              // boxShadow: [
              //   BoxShadow(
              //     offset: Offset(-1, 0),
              //     color: Colors.black,
              //     spreadRadius: 1,
              //   )
              // ],
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1)),
          child: Center(
            child: Text(
              number,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
