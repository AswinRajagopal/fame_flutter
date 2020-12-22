import 'views/dashboard_page.dart';

import 'connection/remote_services.dart';
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
  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  await Hive.openBox('fame_pocket');
  runApp(PocketFaME());
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
      // smartManagement: SmartManagement.keepFactory,
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void main() {
//   runApp(GetMaterialApp(home: HomePage()));
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('HOME')),
//       body: Center(
//         child: RaisedButton(
//           child: Text('Go Dashboard'),
//           onPressed: () => Get.to(DashboardPage()),
//         ),
//       ),
//     );
//   }
// }

// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final DashboardController dbC = Get.put(DashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('HOME')),
//       body: Center(
//         child: RaisedButton(
//           child: Text('Return'),
//           onPressed: () => Get.offAll(HomePage()),
//         ),
//       ),
//     );
//   }
// }

// class DashboardController extends GetxController {
//   @override
//   void onInit() {
//     print('dbc onInit');
//     super.onInit();
//   }
// }
