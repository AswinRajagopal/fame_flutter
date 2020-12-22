import 'package:intl/intl.dart';

import '../widgets/custom_app_bar.dart';

import '../utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/apply_leave_controller.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    alC.pr.style(
      backgroundColor: Colors.black,
    );
    super.initState();
  }

  final DateTime _frmDate = DateTime.now().add(Duration(days: 1));

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDt.text.isEmpty
          ? _frmDate
          : DateTime.parse(
              fromDt.text.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: toDt.text != ''
          ? DateTime.parse(toDt.text.toString()).add(
              Duration(days: -1),
            )
          : DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${_frmDate.toString()}');
      setState(() {
        fromDt.text = DateFormat('yyyy-M-d').format(picked).toString();
      });
    }
  }

  Future<Null> toDate(BuildContext context) async {
    final _toDate = DateTime.parse(fromDt.text.toString()).add(
      Duration(days: 1),
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: toDt.text.isEmpty
          ? _toDate
          : DateTime.parse(
              toDt.text.toString(),
            ),
      firstDate: DateTime.parse(fromDt.text.toString()).add(
        Duration(days: 1),
      ),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${_toDate.toString()}');
      setState(() {
        toDt.text = DateFormat('yyyy-M-d').format(picked).toString();
      });
    }
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(LeavePage());
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 100), alC.init);
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CustomAppBar('Apply Leave'),
      ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: SafeArea(
          child: Obx(() {
            if (alC.isLoading.value) {
              return Column();
            } else {
              return Column(
                children: [
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
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
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
                                  backgroundColor: Colors.red,
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
                          'Select leave type',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
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
                            fontWeight: FontWeight.bold,
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
                              setState(() {
                                stVal = sVal;
                              });
                            },
                          ),
                          Text(
                            'Whole day',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
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
                              setState(() {
                                stVal = sVal;
                              });
                            },
                          ),
                          Text(
                            'First half',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
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
                              setState(() {
                                stVal = sVal;
                              });
                            },
                          ),
                          Text(
                            'Second half',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
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
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Reason',
                      ),
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
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                print('Apply Leave');
                                FocusScope.of(context).requestFocus(FocusNode());
                                if (fromDt.text == null || fromDt.text == '' || toDt.text == null || toDt.text == '' || reason.text == null || reason.text == '' || leaveType == '') {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill all data',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 10.0,
                                    ),
                                  );
                                } else {
                                  // print('fromDate: ${fromDt.text}');
                                  // print('toDate: ${toDt.text}');
                                  // print('reason: ${reason.text}');
                                  // print('dayType: $stVal');
                                  // print('leaveTypeId: $leaveType');
                                  alC.applyLeave(
                                    fromDt.text,
                                    toDt.text,
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
              );
            }
          }),
        ),
      ),
    );
  }
}
