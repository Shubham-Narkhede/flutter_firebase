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

class ScreenLogin extends StatefulWidget {
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isGetOtp = false;

  final key = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  TextEditingController controllerOtpField = TextEditingController();

  WidgetButtonController controllerLogin = WidgetButtonController();

  SmsUserConsent? _smsUserConsent;
  String verificationIdToken = "";

  @override
  void initState() {
    HelperFunction.getCurrentLocation();
    _smsUserConsent = SmsUserConsent(smsListener: _listenerSMS);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 40),
                child: const Text(
                  "Welcome back, Please login with your credentials",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
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
              if (isGetOtp == true)
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      inactiveColor: Colors.grey,
                      inactiveFillColor: Colors.grey,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
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
              WidgetButton(
                onPressed: controller.text.length < 10
                    ? null
                    : () {
                        if (key.currentState!.validate()) {
                          _smsUserConsent!.requestSms();
                          getOtp(controller.text.toString());
                        }
                      },
                title: controllerOtpField.text.isNotEmpty
                    ? "Verify OTP"
                    : "Get OTP",
                controller: controllerLogin,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          signIn(controller.text.toString(), verificationIdToken);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => ScreenRegister()));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: [
                TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500))
              ])),
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
