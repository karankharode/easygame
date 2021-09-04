import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:easygame/HomeScreen/widgets/LuckyDrawRoller.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/LuckyDrawPage/controller/services/ballBorderService.dart';
import 'package:easygame/LuckyDrawPage/widgets/luckyDrawBall.dart';
import 'package:easygame/LuckyDrawPage/widgets/remainingPrizes.dart';
import 'package:easygame/common/widgets/ballSpinnerLuckyDraw.dart';
import 'package:easygame/common/widgets/loaderForStreamBuilder.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:roller_list/roller_list.dart';

class LuckyDrawPage extends StatefulWidget {
  @override
  _LuckyDrawPageState createState() => _LuckyDrawPageState();
}

class _LuckyDrawPageState extends State<LuckyDrawPage> {
  double height, width;
  bool showDraw = true;
  bool showRollerAnimation = false;
  DatabaseReference db;
  Timer drawTimer;

  final AudioCache player = AudioCache(fixedPlayer: AudioPlayer(), duckAudio: true);
  String aboutToBeginFileName = 'sounds/TTS/lucky draw start and end/aboutToBegin.mp3';

  static const NUMBERS = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  ];

  List mockLuckyDrawNumber = ['0', '0', '0', '0', '0', '0'];

  final List<Widget> numbers = NUMBERS
      .map((month) => Container(
            decoration: BoxDecoration(
                color: white,
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border(
                    left: BorderSide(
                  color: darkGrey,
                  width: 1.5,
                ))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 7, 18, 7),
              child: Text(
                month,
                textScaleFactor: 1.3,
                style: TextStyle(fontFamily: 'Sans_Expanded', color: colorPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ))
      .toList();

  @override
  void initState() {
    super.initState();
    db = FirebaseDatabase().reference();
    player.load(aboutToBeginFileName);
  }

  @override
  void dispose() {
    player.clearAll();
    player.fixedPlayer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // lucky draw widget
        showDraw
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Text(
                  'Lucky Draw',
                  style: headingStyle,
                ),
              )
            : Container(),
        StreamBuilder(
            stream: db.child('LuckyDraw').child('CurrentDayDraws').child('drawId').onValue,
            initialData: db.child('LuckyDraw').child('CurrentDayDraws').child('drawId').onValue,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return loader(height);
                  break;
                case ConnectionState.active:
                  var data = snapshot.data.snapshot.value;

                  String luckyDrawString = data['Info']['string'].toString();
                  if (luckyDrawString.isEmpty) {
                    luckyDrawString = '123456';
                  } else if (luckyDrawString.length > 6) {
                    luckyDrawString = luckyDrawString.substring(0, 6);
                  } else if (luckyDrawString.length < 6) {
                    luckyDrawString = '123456';
                  }
                  List luckyDrawNumbers = luckyDrawString.characters.toList();

                  String winningCriteria = data['Info']['winningCriteria'].toString();

                  String time = data['Info']['time'];
                  int diff = 200;
                  try {
                    diff = Jiffy(Jiffy(time, 'yyyy-MM-dd hh:mm:ss aa'))
                        .diff(Jiffy().dateTime, Units.SECOND);
                  } catch (e) {
                    diff = 200;
                  }

                  String payout1 = data['PrizePayout']['payout1'].toString();
                  String payout2 = data['PrizePayout']['payout2'].toString();
                  String payout3 = data['PrizePayout']['payout3'].toString();
                  String payout4 = data['PrizePayout']['payout4'].toString();

                  int index = 0;

                  if (diff > 0) {
                    drawTimer?.cancel();
                    // if (true) {
                    drawTimer = Timer(Duration(seconds: diff), () async {
                      player.play(aboutToBeginFileName);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.black.withOpacity(0.2),
                          builder: (context) => AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Lottie.asset(
                                  'assets/animations/celebration.json',
                                ),
                              ));
                      await Future.delayed(Duration(seconds: 5));
                      Navigator.pop(context);
                      setState(() {
                        showDraw = true;
                        showRollerAnimation = true;
                      });
                    });

                    // var timeForDraw = Jiffy(Jiffy(time, 'yyyy-MM-dd hh:mm:ss aa')).fromNow();
                    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              'Time to next Draw',
                              style: greyHeadingStyle,
                            ),
                          ),
                          CountdownTimer(
                            endTime: Jiffy(time, 'yyyy-MM-dd hh:mm:ss aa')
                                .dateTime
                                .millisecondsSinceEpoch,
                            widgetBuilder: (_, CurrentRemainingTime time) {
                              if (time == null) {
                                return Text('');
                              }
                              return Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ' in ',
                                      style: redClickableTextStyle,
                                    ),
                                    time.days != null
                                        ? Text(
                                            ' ${time.days} day, ',
                                            style: redClickableTextStyle,
                                          )
                                        : Container(),
                                    time.hours != null
                                        ? Text(
                                            ' ${time.hours} hour,',
                                            style: redClickableTextStyle,
                                          )
                                        : Container(),
                                    time.min != null
                                        ? Text(
                                            ' ${time.min} min, ',
                                            style: redClickableTextStyle,
                                          )
                                        : Container(),
                                    time.sec != null
                                        ? Text(
                                            ' ${time.sec} sec ',
                                            style: redClickableTextStyle,
                                          )
                                        : Container(),
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/animations/progress.gif',
                                height: 50,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              )),
                          staticRoller(mockLuckyDrawNumber: mockLuckyDrawNumber, numbers: numbers),
                          payoutWidget(
                            payout1: payout1,
                            payout2: payout2,
                            payout3: payout3,
                            payout4: payout4,
                          ),
                        ],
                      )
                    ]);
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Text(
                        'Winning Numbers',
                        style: greyNonClickableTextStyle,
                      ),
                    ),
                    showRollerAnimation
                        ? LuckyDrawRoller(luckyDrawNumbers: luckyDrawNumbers)
                        : Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    color: darkGrey,
                                    border: Border.all(
                                      color: grey,
                                      width: 1,
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...mockLuckyDrawNumber.map((value) {
                                      return RollerList(
                                        items: numbers,
                                        onSelectedIndexChanged: (val) {},
                                        scrollType: ScrollType.goesOnlyBottom,
                                        initialIndex: 0,
                                        enabled: false,
                                        dividerColor: darkGrey,
                                        dividerThickness: 0,

                                        // builder: ,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Container(
                                height: 114,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.4),
                                        Colors.grey.withOpacity(0.3),
                                        Colors.black.withOpacity(0.3),
                                        Colors.grey.withOpacity(0.0),
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(0.2),
                                        Colors.black.withOpacity(0.5),
                                        Colors.black.withOpacity(0.6),
                                      ]),
                                ),
                              ),
                            ],
                          ),

                    showRollerAnimation
                        ? SizedBox(
                            height: 10,
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 2, bottom: 20),
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: shadowColor,
                                    offset: Offset(1, 1),
                                    blurRadius: 8,
                                    spreadRadius: 3)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ...luckyDrawNumbers.map(
                                  (e) => LuckyDrawBall(
                                      number: e.toString(),
                                      borderColor: getBalBorderColor(index++)),
                                )
                                // LuckyDrawBall(number: '1', borderColor: Color(0xffFFD807)),
                                // LuckyDrawBall(number: '5', borderColor: Color(0xff82AF00)),
                                // LuckyDrawBall(number: '7', borderColor: Color(0xff6B82FF)),
                                // LuckyDrawBall(number: '3', borderColor: Color(0xff364495)),
                                // LuckyDrawBall(number: '9', borderColor: Color(0xff484021)),
                                // LuckyDrawBall(number: '2', borderColor: Color(0xffB32DBF)),
                              ],
                            ),
                          ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    //   child: Text(
                    //     'Remaining Prize',
                    //     style: greyNonClickableTextStyle,
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     remainingPrizesWidget(
                    //         position: '1st', remainingPrizes: remainingPrizesFirst.toString()),
                    //     remainingPrizesWidget(
                    //         position: '2nd', remainingPrizes: remainingPrizesSecond.toString()),
                    //     remainingPrizesWidget(
                    //         position: '3rd', remainingPrizes: remainingPrizesThird.toString()),
                    //     remainingPrizesWidget(
                    //         position: 'Consolation',
                    //         remainingPrizes: remainingPrizesConsolation.toString()),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    //   child: ballSpinnerLuckyDraw(),
                    // ),
                    FilledRedButton(
                        width: width,
                        height: height + 100,
                        text: 'Winning Criteria : ' + winningCriteria,
                        onPressed: () {}),
                    payoutWidget(
                      payout1: payout1,
                      payout2: payout2,
                      payout3: payout3,
                      payout4: payout4,
                    ),
                  ]);

                  break;
                default:
                  return loader(height);
              }
            }),
      ],
    );
  }
}

class payoutWidget extends StatelessWidget {
  final String payout1;
  final String payout2;
  final String payout3;
  final String payout4;
  const payoutWidget({
    Key key,
    @required this.payout1,
    @required this.payout2,
    @required this.payout3,
    @required this.payout4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
      decoration: BoxDecoration(
          border: Border.all(color: colorPrimary, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(brRadius + 10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '*PRIZE PAYOUT :',
            style: TextStyle(
              color: primaryAccent,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(55, 10, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '6 Numbers Win   :   ',
                    ),
                    Text(payout1, style: redClickableTextStyle),
                  ],
                ),
                Text('5 Numbers Win   :   $payout2/-'),
                Text('4 Numbers Win   :   $payout3/-'),
                Text('3 Numbers Win   :   $payout4/-'),
              ],
            ),
          ),
          Center(
            child: Text(
              '(*Prizes may be subjected to change according to category of game in play )',
              style: TextStyle(color: darkGrey, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}

class staticRoller extends StatelessWidget {
  const staticRoller({
    Key key,
    @required this.mockLuckyDrawNumber,
    @required this.numbers,
  }) : super(key: key);

  final List mockLuckyDrawNumber;
  final List<Widget> numbers;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: darkGrey,
              border: Border.all(
                color: grey,
                width: 1,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...mockLuckyDrawNumber.map((value) {
                return RollerList(
                  items: numbers,
                  onSelectedIndexChanged: (val) {},
                  scrollType: ScrollType.goesOnlyBottom,
                  initialIndex: 0,
                  enabled: false,
                  dividerColor: darkGrey,
                  dividerThickness: 0,

                  // builder: ,
                );
              }),
            ],
          ),
        ),
        Container(
          height: 114,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            gradient:
                LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
              Colors.black.withOpacity(0.4),
              Colors.grey.withOpacity(0.3),
              Colors.black.withOpacity(0.3),
              Colors.grey.withOpacity(0.0),
              Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.6),
            ]),
          ),
        ),
      ],
    );
  }
}
