import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_update/in_app_update.dart';

import 'views/dashboard_page.dart';

import 'connection/remote_services.dart';
import 'package:flutter/services.dart';

import 'views/welcome_page.dart';

import 'views/forgot_password_page.dart';

import 'views/signup_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FirebaseCrashlytics.instance.crash();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  await Hive.openBox('fame_pocket');
  // runApp(PocketFaME());
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => PocketFaME(), // Wrap your app
    ),
  );
}

// ignore: must_be_immutable
class PocketFaME extends StatelessWidget {
  AppUpdateInfo updateInfo;

  void _showError(dynamic exception) {
    // Get.snackbar(
    //   'Error',
    //   exception.toString(),
    //   colorText: Colors.white,
    //   backgroundColor: Colors.black87,
    //   snackPosition: SnackPosition.BOTTOM,
    //   margin: EdgeInsets.symmetric(
    //     horizontal: 8.0,
    //     vertical: 10.0,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    InAppUpdate.checkForUpdate().then((info) {
      if (info != null && info.updateAvailable) {
        // ignore: unnecessary_lambdas
        // InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
      }
      // ignore: unnecessary_lambdas
    }).catchError((e) => _showError(e));

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
    );

    return GetMaterialApp(
      title: 'FaME',
      debugShowCheckedModeBanner: false,
      // smartManagement: SmartManagement.keepFactory,
      locale: DevicePreview.locale(context),
      theme: ThemeData(
        // textTheme: GoogleFonts.nunitoTextTheme(
        //   Theme.of(context).textTheme,
        // ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'AvenirMedium',
        primaryColor: HexColor('4981DB'),
      ),
      // builder: (context, child) {
      //   return ScrollConfiguration(
      //     behavior: MyBehavior(),
      //     child: child,
      //   );
      // },
      builder: (context, widget) => ResponsiveWrapper.builder(
        ScrollConfiguration(
          behavior: MyBehavior(),
          child: widget,
        ),
        maxWidth: 1200,
        minWidth: 480,
        // minWidth: MediaQuery.of(context).size.width,
        defaultScale: true,
        debugLog: false,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      home: RemoteServices().box.get('empid') != null && RemoteServices().box.get('empid') != '' ? DashboardPage() : WelcomePage(),
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
        GetPage(
          name: 'dashboard',
          page: () => DashboardPage(),
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
