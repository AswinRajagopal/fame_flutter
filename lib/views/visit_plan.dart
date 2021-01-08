import 'visit_plan_detail.dart';

import '../connection/remote_services.dart';
import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VisitPlan extends StatefulWidget {
  @override
  _VisitPlanState createState() => _VisitPlanState();
}

class _VisitPlanState extends State<VisitPlan> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  TextEditingController date = TextEditingController();
  TextEditingController empName = TextEditingController();
  var empId;
  var sDate;

  @override
  void initState() { 
    super.initState();
    date.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    sDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final DateTime curDate = DateTime.now();

  Future<Null> getDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: sDate == null
          ? curDate
          : DateTime.parse(
              sDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${date.toString()}');
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        sDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Visit Plan',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              child: TextField(
                controller: date,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Select Date',
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    size: 25.0,
                  ),
                ),
                readOnly: true,
                keyboardType: null,
                onTap: () {
                  getDate(context);
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
                          if (empId == null || sDate == null || sDate == '') {
                            Get.snackbar(
                              'Error',
                              'Please select employee and date',
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
                            print('date: ${date.text}');
                            Get.to(VisitPlanDetail(empId, sDate));
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
