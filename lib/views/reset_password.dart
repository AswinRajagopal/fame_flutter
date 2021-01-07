import 'package:flutter/gestures.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  ResetPassword(this.email);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ResetPasswordController rpC = Get.put(ResetPasswordController());
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  var _obscureText = true;

  @override
  void initState() {
    super.initState();
    rpC.pr = ProgressDialog(
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
    rpC.pr.style(
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    super.dispose();
    password.dispose();
    confirmpassword.dispose();
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
                    color: Colors.blue,
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
                            'Create new password',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
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
                      Container(
                        height: 35.0,
                      ),
                      // CommonTextField(
                      //   'Enter new password',
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
                              hintText: 'Enter new password',
                              prefixIcon: Image.asset(
                                'assets/images/password.png',
                                scale: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // CommonTextField(
                      //   'Confirm password',
                      //   'assets/images/password.png',
                      //   'password',
                      //   confirmpassword,
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
                            controller: confirmpassword,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              // suffixIcon: GestureDetector(
                              //   dragStartBehavior: DragStartBehavior.down,
                              //   onTap: () {
                              //     print('herer');
                              //     _obscureText = !_obscureText;
                              //     setState(() {});
                              //   },
                              //   child: Icon(
                              //     _obscureText ? Icons.visibility : Icons.visibility_off,
                              //     size: 22.0,
                              //   ),
                              // ),
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
                              hintText: 'Confirm password',
                              prefixIcon: Image.asset(
                                'assets/images/password.png',
                                scale: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 135.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 280.0,
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
                    color: Colors.orangeAccent,
                    shape: CircleBorder(),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (password.text == null || confirmpassword.text == '') {
                        Get.snackbar(
                          'Error',
                          'Please provide password and confirm password',
                          colorText: Colors.white,
                          backgroundColor: Colors.black87,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                        );
                      } else if (password.text != confirmpassword.text) {
                        Get.snackbar(
                          'Error',
                          'Password are not matching',
                          colorText: Colors.white,
                          backgroundColor: Colors.black87,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                        );
                      } else {
                        rpC.verifyOTP(widget.email, password.text);
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
