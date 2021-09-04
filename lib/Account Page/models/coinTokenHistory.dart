import 'package:flutter/material.dart';

class CoinTokenHistory {
  final String date;
  final String time;
  final String qty;
  final String balance;
  final int type;

  CoinTokenHistory(
      {
        @required this.date,
      @required this.time,
      @required this.qty,
      @required this.type,
      @required this.balance});
}
