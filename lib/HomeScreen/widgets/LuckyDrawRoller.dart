import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class LuckyDrawRoller extends StatefulWidget {
  const LuckyDrawRoller({Key key, @required this.luckyDrawNumbers}) : super(key: key);
  final List luckyDrawNumbers;

  @override
  _LuckyDrawRollerState createState() => _LuckyDrawRollerState(this.luckyDrawNumbers);
}

class _LuckyDrawRollerState extends State<LuckyDrawRoller> {
  final List luckyDrawNumbers;
  _LuckyDrawRollerState(this.luckyDrawNumbers);

//  -- variable start

// audio
  final AudioCache player = AudioCache(
    fixedPlayer: AudioPlayer(),
  );
  final AudioCache luckyDrawPlayer = AudioCache(
    fixedPlayer: AudioPlayer(),
  );

  String startedFilename = 'sounds/TTS/lucky draw start and end/hasStarted.mp3';
  String endedFilename = 'sounds/TTS/lucky draw start and end/hasEnded.mp3';

  String luckyDrawOnGoing = 'sounds/TTS/lucky draw on going/live_spinning.wav';
  String luckyDrawSpinningStop = 'sounds/TTS/lucky draw on going/spinning_stop.wav';

  String firstDrawSound;
  String secondDrawSound;
  String thirdDrawSound;
  String fourthDrawSound;
  String fifthDrawSound;
  String sixthDrawSound;

  // roller

  static const _ROTATION_DURATION = Duration(milliseconds: 1200);
  static final firstRoller = new GlobalKey<RollerListState>();
  static final secondRoller = new GlobalKey<RollerListState>();
  static final thirdRoller = new GlobalKey<RollerListState>();
  static final fourthRoller = new GlobalKey<RollerListState>();
  static final fifthRoller = new GlobalKey<RollerListState>();
  static final sixthRoller = new GlobalKey<RollerListState>();

  final List rollerKeys = [
    firstRoller,
    secondRoller,
    thirdRoller,
    fourthRoller,
    fifthRoller,
    sixthRoller
  ];

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

  Timer rotator0;
  Timer rotator1;
  Timer rotator2;
  Timer rotator3;
  Timer rotator4;
  Timer rotator5;

  bool set0 = false;
  bool set1 = false;
  bool set2 = false;
  bool set3 = false;
  bool set4 = false;
  bool set5 = false;

  bool setNumber0 = false;
  bool setNumber1 = false;
  bool setNumber2 = false;
  bool setNumber3 = false;
  bool setNumber4 = false;
  bool setNumber5 = false;
  Random _random = new Random();

//   --- variable end ---

//   -- methods --

  void _startRotating() async {
    // _rotateRoller();

    int waitTime1 = 5;
    int waitTime2 = 2;

    double highVol = 0.5;
    double lowVol = 0.2;

    await Future.delayed(Duration(seconds: waitTime2));
    player.play(startedFilename);
    await Future.delayed(Duration(seconds: waitTime2));
    luckyDrawPlayer.loop(luckyDrawOnGoing, volume: lowVol);

    rotator0 = Timer.periodic(_ROTATION_DURATION, (_) {
      _rotateRoller(_, 0, set0);
    });

    rotator1 = Timer.periodic(_ROTATION_DURATION, (_) {
      _rotateRoller(_, 1, set1);
    });

    rotator2 = Timer.periodic(_ROTATION_DURATION, (_) {
      _rotateRoller(_, 2, set2);
    });

    rotator3 = Timer.periodic(_ROTATION_DURATION, (_) {
      _rotateRoller(_, 3, set3);
    });

    rotator4 = Timer.periodic(_ROTATION_DURATION, (_) {
      _rotateRoller(_, 4, set4);
    });

    rotator5 = Timer.periodic(_ROTATION_DURATION, (_) {
      _rotateRoller(_, 5, set5);
    });

// roller 1
    await Future.delayed(Duration(seconds: waitTime1));
    setState(() {
      set0 = true;
    });
    await Future.delayed(Duration(seconds: waitTime2));
    rotator0?.cancel();
    player.play(firstDrawSound, volume: highVol);
    setState(() => setNumber0 = true);

// roller 2
    await Future.delayed(Duration(seconds: waitTime1));
    setState(() {
      set1 = true;
    });
    await Future.delayed(Duration(seconds: waitTime2));
    rotator1?.cancel();
    player.play(secondDrawSound, volume: highVol);
    setState(() => setNumber1 = true);

// roller 3
    await Future.delayed(Duration(seconds: waitTime1));
    setState(() {
      set2 = true;
    });
    await Future.delayed(Duration(seconds: waitTime2));
    rotator2?.cancel();
    player.play(thirdDrawSound, volume: highVol);
    setState(() => setNumber2 = true);

// roller 4
    await Future.delayed(Duration(seconds: waitTime1));
    setState(() {
      set3 = true;
    });
    await Future.delayed(Duration(seconds: waitTime2));
    rotator3?.cancel();
    player.play(fourthDrawSound, volume: highVol);
    setState(() => setNumber3 = true);

// roller 5
    await Future.delayed(Duration(seconds: waitTime1));
    setState(() {
      set4 = true;
    });
    await Future.delayed(Duration(seconds: waitTime2));
    rotator4?.cancel();
    player.play(fifthDrawSound, volume: highVol);
    setState(() => setNumber4 = true);

// roller 6
    await Future.delayed(Duration(seconds: waitTime1));
    setState(() {
      set5 = true;
    });
    await Future.delayed(Duration(seconds: waitTime2));
    rotator5?.cancel();
    player.play(sixthDrawSound, volume: highVol);
    setState(() => setNumber5 = true);

    await Future.delayed(Duration(seconds: waitTime2));
    luckyDrawPlayer.fixedPlayer.pause();
    player.play(luckyDrawSpinningStop, volume: highVol);
    await Future.delayed(Duration(seconds: waitTime2));
    player.play(endedFilename);
    await Future.delayed(Duration(seconds: waitTime2));
    luckyDrawPlayer.fixedPlayer.stop();
    player.fixedPlayer.stop();
    // _finishRotating();
    // firstRoller.currentState.
  }

  void _rotateRoller(_, index, bool set) {
    final leftRotationTarget =
        set ? int.parse(luckyDrawNumbers[index]) : _random.nextInt(NUMBERS.length);

    rollerKeys[index].currentState?.smoothScrollToIndex(leftRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
  }

  // void _finishRotating() {
  //   rotator1?.cancel();
  // }

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

  void _changeMonths(int value) {
    // setState(() {
    //   // selectedMonth = MONTHS.keys.toList()[value];
    // });
  }

  @override
  void initState() {
    super.initState();
    firstDrawSound = 'sounds/TTS/first number/first number is ${luckyDrawNumbers[0]}.mp3';
    secondDrawSound = 'sounds/TTS/second number/second number is ${luckyDrawNumbers[1]}.mp3';
    thirdDrawSound = 'sounds/TTS/third number/third number is ${luckyDrawNumbers[2]}.mp3';
    fourthDrawSound = 'sounds/TTS/fourth number/fourth number is ${luckyDrawNumbers[3]}.mp3';
    fifthDrawSound = 'sounds/TTS/fifth number/fifth number is ${luckyDrawNumbers[4]}.mp3';
    sixthDrawSound = 'sounds/TTS/sixth number/sixth number is ${luckyDrawNumbers[5]}.mp3';
    luckyDrawPlayer.load(luckyDrawOnGoing);
    player.loadAll([
      startedFilename,
      endedFilename,
      firstDrawSound,
      secondDrawSound,
      thirdDrawSound,
      fourthDrawSound,
      fifthDrawSound,
      sixthDrawSound,
      luckyDrawOnGoing,
      luckyDrawSpinningStop
    ]);
    _startRotating();
  }

  @override
  void dispose() {
    super.dispose();
    player.clearAll();
    luckyDrawPlayer.clearAll();
    player.fixedPlayer.dispose();
    luckyDrawPlayer.fixedPlayer.dispose();
    // firstRoller.currentState.dispose();
    rotator0?.cancel();
    rotator1?.cancel();
    rotator2?.cancel();
    rotator3?.cancel();
    rotator4?.cancel();
    rotator5?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
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
                  ...rollerKeys.map((value) {
                    return RollerList(
                      items: numbers,
                      onSelectedIndexChanged: _changeMonths,
                      scrollType: ScrollType.goesOnlyBottom,
                      initialIndex: 0,
                      enabled: false,
                      dividerColor: darkGrey,
                      dividerThickness: 0,
                      key: value,

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
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            bottomBoxes(setNumber0, luckyDrawNumbers[0]),
            bottomBoxes(setNumber1, luckyDrawNumbers[1]),
            bottomBoxes(setNumber2, luckyDrawNumbers[2]),
            bottomBoxes(setNumber3, luckyDrawNumbers[3]),
            bottomBoxes(setNumber4, luckyDrawNumbers[4]),
            bottomBoxes(setNumber5, luckyDrawNumbers[5]),
          ]),
        )
      ],
    );
  }
}

// ignore: camel_case_types
class bottomBoxes extends StatelessWidget {
  final bool set;
  final String number;
  const bottomBoxes(
    this.set,
    this.number,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: darkGrey,
          border: Border.all(
            color: colorPrimary,
            width: 1,
          )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Text(
          set ? number : '  ',
          style: TextStyle(color: white),
        ),
      ),
    );
  }
}
