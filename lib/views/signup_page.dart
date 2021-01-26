import 'package:flutter/gestures.dart';

import '../controllers/otp_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/signup_controller.dart';

import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController signupController = Get.put(SignupController());
  final OTPController otpController = Get.put(OTPController());
  TextEditingController username = TextEditingController();
  TextEditingController empid = TextEditingController();
  TextEditingController empNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  var _obscureText = true;

  @override
  void initState() {
    super.initState();
    signupController.pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    signupController.pr.style(
      backgroundColor: Colors.white,
    );

    otpController.pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    otpController.pr.style(
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    empid.dispose();
    empNo.dispose();
    password.dispose();
    mobile.dispose();
    fullname.dispose();
    email.dispose();
    company.dispose();
  }

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
                            AppUtils().appName,
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
                            'Sign up to Continue',
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
            // ListView(
            //   shrinkWrap: true,
            //   children: [],
            // ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                // height: 650.0,
                // height: 650.0,
                child: SingleChildScrollView(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(LoginPage());
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Text(
                                      'SIGNUP',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.yellowAccent,
                                      height: 4.0,
                                      width: 65.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CommonTextField(
                          'Full Name',
                          'assets/images/full_name_icon.png',
                          'text',
                          fullname,
                        ),
                        CommonTextField(
                          'Email Address',
                          'assets/images/email.png',
                          'email',
                          email,
                        ),
                        CommonTextField(
                          'Mobile No. (without +91)',
                          'assets/images/icon_mobile.png',
                          'mobile',
                          mobile,
                        ),
                        CommonTextField(
                          'Company Name',
                          'assets/images/company_name.png',
                          'text',
                          company,
                        ),
                        CommonTextField(
                          'Employee ID',
                          'assets/images/emp_id_icon.png',
                          'text',
                          empid,
                        ),
                        CommonTextField(
                          'Employee Number',
                          'assets/images/emp_id_icon.png',
                          'text',
                          empNo,
                        ),
                        CommonTextField(
                          'Username',
                          'assets/images/person_male.png',
                          'text',
                          username,
                        ),
                        Container(
                          height: 60.0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15.0,
                              left: 15.0,
                              bottom: 12.0,
                            ),
                            child: TextField(
                              controller: password,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  dragStartBehavior: DragStartBehavior.down,
                                  onTap: () {
                                    print('herer');
                                    _obscureText = !_obscureText;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    size: 22.0,
                                  ),
                                ),
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
                                hintText: 'Password',
                                prefixIcon: Image.asset(
                                  'assets/images/password.png',
                                  scale: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Center(
                        //   child: Column(
                        //     children: [
                        //       Text(
                        //         'By pressing "Submit" you agree to our',
                        //         style: TextStyle(
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Text(
                        //           'Terms & Conditions',
                        //           style: TextStyle(
                        //             color: AppUtils().orangeColor,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          // height: 95.0,
                          height: 105.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // top: 690.0,
              top: 640.0,
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
                      if (username.text == null || username.text == '' || empid.text == null || empid.text == '' || password.text == null || password.text == '' || fullname.text == null || fullname.text == '' || email.text == null || email.text == '' || mobile.text == null || mobile.text == '' || company.text == null || company.text == '' || empNo.text.isNullOrBlank) {
                        Get.snackbar(
                          null,
                          'Please provide all detail',
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
                      } else if (mobile.text != '' && mobile.text.length != 10) {
                        Get.snackbar(
                          null,
                          'Please provide valid 10 digit mobile',
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
                        // Call Signup Controller's Function
                        print('Signup Pressed');
                        var signup = await signupController.registerUser(
                          username.text,
                          empid.text,
                          empNo.text,
                          password.text,
                          mobile.text,
                          fullname.text,
                          email.text,
                          company.text,
                        );
                        print('Signup RES: $signup');
                        if (signup) {
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
                                            var resend = await signupController.registerUser(
                                              username.text,
                                              empid.text,
                                              empNo.text,
                                              password.text,
                                              mobile.text,
                                              fullname.text,
                                              email.text,
                                              company.text,
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
                                          otpController.verifyOTP(
                                            mobile.text,
                                            otp.text,
                                          );
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
  final TextEditingController inputController;
  CommonTextField(
    this.hintText,
    this.prefixIcon,
    this.type,
    this.inputController,
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
          controller: inputController,
          obscureText: type == 'password' ? true : false,
          keyboardType: type == 'mobile'
              ? TextInputType.phone
              : type == 'email'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
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
              scale: type == 'mobile' ? 2.2 : 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
