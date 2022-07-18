import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';
import 'emp_report_detail.dart';

class EmployeeReport extends StatefulWidget {
  @override
  _EmployeeReportState createState() => _EmployeeReportState();
}

class _EmployeeReportState extends State<EmployeeReport> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  var clientId;
  var manpowerList = {};

  @override
  void initState() {
    epC.pr = ProgressDialog(
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
    epC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      epC.getClient,
    );
    super.initState();
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
          'Employee Report',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              if (epC.isLoading.value) {
                return Column();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15.0,
                ),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSearchBox: true,
                  isFilteredOnline: true,
                  dropDownButton: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 18,
                  ),
                  hint: 'Select Client',
                  showSelectedItem: true,
                  items: epC.clientList.map((item) {
                    print(json.encode(item));
                    var sC = item['name'] + ' - ' + item['id'];
                    return sC.toString();
                  }).toList(),
                  onChanged: (value) {
                    var splitIt = value.split('-');
                    clientId = value[1].trim();
                    setState(() {});
                  },
                ),
              );
            }),
            Flexible(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[300],
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (clientId == null) {
                            Get.snackbar(
                              null,
                              'Please select client',
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
                            Get.to(EmpReportDetail(clientId));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
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
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
