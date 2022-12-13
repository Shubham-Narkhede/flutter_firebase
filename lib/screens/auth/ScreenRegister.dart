import 'package:flutter/material.dart';
import 'package:flutter_firebase/repo/FirebaseClass.dart';
import 'package:flutter_firebase/widgets/WidgetButton.dart';
import 'package:flutter_firebase/widgets/WidgetTextField.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helper/HelperFunction.dart';
import '../../helper/NavigatorFunction.dart';
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
    controllerMobileNumber.text = widget.mobileNumber;
    getCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 40),
                  child: const Text(
                    "Create an Account, it's free",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                widgetMargin(
                  WidgetTextFormField(
                    modelTextField:
                        ModelTextField(isCompulsory: true, title: "First Name"),
                    controller: controllerFirstName,
                    hintText: "Please enter first name",
                    enumValidator: EnumValidator.text,
                  ),
                ),
                widgetMargin(
                  WidgetTextFormField(
                    modelTextField:
                        ModelTextField(isCompulsory: true, title: "Last Name"),
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
                    modelTextField: ModelTextField(title: "Address"),
                    controller: controllerAddress,
                    hintText: "Please enter Address",
                    enumValidator: EnumValidator.text,
                  ),
                ),
                widgetMargin(
                  WidgetTextFormField(
                    modelTextField: ModelTextField(title: "City"),
                    controller: controllerCity,
                    hintText: "Please enter City",
                    enumValidator: EnumValidator.text,
                  ),
                ),
                widgetMargin(Row(
                  children: [
                    Expanded(
                      child: WidgetTextFormField(
                        modelTextField: ModelTextField(title: "State"),
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
                        modelTextField: ModelTextField(title: "Country"),
                        controller: controllerCountry,
                        hintText: "Please enter Country",
                        enumValidator: EnumValidator.text,
                      ),
                    )
                  ],
                )),
                widgetMargin(WidgetTextFormField(
                  modelTextField: ModelTextField(title: "PinCode"),
                  controller: controllerPinCode,
                  hintText: "Please enter PinCode",
                  enumValidator: EnumValidator.text,
                )),
                WidgetButton(
                  controller: controllerSubmit,
                  onPressed: () async {
                    if (await Permission.location.isGranted) {
                      if (key.currentState!.validate()) {
                        updateUser();
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
        ),
      ),
    );
  }

  Widget widgetMargin(Widget child) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20), child: child);
  }

  getCurrentAddress() {
    HelperFunction.getCurrentLocation().then((value) {
      HelperFunction.getAddress(value.latitude, value.longitude).then((data) {
        setState(() {
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
