import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';

class AppUtils {
  var appName = 'Blink-In';
  Color grScaffoldBg = Colors.grey[300];
  Color greyScaffoldBg = HexColor('eff4f6');
  Color innerScaffoldBg = Colors.white;
  Color greenColor = HexColor('4DB734');
  Color darkBlueColor = HexColor('3C6BB7');
  Color lightBlueColor = HexColor('54D2DB');
  Color orangeColor = HexColor('FF7933');
  static String WHOLEDAY = 'W';
  static String ADMIN = '4';
  static String MANAGER = '3';
  static String FIRSTHALF = 'F';
  static String SECONDHALF = 'S';
  static String GKEY = 'AIzaSyADoNEFbFbgHCpu7mz7yLWhbbUMZqk4yHU';
  // static String GKEY = 'AIzaSyBFsUGJKkY5yvYAC3Tb0vHIX9ZW7s5aGog';
  static String EMP_ID = 'EMP_ID';
  static String ATTENDANCE = 'ATTENDANCE';
  static String NAME = 'NAME';
  static String PLAYSTORE = 'https://play.google.com/store/apps/details?id=in.androidfame.attendance';

  static checkTextisNull(TextEditingController text1,String val){
    if(text1.isNullOrBlank){
      Get.snackbar(
        null,
        'Please provide '+val,
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
      return true;
    } else{
        return false;
    }
  }

  static String checkStr(var str){
    if(str == 'null'){
      str = '[NULL]';
    }
    return str;
  }
}
