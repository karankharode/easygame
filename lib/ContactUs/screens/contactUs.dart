import 'package:easygame/HomePage/controllers/providers/BottomNavBarProvider.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/widgets/topCoinsWidget.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatelessWidget {
  ContactUs({Key key}) : super(key: key);

  double height, width;
  final EdgeInsets buttonPadding = EdgeInsets.fromLTRB(0, 13, 0, 13);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    var navBarProvider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            'assets/branding/logo.png',
            fit: BoxFit.scaleDown,
            width: 180,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorPrimary,
      ),
      body: Stack(
        children: [
          Column(children: [
            Container(
              height: 75,
              color: colorPrimary,
            ),
            Container(
                height: height - 75 - 65 - 80,
                color: bgColor,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: 58, bottom: 20, left: columnPadding + 5, right: columnPadding + 5),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: Text(
                            'Contact Us',
                            style: headingStyle,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: buttonPadding,
                            child: FilledRedButton(
                                width: width, height: height, text: 'Email', onPressed: () {}),
                          ),
                          Padding(
                            padding: buttonPadding,
                            child: FilledRedButton(
                                width: width, height: height, text: 'WhatsApp', onPressed: () {}),
                          ),
                          Padding(
                            padding: buttonPadding,
                            child: FilledRedButton(
                                width: width,
                                height: height,
                                text: 'Faq',
                                onPressed: () {
                                  navBarProvider.currentIndex = 5;
                                  Navigator.pop(context);
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ]),

          // top coins container
          topCoinsWidget()
        ],
      ),
    );
  }
}
