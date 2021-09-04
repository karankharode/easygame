import 'package:country_picker/country_picker.dart';
import 'package:easygame/Login&Signup/screens/LoginScreen.dart';
import 'package:easygame/Login&Signup/screens/ThankYouPage.dart';
import 'package:easygame/Login&Signup/services/Form/inputDecoration.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/common/widgets/alertDialog_custom.dart';
import 'package:easygame/common/widgets/loaderDialog.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'PrivacyPolicy.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  double height, width;

  String email = '';
  String username = '';
  String fullName = '';
  String password = '';
  String confirmPassword = '';
  String address = '';
  String number = '';
  String _id = '';
  String _referralId = '';
  String _agentId = '';
  String _paymentOption = '';
  String _paymentMethod = '';
  String _postalCode = '';
  String otp = '';
  String _countryCode = '63';
  bool success = false;
  bool checkedTerms = false;

  DatabaseReference databaseReference;
  final _formKey = GlobalKey<FormState>();

  FocusNode _emailFieldFocus = FocusNode();
  FocusNode _usernameFieldFocus = FocusNode();
  FocusNode _fullNameFieldFocus = FocusNode();
  FocusNode _passwordFieldFocus = FocusNode();
  FocusNode _confirmPasswordFieldFocus = FocusNode();
  FocusNode _addressFieldFocus = FocusNode();
  FocusNode _numberFieldFocus = FocusNode();
  FocusNode _idFieldFocus = FocusNode();
  FocusNode _refIdFieldFocus = FocusNode();
  FocusNode _agentIdFieldFocus = FocusNode();
  FocusNode _paymentOptionFieldFocus = FocusNode();
  FocusNode _paymentMethodFieldFocus = FocusNode();
  FocusNode _postalCodeFieldFocus = FocusNode();
  FocusNode _otpFieldFocus = FocusNode();

  Color _emailColor = textFieldFillColor;
  Color _emailLabelColor = secondaryAccent;

  Color _usernameColor = textFieldFillColor;
  Color _usernameLabelColor = secondaryAccent;

  Color _fullNameColor = textFieldFillColor;
  Color _fullNameLabelColor = secondaryAccent;

  Color _passwordColor = textFieldFillColor;
  Color _passwordLabelColor = secondaryAccent;

  Color _confirmPasswordColor = textFieldFillColor;
  Color _confirmPasswordLabelColor = secondaryAccent;

  Color _addressColor = textFieldFillColor;
  Color _addressLabelColor = secondaryAccent;

  Color _idColor = textFieldFillColor;
  Color _idLabelColor = secondaryAccent;

  Color _refIdColor = textFieldFillColor;
  Color _refIdLabelColor = secondaryAccent;

  Color _agentIdColor = textFieldFillColor;
  Color _agentIdLabelColor = secondaryAccent;

  Color _paymentOptionColor = textFieldFillColor;
  Color _paymentOptionLabelColor = secondaryAccent;

  Color _paymentMethodColor = textFieldFillColor;
  Color _paymentMethodLabelColor = secondaryAccent;

  Color _postalCodeColor = textFieldFillColor;
  Color _postalCodeLabelColor = secondaryAccent;

  Color _countryColor = textFieldFillColor;
  Color _countryLabelColor = secondaryAccent;

  Color _numberColor = textFieldFillColor;
  Color _numberLabelColor = secondaryAccent;

  Color _otpColor = textFieldFillColor;
  Color _otpLabelColor = secondaryAccent;

  bool _obscureText = false;

  int _radioValue = 0;
  String _idLabelText = 'National ID';

  final _countryPickerControler = TextEditingController();

  // mobile verification
  String phoneNo, verificationId, smsCode;
  int _forceResendingToken;
  bool codeRequested = false;
  bool codeSent = false;
  bool codeReSent = false;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _idLabelText = 'National ID';
          break;
        case 1:
          _idLabelText = 'TIN ID';
          break;
      }
    });
  }

  void _register() async {
    print('Here');
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    // if (authCreds.token != null) {
    showLoaderDialog(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // if (true) {
      if (userCredential != null) {
        setState(() {
          success = true;
        });
        if (_referralId != '' || _referralId != null) {
          // benefit the tier 1 user
          DatabaseReference dbRef = databaseReference.child('Users').child(_referralId);
          int coins = 0;
          await dbRef.child('Wallet').child('coins').once().then((value) {
            coins = 0;
            // coins = int.parse(value.value.toString());
          });
          dbRef.child('Wallet').child('coins').set((coins + 100));
          dbRef
              .child('Referred')
              .child(FirebaseAuth.instance.currentUser.uid.toString())
              .child('Info')
              .set({
            'uid': FirebaseAuth.instance.currentUser.uid.toString(),
            'userName': username,
            'emailAddress': email,
            'phoneNo': number ?? '',
          });

          // print('wtf');

          // benefit the agent on tier 2
          dbRef.child('Info').once().then((value) async {
            // print('wtf');
            if (value.value['agentId'] != null) {
              DatabaseReference dbRef =
                  databaseReference.child('Agents').child(value.value['agentId'].toString());
              String agentKey = value.value['agentId'];
              int agentCoins = 0;
              // print(value.value['agentId']);
              if (value.value['agentId'] != '') {
                dbRef.once().then((value1) {
                  var data = value1.value;
                  try {
                    agentCoins = int.tryParse(data['Wallet']['coins'].toString()) ?? 0;
                  } catch (e) {
                    agentCoins = 0;
                  }
                });
                if (agentKey != '') {
                  dbRef
                      .child('Referrals')
                      .child(_referralId)
                      .child('SubReferrals')
                      .child(FirebaseAuth.instance.currentUser.uid.toString())
                      .set({
                    'uid': FirebaseAuth.instance.currentUser.uid.toString(),
                    'userName': username,
                    'emailAddress': email,
                    'phoneNo': number ?? '',
                  });

                  databaseReference
                      .child('Agents')
                      .child(agentKey)
                      .child('Wallet')
                      .child('coins')
                      .set(agentCoins + 50);
                }
                print('here');
              }
              if (value.value['referralId'].toString() != '') {
                // benefit the tier 2 user
                // benefit the tier 1 user
                String refid2 = value.value['referralId'];
                DatabaseReference dbRef = databaseReference.child('Users').child(refid2);
                int coins = 0;
                await dbRef.child('Wallet').child('coins').once().then((value) {
                  coins = 0;
                  // coins = int.parse(value.value.toString());
                });
                dbRef.child('Wallet').child('coins').set((coins + 100));
                dbRef
                    .child('Referred')
                    .child(FirebaseAuth.instance.currentUser.uid.toString())
                    .child('SubReferrals')
                    .set({
                  'uid': FirebaseAuth.instance.currentUser.uid.toString(),
                  'userName': username,
                  'emailAddress': email,
                  'phoneNo': number ?? '',
                });
              }
              // referral id on tier 2
            }
          });
        }

        // agent id ka choda
        if (_agentId != '' || _agentId != null) {
          DatabaseReference dbRef = databaseReference.child('Agents').child(_agentId);
          String agentKey = _agentId;
          int agentCoins = 0;
          dbRef.once().then((value) {
            var data = value.value;
            // bool notFound = true;

            if (data['agentId'] == null) {
              Fluttertoast.showToast(
                  msg: "Agent ID not found",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: white,
                  textColor: colorPrimary,
                  fontSize: 16.0);
              return;
            } else {
              if (agentKey != '') {
                agentCoins = int.tryParse(data['Wallet']['coins'].toString()) ?? 0;
                dbRef
                    .child('Referrals')
                    .child(FirebaseAuth.instance.currentUser.uid.toString())
                    .child('Info')
                    .set({
                  'uid': FirebaseAuth.instance.currentUser.uid.toString(),
                  'userName': username,
                  'emailAddress': email,
                  'phoneNo': number ?? '',
                });

                dbRef.child('Wallet').child('coins').set(agentCoins + 100);
              }
            }
          });
        }

        await databaseReference
            .child('Users')
            .child(FirebaseAuth.instance.currentUser.uid.toString())
            .child('Info')
            .set({
          'fullName': fullName,
          'userName': username,
          'emailAddress': email,
          'password': password,
          'addresss': address,
          'id': _id,
          'idType': _idLabelText,
          'referralId': _referralId ?? '',
          'agentId': _agentId ?? '',
          'paymentOption': _paymentOption ?? '',
          'paymentMethod': _paymentMethod ?? '',
          'postalCode': _postalCode ?? '',
          'country': _countryPickerControler.text ?? '',
          'phoneNo': number ?? '',
        });
        await databaseReference
            .child('Users')
            .child(FirebaseAuth.instance.currentUser.uid.toString())
            .child('Wallet')
            .set({'coins': 1000, 'tokens': 1000});
        FirebaseAuth.instance.currentUser.updateDisplayName(username);

        Navigator.pop(context);
        Navigator.pushReplacement(context, commonRouter(ThankYouPage()));
      } else {
        setState(() {
          success = false;
        });
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.pop(context);
        showAlert('Password too weak !',
            'The password provided is too weak.\nTry again with a strong password', context);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.pop(context);
        showAlert(
            'Account already exists!',
            'The account already exists for this email.\nTry to login using your password.',
            context);
      }
    } catch (e) {
      // print(e);
    }
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Verification Failed",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: white,
    //       textColor: colorPrimary,
    //       fontSize: 16.0);
    // }
  }

  Future<void> registerUser(mobile) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {};
    final PhoneVerificationFailed verificationfailed = (FirebaseAuthException authException) {
      debugPrint('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResendingToken]) {
      Fluttertoast.showToast(
          msg: "OTP Sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: white,
          textColor: colorPrimary,
          fontSize: 16.0);
      this.verificationId = verId;
      this._forceResendingToken = forceResendingToken;
      setState(() {
        this.codeSent = true;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+$_countryCode$mobile",
      timeout: const Duration(seconds: 5),
      forceResendingToken: _forceResendingToken,
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }

  @override
  void initState() {
    // email listener
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
    // password listener
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
    // confirm pass listener
    _confirmPasswordFieldFocus.addListener(() {
      if (_confirmPasswordFieldFocus.hasFocus) {
        setState(() {
          _confirmPasswordColor = bgColor;
          _confirmPasswordLabelColor = colorPrimary;
        });
      } else {
        setState(() {
          _confirmPasswordColor = textFieldFillColor;
          _confirmPasswordLabelColor = secondaryAccent;
        });
      }
    });
    // address listener
    _addressFieldFocus.addListener(() {
      if (_addressFieldFocus.hasFocus) {
        setState(() {
          _addressColor = bgColor;
          _addressLabelColor = colorPrimary;
        });
      } else {
        setState(() {
          _addressColor = textFieldFillColor;
          _addressLabelColor = secondaryAccent;
        });
      }
    });
    databaseReference = FirebaseDatabase.instance.reference();
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              physics: BouncingScrollPhysics(),
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
                  // form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // signup heading
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 3),
                              child: Text(
                                'Sign Up',
                                style: headingStyle,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, commonRouter(LoginScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Already have an Account ? ',
                                      style: greyNonClickableTextStyle,
                                    ),
                                    Text(
                                      'Login',
                                      style: redClickableTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        //email
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

                        // username
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              return val.isNotEmpty ? null : "Please provide an username";
                            },
                            onChanged: (value) => username = value,
                            cursorColor: colorPrimary,
                            focusNode: _usernameFieldFocus,
                            style: TextStyle(
                              color: _usernameLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Username",
                                _usernameColor,
                                _usernameLabelColor,
                                Icon(
                                  Icons.person,
                                  size: 18,
                                  color: _usernameLabelColor,
                                ),
                                null),
                          ),
                        ),
                        // full name
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              return val.isNotEmpty ? null : "Please provide your Full Name";
                            },
                            onChanged: (value) => fullName = value,
                            cursorColor: colorPrimary,
                            focusNode: _fullNameFieldFocus,
                            style: TextStyle(
                              color: _fullNameLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Full Name",
                                _fullNameColor,
                                _fullNameLabelColor,
                                Icon(
                                  Icons.person_add,
                                  size: 18,
                                  color: _fullNameLabelColor,
                                ),
                                null),
                          ),
                        ),

                        //password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              return RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                      .hasMatch(val)
                                  ? null
                                  : "Password Must contain a number, special character & letters";
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

                        // confirm password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              return val == password ? null : "Password did not match";
                            },
                            onChanged: (value) => confirmPassword = value,
                            cursorColor: colorPrimary,
                            obscureText: _obscureText,
                            focusNode: _confirmPasswordFieldFocus,
                            style: TextStyle(
                              color: _confirmPasswordLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Confirm Password",
                                _confirmPasswordColor,
                                _confirmPasswordLabelColor,
                                Icon(
                                  Icons.lock,
                                  size: 18,
                                  color: _confirmPasswordLabelColor,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(
                                      !_obscureText ? Icons.visibility : Icons.visibility_off,
                                      color: !_obscureText
                                          ? _confirmPasswordLabelColor
                                          : Colors.grey[500],
                                    ))),
                          ),
                        ),

                        // address
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              return val.isNotEmpty ? null : "Please provide valid address";
                            },
                            onChanged: (value) => address = value,
                            cursorColor: colorPrimary,
                            focusNode: _addressFieldFocus,
                            style: TextStyle(
                              color: _addressLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Address",
                                _addressColor,
                                _addressLabelColor,
                                Icon(
                                  Icons.location_city,
                                  size: 18,
                                  color: _addressLabelColor,
                                ),
                                null),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text('National ID'),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text('TIN ID'),
                          ],
                        ),
                        // id
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please provide a valid $_idLabelText";
                              } else if (val.length < 12 && _radioValue == 1) {
                                return "Enter a valid $_idLabelText";
                              } else if (val.length != 12) {
                                if (_radioValue == 1)
                                  return "Enter a 12 digit $_idLabelText";
                                else
                                  return null;
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) => _id = value,
                            cursorColor: colorPrimary,
                            focusNode: _idFieldFocus,
                            style: TextStyle(
                              color: _idLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                _idLabelText,
                                _idColor,
                                _idLabelColor,
                                Icon(
                                  Icons.verified_user,
                                  size: 18,
                                  color: _idLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // referal id
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            onChanged: (value) => _referralId = value,
                            cursorColor: colorPrimary,
                            focusNode: _refIdFieldFocus,
                            style: TextStyle(
                              color: _refIdLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Referral ID (Optional)",
                                _refIdColor,
                                _refIdLabelColor,
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 18,
                                  color: _refIdLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // agent id
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            onChanged: (value) => _agentId = value,
                            cursorColor: colorPrimary,
                            focusNode: _agentIdFieldFocus,
                            style: TextStyle(
                              color: _agentIdLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Agent ID (Optional)",
                                _agentIdColor,
                                _agentIdLabelColor,
                                Icon(
                                  Icons.verified_outlined,
                                  size: 18,
                                  color: _agentIdLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // payment option
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            onChanged: (value) => _paymentOption = value,
                            cursorColor: colorPrimary,
                            focusNode: _paymentOptionFieldFocus,
                            style: TextStyle(
                              color: _paymentOptionLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Payment Option (Optional)",
                                _paymentOptionColor,
                                _paymentOptionLabelColor,
                                Icon(
                                  Icons.payments,
                                  size: 18,
                                  color: _paymentOptionLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // payment method
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            onChanged: (value) => _paymentMethod = value,
                            cursorColor: colorPrimary,
                            focusNode: _paymentMethodFieldFocus,
                            style: TextStyle(
                              color: _paymentMethodLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Payment Option Account Details",
                                _paymentMethodColor,
                                _paymentMethodLabelColor,
                                Icon(
                                  Icons.payment,
                                  size: 18,
                                  color: _paymentMethodLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // postal code
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please provide a valid postal code";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) => _postalCode = value,
                            cursorColor: colorPrimary,
                            focusNode: _postalCodeFieldFocus,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: _postalCodeLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Postal Code",
                                _postalCodeColor,
                                _postalCodeLabelColor,
                                Icon(
                                  Icons.location_city_rounded,
                                  size: 18,
                                  color: _postalCodeLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // country picker
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: TextFormField(
                            controller: _countryPickerControler,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please select a country";
                              } else {
                                return null;
                              }
                            },
                            cursorColor: colorPrimary,
                            readOnly: true,
                            showCursor: false,
                            // enabled: false,
                            onTap: () {
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: CountryListThemeData(
                                    flagSize: 20,
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(fontSize: 16, color: colorPrimary),
                                    //Optional. Sets the border radius for the bottomsheet.
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    //Optional. Styles the search field.
                                    inputDecoration: InputDecoration(
                                      labelText: 'Search',
                                      hintText: 'Start typing to search',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onSelect: (Country country) {
                                    setState(() {
                                      _countryPickerControler.text = country.displayName;
                                    });
                                  });
                            },
                            focusNode: AlwaysDisabledFocusNode(),
                            style: TextStyle(
                              color: _countryLabelColor,
                              fontSize: 18,
                              fontFamily: 'GothamMedium',
                            ),
                            decoration: getInputDecoration(
                                "Country",
                                _countryColor,
                                _countryLabelColor,
                                Icon(
                                  Icons.flag,
                                  size: 18,
                                  color: _countryLabelColor,
                                ),
                                null),
                          ),
                        ),

                        // phone number
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                      context: context,
                                      countryListTheme: CountryListThemeData(
                                        flagSize: 20,
                                        backgroundColor: Colors.white,
                                        textStyle: TextStyle(fontSize: 16, color: colorPrimary),
                                        //Optional. Sets the border radius for the bottomsheet.
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0),
                                        ),
                                        //Optional. Styles the search field.
                                        inputDecoration: InputDecoration(
                                          labelText: 'Search',
                                          hintText: 'Start typing to search',
                                          prefixIcon: const Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onSelect: (Country country) {
                                        setState(() {
                                          _countryCode = country.phoneCode.toString();
                                        });
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: textFieldFillColor,
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                                      child: Text("+" + _countryCode),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  // validator: (val) {

                                  // },
                                  onChanged: (value) => number = value,
                                  cursorColor: colorPrimary,
                                  focusNode: _numberFieldFocus,
                                  style: TextStyle(
                                    color: _numberLabelColor,
                                    fontSize: 18,
                                    fontFamily: 'GothamMedium',
                                  ),
                                  decoration: getInputDecoration(
                                      "Phone Number",
                                      _numberColor,
                                      _numberLabelColor,
                                      Icon(
                                        Icons.phone,
                                        size: 18,
                                        color: _numberLabelColor,
                                      ),
                                      null),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) => smsCode = value,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Enter OTP';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  cursorColor: colorPrimary,
                                  focusNode: _otpFieldFocus,
                                  style: TextStyle(
                                    color: _otpLabelColor,
                                    fontSize: 18,
                                    fontFamily: 'GothamMedium',
                                  ),
                                  decoration: getInputDecoration(
                                      "OTP",
                                      _otpColor,
                                      _otpLabelColor,
                                      Icon(
                                        Icons.password_sharp,
                                        size: 18,
                                        color: _otpLabelColor,
                                      ),
                                      null),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 2, 0, 2),
                                child: FilledRedButton(
                                    width: width / 4,
                                    height: height,
                                    text: codeRequested ? 'Resend' : 'Send',
                                    onPressed: () {
                                      if (codeRequested) {
                                        registerUser(this.number);
                                        Fluttertoast.showToast(
                                            msg: "Sending Again",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: white,
                                            textColor: colorPrimary,
                                            fontSize: 16.0);
                                      } else {
                                        registerUser(this.number);
                                        setState(() {
                                          codeRequested = true;
                                        });
                                      }
                                    }),
                              )
                            ],
                          ),
                        ),

                        // privacy
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalTextFieldPadding,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: colorPrimary,
                                  value: this.checkedTerms,
                                  onChanged: (bool value) {
                                    setState(() {
                                      this.checkedTerms = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                child: Container(
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                        text: "By clicking this, I agree to the ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal, color: colorPrimary),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: darkGrey,
                                            ),
                                            recognizer: new TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context, commonRouter(PrivacyPolicy()));
                                              },
                                          ),
                                          TextSpan(
                                            text: ' & Terms and Conditions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: colorPrimary,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  FilledRedButton(
                    width: width,
                    height: height,
                    text: 'Create Account',
                    onPressed: () {
                      if (checkedTerms) {
                        if (codeSent) {
                          if (_formKey.currentState.validate()) _register();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Number not verified",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: white,
                              textColor: colorPrimary,
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Terms not accepted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: white,
                            textColor: colorPrimary,
                            fontSize: 16.0);
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(3, 13, 3, 10),
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
      ),
    );
  }
}
