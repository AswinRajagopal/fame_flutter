import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class Expenses extends StatefulWidget {
  final String details;
  Expenses({this.details});

  @override
  _ExpensesState createState() => _ExpensesState(this.details);
}

class _ExpensesState extends State<Expenses> {
  final ExpenseController expC = Get.put(ExpenseController());
  CameraController controller;
  final TextEditingController date = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController attach = TextEditingController();
  final TextEditingController attachOne = TextEditingController();
  final TextEditingController attachTwo = TextEditingController();
  final TextEditingController expense = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  var empId;
  var expenseTypeId;
  File attachment;
  var passDate;

  var details;
  _ExpensesState(this. details);

  @override
  void initState() {
    date.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    passDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    expC.pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    expC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      expC.getExpenses,
    );
    super.initState();
  }

  Future<Null> getDate(BuildContext context) async {
    int attendanceDaysPermitted = jsonDecode(
        RemoteServices().box.get('appFeature'))['attendanceDaysPermitted'];
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
        passDate.toString(),
      ),
      firstDate:
          DateTime.now().add(Duration(days: -(attendanceDaysPermitted - 1))),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${date.text.toString()}');
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        passDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Expense Management',
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: RemoteServices().box.get('role') != '3'
                      ? MediaQuery.of(context).size.height / 1.20
                      : MediaQuery.of(context).size.height / 1.35,
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text(
                              'Add Expense',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                color: Colors.grey[200],
                                child: Container(
                                  width: 200,
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        date.text,
                                        style: TextStyle(fontSize: 18.0,color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                color: Colors.grey[200],
                                child: Container(
                                  width: 200,
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                  expC.empExpList[0]['empId'].toString(),
                                        style: TextStyle(fontSize: 18.0,color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          color: Colors.grey[200],
                          child: Container(
                            width: 200,
                            height: 55,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  RemoteServices().box.get('empName'),
                                  style: TextStyle(fontSize: 18.0,color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                child: Container(
                                  width: 200,
                                  height: 60,
                                  child: TextField(
                                    controller: amount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      labelText: 'Amount',
                                      labelStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: DropdownSearch(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  dropDownButton: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                    size: 18.0,
                                  ),
                                  hint: 'Expenses Type',
                                  showSelectedItem: true,
                                  items: expC.exp.map((item) {
                                    print(item['expenseType']);
                                    print("items " + item['expenseType']);
                                    var sC = item['expenseType'].toString();
                                    return sC.toString();
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            child: TextField(
                              controller: remarks,
                              maxLength: 160,
                              maxLengthEnforced: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Remarks...',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            height: 60,
                            child: TextField(
                              controller: attach,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 18,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Attachment',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/uplode_proof.png',
                                    scale: 2.2,
                                  ),
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile = await ImagePicker().getImage(
                                  source: ImageSource.camera,
                                  imageQuality: 50,
                                );
                                if (pickedFile != null) {
                                  attachment =  new File(pickedFile.path);
                                  attach.text = path.basename(pickedFile.path);
                                  setState(() {});
                                } else {
                                  print('No image selected.');
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            height: 60,
                            child: TextField(
                              controller: attachOne,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 18,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Attachment',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/uplode_proof.png',
                                    scale: 2.2,
                                  ),
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile = await ImagePicker().getImage(
                                  source: ImageSource.camera,
                                  imageQuality: 50,
                                );
                                if (pickedFile != null) {
                                  attachment =  new File(pickedFile.path);
                                  attachOne.text = path.basename(pickedFile.path);
                                  setState(() {});
                                } else {
                                  print('No image selected.');
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            height: 60,
                            child: TextField(
                              controller: attachTwo,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 18,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Attachment',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/uplode_proof.png',
                                    scale: 2.2,
                                  ),
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile = await ImagePicker().getImage(
                                  source: ImageSource.camera,
                                  imageQuality: 50,
                                );
                                if (pickedFile != null) {
                                  attachment =  new File(pickedFile.path);
                                  attachTwo.text = path.basename(pickedFile.path);
                                  setState(() {});
                                } else {
                                  print('No image selected.');
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                        child: RaisedButton(
                          onPressed: () async {
                            print('Submit');
                            FocusScope.of(context).requestFocus(FocusNode());
                            var base64String = '';
                            if (attachment != null) {
                              final bytes =
                              await File(attachment.path).readAsBytes();
                              // print(base64.encode(bytes));
                              base64String = base64.encode(bytes);
                            } else {
                              Get.snackbar(
                                null,
                                'Please provide Attachment',
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
                            if (amount.text == null ||
                                amount.text == '' ||
                                remarks.text == null ||
                                remarks.text == '') {
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
                            } else if (expC.exp.isEmpty) {
                              Get.snackbar(
                                null,
                                'Please select atleast one Expense Type',
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
                            } else {
                              if (expenseTypeId == null) {
                                expenseTypeId = '3';
                              }
                              print(empId);
                              print(amount.text);
                              expC.newExpenses(amount.text, expenseTypeId);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 40.0,
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                            color:AppUtils().blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color:AppUtils().blueColor,
                            ),
                          ),
                        ),

                      )
                    ],
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

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController inputController;
  MyTextField(this.hintText, this.inputController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: TextField(
        controller: inputController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 18.0,
            // fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}