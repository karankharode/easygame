import 'dart:io';

import 'package:easygame/Account%20Page/screens/AccountPage.dart';
import 'package:easygame/FAQ/screens/FAQPage.dart';
import 'package:easygame/HomePage/controllers/providers/BottomNavBarProvider.dart';
import 'package:easygame/HomeScreen/screens/HomeScreen.dart';
import 'package:easygame/LuckyDrawPage/screens/LuckyDrawPage.dart';
import 'package:easygame/MiniGames/screens/MiniGames.dart';
import 'package:easygame/TokenRedemption/screens/TokenRedemption.dart';
import 'package:easygame/common/services/coinsAndTokenService.dart';
import 'package:easygame/common/widgets/topCoinsWidget.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:audioplayers/audioplayers.dart';

// int selectedIndex = 0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height, width;
  AudioCache player = AudioCache(
      respectSilence: true,
      duckAudio: false,
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  // AudioPlayer audioPlayer;

  void onItemTapped(int index, provider) {
    // setState(() {
    // selectedIndex = index;
    //   // pageIndex = index;
    // });
    player.play(tapSweepSoundAsset);
    if (provider.currentIndex != index) provider.currentIndex = index;
  }

  // void _playFile() async {
  //   await player.loop('sounds/bgMusic.ogg', stayAwake: true, volume: 1.0); // assign player here
  // }

  // void _stopFile() {
  //   audioPlayer.stop(); // stop the file like this
  // }

  @override
  void initState() {
    super.initState();
    player.load(tapSweepSoundAsset);
    // player.load('sounds/bgMusic.ogg');
    // _playFile();
    updateCoinsAndTokens(context);
  }

  @override
  void dispose() {
    player.clearAll();
    player.fixedPlayer.stop();
    // _stopFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    const double iconHeight = 31;
    List<Widget> bodyOptions = [
      // MainPage(),
      WinnerHomePage(),
      AccountPage(),
      homePageScrollViewWithTopContainer(LuckyDrawPage(), height),
      homePageScrollViewWithTopContainer(MiniGames(), height),
      homePageScrollViewWithTopContainer(TokenRedemption(), height),
      homePageScrollViewWithTopContainer(FaqPage(), height)
    ];

    Future<bool> dialogue() {
      final player = AudioCache();
      double h = height;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  GestureDetector(
                    onTap: () {
                      player.play(tapSweepSoundAsset);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "NO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // player.play('frosting_cleared2.wav');
                      // return true;
                      exit(0);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                      child: Text(
                        "YES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Do you really want to exit the Game?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: h / 35,
                            decoration: TextDecoration.none,
                            color: colorPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    }

    return WillPopScope(
      onWillPop: () {
        player.play('frosting_cleared2.wav');
        return dialogue();
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(
              'assets/branding/logo.png',
              fit: BoxFit.scaleDown,
              width: 180,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorPrimary,
        ),
        body: Consumer<BottomNavigationBarProvider>(
          builder: (context, indexProvider, widget) => bodyOptions[indexProvider.currentIndex],
        ),
        bottomNavigationBar: Container(
          child: SizedBox(
            height: 77,
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: iconHeight,
                        child: IconButton(
                          icon: Image.asset(
                            "assets/navBarIcons/navBarIcon1.png",
                          ),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      label: "Home"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: iconHeight,
                        child: IconButton(
                          icon: Image.asset("assets/navBarIcons/navBarIcon2.png"),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      label: "Account"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: iconHeight,
                        child: IconButton(
                          icon: Image.asset("assets/navBarIcons/navBarIcon3.png"),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      label: "Lucky\nDraw"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: iconHeight,
                        child: IconButton(
                          icon: Image.asset("assets/navBarIcons/navBarIcon4.png"),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      label: "Mini\nGames"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: iconHeight,
                        child: IconButton(
                          icon: Image.asset("assets/navBarIcons/navBarIcon5.png"),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      label: "Token\nRedemption"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: iconHeight,
                        child: IconButton(
                          icon: Image.asset("assets/navBarIcons/navBarIcon6.png"),
                          onPressed: null,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      label: "FAQ"),
                ],
                onTap: (index) {
                  onItemTapped(index, provider);
                },
                showUnselectedLabels: true,
                showSelectedLabels: true,
                selectedLabelStyle: navBarSelectedLabelStyle,
                unselectedLabelStyle: navBarUnSelectedLabelStyle,
                selectedItemColor: colorPrimary,
                unselectedItemColor: grey,
                enableFeedback: true,
                type: BottomNavigationBarType.fixed,
                currentIndex: provider.currentIndex,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget homePageScrollViewWithTopContainer(child, height) {
  return SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Stack(
      children: [
        Column(children: [
          Container(
            height: 75,
            color: colorPrimary,
          ),
          Container(
              height: height - 75 - 65 - 80,
              color: bgColor,
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: 58, bottom: 20, left: columnPadding, right: columnPadding),
                  child: child)),
        ]),

        // top coins container
        topCoinsWidget()
      ],
    ),
  );
}
