import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/Login&Signup/widgets/greyInactiveButton.dart';
import 'package:easygame/TokenRedemption/models/Token.dart';
import 'package:easygame/TokenRedemption/widgets/counterBox.dart';
import 'package:easygame/common/providers/coinsAndTokenProvider.dart';
import 'package:easygame/common/widgets/loaderForStreamBuilder.dart';
import 'package:easygame/common/widgets/notFoundWidget.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class TokenRedemption extends StatefulWidget {
  const TokenRedemption({Key key}) : super(key: key);

  @override
  _TokenRedemptionState createState() => _TokenRedemptionState();
}

class _TokenRedemptionState extends State<TokenRedemption> {
  double height, width;
  DatabaseReference databaseReference;
  List<Token> tokenList = [];

  @override
  void initState() {
    super.initState();
    // print(FirebaseAuth.instance.currentUser.uid);
    databaseReference = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    var coinsAndTokenProvider = Provider.of<TopCoinTokenProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text(
            'Token Redemption',
            style: headingStyle,
          ),
        ),
        StreamBuilder(
            stream: databaseReference.child('Tokens').onValue,
            initialData: databaseReference.child('Tokens').onValue,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return loader(height);
                  break;
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    var data = snapshot.data.snapshot.value;

                    tokenList.clear();
                    data.forEach((key, value) {
                      tokenList.add(Token(
                        name: value['name'],
                        tokenId: key.toString(),
                        image: value['image'],
                        descriptioin: value['description'],
                        qty: value['quantity'],
                        value: value['value'],
                        amount: 1,
                        status: false,
                      ));
                    });
                    return tokenList.length != 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 5 / 10,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tokenList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(brRadius),
                                          boxShadow: [
                                            BoxShadow(
                                                color: shadowColor,
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                                offset: Offset(1, 1))
                                          ]),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                              Center(
                                                                child: Container(
                                                                  height: 400,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(22))),
                                                                  width: width,
                                                                  child: Image.network(
                                                                    tokenList[index].image,
                                                                    width: double.infinity,
                                                                    height: 400,
                                                                  ),
                                                                ),
                                                              )
                                                            ]),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(4, 1, 4, 3),
                                                child: Image.network(
                                                  tokenList[index].image,
                                                  height: 50,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                                child: Text(tokenList[index].name,
                                                    style: darkGreyTextStyle),
                                              ),
                                              Container(
                                                height: 36,
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                                  child: Text(tokenList[index].descriptioin,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: greyNonClickableTextStyle),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Cost - ', style: darkGreyTextStyle),
                                                    Text(tokenList[index].value.toString(),
                                                        style: redClickableTextStyle),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Remaining - ', style: darkGreyTextStyle),
                                                    Text(tokenList[index].qty.toString(),
                                                        style: redClickableTextStyle),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                                child: CountButtonView(
                                                  initialCount: tokenList[index].amount,
                                                  onChange: (count) {
                                                    tokenList[index].amount = count;
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          tokenList[index].qty > 0
                                              ? Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 2),
                                                  child: FilledRedButton(
                                                      width: width / 2.5,
                                                      height: height - 250,
                                                      text: "Redeem",
                                                      onPressed: () async {
                                                        int totalTokens = int.parse(
                                                                tokenList[index].value.toString()) *
                                                            tokenList[index].amount;
                                                        if (coinsAndTokenProvider.currentTokens >=
                                                                totalTokens &&
                                                            tokenList[index].amount <
                                                                tokenList[index].qty) {
                                                          // buying dialog box
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    tokenList[index].name,
                                                                    style: redHeadingStyle,
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text(
                                                                          'No',
                                                                          style: TextStyle(
                                                                              color: grey),
                                                                        )),
                                                                    TextButton(
                                                                        onPressed: () async {
                                                                          try {
                                                                            coinsAndTokenProvider
                                                                                    .currentTokens =
                                                                                coinsAndTokenProvider
                                                                                        .currentTokens -
                                                                                    totalTokens;

                                                                            // DatabaseReference newDbRef =
                                                                            DatabaseReference
                                                                                newRef =
                                                                                databaseReference
                                                                                    .child('Users')
                                                                                    .child(FirebaseAuth
                                                                                        .instance
                                                                                        .currentUser
                                                                                        .uid
                                                                                        .toString())
                                                                                    .child(
                                                                                        'TokenRedemptionHistory')
                                                                                    .push();

                                                                            newRef.set(
                                                                              {
                                                                                'description':
                                                                                    tokenList[index]
                                                                                        .descriptioin,
                                                                                'image':
                                                                                    tokenList[index]
                                                                                        .image,
                                                                                'name':
                                                                                    tokenList[index]
                                                                                        .name,
                                                                                'quantity':
                                                                                    tokenList[index]
                                                                                        .amount,
                                                                                'value':
                                                                                    tokenList[index]
                                                                                        .value,
                                                                                'date': Jiffy()
                                                                                    .format(
                                                                                        'dd/MM/yyyy'),
                                                                                'time': Jiffy()
                                                                                    .format(
                                                                                        'hh:mm aa'),
                                                                                'status': 0,
                                                                              },
                                                                            );
                                                                            databaseReference
                                                                                .child('Tokens')
                                                                                .child(
                                                                                    tokenList[index]
                                                                                        .tokenId
                                                                                        .toString())
                                                                                .child('quantity')
                                                                                .set((tokenList[
                                                                                            index]
                                                                                        .qty -
                                                                                    tokenList[index]
                                                                                        .amount));

                                                                            // update for review
                                                                            databaseReference
                                                                                .child(
                                                                                    'TokenRedemptionHistory')
                                                                                .push()
                                                                                .set(
                                                                              {
                                                                                'Token': {
                                                                                  'description':
                                                                                      tokenList[
                                                                                              index]
                                                                                          .descriptioin,
                                                                                  'image':
                                                                                      tokenList[
                                                                                              index]
                                                                                          .image,
                                                                                  'name': tokenList[
                                                                                          index]
                                                                                      .name,
                                                                                  'quantity':
                                                                                      tokenList[
                                                                                              index]
                                                                                          .amount,
                                                                                  'value':
                                                                                      tokenList[
                                                                                              index]
                                                                                          .value,
                                                                                  'date': Jiffy()
                                                                                      .format(
                                                                                          'dd/MM/yyyy'),
                                                                                  'time': Jiffy()
                                                                                      .format(
                                                                                          'hh:mm aa'),
                                                                                  'tokenId':
                                                                                      tokenList[
                                                                                              index]
                                                                                          .tokenId,
                                                                                  'status': 0,
                                                                                },
                                                                                'User': {
                                                                                  'email':
                                                                                      FirebaseAuth
                                                                                          .instance
                                                                                          .currentUser
                                                                                          .email,
                                                                                  'uid': FirebaseAuth
                                                                                      .instance
                                                                                      .currentUser
                                                                                      .uid,
                                                                                  'username':
                                                                                      FirebaseAuth
                                                                                          .instance
                                                                                          .currentUser
                                                                                          .displayName,
                                                                                  'pushIdForUserDb':
                                                                                      newRef.key
                                                                                }
                                                                              },
                                                                            );

                                                                            await databaseReference
                                                                                .child('Users')
                                                                                .child(FirebaseAuth
                                                                                    .instance
                                                                                    .currentUser
                                                                                    .uid
                                                                                    .toString())
                                                                                .child('Wallet')
                                                                                .child('tokens')
                                                                                .set((coinsAndTokenProvider
                                                                                    .currentTokens));

                                                                            Fluttertoast.showToast(
                                                                                msg:
                                                                                    "Tokens Redeemed :)",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity:
                                                                                    ToastGravity
                                                                                        .BOTTOM,
                                                                                timeInSecForIosWeb:
                                                                                    1,
                                                                                backgroundColor:
                                                                                    white,
                                                                                textColor:
                                                                                    colorPrimary,
                                                                                fontSize: 16.0);
                                                                            // tokenList[index]
                                                                            //     .amount = 1;
                                                                            Navigator.pop(context);
                                                                          } catch (e) {
                                                                            Fluttertoast.showToast(
                                                                                msg:
                                                                                    "Some error occured ! :(",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity:
                                                                                    ToastGravity
                                                                                        .BOTTOM,
                                                                                timeInSecForIosWeb:
                                                                                    1,
                                                                                backgroundColor:
                                                                                    white,
                                                                                textColor:
                                                                                    colorPrimary,
                                                                                fontSize: 16.0);
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                          'Yes',
                                                                          style: TextStyle(
                                                                              color: colorPrimary),
                                                                        )),
                                                                  ],
                                                                  content: SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                            'Do you want to use $totalTokens Tokens to redeem  ${tokenList[index].amount.toString()} ${tokenList[index].name}?'),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                                  top: 14.0),
                                                                          child: Image.network(
                                                                            tokenList[index].image,
                                                                            height: 70,
                                                                            fit: BoxFit.fitHeight,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: "Not enough Tokens !",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: white,
                                                              textColor: colorPrimary,
                                                              fontSize: 16.0);
                                                        }
                                                      }),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 2),
                                                  child: GreyInactiveButton(
                                                      width: width / 2.5,
                                                      height: height - 250,
                                                      text: "All Redeemed",
                                                      onPressed: () {}),
                                                )
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          )
                        : notFoundWidget(
                            height: height,
                            text: 'No Tokens Available !',
                          );
                  } else {
                    return loader(height);
                  }

                  break;
                default:
                  return loader(height);
              }
            })
      ],
    );
  }
}
