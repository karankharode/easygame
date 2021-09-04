import 'package:flutter/material.dart';

Color getBalBorderColor(int index) {
  switch (index) {
    case 0:
      return Color(0xffFFD807);
      break;
    case 1:
      return Color(0xff82AF00);
      break;
    case 2:
      return Color(0xff6B82FF);
      break;
    case 3:
      return Color(0xff364495);
      break;
    case 4:
      return Color(0xff484021);
      break;
    case 5:
      return Color(0xffB32DBF);
      break;
    default:
      return Color(0xffFFD807);
  }
}
