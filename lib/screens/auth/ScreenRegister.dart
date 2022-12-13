import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/WidgetButton.dart';
import 'package:flutter_firebase/widgets/WidgetTextField.dart';

class ScreenRegister extends StatefulWidget {
  @override
  _ScreenRegisterState createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerDistrict = TextEditingController();
  TextEditingController controllerState = TextEditingController();
  TextEditingController controllerCountry = TextEditingController();
  TextEditingController controllerPinCode = TextEditingController();

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
                controller: controller,
                hintText: "Please enter first name",
                enumValidator: EnumValidator.text,
                onChanged: (v) {
                  setState(() {});
                },
              ),
            ),
            widgetMargin(
              WidgetTextFormField(
                modelTextField:
                    ModelTextField(isCompulsory: true, title: "Last Name"),
                controller: controller,
                hintText: "Please enter last name",
                enumValidator: EnumValidator.text,
                onChanged: (v) {
                  setState(() {});
                },
              ),
            ),
            widgetMargin(
              WidgetTextFormField(
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
            widgetMargin(
              WidgetTextFormField(
                modelTextField:
                    ModelTextField(isCompulsory: true, title: "Address"),
                controller: controller,
                hintText: "Please enter Address",
                enumValidator: EnumValidator.text,
                onChanged: (v) {
                  setState(() {});
                },
              ),
            ),
            widgetMargin(Row(
              children: [
                Expanded(
                  child: WidgetTextFormField(
                    modelTextField:
                        ModelTextField(isCompulsory: true, title: "City"),
                    controller: controller,
                    hintText: "Please enter City",
                    enumValidator: EnumValidator.text,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  width: 5,
                ),
                Expanded(
                  child: WidgetTextFormField(
                    modelTextField:
                        ModelTextField(isCompulsory: true, title: "District"),
                    controller: controller,
                    hintText: "Please enter District",
                    enumValidator: EnumValidator.text,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                )
              ],
            )),
            widgetMargin(Row(
              children: [
                Expanded(
                  child: WidgetTextFormField(
                    modelTextField:
                        ModelTextField(isCompulsory: true, title: "State"),
                    controller: controller,
                    hintText: "Please enter State",
                    enumValidator: EnumValidator.text,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  width: 5,
                ),
                Expanded(
                  child: WidgetTextFormField(
                    modelTextField:
                        ModelTextField(isCompulsory: true, title: "Country"),
                    controller: controller,
                    hintText: "Please enter Country",
                    enumValidator: EnumValidator.text,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                )
              ],
            )),
            widgetMargin(WidgetTextFormField(
              modelTextField:
                  ModelTextField(isCompulsory: true, title: "PinCode"),
              controller: controller,
              hintText: "Please enter PinCode",
              enumValidator: EnumValidator.text,
              onChanged: (v) {
                setState(() {});
              },
            )),
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
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: [
                TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500))
              ])),
        ),
      ),
    );
  }

  Widget widgetMargin(Widget child) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20), child: child);
  }
}
