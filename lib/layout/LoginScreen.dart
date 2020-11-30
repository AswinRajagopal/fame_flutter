import 'dart:io';

import 'package:fame_mobile_flutter/utility/sharedPref.dart';
import 'package:fame_mobile_flutter/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController empidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/logo.png',
                        height: 200, width: 200)),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: empidController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Employee Id',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        networkcall(nameController.text, passwordController.text, empidController.text);
                      },
                    )),
              ],
            )));
  }

  networkcall(user, password, empId) async {
    var url = Utility.url()+'user/login';
    Map<String,String> request = {
      'userName': '$user', 'password': '$password',
      'empId':'$empId'
    };
    pr = new ProgressDialog(context);
    await pr.show();
    var response = await http.post(url, headers: {"Content-Type": "application/json"}
    , body: JSON.jsonEncode(request)).catchError(onError);
   print('Response status: ${response.statusCode} ${response.request}');
   print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      if (response.body.length > 2) {
        var objJson = JSON.jsonDecode(response.body);
        pr.hide();
        if (objJson['valid']==false){
          Utility.showToast("Incorrect Login credentials");
        }else {
          MyPref myPref = new MyPref();
          await myPref.setVal(MyPref.LOGGED_IN, "true");
          await myPref.setVal(MyPref.USER_ID, objJson['loginDetails']['empId']);
          await myPref.setVal(MyPref.COMPANY_ID, objJson['loginDetails']['companyId']);
          await myPref.setVal(MyPref.ROLE, objJson['loginDetails']['role']);
          Utility.showToast('Login Successful');
          Navigator.popAndPushNamed(context, '/cat');
        }
//        Navigator.pop(context);
      } else {
        pr.hide();
        Utility.showToast('Invalid username or password');
      }
    } else {
      pr.hide();
      Utility.showToast("Couldn't communicate with server");
    }
  }

  onError(error) {
    pr.hide();
    Utility.showToast("Server error");
  }
}
