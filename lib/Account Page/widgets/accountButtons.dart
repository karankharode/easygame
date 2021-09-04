import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.onPressed,
    this.color,
    this.textColor,
  }) : super(key: key);

  final double width;
  final double height;
  final String text;
  final Color color;
  final Color textColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height / 18,
      // width: width / 1.5,
      decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 3, spreadRadius: 1, offset: Offset(1, 1))
          ]),
      child: MaterialButton(
        // minWidth: width / 1.3,
        height: height / 15,
        onPressed: onPressed,
        color: this.color,
        elevation: 0,
        splashColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            color: this.textColor,
          ),
        ),
      ),
    );
  }
}
