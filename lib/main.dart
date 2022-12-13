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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  int start = 5;

  @override
  void initState() {
    super.initState();
    navigatorFunction();
    startTimer();
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
            widgetText("1). Please allow location permission"),
            widgetText("2). Ensure your internet connection is start"),
            widgetText(
              "$start",
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

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

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

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
