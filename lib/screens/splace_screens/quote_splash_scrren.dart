import 'package:flutter/material.dart';
import 'package:quote_app/screens/home_screen/page/home_screen.dart';

class QuoteSplashscreen extends StatefulWidget {
  const QuoteSplashscreen({Key? key}) : super(key: key);

  @override
  State<QuoteSplashscreen> createState() => _QuoteSplashscreenState();
}

class _QuoteSplashscreenState extends State<QuoteSplashscreen> {
  initTime() async {
    await Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "This is a random Quote provided by API. All random Quotes display here",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
