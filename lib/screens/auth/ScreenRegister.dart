import 'package:flutter/material.dart';
import 'package:flutter_firebase/repo/FirebaseClass.dart';
import 'package:flutter_firebase/widgets/WidgetButton.dart';
import 'package:flutter_firebase/widgets/WidgetTextField.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helper/HelperFunction.dart';
import '../../helper/NavigatorFunction.dart';
import '../../model/ModelUser.dart';
import '../main/ScreenMain.dart';

class ScreenRegister extends StatefulWidget {
  String mobileNumber;

  ScreenRegister({required this.mobileNumber});
  @override
  _ScreenRegisterState createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final key = GlobalKey<FormState>();

  TextEditingController controllerMobileNumber = TextEditingController();
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerDistrict = TextEditingController();
  TextEditingController controllerState = TextEditingController();
  TextEditingController controllerCountry = TextEditingController();
  TextEditingController controllerPinCode = TextEditingController();

  WidgetButtonController controllerSubmit = WidgetButtonController();

  ModelAddress? addressData;

  @override
  void initState() {
    super.initState();

    /// here we get mobile number from the constructor and we simply set this mobile number on the text field
    controllerMobileNumber.text = widget.mobileNumber;
    getCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.green,
            Colors.green.shade200,
          ],
        )),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 40),
                        child: const Text(
                          "Create an Account, it's free",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: widgetMargin(
                              WidgetTextFormField(
                                modelTextField: ModelTextField(
                                    isCompulsory: true, title: "First Name"),
                                controller: controllerFirstName,
                                hintText: "Please enter first name",
                                enumValidator: EnumValidator.text,
                              ),
                            ),
                          ),
                          widgetMargin(
                            WidgetTextFormField(
                              modelTextField: ModelTextField(
                                  isCompulsory: true, title: "Last Name"),
                              controller: controllerLastName,
                              hintText: "Please enter last name",
                              enumValidator: EnumValidator.text,
                            ),
                          ),
                          widgetMargin(
                            WidgetTextFormField(
                              modelTextField: ModelTextField(
                                  isCompulsory: true,
                                  title: "Mobile Number",
                                  isEnable: false),
                              controller: controllerMobileNumber,
                              enumTextInputType: EnumTextInputType.mobile,
                              hintText: "Please enter mobile number",
                              enumValidator: EnumValidator.mobile,
                            ),
                          ),
                          widgetMargin(
                            WidgetTextFormField(
                              modelTextField: ModelTextField(
                                title: "Address",
                                isCompulsory: true,
                              ),
                              controller: controllerAddress,
                              hintText: "Please enter Address",
                              enumValidator: EnumValidator.text,
                            ),
                          ),
                          widgetMargin(
                            WidgetTextFormField(
                              modelTextField: ModelTextField(
                                title: "City",
                                isCompulsory: true,
                              ),
                              controller: controllerCity,
                              hintText: "Please enter City",
                              enumValidator: EnumValidator.text,
                            ),
                          ),
                          widgetMargin(Row(
                            children: [
                              Expanded(
                                child: WidgetTextFormField(
                                  modelTextField: ModelTextField(
                                    title: "State",
                                    isCompulsory: true,
                                  ),
                                  controller: controllerState,
                                  hintText: "Please enter State",
                                  enumValidator: EnumValidator.text,
                                ),
                              ),
                              Container(
                                width: 5,
                              ),
                              Expanded(
                                child: WidgetTextFormField(
                                  modelTextField: ModelTextField(
                                    title: "Country",
                                    isCompulsory: true,
                                  ),
                                  controller: controllerCountry,
                                  hintText: "Please enter Country",
                                  enumValidator: EnumValidator.text,
                                ),
                              )
                            ],
                          )),
                          widgetMargin(WidgetTextFormField(
                            modelTextField: ModelTextField(
                              title: "PinCode",
                              isCompulsory: true,
                            ),
                            controller: controllerPinCode,
                            hintText: "Please enter PinCode",
                            enumValidator: EnumValidator.text,
                            bottomMargin: 30,
                          )),
                          WidgetButton(
                            controller: controllerSubmit,
                            onPressed: () async {
                              // here we have check first that if he added permission of not if he not address permission then we ask permission
                              if (await Permission.location.isGranted) {
                                // if he added permissio but till yet we did not get address then we show error message
                                if (addressData == null) {
                                  HelperFunction.errorToast(
                                      "Please wait we are getting your location",
                                      context);
                                } else {
                                  // else we update the user
                                  if (key.currentState!.validate()) {
                                    updateUser();
                                  }
                                }
                              } else {
                                getCurrentAddress();
                              }
                            },
                            title: "Submit",
                            color: Colors.green,
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetMargin(Widget child) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20), child: child);
  }

  // here this method is created for get the current address on the basis of latitude and longitude
  getCurrentAddress() {
    HelperFunction.getCurrentLocation().then((value) {
      HelperFunction.getAddress(value.latitude, value.longitude).then((data) {
        setState(() {
          // we simply set the location data on the text field
          controllerAddress.text =
              "${data.first.name}-${data.first.subLocality}";
          controllerState.text = "${data.first.administrativeArea}";
          controllerCountry.text = "${data.first.country}";
          controllerCity.text = "${data.first.locality}";
          controllerPinCode.text = "${data.first.postalCode}";

          addressData = ModelAddress(
              addressLine: controllerAddress.text,
              state: controllerState.text,
              country: controllerCountry.text,
              city: controllerCity.text,
              pinCode: controllerPinCode.text.toString());
        });
      });
    });
  }

  // this method is used to update the user which loging
  // if user is new and he logging then we simply update his profile
  updateUser() {
    controllerSubmit.loading!();
    FirebaseRepository.updateLoggedInUser(ModelUser(
            address: addressData!,
            firstName: controllerFirstName.text.toString(),
            lastName: controllerLastName.text.toString(),
            mobileNumber: controllerMobileNumber.text.toString()))
        .then((value) {
      controllerSubmit.reset!();

      NavigatorRoute.navigatorWithRoutes(context, ScreenMain());
    }).catchError((onError) {
      controllerSubmit.error!();
      controllerSubmit.reset!();

      HelperFunction.errorToast(onError.toString(), context);
    });
  }
}
