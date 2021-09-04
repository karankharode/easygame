import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

class NeuMorphicContainer extends StatelessWidget {
  const NeuMorphicContainer({
    Key key,
    @required this.bevel,
    @required this.blurOffset,
    this.child,
    this.onPressed,
    this.color,
  }) : super(key: key);

  final double bevel;
  final Color color;
  final Offset blurOffset;
  final Widget child;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
            color.mix(shadowColor, 0.3),
            color,
            color,
            color.mix(shadowColor, .1),
          ], stops: [
            0.0,
            .3,
            .6,
            1.0,
          ]),
          boxShadow: [
            BoxShadow(
              blurRadius: bevel,
              offset: -blurOffset,
              color: bgColor.mix(Colors.white60, .2),
            ),
            BoxShadow(
              blurRadius: bevel,
              offset: blurOffset,
              color: bgColor.mix(shadowColor, .4),
            )
          ],
        ),
        child: child);
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}
