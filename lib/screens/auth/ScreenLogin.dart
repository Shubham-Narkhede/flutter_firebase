import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/auth/ScreenRegister.dart';
import 'package:flutter_firebase/widgets/WidgetButton.dart';
import 'package:flutter_firebase/widgets/WidgetTextField.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

import '../../helper/HelperFunction.dart';
import '../../helper/NavigatorFunction.dart';
import '../../repo/FirebaseClass.dart';
import '../main/ScreenMain.dart';

/// ScreenLogin this class is used to do login purpose
class ScreenLogin extends StatefulWidget {
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  /// here we have created one firebase auth instance to access all firebase methods
  FirebaseAuth auth = FirebaseAuth.instance;
  // This parameter is used to check the otp is send or not
  bool isGetOtp = false;
  // This param is used to check validatioion on text field
  final key = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  TextEditingController controllerOtpField = TextEditingController();
  WidgetButtonController controllerLogin = WidgetButtonController();

  //_smsUserConsent is used to get automatically otp
  SmsUserConsent? _smsUserConsent;
  // verificationIdToken is used to store the verification token
  String verificationIdToken = "";

  @override
  void initState() {
    // here we are asking the permission
    HelperFunction.getCurrentLocation();
    // here we listen the message if any
    _smsUserConsent = SmsUserConsent(smsListener: _listenerSMS);
    super.initState();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 40),
                      child: const Text(
                        "Welcome back, Please login with your credentials",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ],
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: WidgetTextFormField(
                          modelTextField: ModelTextField(
                              isCompulsory: true, title: "Mobile Number"),
                          controller: controller,
                          enumTextInputType: EnumTextInputType.mobile,
                          hintText: "Please enter mobile number",
                          enumValidator: EnumValidator.mobile,
                          onChanged: (v) {
                            setState(() {});
                          },
                        ),
                      ),
                      // here if we called an OTp then otp text field will be enable
                      if (isGetOtp == true)
                        Container(
                          margin: const EdgeInsets.only(left: 25, right: 25),
                          child: PinCodeTextField(
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              inactiveColor: Colors.grey,
                              inactiveFillColor: Colors.grey.shade300,
                              selectedColor: Colors.green.shade300,
                              selectedFillColor: Colors.green.shade300,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            controller: controllerOtpField,
                            onCompleted: (v) {},
                            onChanged: (value) {
                              setState(() {});
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                            appContext: context,
                          ),
                        ),
                      // until user put the mobile number this button disable once he added mobile number then this button with be in use
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: WidgetButton(
                          onPressed: controller.text.length < 10
                              ? null
                              : () {
                                  /// here we simply check if OTP text filed is not empty it means if used added OTP then it will called an OTP verify method
                                  if (controllerOtpField.text.isNotEmpty) {
                                    signIn(controller.text.toString(),
                                        verificationIdToken);
                                  } else {
                                    // else it will called get otp method
                                    if (key.currentState!.validate()) {
                                      _smsUserConsent!.requestSms();
                                      getOtp(controller.text.toString());
                                    }
                                  }
                                },
                          title: controllerOtpField.text.isNotEmpty
                              ? "Verify OTP"
                              : "Get OTP",
                          controller: controllerLogin,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenerSMS() {
    // If we received message then we simply apply some regex pattern to get formatted OTP
    int otp = int.parse(
        _smsUserConsent!.receivedSms!.replaceAll(RegExp(r'[^0-9]'), ''));
    // And here we set OTP on text field
    setState(() {
      controllerOtpField.text = otp.toString().replaceAll("3619", '');
    });
    if (controllerOtpField.text.isNotEmpty) {
      signIn(controller.text.toString(), verificationIdToken);
    }
  }

  // getOtp this method is used to create for get OTP to mobile number which we have added
  getOtp(String mobileNumber) async {
    controllerLogin.loading!();
    await auth.verifyPhoneNumber(
      phoneNumber: "+91$mobileNumber",
      timeout: const Duration(seconds: 0),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        HelperFunction.errorToast(e.toString(), context);

        controllerLogin.reset!();
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verificationIdToken = verificationId;
          isGetOtp = true;
        });
        controllerLogin.success!();
        controllerLogin.reset!();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // this method is used to create for validate the otp and mobile number which user have added
  signIn(String mobileNumber, String tokenId) async {
    try {
      controllerLogin.loading!();
      FirebaseRepository.checkMobileNumberExist(mobileNumber)
          .then((DatabaseEvent value) {
        if (value.snapshot.value == null) {
          FirebaseRepository.login(tokenId, controllerOtpField.text.toString())
              .then((value) {
            addDataInFirebase(mobileNumber);
          }).catchError((onError) {
            controllerLogin.reset!();
            HelperFunction.errorToast(onError.toString(), context);
          });
        } else {
          FirebaseRepository.login(tokenId, controllerOtpField.text.toString())
              .then((value) {
            controllerLogin.reset!();

            NavigatorRoute.navigatorWithRoutes(context, ScreenMain());
          }).catchError((onError) {
            controllerLogin.reset!();
            HelperFunction.errorToast(onError.toString(), context);
          });
        }
      });

      return true;
    } catch (e) {
      HelperFunction.errorToast(e.toString(), context);
      return false;
    }
  }

  // Here we simply put down the user data once he logged in successfully
  addDataInFirebase(String mobileNumber) {
    FirebaseRepository.addDataToFirebase(mobileNumber).then((value) {
      controllerLogin.reset!();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScreenRegister(
                    mobileNumber: mobileNumber,
                  )));
    }).catchError((onError) {
      controllerLogin.reset!();
      HelperFunction.errorToast(onError.toString(), context);
    });
  }
}
