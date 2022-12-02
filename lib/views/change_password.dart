import 'package:fame/controllers/change_pass_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ChangePasswordController cpC = Get.put(ChangePasswordController());
  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController cfNewPass = TextEditingController();
  var _obscureText = true;
  var _hideText = true;
  var _confirmText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Change Password',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black38)),
                  child: Container(
                    height: 60,
                    child: TextField(
                      controller: currentPass,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 10,
                          top: 18,
                        ),
                        suffixIcon: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {
                            print('herer');
                            _obscureText = !_obscureText;
                            setState(() {});
                          },
                          child: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            size: 22.0,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                        labelText: 'Current Password*',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black38)),
                  child: Container(
                    height: 60.0,
                    child: TextField(
                      controller: newPass,
                      obscureText: _hideText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 10,
                          top: 18,
                        ),
                        suffixIcon: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {
                            print('herer');
                            _hideText = !_hideText;
                            setState(() {});
                          },
                          child: Icon(
                            _hideText ? Icons.visibility : Icons.visibility_off,
                            size: 22.0,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                        labelText: 'New Password*',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black38)),
                  child: Container(
                    height: 60.0,
                    child: TextField(
                      controller: cfNewPass,
                      obscureText: _confirmText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 10,
                          top: 18,
                        ),
                        suffixIcon: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {
                            print('herer');
                            _confirmText = !_confirmText;
                            setState(() {});
                          },
                          child: Icon(
                            _confirmText ? Icons.visibility : Icons.visibility_off,
                            size: 22.0,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                        labelText: ' Confirm New Password*',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                child: RaisedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (currentPass.text == null ||
                        currentPass.text == ''||newPass.text==null||newPass.text=='') {
                      Get.snackbar(
                        null,
                        'Please provide all the details',
                        colorText: Colors.white,
                        backgroundColor: Colors.black87,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 10.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 18.0,
                        ),
                        borderRadius: 5.0,
                      );
                    }else if(cfNewPass.text!=newPass.text){
                      Get.snackbar(
                        null,
                        'Please make sure your password match',
                        colorText: Colors.white,
                        backgroundColor: Colors.black87,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 10.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 18.0,
                        ),
                        borderRadius: 5.0,
                      );
                    }
                    else {
                      print(currentPass.text);
                      print(newPass.text);
                      cpC.getChangePass(currentPass.text,newPass.text,context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12.0),
                    child: Text(
                      'Update Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
