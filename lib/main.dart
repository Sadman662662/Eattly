import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import './FirstView.dart';
import './emailSIgn/SignInWIthEmailPage.dart';
import './pages/HomePage.dart';
import './pages/SplashScreen.dart';
import './pages/UploadPage.dart';
import './pages/add_recipe_screen.dart';
import './pages/create_meal_plan_screen.dart';
import './pages/meal_planner_screen.dart';
import './pages/recipe_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool isPro = false;

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup('mhUwTBIkUeraDKCvajFvdKiVNLmSGIGz');

    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      print(purchaserInfo.toString());

      if (purchaserInfo.entitlements.all['premium'] != null) {
        isPro = purchaserInfo.entitlements.all['premium'].isActive;
      } else {
        isPro = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }

    print('#### is user pro? $isPro');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eattly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        primarySwatch: Colors.green,
        accentColor: Colors.white,
        cardColor: Color(0xFF1B5E20),
        fontFamily: 'Montserrat',
        primaryColor: Color(0xFF1F6B00),
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/signUp': (BuildContext context) => HomePage(),
        '/signIn': (BuildContext context) => HomePage(),
        '/home': (BuildContext context) => FirstView(),
        '/email': (BuildContext context) => SignInWithEmailAndPass(),
        AddRecipeScreen.routeName: (BuildContext context) => AddRecipeScreen(),
        '/upload-page': (BuildContext context) => UploadPage(),
        RecipeDetailScreen.routeName: (BuildContext context) =>
            RecipeDetailScreen(),
        MealPlannerScreen.routeName: (BuildContext context) =>
            MealPlannerScreen(),
        CreateMealPlanScreen.routeName: (BuildContext context) =>
            CreateMealPlanScreen()
      },
    );
  }
}
