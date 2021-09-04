import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

Color getStatusDarkColor(int status) {
  switch (status) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.green;
      break;
    default:
      return Colors.red;
  }
}

Color getStatusLightColor(int status) {
  switch (status) {
    case 0:
      return Colors.red[100];
    case 1:
      return Colors.orange[100];
    case 2:
      return Colors.green[100];
      break;
    default:
      return Colors.red[100];
  }
}

String getStatusText(int status) {
  switch (status) {
    case 0:
      return 'Processing';
    case 1:
      return 'Verifying';
    case 2:
      return 'Paid';
      break;
    default:
      return 'Processing';
  }
}

IconData getIcon(String item) {
  switch (item) {
    case 'str':
      return Icons.star_border_outlined;
    case 'sqr':
      return Icons.add_box;
    case 'lbl':
      return Icons.bookmark_border_rounded;
      break;
    case 'pls':
      return Icons.add_box_outlined;
      break;
    default:
      return Icons.star_border;
  }
}

Widget getStatus(int status) {
  Color colorDark = getStatusDarkColor(status);
  Color colorLight = getStatusLightColor(status);
  String statusText = getStatusText(status);

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
    child: Container(
        width: 100,
        height: 27,
        decoration: BoxDecoration(
            color: colorLight.withOpacity(0.5),
            border: Border.all(
              color: colorDark,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            statusText,
            style: TextStyle(
              color: colorDark,
              fontFamily: 'Gotham',
            ),
          ),
        )),
  );
}

Widget getItems(String item) {
  IconData icon = getIcon(item);

  return Center(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 25,
          color: colorPrimary,
        )),
  );
}
