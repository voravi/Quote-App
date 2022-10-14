import 'package:flutter/cupertino.dart';
import 'package:quote_app/screens/home_screen/like_screen.dart';
import 'package:quote_app/screens/splace_screens/quote_splash_scrren.dart';
import 'package:quote_app/screens/splace_screens/screen1.dart';
import 'package:quote_app/screens/splace_screens/screen2.dart';
import 'package:quote_app/screens/splace_screens/screen3.dart';
import 'package:quote_app/screens/splace_screens/screen4.dart';


import '../screens/home_screen/page/home_screen.dart';
import 'appRoutes.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes().homePage: (context) => const HomePage(),
  AppRoutes().splash1: (context) => const SplashScreen1(),
  AppRoutes().splash2: (context) => const SplashScreen2(),
  AppRoutes().splash3: (context) => const SplashScreen3(),
  AppRoutes().splash4: (context) => const SplashScreen4(),
  AppRoutes().quoteSplashscreen: (context) => const QuoteSplashscreen(),
  AppRoutes().likeScreen: (context) => const LikeScreen(),
};
