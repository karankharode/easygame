import 'package:flutter/material.dart';

Widget loader(height) {
  return Container(height: height / 2, child: Center(child: CircularProgressIndicator()));
}
