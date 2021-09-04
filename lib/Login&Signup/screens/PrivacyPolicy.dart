import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
              color: colorPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Privacy Policy',
                style: headingStyle,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 0, bottom: 0, left: columnPadding, right: columnPadding),
              child: Text(
                privacyPolicy,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
