import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/helper/NavigatorFunction.dart';
import 'package:flutter_firebase/repo/FirebaseClass.dart';
import 'package:flutter_firebase/screens/auth/ScreenLogin.dart';
import 'package:flutter_firebase/screens/main/ScreenMain.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

/// This MyHomePage class basically used to show splash screen
/// in this class we simply check the used is logged or not if he logged in then we simply navigate him in inner page
/// else we navigate him to the login screen
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    navigatorFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widgetText(
              'Welcome to the App, Please read following comments',
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            widgetText("1) Please allow location permission"),
            widgetText("2) Ensure your internet connection is start"),
            widgetText(
              "3) Because of this debug APK it will take some time to get OTP kindly please wait ",
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Container(
              margin: const EdgeInsets.only(left: 60, right: 60, top: 20),
              child: LinearProgressIndicator(
                color: Colors.green,
                backgroundColor: Colors.green.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// here we have created one common text widget to use the text
  Widget widgetText(String title, {TextStyle? textStyle}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  /// this is navigator function which called after 5 second we have added delay to show splash screen
  navigatorFunction() {
    Future.delayed(const Duration(seconds: 5), () {
      if (FirebaseRepository.auth.currentUser == null) {
        NavigatorRoute.navigatorWithRoutes(context, ScreenLogin());
      } else {
        NavigatorRoute.navigatorWithRoutes(context, ScreenMain());
      }
    });
  }
}
