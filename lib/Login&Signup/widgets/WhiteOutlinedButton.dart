import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

class WhiteOutlinedButton extends StatelessWidget {
  const WhiteOutlinedButton({
    Key key,
    @required this.height,
    @required this.width,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final double height;
  final double width;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 18, 0, 10),
      padding: EdgeInsets.only(top: 0, left: 0),
      height: height / 15,
      width: width / 1.3,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorPrimary, width: 2)),
      child: MaterialButton(
        minWidth: width / 1.3,
        height: height / 15,
        onPressed: onPressed,
        color: bgColor,
        elevation: 0,
        splashColor: colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            // fontWeight: FontWeight.w400,
            fontSize: 17,
            color: colorPrimary,
          ),
        ),
      ),
    );
  }
}
