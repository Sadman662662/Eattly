import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './HomePage.dart';
import '../FirstView.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences preferences;
  bool isFirstTime;

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp();
    setTimer();
  }

  setTimer() async {
    Duration _duration = Duration(seconds: 3);
    return Timer(_duration, _navigateUser);
  }

  void _navigateUser() async {
    preferences = await SharedPreferences.getInstance();
    isFirstTime = preferences.getBool("isFirstTime") ?? true;

    if (isFirstTime) {
      preferences.setBool("isFirstTime", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstView(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Center(
      child: Container(
        color: Color(0xFF206B00),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset("assets/splash_screen.png"),
          ),
        ),
      ),
    );
  }
}
