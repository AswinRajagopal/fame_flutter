import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool rememberMe = true;

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
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Enter the email associated with your account',
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
                    color: Colors.orangeAccent,
                    shape: CircleBorder(),
                    onPressed: () {},
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
  CommonTextField(
    this.hintText,
    this.prefixIcon,
    this.type,
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
