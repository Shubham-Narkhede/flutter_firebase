import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/auth/ScreenRegister.dart';
import 'package:flutter_firebase/widgets/WidgetButton.dart';
import 'package:flutter_firebase/widgets/WidgetTextField.dart';

class ScreenLogin extends StatefulWidget {
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
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
                modelTextField:
                    ModelTextField(isCompulsory: true, title: "Mobile Number"),
                controller: controller,
                enumTextInputType: EnumTextInputType.mobile,
                hintText: "Please enter mobile number",
                enumValidator: EnumValidator.mobile,
                onChanged: (v) {
                  setState(() {});
                },
              ),
            ),
            WidgetButton(
              onPressed: controller.text.length < 10 ? null : () {},
              title: "Get OTP",
              color: Colors.green,
            )
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ScreenRegister()));
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
}
