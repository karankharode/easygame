import 'package:flutter/material.dart';

class TopCoinTokenProvider with ChangeNotifier {
  int coins = 0;
  int tokens = 0;

  get currentCoins => coins;
  get currentTokens => tokens;

  set currentCoins(int setCoins) {
    coins = setCoins;
    notifyListeners();
  }

  set currentTokens(int setTokens) {
    tokens = setTokens;
    notifyListeners();
  }
}
