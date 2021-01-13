import 'daily_emp_rep_detail.dart';

import '../connection/remote_services.dart';
import '../controllers/employee_report_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class DailyEmployeeReport extends StatefulWidget {
  @override
  _DailyEmployeeReportState createState() => _DailyEmployeeReportState();
}

class _DailyEmployeeReportState extends State<DailyEmployeeReport> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  TextEditingController fromDt = TextEditingController();
  TextEditingController toDt = TextEditingController();
  TextEditingController empName = TextEditingController();
  var empId;
  var sfromDate;
  var stoDate;

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final DateTime _frmDate = DateTime.now();

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: sfromDate == null
          ? _frmDate
          : DateTime.parse(
              sfromDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365)),
      lastDate: stoDate != null
          ? DateTime.parse(stoDate.toString()).add(
              Duration(days: 0),
            )
          : DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${_frmDate.toString()}');
      setState(() {
        fromDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        sfromDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> toDate(BuildContext context) async {
    final _toDate = DateTime.parse(sfromDate.toString()).add(
      Duration(days: 0),
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: stoDate == null
          ? _toDate
          : DateTime.parse(
              stoDate.toString(),
            ),
      firstDate: DateTime.parse(sfromDate.toString()).add(
        Duration(days: 0),
      ),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${_toDate.toString()}');
      setState(() {
        toDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        stoDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Daily Employee Report',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      controller: fromDt,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
           // fontWeight: FontWeight.bold,
                        ),
                        hintText: 'From date',
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 25.0,
                        ),
                      ),
                      readOnly: true,
                      keyboardType: null,
                      onTap: () {
                        fromDate(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextField(
                      controller: toDt,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
           // fontWeight: FontWeight.bold,
                        ),
                        hintText: 'To date',
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 25.0,
                        ),
                      ),
                      readOnly: true,
                      keyboardType: null,
                      onTap: () {
                        if (fromDt.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please select from date',
                            colorText: Colors.white,
                            backgroundColor: Colors.black87,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 10.0,
                            ),
                          );
                        } else {
                          toDate(context);
                        }
                      },
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
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: empName,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                      // fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Employee name',
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  // print(pattern);
                  if (pattern.isNotEmpty) {
                    return await RemoteServices().getEmployees(pattern);
                  } else {
                    empId = null;
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
                      suggestion['empId'],
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print(suggestion);
                  print(suggestion['name']);
                  empName.text = suggestion['name'].toString().trimRight() + ' - ' + suggestion['empId'];
                  empId = suggestion['empId'];
                },
              ),
            ),
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
                          if (empId == null || sfromDate == null || stoDate == null) {
                            Get.snackbar(
                              'Error',
                              'Please select employee, from date & to date',
                              colorText: Colors.white,
                              backgroundColor: Colors.black87,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10.0,
                              ),
                            );
                          } else {
                            print('empId: $empId');
                            print('fromDate: ${fromDt.text}');
                            print('toDate: ${toDt.text}');
                            Get.to(DailyEmpRepDetail(empId, sfromDate, stoDate));
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
