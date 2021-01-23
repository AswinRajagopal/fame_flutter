import '../utils/utils.dart';

import 'reset_password.dart';

import '../controllers/otp_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordController fpController = Get.put(ForgotPasswordController());
  final OTPController otpController = Get.put(OTPController());
  bool rememberMe = true;
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 20.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            'Enter the email associated with your account',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Card(
                  color: Colors.white,
                  elevation: 6.0,
                  margin: EdgeInsets.only(
                    top: 100.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Wrap(
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 30.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'We will send an OTP to your registered email to reset your password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CommonTextField(
                        'Enter your email address',
                        'assets/images/email.png',
                        'email',
                        email,
                      ),
                      SizedBox(
                        height: 120.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 265.0,
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.0,
                        5.0,
                      ),
                    ),
                  ],
                ),
                child: Center(
                  child: MaterialButton(
                    color: AppUtils().orangeColor,
                    shape: CircleBorder(),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (email.text == null || email.text == '') {
                        Get.snackbar(
                          null,
                          'Please provide email',
                          colorText: Colors.white,
                          backgroundColor: Colors.black87,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 18.0,
                          ),
                          borderRadius: 5.0,
                        );
                      } else if (email.text != '' && !GetUtils.isEmail(email.text)) {
                        Get.snackbar(
                          null,
                          'Please provide valid email',
                          colorText: Colors.white,
                          backgroundColor: Colors.black87,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 18.0,
                          ),
                          borderRadius: 5.0,
                        );
                      } else {
                        var forgotpwd = await fpController.forgotPassword(
                          email.text,
                          context,
                        );
                        if (forgotpwd) {
                          // ignore: unawaited_futures
                          Get.bottomSheet(
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                                // vertical: 20.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    // Container(
                                    //   height: 8.0,
                                    //   width: 80.0,
                                    //   color: Colors.white38,
                                    // ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      'Verification',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      "Please enter the OTP you've received on your registered email",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    PinCodeTextField(
                                      appContext: context,
                                      length: 4,
                                      obscureText: false,
                                      animationType: AnimationType.fade,
                                      controller: otp,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.underline,
                                        fieldHeight: 65,
                                        fieldWidth: 65,
                                        activeColor: Theme.of(context).primaryColor,
                                        activeFillColor: Theme.of(context).primaryColor,
                                        selectedColor: Theme.of(context).primaryColor,
                                        selectedFillColor: Theme.of(context).primaryColor,
                                        inactiveColor: Theme.of(context).primaryColor,
                                      ),
                                      cursorColor: Colors.transparent,
                                      cursorHeight: 40.0,
                                      cursorWidth: 2.0,
                                      // autoFocus: false,
                                      backgroundColor: Colors.transparent,
                                      keyboardType: TextInputType.number,
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
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
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "If you didn't receive the code!",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            var resend = await fpController.forgotPassword(
                                              email.text,
                                              context,
                                            );
                                            if (resend) {
                                              Get.snackbar(
                                                null,
                                                'OTP sent',
                                                colorText: Colors.white,
                                                backgroundColor: AppUtils().greenColor,
                                                snackPosition: SnackPosition.BOTTOM,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 10.0,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 18.0,
                                                ),
                                                borderRadius: 5.0,
                                              );
                                            } else {
                                              Get.snackbar(
                                                null,
                                                'OTP not sent',
                                                colorText: Colors.white,
                                                backgroundColor: Colors.black87,
                                                snackPosition: SnackPosition.BOTTOM,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 10.0,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 18.0,
                                                ),
                                                borderRadius: 5.0,
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Resend',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    RaisedButton(
                                      onPressed: () async {
                                        if (otp.text == null || otp.text == '') {
                                          Get.snackbar(
                                            null,
                                            'Please enter otp',
                                            colorText: Colors.white,
                                            backgroundColor: Colors.black87,
                                            snackPosition: SnackPosition.BOTTOM,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 10.0,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 18.0,
                                            ),
                                            borderRadius: 5.0,
                                          );
                                        } else {
                                          var otpVerify = await otpController.verifyForgotOTP(
                                            email.text,
                                            otp.text,
                                            context,
                                          );
                                          if (otpVerify) {
                                            await Get.back();
                                            otp.clear();
                                            await Get.to(ResetPassword(email.text));
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0,
                                          vertical: 18.0,
                                        ),
                                        child: Text(
                                          'SUBMIT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(
                        20.0,
                      ),
                      child: Image.asset(
                        'assets/images/arrow_right.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final String hintText;
  final String prefixIcon;
  final String type;
  final TextEditingController tec;
  CommonTextField(
    this.hintText,
    this.prefixIcon,
    this.type,
    this.tec,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15.0,
          left: 15.0,
          bottom: 12.0,
        ),
        child: TextField(
          obscureText: type == 'password' ? true : false,
          keyboardType: type == 'mobile'
              ? TextInputType.phone
              : type == 'email'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
          controller: tec,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
            hintText: hintText,
            prefixIcon: Image.asset(
              prefixIcon,
              scale: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
