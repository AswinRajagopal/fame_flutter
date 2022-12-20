import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/views/view_expenses.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:number_to_character/number_to_character.dart';
import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestExpense extends StatefulWidget {
  final String details;
  RequestExpense({this.details});

  @override
  _RequestExpenseState createState() => _RequestExpenseState();
}

class _RequestExpenseState extends State<RequestExpense> {
  final ExpenseController expC = Get.put(ExpenseController());
  CameraController controller;
  final TextEditingController date = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController empName = TextEditingController();
  final TextEditingController purpose = TextEditingController();
  final TextEditingController attach = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  var empId;
  var expenseTypeId;
  var passDate;
  var employeeId;
  var amountInWords;


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
      // lastDate: DateTime.now().add(Duration(days: 30)),
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

  Future<Null> getWord(BuildContext context) {
    var converter = NumberToCharacterConverter('en');
    var amtInWords = int.parse(amount.text);
    if (amtInWords != null) {
      print(amtInWords);
      setState(() {
        amountInWords = converter.convertInt(amtInWords);
      });
    }
    print(converter);
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
                              'Request For Advance',
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
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black54),
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
                                        RemoteServices()
                                            .box
                                            .get('empid')
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black54),
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
                          child: Container(
                            height: 60.0,
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: empName,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  labelText: 'Enter Employee Name',
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                // print(pattern);
                                if (pattern.isNotEmpty) {
                                  return await RemoteServices()
                                      .getEmployees(pattern);
                                } else {
                                  employeeId = null;
                                }
                                return null;
                              },
                              hideOnEmpty: true,
                              noItemsFoundBuilder: (context) {
                                return Text('No employee found');
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion['name'],
                                  ),
                                  subtitle: Text(
                                    suggestion['empId'] +
                                        " " +
                                        "(" +
                                        suggestion['clientName'] +
                                        ")",
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                print(suggestion);
                                empName.text =
                                    suggestion['name'].toString().trimRight() +
                                        "-" +
                                        suggestion['empId'];
                                empId.text = suggestion['empId'];
                                employeeId = suggestion['empId'];
                              },
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
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                child: Container(
                                  width: 200,
                                  height: 60,
                                  child: DropdownSearch(
                                      mode: Mode.MENU,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      dropDownButton: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                        size: 18.0,
                                      ),
                                      hint: 'Purpose',
                                      showSelectedItem: true,
                                      items: expC.purpose.map((item) {
                                        print(item['expenseType']);
                                        print("items " + item['expenseType']);
                                        var sC = item['expenseType'].toString();
                                        return sC.toString();
                                      }).toList(),
                                      onChanged: (value) {
                                        for(var e in expC.exp){
                                          if(e['expenseType']==value){
                                            expenseTypeId = e['expenseTypeId'];
                                            break;
                                          }
                                        }
                                        setState(() {});
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 5.0),
                        child: Row(
                          children: [Text('Amount In Words:',style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),)],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Text(
                              amount.text == null
                                  ? amountInWords
                                  : "Amount",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            height: 150.0,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: RaisedButton(
                          onPressed: () async {
                            print('Submit');
                            FocusScope.of(context).requestFocus(FocusNode());
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
                            } else if (expC.purpose.isEmpty) {
                              Get.snackbar(
                                null,
                                'Please select atleast one Purpose Type',
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
                              print(empId);
                              print(amount.text);
                              expC.getNewEmpAdv(amount.text);
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
                          color: AppUtils().blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: AppUtils().blueColor,
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
