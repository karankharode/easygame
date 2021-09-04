import 'package:easygame/ContactUs/screens/contactUs.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  FaqPage({Key key}) : super(key: key);

  double height, width;
  final List questionList = [
    {
      'ques': "1) What is Easygame ?",
      'ans':
          "Easy Game is a non gambling, Free-to-Play app. Easy game is an entertaining app, consists of FREE lucky draw, mini IQ games and fun talent contest, for the users to play, interact and to win attractive prizes",
    },
    {
      'ques': "2) Easygame lucky draw ?",
      'ans': '''2.1) What is Easygame lucky draw

Easygame lucky draw is a daily draw for members to have a chance to win EZ coins. 


2.2) Game Rules

1.	EZ Game is a Free-to-Play match-to-win numbers game. No tickets, no wages or no bets are required.
2.	Four draws daily starting 12.00, 14.00, 16.00, 18.00 hours. (HK/Philippine Time).
3.	Each game, a set of 5 to 6 numbers will be randomly generated from the app. 
4.	Match the last 5 numbers in the same order to win 2000 EZ coins.
5.	Match the last 4 numbers in the same order to win 500 EZ coins
6.	Match the last 3 numbers in the same order to win 300 EZ Coins.
7.	Weekend Jackpot (Saturday & Sunday) pays 50,000 EZ coins for 6 numbers matched correctly up in the same order.
8.	Game category in play will be notified in the app prior to the draw. 
9.	EZ coins will be credited into winner’s wallet, upon verifications.
10.	Game developer reserves the rights to make changes to the above game rules, from time to time when required. 
Personal Number
Personal Numbers are defined as document of identity(DOI) belonging to the user, which are specified herein as passport, birth certificate, driver’s license, TIN, bank cards, vehicle number plate. The use of DOI not listed herein, cannot be in play. 


2.3) What to do if you win

Contact the customer service with your winning ticket to get EZ coins''',
    },
    {
      'ques': "3) Mini Games ",
      'ans': '''3.1) Mini games rules
Play and follow each game rules to win tokens.''',
    },
    {
      'ques': "4) EZ Coins",
      'ans': ''' 4.1) Usage

EZ coins can be use to redeem attractive premium prizes. 


4.2) How to redeem

Contact our customer service to claim your prizes using Easy coins. 


4.3) Balance and History

All balance and history will be shown in the user app.''',
    },
    {
      'ques': "5) EZ Token",
      'ans': ''' 5.1) How to earn tokens

Earn tokens through our mini games, entertainment and advertisements participation


5.2) how to redeem tokens

Go to the redemption page in the app to see the prizes you can redeem using tokens


5.3) Balance and history

All balance and history will be shown in the user app.
''',
    },
    {
      'ques': "6) Account",
      'ans': '''6.1) how to change password 

 Password can change via app and OTP


6.2) how to change username 

Contact customer service to change username. 


6.3) User ID 

User ID cannot be change once you open your account. 


6.4) how to retrieve account 

Contact customer service to retrieve your account 
''',
    },
    {
      'ques': "7) Contact",
      'ans': "Contact Customer Service Button Customer service option is available in the app",
    },
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      height: height - 75 - 65 - 80 - 58 - 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text(
              'FAQ',
              style: headingStyle,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ...questionList.map((e) {
                    int qNumber = questionList.indexOf(e) + 1;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: white,
                          boxShadow: [
                            BoxShadow(color: shadowColor, spreadRadius: 1, offset: Offset(1, 1))
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
                            child: Text(
                              e['ques'],
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                                child: Text(
                                  e['ans'],
                                  style: TextStyle(color: grey),
                                ),
                              ),
                            )
                          ],
                          collapsedTextColor: grey,
                          initiallyExpanded: (qNumber == 1),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: FilledRedButton(
                  width: width,
                  height: height,
                  text: "Contact Us",
                  onPressed: () {
                    Navigator.push(context, commonRouter(ContactUs()));
                  })),
        ],
      ),
    );
  }
}
