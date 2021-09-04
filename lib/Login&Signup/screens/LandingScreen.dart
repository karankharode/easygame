import 'package:easygame/Login&Signup/screens/LoginScreen.dart';
import 'package:easygame/Login&Signup/screens/SignUpScreen.dart';
import 'package:easygame/Login&Signup/widgets/WhiteOutlinedButton.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key key}) : super(key: key);
  double height, width;

  double bevel = 10;
  Color color = shadowColor;
  Offset blurOffset = Offset(10 / 2, 10 / 2);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
                      child: Image.asset(
                        'assets/branding/logo_wide.png',
                        height: 250,
                      ),
                    ),
                  ),
                  FilledRedButton(
                      width: width,
                      height: height,
                      text: 'Create Account',
                      onPressed: () => Navigator.push(context, commonRouter(SignUpScreen()))),
                  WhiteOutlinedButton(
                      height: height,
                      width: width,
                      text: "Login",
                      onPressed: () => Navigator.push(context, commonRouter(LoginScreen()))),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 40),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         height: 1,
                  //         width: width / 3,
                  //         color: colorPrimary,
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 17),
                  //         child: Text(
                  //           "OR",
                  //           style: TextStyle(color: colorPrimary),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 1,
                  //         width: width / 3,
                  //         color: colorPrimary,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     NeuMorphicContainer(
                  //       bevel: bevel,
                  //       color: facebookColor,
                  //       blurOffset: blurOffset,
                  //       child: IconButton(
                  //         onPressed: signInWithFacebook,
                  //         icon: Padding(
                  //           padding: const EdgeInsets.fromLTRB(13, 13, 5, 5),
                  //           child: Image.asset('assets/icons/facebook.png'),
                  //         ),
                  //         // Icon(Icons.facebook_outlined, color: Colors.white),
                  //         iconSize: 40,
                  //         padding: EdgeInsets.zero,
                  //       ),
                  //     ),
                  //     NeuMorphicContainer(
                  //       bevel: bevel,
                  //       color: white,
                  //       blurOffset: blurOffset,
                  //       child: IconButton(
                  //         onPressed: signInWithGoogle,
                  //         icon: Padding(
                  //           padding: const EdgeInsets.all(6.0),
                  //           child: Image.asset('assets/icons/google.png'),
                  //         ),
                  //         iconSize: 40,
                  //         padding: EdgeInsets.zero,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3, 3, 3, 10),
                    child: Text(
                      "All Rights Reserved @2021",
                      style: greyNonClickableTextStyle,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
