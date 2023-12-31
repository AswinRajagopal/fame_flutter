import 'package:fame/controllers/visit_plan_controller.dart';

import 'visit_plan_detail.dart';

import '../connection/remote_services.dart';
import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VisitPlan extends StatefulWidget {
  String user;
  VisitPlan({this.user});

  @override
  _VisitPlanState createState() => _VisitPlanState();
}

class _VisitPlanState extends State<VisitPlan> {
  // final EmployeeReportController epC = Get.put(EmployeeReportController());
  final VisitPlanController vpC = Get.put(VisitPlanController());
  TextEditingController frmDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController empName = TextEditingController();
  var empId;
  var fDate;
  var tDate;

  bool allEmployees = false;

  void _allEmployees(bool newValue) => setState(() {
    allEmployees = newValue;
    if (allEmployees == true) {
      vpC.getPitstopByFromToDate(empId, fDate, tDate);
    } else {}
  });

  @override
  void initState() {
    super.initState();
    frmDate.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    toDate.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    fDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
    tDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
    if (widget.user != null) {
      empId = RemoteServices().box.get('empid');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final DateTime curDate = DateTime.now();

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fDate == null
          ? curDate
          : DateTime.parse(
              fDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365 * 2)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${frmDate.toString()}');
      setState(() {
        frmDate.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        fDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> lastDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tDate == null
          ? curDate
          : DateTime.parse(
              tDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365 * 2)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${tDate.toString()}');
      setState(() {
        toDate.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        tDate = DateFormat('yyyy-MM-dd').format(picked).toString();
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
            Visibility(
              visible: widget.user != null ? false : true,
              child: Padding(
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
                      hintText: 'Employee Name',
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
                    empName.text = suggestion['name'].toString().trimRight() +
                        ' - ' +
                        suggestion['empId'];
                    empId = suggestion['empId'];
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [Text('From Date')],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              child: TextField(
                controller: frmDate,
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
                  fromDate(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [Text('To Date')],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              child: TextField(
                controller: toDate,
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
                  lastDate(context);
                },
              ),
            ),
        SizedBox(
          height:10.0 ,
        ),
        Visibility(
          visible: widget.user != null ? false : true,
            child:Row(children: [
              Container(
                width: 150.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                ),
                child: Row(children: [
                  Checkbox(value: allEmployees, onChanged: _allEmployees),
                  Text('AllEmployees')
                ]),
              ),
            ]),),
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
                          if (fDate == null ||
                              fDate == '' ||
                              tDate == null ||
                              tDate == '') {
                            Get.snackbar(
                              null,
                              'Please select employee and date',
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
                            print('empId: $empId');
                            print('fromdate: ${frmDate.text}');
                            print('todate:${toDate.text}');
                            Get.to(VisitPlanDetail(empId, fDate, tDate));
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
