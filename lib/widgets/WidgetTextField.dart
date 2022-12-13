import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'WidgetButton.dart';

class ModelDropdownItems {
  String? id;
  String? name;
  String? extraValue;
  List<ModelDropdownItems>? list;

  ModelDropdownItems(
      {required this.id, required this.name, this.extraValue, this.list});
}

enum EnumTextFieldTitle { sideTitle, topTitle }

enum EnumTextField {
  none,
  datePicker,
  dropdown,
  verified,
  unverified,
}

enum EnumTextInputType {
  mobile,
  email,
  capitalLettersWithDigitsNoSpecialChars, //eg:ifsc
  onlyDigits, //eg:bank account no
  capitalLettersWithDigitsWithSpecialChars,
  onlyLetters, //eg:bank name
  panCardNumber,
  digitsWithDecimal,
  birthDate
}

enum EnumValidator {
  mobile,
  email,
  ifsc,
  adhar,
  text,
  panCard,
  passport,
  voterId,
  gstNumber,
  bankAccountNo,
  pincode,
  vehicleNo,
  upiId
}

class ModelTextField {
  String? title;
  EnumTextFieldTitle? enumTextFieldTitle;
  bool? isCompulsory, isEnable;

  ModelTextField({
    this.title,
    this.enumTextFieldTitle = EnumTextFieldTitle.topTitle,
    this.isCompulsory = false,
    this.isEnable = true,
  });
}

class ModelAttachments {
  String? id;
  String? localPath;
  String? serverPath;
  String? mediaType;
  String? serverId;

  bool? isEncrypted;
  ModelAttachments(
      {this.id,
      this.localPath,
      this.serverPath,
      this.mediaType,
      this.serverId,
      this.isEncrypted});
}

class ModelTextFieldAttachment {
  final Function(List<ModelAttachments>)? getAllAttachments;
  final List<ModelAttachments>? listAttachments;
  final int? maxCount;

  ModelTextFieldAttachment(
      {this.maxCount, this.getAllAttachments, this.listAttachments});
}

class WidgetTextFormField extends StatefulWidget {
  EnumTextField? eNum;
  final EnumTextInputType? enumTextInputType;
  final EnumValidator? enumValidator;
  final List<ModelDropdownItems>? dropdownList;
  final EnumWidgetSize? size;
  String? heleperText, suffixText, hintText, dropDownPreSelectedId, errorText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines; // should be always less than maxLines

  final Color? fillColor;
  final Color? borderColor;

  final bool? isLoading; //isCompulsory
  final bool? obscureText;
  final DateTime? initialDate, firstDate;
  final Widget? frontIconDynamic, backIconDynamic;

  final TextEditingController controller;

  final Function(DateTime)? selectedDate;
  final Function(DateTimeRange)? selectedDateRage;

  final Function(String)? onChanged;
  final Function(String)? onSearch;

  final Function(String)? validator;
  final Function(ModelDropdownItems)? selctedListItem;

  final Function? onDelete;
  final VoidCallback? onEditingComplete;
  final Function? onEdit;

  final Function? clear;
  final Function? onTap;

  final TextStyle? errorStyle;

  final double? bottomMargin;
  final ModelTextField? modelTextField;
  final ModelTextFieldAttachment? modelTextFieldAttachment;

  final TextStyle? suffixTextStyle;
  TextAlign? textAlign;

  WidgetTextFormField(
      {Key? key,
      required this.controller,
      this.enumTextInputType,
      this.eNum,
      this.enumValidator,
      this.dropdownList,
      this.dropDownPreSelectedId,
      this.heleperText,
      this.hintText,
      this.suffixText,
      this.errorText,
      this.maxLength,
      this.fillColor,
      this.borderColor,
      this.isLoading,
      this.frontIconDynamic,
      this.backIconDynamic,
      this.validator,
      this.selectedDate,
      this.selectedDateRage,
      this.onChanged,
      this.selctedListItem,
      this.onDelete,
      this.clear,
      this.onEdit,
      this.onTap,
      this.onSearch,
      this.errorStyle,
      this.bottomMargin,
      this.initialDate,
      this.size,
      this.maxLines = 1,
      this.minLines,
      this.modelTextField,
      this.modelTextFieldAttachment,
      this.onEditingComplete,
      this.obscureText,
      this.firstDate,
      this.suffixTextStyle,
      this.textAlign});

  @override
  _WidgetTextFormFieldState createState() => _WidgetTextFormFieldState();
}

class _WidgetTextFormFieldState extends State<WidgetTextFormField> {
  bool isError = false;
  @override
  void initState() {
    super.initState();
    widget.eNum ?? EnumTextField.none;
  }

  Color iconColor = const Color(0xff656565);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.modelTextField?.enumTextFieldTitle ==
            EnumTextFieldTitle.topTitle)
          if (widget.modelTextField?.title != null)
            Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [widgetTextTitle(), widgetIsCompulsory()],
                )),
        Container(
          height: widget.size == EnumWidgetSize.sm ? 55 : null,
          padding: EdgeInsets.only(
              bottom: widget.bottomMargin != null ? widget.bottomMargin! : 15),
          child: Row(
            children: [
              if (widget.modelTextField?.enumTextFieldTitle ==
                  EnumTextFieldTitle.sideTitle)
                if (widget.modelTextField?.title != null)
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 7),
                            child: widgetTextTitle(),
                          ),
                        ),
                        widgetIsCompulsory()
                      ],
                    ),
                  ),
              Flexible(flex: 4, child: widgetTextField()),
            ],
          ),
        )
      ],
    );
  }

  Widget widgetTextTitle() {
    return Text(
      widget.modelTextField!.title!,
      maxLines: 3,
      style: TextStyle(
          fontSize: () {
            switch (widget.size) {
              case EnumWidgetSize.sm:
                return 14.0;
              case EnumWidgetSize.md:
                return 16.0;
              case EnumWidgetSize.lr:
                return 18.0;
              default:
                return 16.0;
            }
          }(),
          fontWeight: FontWeight.w500),
    );
  }

  Widget widgetIsCompulsory() {
    return Visibility(
        visible: widget.modelTextField?.isCompulsory == true &&
            widget.modelTextField!.title!.isNotEmpty,
        child: const Text(
          '*',
          style: TextStyle(color: Colors.red),
        ));
  }

  Widget widgetTextField() {
    return Row(
      children: [
        // if (widget.modelTextFieldAttachment?.getAllAttachments != null &&
        //     widget.modelTextFieldAttachment?.listAttachments != null)
        //   PackagePinAttachment(
        //     maxCount: widget.modelTextFieldAttachment!.maxCount,
        //     listAttachments: widget.modelTextFieldAttachment!.listAttachments,
        //     getAllAttachments:
        //         widget.modelTextFieldAttachment!.getAllAttachments,
        //   ),
        Expanded(
          child: TextFormField(
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            autofocus: false,
            //checking widget.eNUm==null because if we click same textfield more than once it gets assign null so
            //i am checking null condition
            readOnly: widget.eNum == EnumTextField.none || widget.eNum == null
                ? false
                : true,
            controller: widget.controller,
            obscureText: widget.obscureText ?? false,
            maxLength: widget.maxLength,
            //if custom validator is provided it will override widget.enumValidator
            validator: (value) => widget.validator != null
                ? widget.validator!(value!)
                : widget.enumValidator != null
                    ? validation(value!)
                    : null,

            enabled: widget.modelTextField != null
                ? widget.modelTextField?.isEnable == true
                    ? true
                    : false
                : true,
            onChanged: widget.onChanged == null
                ? null
                : (value) => widget.onChanged!(value),
            onEditingComplete: widget.onEditingComplete == null
                ? null
                : widget.onEditingComplete,

            textCapitalization: textCapitalization(),
            keyboardType: keyBoardType(),
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: () {
                switch (widget.size) {
                  case EnumWidgetSize.sm:
                    return 14.0;
                  case EnumWidgetSize.md:
                    return 16.0;
                  case EnumWidgetSize.lr:
                    return 18.0;
                  default:
                    return 16.0;
                }
              }(),
            ),
            onTap: () {
              if (widget.eNum == EnumTextField.datePicker) {
                FocusScope.of(context).unfocus();
                selectDate(context);
              } else if (widget.eNum == EnumTextField.dropdown) {
                FocusScope.of(context).unfocus();
                widget.onTap!();
              }
            },
            textAlign: widget.textAlign ?? TextAlign.start,
            decoration: InputDecoration(
                contentPadding: () {
                  switch (widget.size) {
                    case EnumWidgetSize.sm:
                      return const EdgeInsets.all(10.0);
                    case EnumWidgetSize.md:
                      return const EdgeInsets.all(12.0);
                    case EnumWidgetSize.lr:
                      return const EdgeInsets.only(
                          left: 12, top: 20, bottom: 20, right: 12);
                    default:
                      return const EdgeInsets.all(12.0);
                  }
                }(),
                filled: widget.modelTextField?.isEnable == false
                    ? true
                    : widget.fillColor != null
                        ? true
                        : false,
                fillColor: widget.modelTextField?.isEnable == false
                    ? const Color(0xffF5F5F5)
                    : widget.fillColor ?? Colors.white,
                prefixIcon: prifix(),
                suffixIcon: sufix(),
                suffixText: widget.suffixText,
                suffixStyle: widget.suffixTextStyle,
                helperText: widget.heleperText,
                helperStyle: TextStyle(
                    fontSize: () {
                      switch (widget.size) {
                        case EnumWidgetSize.sm:
                          return 12.0;
                        case EnumWidgetSize.md:
                          return 14.0;
                        case EnumWidgetSize.lr:
                          return 16.0;
                        default:
                          return 14.0;
                      }
                    }(),
                    color: widget.borderColor != null
                        ? widget.borderColor!
                        : const Color(0xff656565)),
                errorText: widget.errorText,
                errorStyle: widget.errorStyle,
                hintText: widget.hintText,
                counter: () {
                  if (widget.eNum == EnumTextField.verified) {
                    return const Text("verified");
                  } else if (widget.eNum == EnumTextField.unverified) {
                    return const Text("unverified");
                  } else {
                    return null;
                  }
                }(),
                enabledBorder: inputBorder(widget.borderColor != null
                    ? widget.borderColor!
                    : Colors.grey),
                focusedBorder: inputBorder(Colors.green),
                errorBorder: inputBorder(Colors.red),
                focusedErrorBorder: inputBorder(Colors.red)),
            inputFormatters: textInputformatter(),
          ),
        ),
        if (widget.onDelete != null)
          InkWell(
            onTap: widget.onDelete == null ? null : () => widget.onDelete!(),
            child: Container(
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              margin: const EdgeInsets.only(
                  left: 12, right: 12, top: 10, bottom: 10),
            ),
          ),
      ],
    );
  }

  InputBorder inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        color: color,
      ),
    );
  }

  TextCapitalization textCapitalization() {
    if (widget.enumTextInputType == EnumTextInputType.email) {
      return TextCapitalization.none;
    }
    if (widget.enumTextInputType ==
            EnumTextInputType.capitalLettersWithDigitsNoSpecialChars ||
        widget.enumTextInputType ==
            EnumTextInputType.capitalLettersWithDigitsWithSpecialChars ||
        widget.enumTextInputType == EnumTextInputType.panCardNumber) {
      return TextCapitalization.characters;
    }
    return TextCapitalization.words;
  }

  TextInputType keyBoardType() {
    if (widget.enumTextInputType == EnumTextInputType.digitsWithDecimal) {
      return const TextInputType.numberWithOptions(
          signed: false, decimal: true);
    } else if (widget.enumTextInputType == EnumTextInputType.mobile ||
        widget.enumTextInputType == EnumTextInputType.onlyDigits) {
      return const TextInputType.numberWithOptions(
          decimal: false, signed: false);
    } else if (widget.enumTextInputType == EnumTextInputType.email) {
      return TextInputType.emailAddress;
    }
    return TextInputType.text;
  }

  List<TextInputFormatter> textInputformatter() {
    List<TextInputFormatter> listFormatters = [];
    if (widget.enumTextInputType == EnumTextInputType.mobile) {
      listFormatters.add(FilteringTextInputFormatter.digitsOnly);
      listFormatters.add(LengthLimitingTextInputFormatter(10));
    } else if (widget.enumTextInputType == EnumTextInputType.onlyDigits) {
      listFormatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (widget.enumTextInputType ==
        EnumTextInputType.capitalLettersWithDigitsNoSpecialChars) {
      listFormatters.add(UpperCaseTextFormatter());
      listFormatters
          .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")));
    } else if (widget.enumTextInputType ==
        EnumTextInputType.capitalLettersWithDigitsWithSpecialChars) {
      listFormatters.add(UpperCaseTextFormatter());
    } else if (widget.enumTextInputType == EnumTextInputType.onlyLetters) {
      listFormatters.add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")));
    } else if (widget.enumTextInputType == EnumTextInputType.panCardNumber) {
      listFormatters.add(UpperCaseTextFormatter());
      listFormatters
          .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")));
      listFormatters.add(LengthLimitingTextInputFormatter(10));
    } else if (widget.enumTextInputType ==
        EnumTextInputType.digitsWithDecimal) {
      listFormatters.add(
        FilteringTextInputFormatter.allow(RegExp(r"^(\d+)?([.]?\d{0,3})?$")),
      );
    }
    return listFormatters;
  }

  Widget? prifix() {
    if (widget.eNum == EnumTextField.datePicker) {
      return Icon(
        Icons.date_range,
        color: iconColor,
      );
    } else if (widget.frontIconDynamic != null) {
      return Container(
        margin: const EdgeInsets.only(top: 1, left: 1, bottom: 1, right: 0),
        child: Container(
          child: widget.frontIconDynamic,
          margin: const EdgeInsets.only(right: 7, left: 7),
        ),
      );
    } else if (widget.onEdit != null) {
      return InkWell(
        onTap: widget.onEdit == null ? null : () => widget.onEdit!(),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          color: Colors.green.withOpacity(.2),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      );
    } else if (widget.onSearch != null) {
      return const Icon(Icons.search);
    } else {
      return null;
    }
  }

  Widget? sufix() {
    if (widget.dropdownList != null ||
        widget.eNum == EnumTextField.verified ||
        (widget.clear != null || widget.onSearch != null) &&
            widget.controller.text.isNotEmpty ||
        (widget.modelTextField?.isEnable == false) ||
        widget.backIconDynamic != null ||
        widget.isLoading != null ||
        widget.eNum == EnumTextField.dropdown) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.dropdownList != null) dropDown(),
          if (widget.eNum == EnumTextField.verified)
            const Icon(
              Icons.done_rounded,
              color: Colors.green,
            ),
          if (widget.eNum == EnumTextField.dropdown)
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          if (isError)
            const Icon(
              Icons.warning,
              color: Colors.red,
            ),
          if ((widget.clear != null || widget.onSearch != null) &&
              widget.controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                widget.clear != null ? widget.clear!() : print('no action');
              },
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
          if (widget.modelTextField?.isEnable == false)
            const Icon(
              Icons.not_interested,
              color: Colors.grey,
            ),
          if (widget.backIconDynamic != null) widget.backIconDynamic!,
          if (widget.isLoading != null)
            Visibility(
              visible: widget.isLoading!,
              child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )),
            )
        ],
      );
    } else {
      return null;
    }
  }

  Widget dropDown() {
    return SizedBox.shrink();
  }

  validation(String value) {
    if (value.isEmpty && widget.modelTextField?.isCompulsory != true) {
      return null;
    } else if (value.isEmpty && widget.modelTextField?.isCompulsory == true) {
      return 'This field should not be empty';
    } else if (widget.enumValidator == EnumValidator.email) {
      RegExp regExpEmail = RegExp(HelperRegEx.regExEmail);

      if (!regExpEmail.hasMatch(value.toString())) {
        return 'Please enter valid email id';
      }

      return null;
    } else if (widget.enumValidator == EnumValidator.mobile) {
      RegExp regExpMobile = RegExp(HelperRegEx.regExMobileNumber);

      if (!regExpMobile.hasMatch(value.toString())) {
        return 'Please enter valid mobile number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.ifsc) {
      RegExp regExpIFSC = RegExp(HelperRegEx.regExIFSC);

      if (!regExpIFSC.hasMatch(value.toString())) {
        return 'Please enter valid ifsc code';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.adhar) {
      if (!AadharCardValidation.validateAadharNumber(value)) {
        return 'Please enter valid aadhar number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.panCard) {
      RegExp regExpPAN = RegExp(HelperRegEx.regExPanCard);

      if (!regExpPAN.hasMatch(value.toString())) {
        return 'Please enter valid pan card number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.passport) {
      RegExp regExpPassport = RegExp(HelperRegEx.regExPassport);

      if (!regExpPassport.hasMatch(value.toString())) {
        return 'Please enter valid passport number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.voterId) {
      RegExp regExpVoter = RegExp(HelperRegEx.regExVoterId);

      if (!regExpVoter.hasMatch(value.toString())) {
        return 'Please enter valid voter id number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.gstNumber) {
      RegExp regExGst = RegExp(HelperRegEx.regExGst);

      if (!regExGst.hasMatch(value.toString())) {
        return 'Please enter valid gst number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.bankAccountNo) {
      RegExp regExBankAccountNo = RegExp(HelperRegEx.regExBankAccountNo);

      if (!regExBankAccountNo.hasMatch(value.toString())) {
        return 'Please enter valid account number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.pincode) {
      RegExp regExPincode = RegExp(HelperRegEx.regExPincode);

      if (!regExPincode.hasMatch(value.toString())) {
        return 'Please enter valid pincode';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.vehicleNo) {
      RegExp regExVehicle = RegExp(HelperRegEx.regexVehicleNumber);

      if (!regExVehicle.hasMatch(value.toString())) {
        return 'Please enter valid vehicle number';
      }
      return null;
    } else if (widget.enumValidator == EnumValidator.upiId) {
      RegExp regExUPIid = RegExp(HelperRegEx.regExUPIid);

      if (!regExUPIid.hasMatch(value.toString())) {
        return 'Please enter valid upi id';
      }
      return null;
    } else if (widget.dropdownList != null &&
        widget.dropDownPreSelectedId == null) {
      return 'Please select value';
    }
    return null;
  }

  setError() {
    setState(() {
      isError = true;
    });
  }

  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            widget.initialDate != null ? widget.initialDate! : selectedDate,
        firstDate:
            widget.firstDate != null ? widget.firstDate! : DateTime(1900, 8),
        lastDate: widget.enumTextInputType == EnumTextInputType.birthDate
            ? DateTime.now()
            : DateTime(2101));
    if (picked != null && picked != selectedDate) {
      widget.controller.text = dateFormat('dd/MM/yyyy', picked);
      widget.selectedDate!(picked);
    }
  }

  String dateFormat(String format, DateTime dateTime) {
    return DateFormat(format).format(dateTime);
  }

  String dateStringFromat(String format, String dateTime) {
    return DateFormat(format).format(DateTime.parse(dateTime)).toString();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class HelperRegEx {
  static String regExMobileNumber = '^[6-9]{1}[0-9]{9}';
  static String regExEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String regExIFSC = r"^[A-Z]{4}0[A-Z0-9]{6}$";
  static String regExPanCard = r"[A-Z]{5}[0-9]{4}[A-Z]{1}";
  static String regExPassport = r"^[A-PR-WYa-pr-wy][1-9]\\d\\s?\\d{4}[1-9]$";
  //not sure for voter id
  static String regExVoterId = r"/^([a-zA-Z]){3}([0-9]){7}?$/g";
  static String regExGst =
      r"\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}";
  static String regExBankAccountNo = r"^\d{9,18}$";
  static String regExPincode = r"^[1-9][0-9]{5}$";
  static String regexVehicleNumber =
      r'(^[A-Z]{3}[0-9]{1,4}$)|^([A-Z]{2}[0-9]{1,2}(?:[A-Z])?(?:[A-Z]*)?[0-9]{4}$)';
  static String regExUPIid = r"^[\w.-]+@[\w.-]+$";
}

class AadharCardValidation {
  //use the validateAadharNumber() to get the result, and pass the String vaiable as the parameter.

  static bool validateAadharNumber(String num) {
    var d = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
      [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
      [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
      [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
      [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
      [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
      [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
      [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
      [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    ];

    var p = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
      [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
      [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
      [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
      [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
      [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
      [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
    ];

    // List<int> inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

    int c = 0;
    List<int> myArray = getReversedIntArray(num);
    for (int i = 0; i < myArray.length; i++) {
      c = d[c][p[(i % 8)][myArray[i]]];
    }
    //The result will be a bool value based on the condition below.
    return (c == 0);
  }

  static List<int> getReversedIntArray(String num) {
    List<int> myArray = [];
    for (int i = 0; i < num.length; i++) {
      myArray.add(int.parse(num.substring(i, i + 1)));
    }
    myArray = reverseArray(myArray);
    return myArray;
  }

  static List<int> reverseArray(List<int> myArray) {
    List<int> reversed = [];
    for (int i = 0; i < myArray.length; i++) {
      reversed.add(myArray[myArray.length - (i + 1)]);
    }
    return reversed;
  }
}
