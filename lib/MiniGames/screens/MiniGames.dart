import 'package:carousel_slider/carousel_slider.dart';
import 'package:easygame/HomePage/controllers/providers/BottomNavBarProvider.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MiniGames extends StatefulWidget {
  const MiniGames({Key key}) : super(key: key);

  @override
  _MiniGamesState createState() => _MiniGamesState();
}

class _MiniGamesState extends State<MiniGames> {
  double height, width;
  int currentPos = 0;

  List<Widget> listItems = [
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGrey,
        borderRadius: BorderRadius.all(Radius.circular(brRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Image.asset(
          'assets/images/adIcon.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(brRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Image.asset(
          'assets/images/miniGame1.jpeg',
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.all(Radius.circular(brRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Image.asset('assets/images/matchToWin.png'),
      ),
    ),
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.all(Radius.circular(brRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Image.asset('assets/branding/logo.png'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text('Mini Games'),
        ),
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(brRadius)),
              child: CarouselSlider(
                  items: listItems,
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 2 / 2.5,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 10),
                    autoPlayAnimationDuration: Duration(milliseconds: 900),
                    autoPlayCurve: Curves.easeIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPos = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: listItems.map((url) {
                int index = listItems.indexOf(url);
                return Container(
                  width: currentPos == index ? 50 : 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        currentPos == index ? BorderRadius.all(Radius.circular(10)) : null,
                    shape: currentPos == index ? BoxShape.rectangle : BoxShape.circle,
                    color: currentPos == index ? colorPrimary : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 35),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: shadowColor, offset: Offset(0, 4), spreadRadius: 0.8, blurRadius: 10)
            ], color: bgColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Win Tokens',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '1000',
                      style: redTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
            child: FilledRedButton(
                width: width,
                height: height,
                text: "Redeem Tokens",
                onPressed: () {
                  provider.currentIndex = 4;
                }))
      ],
    );
  }
}
