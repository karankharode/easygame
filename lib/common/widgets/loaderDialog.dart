import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showLoaderDialog(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
              child:
                  Lottie.asset('assets/animations/hourGlassLoader.json', height: 100, width: 100)),
        );
      });
}
