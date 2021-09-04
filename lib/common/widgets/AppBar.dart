import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';

Widget customAppBar(context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: bgColor,
    ),
    // red color or colorPrimary
    child: Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Image.asset(
                    'assets/branding/logo_wide.png',
                    fit: BoxFit.cover,
                    height: 50,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8),
                    ),
                    color: colorPrimary),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
            height: 90,
            margin: EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: shadowColor, offset: Offset(1, 1), spreadRadius: 3, blurRadius: 8)
            ], color: bgColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Coins',
                        ),
                      ),
                      Text(
                        '1000',
                        style: redClickableTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Tokens',
                        ),
                      ),
                      Text(
                        '300',
                        style: redClickableTextStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
