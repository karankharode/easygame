import 'package:easygame/HomePage/screens/HomePage.dart';
import 'package:easygame/Login&Signup/screens/ForgotPassword.dart';
import 'package:easygame/Login&Signup/screens/SignUpScreen.dart';
import 'package:easygame/Login&Signup/services/Form/inputDecoration.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/common/widgets/alertDialog_custom.dart';
import 'package:easygame/common/widgets/loaderDialog.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double height, width;

  String email = '';
  String password = '';

  final _formKey = GlobalKey<FormState>();

  FocusNode _emailFieldFocus = FocusNode();
  FocusNode _passwordFieldFocus = FocusNode();

  Color _emailColor = textFieldFillColor;
  Color _emailLabelColor = secondaryAccent;
  Color _passwordColor = textFieldFillColor;
  Color _passwordLabelColor = secondaryAccent;

  bool _obscureText = false;

  login() async {
    showLoaderDialog(context);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, commonRouter(HomePage()), (route) => false);
      } else {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Navigator.pop(context);
        showAlert('User not Found!', 'No user found for the email you are trying to login with.',
            context);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Navigator.pop(context);
        showAlert(
            'Wrong Password',
            'Wrong password provided for the email.\nPlease try again with the correct password.',
            context);
      }
    }
  }

  @override
  void initState() {
    _emailFieldFocus.addListener(() {
      if (_emailFieldFocus.hasFocus) {
        setState(() {
          _emailColor = bgColor;
          _emailLabelColor = colorPrimary;
        });
      } else {
        setState(() {
          _emailColor = textFieldFillColor;
          _emailLabelColor = secondaryAccent;
        });
      }
    });
    _passwordFieldFocus.addListener(() {
      if (_passwordFieldFocus.hasFocus) {
        setState(() {
          _passwordColor = bgColor;
          _passwordLabelColor = colorPrimary;
        });
      } else {
        setState(() {
          _passwordColor = textFieldFillColor;
          _passwordLabelColor = secondaryAccent;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    const double verticalTextFieldPadding = 8.0;
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // top logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                      child: Image.asset(
                        'assets/branding/logo_wide.png',
                        height: 100,
                        width: 190,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),

                // email password
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                            child: Text(
                              'Sign In',
                              style: headingStyle,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, commonRouter(SignUpScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                children: [
                                  Text(
                                    'If you are new ! ',
                                    style: greyNonClickableTextStyle,
                                  ),
                                  Text(
                                    'Create Account',
                                    style: redClickableTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: verticalTextFieldPadding,
                        ),
                        child: TextFormField(
                          validator: (val) {
                            return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(val) ||
                                    RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                            r"{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)
                                ? null
                                : "Please provide valid number or Email ID";
                          },
                          onChanged: (value) => email = value,
                          cursorColor: colorPrimary,
                          focusNode: _emailFieldFocus,
                          style: TextStyle(
                            color: _emailLabelColor,
                            fontSize: 18,
                            fontFamily: 'GothamMedium',
                          ),
                          decoration: getInputDecoration(
                              "Email Address",
                              _emailColor,
                              _emailLabelColor,
                              Icon(
                                Icons.email,
                                size: 18,
                                color: _emailLabelColor,
                              ),
                              null),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: verticalTextFieldPadding,
                        ),
                        child: TextFormField(
                          validator: (val) {
                            return RegExp("^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*")
                                    .hasMatch(val)
                                ? null
                                : "Input Valid Password";
                          },
                          onChanged: (value) => password = value,
                          cursorColor: colorPrimary,
                          obscureText: _obscureText,
                          focusNode: _passwordFieldFocus,
                          style: TextStyle(
                            color: _passwordLabelColor,
                            fontSize: 18,
                            fontFamily: 'GothamMedium',
                          ),
                          decoration: getInputDecoration(
                              "Password",
                              _passwordColor,
                              _passwordLabelColor,
                              Icon(
                                Icons.lock,
                                size: 18,
                                color: _passwordLabelColor,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    !_obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: !_obscureText ? _passwordLabelColor : Colors.grey[500],
                                  ))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, commonRouter(ForgotPassword())),
                        child: Row(
                          children: [
                            Text(
                              'Forgot Password ? ',
                              style: greyNonClickableTextStyle,
                            ),
                            Text(
                              'Reset',
                              style: redClickableTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                FilledRedButton(
                  width: width,
                  height: height,
                  text: 'Login',
                  onPressed: () => login(),
                ),
                SizedBox(
                  height: 5,
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
      ),
    );
  }
}
