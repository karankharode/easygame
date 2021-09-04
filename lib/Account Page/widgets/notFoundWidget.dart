import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class notFoundWidget extends StatelessWidget {
  const notFoundWidget({
    @required this.height,
    @required this.text,
  });

  final double height;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Lottie.asset('assets/animations/error.json', height: 100, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
