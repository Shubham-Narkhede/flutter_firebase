import 'package:flutter/material.dart';
import 'package:flutter_firebase/helper/HelperFunction.dart';
import 'package:flutter_firebase/helper/NavigatorFunction.dart';
import 'package:flutter_firebase/repo/FirebaseClass.dart';
import 'package:flutter_firebase/screens/auth/ScreenLogin.dart';
import 'package:flutter_firebase/widgets/WidgetButton.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  ModelUser? user;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: user == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hey,Welcome! ${user!.firstName}${user!.lastName}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Mobile Number : ${user!.mobileNumber}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    child: Text(
                      "Address : ${user!.address.addressLine}, ${user!.address.city}, ${user!.address.state}, ${user!.address.country}, ${user!.address.pinCode}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  WidgetButton(
                    onPressed: () {
                      FirebaseRepository.auth.signOut().then((value) {
                        NavigatorRoute.navigatorWithRoutes(
                            context, ScreenLogin());
                      }).catchError((onError) {
                        HelperFunction.errorToast(onError.toString(), context);
                      });
                    },
                    title: "Logout",
                  )
                ],
              ),
      ),
    );
  }

  getUserData() {
    FirebaseRepository.getLoggedInUserData().then((valueData) {
      dynamic data = valueData.value;
      setState(() {
        user = ModelUser(
            mobileNumber: data['mobileNumber'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            address: ModelAddress(
                addressLine: data['addressLine'],
                city: data['city'],
                state: data['state'],
                pinCode: data['pincode'].toString(),
                country: data['country']));
      });
    }).catchError((onError) {
      HelperFunction.errorToast(onError.toString(), context);
    });
  }
}
