import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/welcome_bg.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/tm_logo_small.png',
                      height: 160.0,
                      width: 160.0,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Get.offAll(SignupPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          'SIGNUP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        side: BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Get.offAll(LoginPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        side: BorderSide(
                          color: Colors.blueAccent,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.0,
                ),
                Text(
                  'Powered by Diyos Infotech Pvt. Ltd.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Version 2.0.1',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
