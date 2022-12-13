import 'package:flutter/material.dart';

class NavigatorRoute {
  static navigatorWithRoutes(BuildContext context, Widget child) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => child), (route) => false);
  }
}
