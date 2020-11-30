import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility{

  static String ruppeeSym = '₹';
  static String sendOtp = 'Send Otp';
  static String verifyOtp = 'Verify Otp';
  static String changePass = 'Change Password';
  static String build_id = '4';
  static List<Color> colorsGrad = <Color>[Colors.redAccent, Colors.red];

  static final TextTheme lightAppBarTextTheme = TextTheme(
    headline1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 102, color: Color(0xff495057))),
    headline2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 64, color: Color(0xff495057))),
    headline3: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 51, color: Color(0xff495057))),
    headline4: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 36, color: Color(0xff495057))),
    headline5: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 25, color: Color(0xff495057))),
    headline6: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 18, color: Color(0xff495057))),
    subtitle1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 17, color: Color(0xff495057))),
    subtitle2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Color(0xff495057))),
    bodyText1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 16, color: Color(0xff495057))),
    bodyText2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 14, color: Color(0xff495057))),
    button: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Color(0xff495057))),
    caption: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 13, color: Color(0xff495057))),
    overline: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 11, color: Color(0xff495057))),
  );


  static showToast(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }
  static String url(){
    return "http://13.232.255.84:8090/v1/api/";
  }
  static String guiseUrl(){
    return "http://13.235.123.160/";
  }
  static String storageName(){
    return "famePref";
  }


  static sharedVar() async{

  }
  static Future<void> msgDial(msg,context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  static Widget entryField(String title, {bool isPassword = false,
    TextEditingController controller,TextInputType keyboard = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: isPassword,
            keyboardType: keyboard,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            controller: controller,
          )
        ],
      ),
    );
  }
  static Widget backButton(context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}