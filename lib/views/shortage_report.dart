import 'dart:convert';

import 'shortage_report_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class ShortageReport extends StatefulWidget {
  @override
  _ShortageReportState createState() => _ShortageReportState();
}

class _ShortageReportState extends State<ShortageReport> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  TextEditingController date = TextEditingController();
  var clientId;
  var shift;
  var selectedDate;

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
    Future.delayed(Duration(milliseconds: 100), epC.getClientTimings);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final DateTime curDate = DateTime.now();

  Future<Null> getDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate == null
          ? curDate
          : DateTime.parse(
              selectedDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${date.toString()}');
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        selectedDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Shortage Report',
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (epC.isLoading.value) {
            return Column();
          }
          return Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                child: DropdownButtonFormField<String>(
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Select Client',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  // value: aC.clientList.first.client.id.toString(),
                  items: epC.clientList.map((item) {
                    // print('item: ${item.client.id}');
                    var sC = item.client.name + ' - ' + item.client.id.toString();
                    return DropdownMenuItem(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          sC.toString(),
                        ),
                      ),
                      value: json.encode(item.clientManpowerList),
                    );
                  }).toList(),
                  onChanged: (value) {
                    var manpower = json.decode(value);
                    // print('value: $manpower');
                    clientId = manpower.first['clientId'];
                    epC.timings.clear();
                    epC.shiftTime = '';
                    epC.shift.clear();
                    shift = null;
                    for (var j = 0; j < manpower.length; j++) {
                      // print('manpower: ${manpower[j]}');
                      manpower[j]['shiftStartTime'] = manpower[j]['shiftStartTime'].split(':').first.length == 1 ? '0' + manpower[j]['shiftStartTime'] : manpower[j]['shiftStartTime'];
                      manpower[j]['shiftEndTime'] = manpower[j]['shiftEndTime'].split(':').first.length == 1 ? '0' + manpower[j]['shiftEndTime'] : manpower[j]['shiftEndTime'];
                      var sSTime = DateFormat('hh:mm')
                              .format(
                                DateTime.parse(
                                  '2020-12-20 ' + manpower[j]['shiftStartTime'],
                                ),
                              )
                              .toString() +
                          DateFormat('a')
                              .format(
                                DateTime.parse(
                                  '2020-12-20 ' + manpower[j]['shiftStartTime'],
                                ),
                              )
                              .toString()
                              .toLowerCase();
                      var sETime = DateFormat('hh:mm')
                              .format(
                                DateTime.parse(
                                  '2020-12-20 ' + manpower[j]['shiftEndTime'],
                                ),
                              )
                              .toString() +
                          DateFormat('a')
                              .format(
                                DateTime.parse(
                                  '2020-12-20 ' + manpower[j]['shiftEndTime'],
                                ),
                              )
                              .toString()
                              .toLowerCase();
                      var addTiming = {
                        'shift': manpower[j]['shift'],
                        'shiftStartTime': sSTime,
                        'shiftEndTime': sETime,
                      };
                      print(epC.timings.contains(addTiming));
                      if (!epC.timings.contains(addTiming)) {
                        epC.timings.add(addTiming);
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
                ),
                child: Row(
                  children: [
                    Text(
                      'Select Timing :',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (epC.timings.isNullOrBlank) {
                  return Container(
                    height: 180.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 5.0,
                              ),
                              child: Text(
                                'Please select client',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  height: 180.0,
                  child: StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    itemCount: epC.timings.length,
                    itemBuilder: (context, index) {
                      // print(aC.timings);
                      var timing = epC.timings[index];
                      var shiftTime = timing['shiftStartTime'] + ' - ' + timing['shiftEndTime'];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // print(shiftTime);
                              epC.shift.clear();
                              epC.shiftTime = shiftTime;
                              if (epC.shift.contains(shiftTime)) {
                                epC.shift.remove(shiftTime);
                              } else {
                                epC.shift.add(shiftTime);
                                shift = timing['shift'];
                              }
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: epC.shift.contains(shiftTime)
                                  ? BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          5.0,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                    )
                                  : BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          5.0,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  shiftTime,
                                  style: TextStyle(
                                    color: epC.shift.contains(shiftTime) ? Colors.green[700] : Colors.grey[700],
                                    fontSize: 15.0,
                                    fontWeight: epC.shift.contains(shiftTime) ? FontWeight.w900 : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
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
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (clientId == null || selectedDate == null || shift == null) {
                              Get.snackbar(
                                'Error',
                                'Please select client, shift and date',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                              );
                            } else {
                              print('clientId: $clientId');
                              print('date: ${date.text}');
                              print('shift: $shift');
                              Get.to(ShortageReportDetail(clientId, selectedDate, shift));
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
          );
        }),
      ),
    );
  }
}
