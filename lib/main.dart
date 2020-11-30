import 'package:fame_mobile_flutter/AppTheme.dart';
import 'package:fame_mobile_flutter/config/route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaME',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
      },
    );
  }
}

