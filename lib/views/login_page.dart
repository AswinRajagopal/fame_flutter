import 'package:fame/controllers/otp_login_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/login_controller.dart';

import 'forgot_password_page.dart';

import 'otp_auth_page.dart';
import 'signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  final OtpLoginController opc = Get.put(OtpLoginController());
  bool rememberMe = true;
  TextEditingController username = TextEditingController();
  TextEditingController empid = TextEditingController();
  TextEditingController password = TextEditingController();
  var _obscureText = true;

  var isSwitched = false;

  @override
  void initState() {
    super.initState();

    var pr = ProgressDialog(
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
    pr.style(
      backgroundColor: Colors.white,
    );
    loginController.pr = pr;
    opc.pr = pr;
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    empid.dispose();
    password.dispose();
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
                            'Sign in to Continue',
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
                alignment: Alignment.topRight,
                child: Column(children: [
                  Switch(
                    value: isSwitched,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                  Text('Lite Mode ', style: TextStyle(color: Colors.white))
                ])),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.yellowAccent,
                                    height: 4.0,
                                    width: 50.0,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.offAll(SignupPage());
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'SIGNUP',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CommonTextField(
                        'Username',
                        'assets/images/person_male.png',
                        'text',
                        username,
                      ),
                      CommonTextField(
                        'Employee Id',
                        'assets/images/emp_id_icon.png',
                        'text',
                        empid,
                      ),
                      // CommonTextField(
                      //   '*********',
                      //   'assets/images/password.png',
                      //   'password',
                      //   password,
                      // ),
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
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: Row(
                          children: [
                            FlatButton(
                              onPressed: () {
                                Get.to(OtpAuth());
                              },
                              child: Text(
                                'Login wth OTP',
                                style: TextStyle(
                                  color: AppUtils().blueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            FlatButton(
                              onPressed: () {
                                Get.to(ForgotPasswordPage());
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: AppUtils().orangeColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 400.0,
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
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (username.text == null ||
                          username.text == '' ||
                          empid.text == null ||
                          empid.text == '' ||
                          password.text == null ||
                          password.text == '') {
                        Get.snackbar(
                          null,
                          'Please provide all the details',
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
                        // Call Login Controller's Function
                        print('Login Pressed');
                        loginController.loginUser(
                          username.text,
                          empid.text,
                          password.text,
                          isSwitched
                        );
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
