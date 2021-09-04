import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget ballSpinnerLuckyDraw() {
  return Center(
    child:
        Lottie.asset('assets/animations/luckyDraw.json', height: 250, animate: true, repeat: true,),
  );
}
