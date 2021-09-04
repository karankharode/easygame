import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThankYouPage extends StatelessWidget {
  ThankYouPage({Key key}) : super(key: key);
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    'assets/animations/thankYou.json',
                    height: height / 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Text(
                        'Thank You\n',
                        style: redThanksHeadingStyle,
                      ),
                      Text(
                        'Thank You for registering.\n\n Our representative will contact you to\n\n activate your account.',
                        style: greyNonClickableThanksTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: FilledRedButton(
                        width: width,
                        height: height,
                        text: "Next",
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(context, commonRouter(LoginScreen()));
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
