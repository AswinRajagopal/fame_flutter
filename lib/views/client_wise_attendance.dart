import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:hexcolor/hexcolor.dart';

import 'client_att_detail.dart';

import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ClientWiseAttendance extends StatefulWidget {
  @override
  _ClientWiseAttendanceState createState() => _ClientWiseAttendanceState();
}

class _ClientWiseAttendanceState extends State<ClientWiseAttendance> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  TextEditingController date = TextEditingController();
  var clientId;
  var shift;
  var sDate;
  var checkList = [];
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
    Future.delayed(Duration(milliseconds: 100), epC.getClientTimings);
    date.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    sDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
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
          'Client Wise Report',
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
                    print(item);
                    var sC = item.client.name;
                    if(item.client.clientShortName!=null && item.client.clientShortName!='') {
                      sC = sC + " (" + item.client.clientShortName + ") ";
                    }
                    if(sC.toString().contains('-')){
                      sC=sC.toString().replaceAll('-', '~');
                    }
                     sC =sC + ' - ' + item.client.id.toString();
                    manpowerList[item.client.id.toString()] =
                        json.encode(item.clientManpowerList);
                    print(json.encode(item.clientManpowerList));
                    return sC.toString();
                  }).toList(),
                  onChanged: (value) {
                    var splitIt = value.split('-');
                    var manpower = json.decode(manpowerList[splitIt[1].trim()]);
                    print('value: $manpower');
                    epC.timings.clear();
                    checkList.clear();
                    if (manpower != null && manpower.length > 0) {
                      clientId = manpower.first['clientId'];
                      epC.timings.clear();
                      checkList.clear();
                      // epC.shiftTime = '';
                      // epC.shift.clear();
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
                        if (!checkList.contains(manpower[j]['shift'])) {
                          epC.timings.add(addTiming);
                          checkList.add(manpower[j]['shift']);
                        }
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
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // print(shiftTime);
                                epC.shift.clear();
                                epC.shiftTime = shiftTime;
                                if (epC.shift.contains(shiftTime)) {
                                  epC.shift.remove(shiftTime);
                                  shift = null;
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
                                        color: HexColor('ccf8d8'),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            5.0,
                                          ),
                                        ),
                                        border: Border.all(
                                          color: HexColor('ccf8d8'),
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
                                      color: epC.shift.contains(shiftTime) ? HexColor('3f7f33') : Colors.grey[700],
                                      fontSize: 15.0,
                                      fontWeight: epC.shift.contains(shiftTime) ? FontWeight.w900 : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (clientId == null || sDate == null || shift == null) {
                              Get.snackbar(
                                null,
                                'Please select client, shift and date',
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
                              print('clientId: $clientId');
                              print('date: ${date.text}');
                              print('shift: $shift');
                              Get.to(ClientAttDetail(clientId, sDate, shift));
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
