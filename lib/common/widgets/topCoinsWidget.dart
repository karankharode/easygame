import 'package:easygame/common/providers/coinsAndTokenProvider.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class topCoinsWidget extends StatelessWidget {
  const topCoinsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Container(
        height: 90,
        margin: EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: shadowColor, offset: Offset(0, 4), spreadRadius: 0.8, blurRadius: 10)
        ], color: bgColor, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Consumer<TopCoinTokenProvider>(
            builder: (context, coinsAndTokens, widget) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/icons/coin.png',
                        height: 28,
                        width: 28,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                          child: Text(
                            'Coins',
                          ),
                        ),
                        Text(
                          coinsAndTokens.coins.toString(),
                          style: redTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/icons/token.png',
                        height: 28,
                        width: 28,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                          child: Text(
                            'Tokens',
                          ),
                        ),
                        Text(
                          coinsAndTokens.tokens.toString(),
                          style: redTextStyle,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
