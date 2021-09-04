import 'package:audioplayers/audioplayers.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/constants.dart';
import 'package:flutter/material.dart';

class FilledRedButton extends StatelessWidget {
   FilledRedButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;
  final String text;
  final Function onPressed;
  final AudioCache player =  AudioCache(
    respectSilence: true,
    duckAudio: false,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height / 18,
      // width: width / 1.5,
      // decoration: BoxDecoration(
      //   color: colorPrimary,
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: colorSecondary, width: 2),
      // ),
      child: MaterialButton(
        minWidth: width / 1.3,
        height: height / 15,
        onPressed: () {
          player.play(tapSweepSoundAsset);
          onPressed();
        },
        color: colorPrimary,
        elevation: 0,
        splashColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            color: primaryTextColor,
          ),
        ),
      ),
    );
  }
}
