import 'package:fame/controllers/otp_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import '../widgets/custom_vertical_divider.dart';

class OtpAuth extends StatefulWidget {
  @override
  _OtpAuthState createState() => _OtpAuthState();
}

class _OtpAuthState extends State<OtpAuth> {
  final OtpLoginController olC = Get.put(OtpLoginController());
  TextEditingController mobile = TextEditingController();
  TextEditingController prefix = TextEditingController();
  var firebaseAuth;

  @override
  void initState() {
    super.initState();
    prefix.text = '+91';
  }

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
                        color: Color(0xFF3C4858),
                        fontWeight: FontWeight.bold,
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
                  'OTP Login',
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
                  'Enter the mobile number associated with your account, please make sure you can access it to get the OTP.',
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
                  'Enter your mobile number',
                  style: TextStyle(
                    color: Color(0xFF3C4858),
                    fontSize: 20.0,
                    fontFamily: 'Heebo-Medium',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 65.0,
                      height: 65.0,
                      child: TextField(
                        controller: prefix,
                        keyboardType: null,
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 10.0,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[200],
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[200],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[200],
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[200],
                            ),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          prefix: Row(
                            children: [
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '+91',
                                style: TextStyle(
                                  color: Color(0xFF3C4858),
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              CustomVerticalDivider(
                                thickness: 1.0,
                                height: 30.0,
                                color: Color(0xFF3C4858),
                                indent: 0,
                                endIndent: 0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        child: TextField(
                          controller: mobile,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            color: Color(0xFF3C4858),
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 10.0,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[200],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[200],
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[200],
                              ),
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: '99XXXXX750',
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  40.0,
                  40.0,
                  40.0,
                  5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 40.0,
                        ),
                        child: Text(
                          'Send',
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (mobile.text == null || mobile.text.isEmpty) {
                          Get.snackbar(
                            AppUtils.snackbarTitle,
                            'Please provide mobile number',
                            colorText: AppUtils.snackbarTextColor,
                            backgroundColor: AppUtils.snackbarbackgroundColor,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 18.0),
                            borderRadius: 5.0,
                          );
                        } else if (mobile.text.length != 10) {
                          Get.snackbar(
                            AppUtils.snackbarTitle,
                            'Please provide 10 digit mobile number',
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
                          olC.validateMobile(mobile.text);
                        }
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
