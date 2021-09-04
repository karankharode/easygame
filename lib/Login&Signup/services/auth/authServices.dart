import 'package:easygame/HomePage/screens/HomePage.dart';
import 'package:easygame/Login&Signup/screens/LandingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Authservice {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LandingScreen();
          }
        });
  }
}

signOut() async {
  await FirebaseAuth.instance.signOut();
}
