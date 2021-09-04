import 'package:easygame/Login&Signup/services/Form/inputDecoration.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  double height, width;

  String email = '';

  final _formKey = GlobalKey<FormState>();

  FocusNode _emailFieldFocus = FocusNode();

  Color _emailColor = textFieldFillColor;
  Color _emailLabelColor = secondaryAccent;

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
    // _passwordFieldFocus.addListener(() {
    //   if (_passwordFieldFocus.hasFocus) {
    //     setState(() {
    //       _passwordColor = bgColor;
    //       _passwordLabelColor = colorPrimary;
    //     });
    //   } else {
    //     setState(() {
    //       _passwordColor = textFieldFillColor;
    //       _passwordLabelColor = secondaryAccent;
    //     });
    //   }
    // });
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
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Forgot Password',
                              style: headingStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
                                : "Please provide valid Email ID";
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
                              "Email",
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

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: verticalTextFieldPadding,
                      //   ),
                      //   child: TextFormField(
                      //     validator: (val) {
                      //       return RegExp("^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*")
                      //               .hasMatch(val)
                      //           ? null
                      //           : "Input Valid Password";
                      //     },
                      //     onChanged: (value) => password = value,
                      //     cursorColor: colorPrimary,
                      //     obscureText: _obscureText,
                      //     focusNode: _passwordFieldFocus,
                      //     style: TextStyle(
                      //       color: _passwordLabelColor,
                      //       fontSize: 18,
                      //       fontFamily: 'GothamMedium',
                      //     ),
                      //     decoration: getInputDecoration(
                      //         "Password",
                      //         _passwordColor,
                      //         _passwordLabelColor,
                      //         Icon(
                      //           Icons.lock,
                      //           size: 18,
                      //           color: _passwordLabelColor,
                      //         ),
                      //         IconButton(
                      //             onPressed: () {
                      //               setState(() {
                      //                 _obscureText = !_obscureText;
                      //               });
                      //             },
                      //             icon: Icon(
                      //               !_obscureText ? Icons.visibility : Icons.visibility_off,
                      //               color: !_obscureText ? _passwordLabelColor : Colors.grey[500],
                      //             ))),
                      //   ),
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

                FilledRedButton(
                  width: width,
                  height: height,
                  text: 'Forgot Password',
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        String email1 = email;
                        // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Lottie.asset('assets/animations/passwordReset.json',
                                    height: 150),
                                content: SingleChildScrollView(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Password Reset',
                                        style: redHeadingStyle,
                                      ),
                                    ),
                                    Text(
                                      'An email has been sent to your registered email ${(email1)} with a link to reset your password. Kidnly check your email and reset your password.',
                                      style: greyNonClickableTextStyle,
                                    )
                                  ]),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ok'))
                                ],
                              );
                            });
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Lottie.asset('assets/animations/error.json', height: 150),
                                content: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Oops ! Error occured',
                                            style: redHeadingStyle,
                                          ),
                                        ),
                                        Text(
                                          'An error has occured. Can not send email. Please check your email and try again.',
                                          style: greyNonClickableTextStyle,
                                        )
                                      ]),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ok'))
                                ],
                              );
                            });
                        print('Can not send email !');
                      }
                    }
                  },
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
