import 'package:fame_mobile_flutter/layout/CameraPage.dart';
import 'package:fame_mobile_flutter/layout/LoginScreen.dart';
import 'package:flutter/material.dart';

class Routes{
  static Map<String,WidgetBuilder> getRoute(){
    return  <String, WidgetBuilder>{
           '/': (_) => CameraPage()
    };
  }
}