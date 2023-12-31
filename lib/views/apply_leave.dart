import 'package:fame/connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/apply_leave_controller.dart';
import '../utils/utils.dart';
import '../widgets/loading_widget.dart';
import '../widgets/progress_indicator.dart';
import 'leave_page.dart';

class ApplyLeave extends StatefulWidget {
  @override
  _ApplyLeaveState createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final ApplyLeaveController alC = Get.put(ApplyLeaveController());
  var stVal = AppUtils.WHOLEDAY;
  var leaveType = '';
  TextEditingController fromDt = TextEditingController();
  TextEditingController toDt = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController empName = TextEditingController();
  var daysDiff;
  var from;
  var to;
  var sfromDt;
  var stoDt;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    alC.pr = ProgressDialog(
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
    alC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), alC.getLeaveBalance);
    super.initState();
  }

  final DateTime _frmDate = DateTime.now().add(Duration(days: 1));

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: sfromDt == null
          ? _frmDate
          : DateTime.parse(
              sfromDt.toString(),
            ),
      firstDate: DateTime.now(),
      lastDate: stoDt != null
          ? DateTime.parse(stoDt.text.toString()).add(
              Duration(days: 0),
            )
          : DateTime.now().add(Duration(days: stVal == 'F' || stVal == 'S' ? 1 : 365)),
    );

    if (picked != null) {
      print('Date selected ${_frmDate.toString()}');
      from = picked;
      if (from != null && to != null) {
        if (from.difference(to).inDays > 1 && (stVal == 'F' || stVal == 'S')) {
          Get.snackbar(
            null,
            'You cannot apply for more then 1 day for Half Day leave',
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
          if (stVal == 'F' || stVal == 'S') {
            setState(() {
              toDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
              stoDt = DateFormat('yyyy-MM-dd').format(picked).toString();
            });
          }
        }
      }
      setState(() {
        fromDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        sfromDt = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> toDate(BuildContext context) async {
    final _toDate = DateTime.parse(sfromDt.toString()).add(
      Duration(days: 0),
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: stoDt == null
          ? _toDate
          : DateTime.parse(
              stoDt.toString(),
            ),
      firstDate: DateTime.parse(sfromDt.toString()).add(
        Duration(days: 0),
      ),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${_toDate.toString()}');
      to = picked;
      if (from != null && to != null) {
        if (to.difference(from).inDays > 1 && (stVal == 'F' || stVal == 'S')) {
          Get.snackbar(
            null,
            'You cannot apply for more then 1 day for Half Day leave',
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
          setState(() {
            toDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
            stoDt = DateFormat('yyyy-MM-dd').format(picked).toString();
          });
        }
      } else {
        Get.snackbar(
          null,
          'Please select from date first',
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
    }
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(LeavePage());
  }

  void chkDate(sVal) {
    // if () {}
    print('from: $from');
    print('to: $to');
    print('sVal: $sVal');
    if (from != null && to != null) {
      print('Diff: ${to.difference(from).inDays}');
      if (sVal == 'F' || sVal == 'S') {
        if (to.difference(from).inDays > 1) {
          Get.snackbar(
            null,
            'You cannot apply for more then 1 day for Half Day leave',
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
          setState(() {
            stVal = sVal;
          });
        }
      } else {
        setState(() {
          stVal = sVal;
        });
      }
    } else {
      Get.snackbar(
        null,
        'Please select both dates first',
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
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 100), alC.init);
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Apply Leave',
        ),
        leading: IconButton(
          onPressed: backButtonPressed,
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: SafeArea(
          child: Obx(() {
            if (alC.isLoading.value) {
              return Column();
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: ListView(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 15.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Reporting Manager:',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  alC.reportingManager.value,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10.0,
                                  ),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8.0,
                                    offset: Offset(
                                      0.0,
                                      0.75,
                                    ),
                                  ),
                                ],
                              ),
                              child: Obx(() {
                                if (alC.isLoadingBalance.value) {
                                  return LoadingWidget(
                                    containerHeight: 75.0,
                                    loaderSize: 30.0,
                                    loaderColor: Colors.black87,
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Leave Balance',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: alC.leaveBalance.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                                      itemBuilder: (BuildContext context, int index) {
                                        var leaveBalance = alC.leaveBalance[index];
                                        return CustomProgressIndicator(
                                          leaveBalance['value'],
                                          leaveBalance['leaveTypeName'],
                                          75.0,
                                          double.parse(leaveBalance['fill'].toString()),
                                          footerTop: 5.0,
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),

                          SizedBox(
                            height: 10.0,
                          ),
                          RemoteServices()
                              .box
                              .get('role') ==
                              '4'|| RemoteServices().box
                              .get('role') ==
                              '3'?Padding(
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
                                  hintText: 'Enter Employee Name',
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                // print(pattern);
                                if (pattern.isNotEmpty) {
                                  return await RemoteServices().getEmployees(pattern);
                                } else {
                                  alC.empId = "888";
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
                              onSuggestionSelected: (suggestion) async {
                                print(suggestion);
                                empName.text = suggestion['name'].toString().trimRight() + ' - ' + suggestion['empId'];
                                alC.empId = suggestion['empId'];
                                Future(alC.getLeaveBalance);
                              },
                            ),
                          ):Column(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // InputDatePickerFormField(firstDate: null, lastDate: null)
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
                                      labelText: 'From Date',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),

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
                                      labelText: 'To Date',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
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
                                          null,
                                          'Please select from date',
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
                                        toDate(context);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Select Leave Type',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              isExpanded: true,
                              // value: alC.ltVal,
                              items: alC.leaveTypeList.map((item) {
                                // print('item: $item');
                                return DropdownMenuItem(
                                  child: Text(
                                    item['name'],
                                  ),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                print('value: $value');
                                setState(() {
                                  leaveType = value.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Status :',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: AppUtils.WHOLEDAY,
                                    groupValue: stVal,
                                    onChanged: (sVal) {
                                      chkDate(sVal);
                                    },
                                  ),
                                  Text(
                                    'Whole Day',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: AppUtils.FIRSTHALF,
                                    groupValue: stVal,
                                    onChanged: (sVal) {
                                      chkDate(sVal);
                                    },
                                  ),
                                  Text(
                                    'First Half',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: AppUtils.SECONDHALF,
                                    groupValue: stVal,
                                    onChanged: (sVal) {
                                      chkDate(sVal);
                                    },
                                  ),
                                  Text(
                                    'Second Half',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            child: TextField(
                              controller: reason,
                              maxLength: 200,
                              maxLengthEnforced: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Reason',
                                focusedBorder:OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                )
                              ),
                            ),
                          ),
                        ],
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
                                  print('Cancel');
                                  // Get.back();
                                  Get.offAll(LeavePage());
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
                                  print('Apply Leave');
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if (sfromDt == null || sfromDt == '' || stoDt == null || stoDt == '' || reason.text == null || reason.text == '' || leaveType == '') {
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
                                  } else {
                                    // print('fromDate: ${fromDt.text}');
                                    // print('toDate: ${toDt.text}');
                                    // print('reason: ${reason.text}');
                                    // print('dayType: $stVal');
                                    // print('leaveTypeId: $leaveType');
                                    alC.applyLeave(
                                      sfromDt,
                                      stoDt,
                                      reason.text,
                                      stVal,
                                      leaveType,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 18.0,
                                  ),
                                  child: Text(
                                    'Apply Leave',
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
              );
            }
          }),
        ),
      ),
    );
  }
}
