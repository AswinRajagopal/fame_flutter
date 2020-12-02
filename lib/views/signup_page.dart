import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/signup_controller.dart';

import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController signupController = Get.put(SignupController());
  TextEditingController username = TextEditingController();
  TextEditingController empid = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();

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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    signupController.pr.style(
      backgroundColor: Colors.black,
    );
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    empid.dispose();
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
                            'Pocket FaME',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Sign up to Continue',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 17.0,
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
                                        color: Colors.blue,
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
                          'Full name',
                          'assets/images/full_name_icon.png',
                          'text',
                          fullname,
                        ),
                        CommonTextField(
                          'Email address',
                          'assets/images/email.png',
                          'email',
                          email,
                        ),
                        CommonTextField(
                          'Mobile no. (without +91)',
                          'assets/images/email.png',
                          'mobile',
                          mobile,
                        ),
                        CommonTextField(
                          'Company name',
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
                          'Username',
                          'assets/images/person_male.png',
                          'text',
                          username,
                        ),
                        CommonTextField(
                          'Password',
                          'assets/images/password.png',
                          'password',
                          password,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'By pressing "Submit" you agree to our',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 95.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 630.0,
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
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (username.text == null ||
                          username.text == '' ||
                          empid.text == null ||
                          empid.text == '' ||
                          password.text == null ||
                          password.text == '' ||
                          fullname.text == null ||
                          fullname.text == '' ||
                          email.text == null ||
                          email.text == '' ||
                          mobile.text == null ||
                          mobile.text == '' ||
                          company.text == null ||
                          company.text == '') {
                        Get.snackbar(
                          'Error',
                          'Please provide all detail',
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                        );
                      } else if (email.text != '' &&
                          !GetUtils.isEmail(email.text)) {
                        Get.snackbar(
                          'Error',
                          'Please provide valid email',
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                        );
                      } else if (mobile.text != '' &&
                          mobile.text.length != 10) {
                        Get.snackbar(
                          'Error',
                          'Please provide valid 10 digit mobile',
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                        );
                      } else {
                        // Call Signup Controller's Function
                        print('Signup Pressed');
                        signupController.registerUser(
                          username.text,
                          empid.text,
                          password.text,
                          mobile.text,
                          fullname.text,
                          email.text,
                          company.text,
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
              scale: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
