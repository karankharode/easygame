import 'package:auto_size_text/auto_size_text.dart';
import 'package:easygame/Login&Signup/services/auth/authServices.dart';
import 'package:easygame/common/widgets/filledRedButton.dart';
import 'package:easygame/SplashScreen/screens/PlaySplashVideo.dart';
import 'package:easygame/common/Routing/commonRouter.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double height, width;

  VideoPlayerController _controller;
  VideoPlayerController _secondController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/introVideo1.mp4',
    );
    _secondController = VideoPlayerController.asset(
      'assets/videos/introVideo.mp4',
    );
    _controller.initialize().then((value) {
      _controller.play();
    });
    _secondController.initialize();
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _controller.pause();

        setState(() {
          _controller = _secondController;
        });
        _controller.setLooping(true);
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _secondController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Column(children: [
              Container(
                color: colorPrimary,
                height: 18,
                width: double.infinity,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context, commonRouter(PlaySplashVideo(_controller.value.position)))
                        .then((value) {
                      _controller.seekTo(value);
                      _controller.play();
                    });
                  },
                  child:
                      //   Container(
                      //       height: height / 2.8 + 45,

                      //       child: ),

                      AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(
                      _controller,
                    ),
                  )
                  // Image.asset(
                  //   'assets/images/luckyDraw.png',
                  //   height: height / 2.8 + 45,
                  //   fit: BoxFit.cover,
                  // ),
                  ),
              Container(
                  height: (height) - 75 - 65 - 80,
                  color: bgColor,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 112, bottom: 10, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FREE -TO - PLAY\n',
                                  style: splashGreyExpandedStyle,
                                ),
                                Text(
                                  'ANYONE CAN PLAY',
                                  style: greyH2SplashSpacedStyle,
                                ),
                                Text(
                                  'ANYWHERE CAN PLAY',
                                  style: greyH2SplashSpacedStyle,
                                ),
                                Text(
                                  'THERE IS NO LOSER',
                                  style: greyH2SplashSpacedStyle,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Image.asset(
                                'assets/images/matchToWin.png',
                                height: 140,
                                // width: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ]),

            // win great prizes
            Padding(
              padding: EdgeInsets.only(top: width * (9 / 16) - 15),
              child: Container(
                height: 110,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: shadowColor, offset: Offset(0, 4), spreadRadius: 0.8, blurRadius: 10)
                ], color: bgColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AutoSizeText(
                          'Win Great Prizes',
                          maxLines: 1,
                          style: redSplashHeadingStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AutoSizeText(
                          'And Cash for Free Today !',
                          maxLines: 1,
                          style: splashHeadingStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: height - 150,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: FilledRedButton(
                      width: width,
                      height: height,
                      text: "Get Started",
                      onPressed: () {
                        // var box = Hive.box('firstOpen');
                        // box.put('initialised', true).then((value) =>
                        //     Navigator.pushReplacement(
                        //         context, commonRouter(Authservice().handleAuth()))

                        //         );

                        Navigator.pushReplacement(
                            context, commonRouter(Authservice().handleAuth()));
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
