import 'package:fame/controllers/otp_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// import '../controllers/password_controller.dart';
import '../utils/utils.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String mobile;

  OTPScreen(this.verificationId, this.mobile);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final OtpLoginController olC = Get.put(OtpLoginController());
  TextEditingController passcode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 22.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/back_icon.png',
                      height: 25.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C4858),
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: Color(0xFF3C4858),
                    fontSize: 30.0,
                    fontFamily: 'Heebo-Medium',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  'We have sent a verification code to your mobile number.',
                  style: TextStyle(
                    color: Color(0xFF3C4858),
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  'Enter your 6 digit passcode.',
                  style: TextStyle(
                    color: Color(0xFF3C4858),
                    fontSize: 20.0,
                    fontFamily: 'Heebo-Medium',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20.0,
                  15.0,
                  20.0,
                  0.0,
                ),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  controller: passcode,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8.0),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeColor: Colors.grey,
                    activeFillColor: Colors.grey,
                    selectedColor: Colors.grey,
                    selectedFillColor: Colors.grey,
                    inactiveColor: Colors.grey,
                  ),
                  cursorColor: Colors.transparent,
                  cursorHeight: 40.0,
                  cursorWidth: 2.0,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // autoFocus: false,
                  backgroundColor: Colors.transparent,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                  autoDisposeControllers: false,
                  onCompleted: (v) {
                    print('Completed');
                  },
                  beforeTextPaste: (text) {
                    print('Allowing to paste $text');
                    return true;
                  },
                  onChanged: (String value) {
                    print(value);
                  },
                ),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  print('widget.mobile: ${widget.mobile}');
                  olC.verifyPhone(
                    widget.mobile,
                    noredirect: false,
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'Resend code',
                      style: TextStyle(
                        color: Color(0xFF00AAFF),
                        fontSize: 20.0,
                        fontFamily: 'Heebo-Medium',
                      ),
                    ),
                    SizedBox(
                      width: 120.0,
                      child: Divider(
                        thickness: 1.0,
                        height: 1.0,
                        color: Color(0xFF00AAFF),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  40.0,
                  60.0,
                  40.0,
                  5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 100.0,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      color: AppUtils().blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                          color: AppUtils().blueColor,
                        ),
                      ),
                      onPressed: () {
                        if (passcode.text == null || passcode.text.isEmpty) {
                          Get.snackbar(
                            AppUtils.snackbarTitle,
                            'Please enter OTP',
                            colorText: AppUtils.snackbarTextColor,
                            backgroundColor: AppUtils.snackbarbackgroundColor,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 18.0),
                            borderRadius: 5.0,
                          );
                        } else {
                          olC.validateOTP(widget.verificationId, passcode.text);
                        }
                        // Get.to(ResetPassword());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
