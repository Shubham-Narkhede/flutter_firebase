import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HelperFunction {
  static successToast(var message, BuildContext context) {
    return Flushbar(
      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      borderRadius: BorderRadius.circular(7),
      message: message,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      titleColor: Colors.white,
      messageColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  static errorToast(var message, BuildContext context, {int second = 2}) {
    return Flushbar(
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      borderRadius: BorderRadius.circular(7),
      message: message,
      duration: Duration(seconds: second),
      backgroundColor: Colors.red,
      titleColor: Colors.white,
      messageColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<List<Placemark>> getAddress(
      double latitude, double longitude) async {
    return await placemarkFromCoordinates(latitude, longitude);
  }
}
