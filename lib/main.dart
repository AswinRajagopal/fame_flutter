import 'package:flutter/services.dart';

import 'views/welcome_page.dart';

import 'views/forgot_password_page.dart';

import 'views/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PocketFaME());

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('fame_pocket');
}

class PocketFaME extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
      ),
    );

    return GetMaterialApp(
      title: 'FaME',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      home: WelcomePage(),
      getPages: [
        GetPage(
          name: 'welcome',
          page: () => WelcomePage(),
        ),
        GetPage(
          name: 'login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: 'signup',
          page: () => SignupPage(),
        ),
        GetPage(
          name: 'forgot_password',
          page: () => ForgotPasswordPage(),
        ),
      ],
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
