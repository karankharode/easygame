import 'package:easygame/HomePage/controllers/providers/BottomNavBarProvider.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/widgets/ballSpinnerLuckyDraw.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double height, width;
  @override
  
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Text(
              'Home',
              style: headingStyle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
          child: ballSpinnerLuckyDraw(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FilledRedButton(
                  width: width / 3,
                  height: height,
                  text: 'Luck Draw',
                  onPressed: () {
                    provider.currentIndex = 2;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FilledRedButton(
                  width: width / 3,
                  height: height,
                  text: 'Mini Games',
                  onPressed: () {
                    provider.currentIndex = 3;
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
