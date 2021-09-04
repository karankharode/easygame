import 'package:easygame/Account%20Page/screens/CoinWithdrawlHistory.dart';
import 'package:easygame/Account%20Page/screens/TokenRedemptionHistory.dart';
import 'package:easygame/Account%20Page/widgets/accountButtons.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/common/providers/coinsAndTokenProvider.dart';
import 'package:easygame/common/widgets/loaderDialog.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    List<Map> accountButtons = [
      {
        'text': 'Change Password',
        "color": colorPrimary,
        'textColor': white,
        'onPressed': () async {
          showLoaderDialog(context);
          // @override
          // Future<void> resetPassword(String email) async {
          try {
            String email = FirebaseAuth.instance.currentUser.email;
            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Lottie.asset('assets/animations/passwordReset.json', height: 150),
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
                          'An email has been sent to your registered email ${(email)} with a link to reset your password. Kidnly check your email and reset your password.',
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
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Lottie.asset('assets/animations/error.json', height: 150),
                    content: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          // }
        }
      },
      // {
      //   'text': 'Contact\nUs',
      //   "color": white,
      //   'textColor': colorPrimary,
      //   'onPressed': () {
      //     Navigator.push(context, commonRouter(ContactUs()));
      //   }
      // },
      {
        'text': 'Token Redemption History',
        "color": colorPrimary,
        'textColor': white,
        'onPressed': () {
          Navigator.push(context, commonRouter(TokenRedemptionHistory()));
        }
      },
      {
        'text': 'Coin History',
        "color": colorPrimary,
        'textColor': white,
        'onPressed': () {
          Navigator.push(
              context,
              commonRouter(CoinWithdrawlHistory(
                  databaseReference: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(FirebaseAuth.instance.currentUser.uid)
                      .child('WalletHistory')
                      .child('Coins'),
                  coinToken: 1)));
        }
      },
      {
        'text': 'Token History',
        "color": colorPrimary,
        'textColor': white,
        'onPressed': () {
          Navigator.push(
              context,
              commonRouter(CoinWithdrawlHistory(
                  databaseReference: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(FirebaseAuth.instance.currentUser.uid)
                      .child('WalletHistory')
                      .child('Tokens'),
                  coinToken: 2)));
        }
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 30,
            color: colorPrimary,
          ),
          Container(
            height: height - 75 - 75 - 40,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi,',
                            style: headingStyle,
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser.displayName.toString(),
                            style: redHeadingStyle,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                      text: FirebaseAuth.instance.currentUser.uid.toString()))
                                  .then((value) => Fluttertoast.showToast(
                                      msg: "Copied to Clipboard !",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: white,
                                      textColor: colorPrimary,
                                      fontSize: 16.0));
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Unique EasyGame ID - ' +
                                      FirebaseAuth.instance.currentUser.uid
                                          .toString()
                                          .substring(0, 10),
                                  style: greyNonClickableTextStyle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.copy,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 5),
                      child: Text(
                        'E Wallet Baalance',
                        textAlign: TextAlign.left,
                        style: greyNonClickableTextStyle,
                      ),
                    ),
                  ),

                  // balance container
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: shadowColor,
                            offset: Offset(0, 4),
                            spreadRadius: 0.8,
                            blurRadius: 10)
                      ], color: bgColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Consumer<TopCoinTokenProvider>(
                          builder: (context, coinsAndTokens, widget) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, right: 8),
                                        child: Image.asset(
                                          'assets/icons/coin.png',
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Coins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    coinsAndTokens.coins.toString(),
                                    style: redTextStyle,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, right: 8),
                                        child: Image.asset(
                                          'assets/icons/token.png',
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Tokens',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    coinsAndTokens.tokens.toString(),
                                    style: redTextStyle,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // gridBuilder

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: accountButtons.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                          child: AccountButton(
                            width: width,
                            height: height,
                            text: accountButtons[index]['text'],
                            onPressed: accountButtons[index]['onPressed'],
                            color: accountButtons[index]['color'],
                            textColor: accountButtons[index]['textColor'],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledRedButton(
                        width: width,
                        height: height,
                        text: 'Logout',
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
