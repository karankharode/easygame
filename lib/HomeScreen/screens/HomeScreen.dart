import 'package:audioplayers/audioplayers.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easygame/LuckyDrawPage/models/pastDraws.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/LuckyDrawPage/controller/services/ballBorderService.dart';
import 'package:easygame/LuckyDrawPage/screens/PastDraw.dart';
import 'package:easygame/LuckyDrawPage/widgets/luckyDrawBall.dart';
import 'package:easygame/LuckyDrawPage/widgets/smallLuckyDrawBalls.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/common/widgets/loaderForStreamBuilder.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class WinnerHomePage extends StatefulWidget {
  const WinnerHomePage({Key key}) : super(key: key);

  @override
  _WinnerHomePageState createState() => _WinnerHomePageState();
}

class _WinnerHomePageState extends State<WinnerHomePage> {
  double height, width;
  final AudioCache player = AudioCache();
  int gameNumber;
  DatabaseReference db;
  List luckyDrawNumbers = ['6', '2', '5', '4', '7', '9'];
  List<PastDraws> pastDraws = [];

  List<Widget> adBannerList = [
    GestureDetector(
      onTap: () async {
        await launch('http://www.ezezcoin.com');
      },
      child: Image.asset(
        'assets/images/adBanner1.jpeg',
        // height: 110,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    ),
    GestureDetector(
      onTap: () async {
        await launch('https://www.weallcansing.com');
      },
      child: Image.asset(
        'assets/images/adBanner.jpeg',
        // height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
    GestureDetector(
      onTap: () async {
        await launch('https://www.vipbets.com');
      },
      child: Image.asset(
        'assets/images/adBanner3.jpeg',
        // height: 110,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    db = FirebaseDatabase().reference();
    player.load('sounds/sweep.wav');
  }

  @override
  void dispose() {
    // rotator1?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    gameNumber = 6;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            color: colorPrimary,
          ),
          CarouselSlider(
              items: adBannerList,
              options: CarouselOptions(
                height: 120,
                aspectRatio: 2 / 2,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 10),
                autoPlayAnimationDuration: Duration(milliseconds: 900),
                autoPlayCurve: Curves.easeIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
              )),
          Container(
            height: height - 75 - 75 - 120,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(14, 5, 14, 30),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: db
                          .child('LuckyDraw')
                          .child('CurrentDayDraws')
                          .child('drawId')
                          .child('Info')
                          .child('time')
                          .onValue,
                      initialData: db
                          .child('LuckyDraw')
                          .child('CurrentDayDraws')
                          .child('drawId')
                          .child('Info')
                          .child('time')
                          .onValue,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Container();
                            break;
                          case ConnectionState.active:
                            var data = snapshot.data.snapshot.value;
                            String time = data;
                            int diff = Jiffy(Jiffy(time, 'yyyy-MM-dd hh:mm:ss aa'))
                                .diff(Jiffy().dateTime, Units.SECOND);
                            if (diff > 0) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                                      ],
                                    )
                                  ]);
                            } else {
                              return Container();
                            }

                            return Container();
                          default:
                            return Container();
                        }
                        return Container();
                      }),

                  StreamBuilder(
                    stream: db.child('LuckyDraw').child('PastDraws').limitToLast(5).onValue,
                    initialData: db.child('LuckyDraw').child('PastDraws').limitToLast(5).onValue,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          // return a loader
                          return loader(height);
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            pastDraws.clear();
                            var data = snapshot.data.snapshot.value;

                            data.forEach((key, value) {
                              String time = '';
                              try {
                                time = Jiffy(value['Info']['time'], 'yyyy-MM-dd hh:mm:ss aa')
                                    .format('hh:mm aa')
                                    .toString();
                              } catch (e) {
                                try {
                                  time = Jiffy(value['Info']['time'], 'yyyy-MM-dd hh:mm aa')
                                      .format('hh:mm aa')
                                      .toString();
                                } catch (e) {
                                  try {
                                    time = value['Info']['time']
                                        .toString()
                                        .trim()
                                        .split(' ')
                                        .removeAt(1)
                                        .toString();
                                  } catch (e) {
                                    time = '';
                                  }
                                }
                              }
                              pastDraws.add(PastDraws(
                                value['Info']['string'],
                                value['Info']['winningCriteria'],
                                time,
                                value['Winners']['first'],
                                value['Winners']['second'],
                                value['Winners']['third'],
                                key.toString(),
                                value['Info']['time'].split(' ').first.toString(),
                              ));
                            });
                            pastDraws = pastDraws.reversed.toList();
                            // process data
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BlinkText(
                                          "Today's winning numbers",
                                          style: splashHeadingStyle,
                                          endColor: colorPrimary,
                                          duration: Duration(milliseconds: 800),
                                        ),
                                      ),
                                      Text(
                                        "Game #${gameNumber--} - ${pastDraws[0].date}   ${pastDraws[0].time}",
                                        style: redClickableTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: darkGrey,
                                  height: 5,
                                  thickness: 0.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ...pastDraws[0].drawString.characters.toList().map(
                                            (e) => LuckyDrawBall(
                                                number: e.toString(),
                                                borderColor: getBalBorderColor(pastDraws[0]
                                                    .drawString
                                                    .characters
                                                    .toList()
                                                    .indexOf(e))),
                                          )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: darkGrey,
                                  height: 5,
                                  thickness: 0.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FilledRedButton(
                                      width: width,
                                      height: height,
                                      text: 'Game Category :  All personal numbers to play',
                                      onPressed: () {}),
                                ),

                                // recent past draw
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: shadowColor,
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                              offset: Offset(1, 1))
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          ...pastDraws.map((e) => Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      'Game #${gameNumber--} - ${e.date}',
                                                      style: redClickableTextStyle,
                                                    )),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceAround,
                                                        children: [
                                                          ...e.drawString.characters.toList().map(
                                                                (e) => SmallLuckyDrawBall(
                                                                    number: e.toString(),
                                                                    borderColor: getBalBorderColor(
                                                                        luckyDrawNumbers
                                                                            .indexOf(e))),
                                                              )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // return not found or loader
                            return loader(height);
                          }
                          break;
                        default:
                          return loader(height);
                        // return a loader
                      }
                    },
                  ),

                  // buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledRedButton(
                            width: width,
                            height: height,
                            text: 'Past Draws',
                            onPressed: () {
                              Navigator.push(context, commonRouter(PastDraw()));
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class mockTimer extends StatelessWidget {
  const mockTimer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
          child: Text(
            'Time to next Draw',
            style: greyHeadingStyle,
          ),
        ),
        CountdownTimer(
          endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 3000,
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
        // TextButton(
        //     onPressed: () {
        //       _startRotating();
        //     },
        //     child: Text('Roll')),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/animations/progress.gif',
              height: 20,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            )),
      ],
    );
  }
}
