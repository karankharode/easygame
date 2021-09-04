import 'package:easygame/common/providers/coinsAndTokenProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

void updateCoinsAndTokens(context) async {
  FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(FirebaseAuth.instance.currentUser.uid.toString())
      .child('Wallet')
      .once()
      .then((value) {
    var coinsAndTokenprovider = Provider.of<TopCoinTokenProvider>(context, listen: false);
    try {
      coinsAndTokenprovider.currentCoins = value.value['coins'];
      coinsAndTokenprovider.currentTokens = value.value['tokens'];
    } catch (e) {
      coinsAndTokenprovider.currentCoins = 0;
      coinsAndTokenprovider.currentTokens = 0;
    }
  });
}
