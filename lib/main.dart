import 'package:easygame/common/providers/coinsAndTokenProvider.dart';
import 'package:easygame/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'HomePage/controllers/providers/BottomNavBarProvider.dart';
import 'SplashScreen/screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // await Permission.storage.request();
  // var dir = await getApplicationDocumentsDirectory();
  var defaultHome;
  // bool initialised = false;
  // Hive..init(dir.path);

  // var box = await Hive.openBox('firstOpen');

  // initialised = await box.get('initialised', defaultValue: false);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // if (initialised) {
  //   defaultHome = Authservice().handleAuth();
  // } else {
    defaultHome = SplashScreen();
  // }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BottomNavigationBarProvider>(
          create: (context) => BottomNavigationBarProvider()),
      ChangeNotifierProvider<TopCoinTokenProvider>(create: (context) => TopCoinTokenProvider()),
    ],
    child: MyApp(startupPage: defaultHome),
  ));
  // runApp(ChangeNotifierProvider<BottomNavigationBarProvider>(
  //     create: (context) => BottomNavigationBarProvider(), child: MyApp(startupPage: defaultHome)));
}

class MyApp extends StatelessWidget {
  final Widget startupPage;

  MyApp({this.startupPage});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyGame',
      theme: ThemeData(primaryColor: colorPrimary, fontFamily: 'lato', primarySwatch: Colors.red),
      home: HomeScreen(startupPage: startupPage),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Widget startupPage;

  const HomeScreen({this.startupPage});

  @override
  Widget build(BuildContext context) {
    // return ThankYouPage();
    return startupPage;
  }
}
