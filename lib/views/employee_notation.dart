import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/attendance_controller.dart';
import 'package:fame/models/employee_notations.dart';
import '../utils/debounce_class.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../controllers/employee_notations_controller.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../utils/utils.dart';

// import 'attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeNotation extends StatefulWidget {
  final String date;
  final String clientId;
  final String status;
  final String shift;
  final String time;

  EmployeeNotation(
    this.date,
    this.clientId,
    this.status,
    this.shift,
    this.time,
  );

  @override
  _EmployeeNotationState createState() => _EmployeeNotationState();
}

class _EmployeeNotationState extends State<EmployeeNotation> {
  final AttendanceController aC = Get.put(AttendanceController());
  final EmployeeNotationsController enC =
      Get.put(EmployeeNotationsController());
  TextEditingController cRemark = TextEditingController();
  TextEditingController otT = TextEditingController();
  TextEditingController ltT = TextEditingController();
  TextEditingController searchQuery = TextEditingController();
  bool isSearching = false;
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
    size: 30.0,
  );
  String searchText = '';
  Widget appBarTitle;
  final _debouncer = Debouncer(milliseconds: 500);
  bool allShifts = false;
  bool allPresent = true;

  void _onAllShifts(bool newValue) => setState(() {
        allShifts = newValue;

        if (allShifts) {
          allPresent = false;
          enC.getEmployeeBySearch(widget.date, widget.clientId, widget.time,
              '', true);
        } else {
          allPresent = true;
          enC.searchList.clear();
          enC.getNotations(
            widget.date,
            widget.shift,
            widget.clientId,
            AppUtils.NAME,
            widget.status,
          );
        }
      });

  @override
  void initState() {
    appBarTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '#' +
              widget.clientId +
              ' ' +
              widget.date.split('-')[2] +
              '-' +
              widget.date.split('-')[1] +
              '-' +
              widget.date.split('-')[0],
        ),
        Text(
          widget.time,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
    enC.pr = ProgressDialog(
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
    enC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      enC.getNotations(
        widget.date,
        widget.shift,
        widget.clientId,
        AppUtils.NAME,
        widget.status,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleSearchStart() {
    setState(() {
      isSearching = true;
    });
  }

  void handleSearchEnd() {
    setState(() {
      actionIcon = Icon(
        Icons.search,
        color: Colors.white,
        size: 30.0,
      );
      appBarTitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#' +
                widget.clientId +
                ' ' +
                widget.date.split('-')[2] +
                '-' +
                widget.date.split('-')[1] +
                '-' +
                widget.date.split('-')[0],
          ),
          Text(
            widget.time,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white70,
            ),
          ),
        ],
      );
      isSearching = false;
      enC.searchList.clear();
      searchQuery.clear();
    });
  }

  void onSearchTextChanged(String text) async {
    print('searching from API');
    enC.searchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    await enC.getNotationsBySearch(
        widget.date, widget.clientId, widget.time, text);

    print('enC.searchList: ${enC.searchList}');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (actionIcon.icon == Icons.search) {
                  actionIcon = Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30.0,
                  );
                  appBarTitle = TextField(
                    controller: searchQuery,
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                    onChanged: (query) {
                      // onSearchTextChanged(query);
                      _debouncer.run(() {
                        onSearchTextChanged(query);
                      });
                    },
                  );
                  handleSearchStart();
                } else {
                  handleSearchEnd();
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              8.0,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: enC.oB == AppUtils.NAME
                            ? null
                            : () {
                                enC.searchList.clear();
                                enC.getNotations(
                                  widget.date,
                                  widget.shift,
                                  widget.clientId,
                                  AppUtils.NAME,
                                  widget.status,
                                );
                                enC.oB = AppUtils.NAME;
                                enC.l.value = 0;
                                enC.p.value = 0;
                                enC.wo.value = 0;
                                enC.a.value = 0;
                                setState(() {});
                              },
                        child: CustomContainer(
                          'Name',
                          Icons.arrow_downward,
                          enC.oB == AppUtils.NAME ? 'yes' : '',
                        ),
                      ),
                      GestureDetector(
                        onTap: enC.oB == AppUtils.EMP_ID
                            ? null
                            : () {
                                enC.oB = AppUtils.EMP_ID;
                                enC.searchList.clear();
                                enC.getNotations(
                                  widget.date,
                                  widget.shift,
                                  widget.clientId,
                                  AppUtils.EMP_ID,
                                  widget.status,
                                );
                                enC.oB = AppUtils.EMP_ID;
                                enC.l.value = 0;
                                enC.p.value = 0;
                                enC.wo.value = 0;
                                enC.a.value = 0;
                                setState(() {});
                              },
                        child: CustomContainer(
                          'Emp ID',
                          Icons.arrow_downward,
                          enC.oB == AppUtils.EMP_ID ? 'yes' : '',
                        ),
                      ),
                      GestureDetector(
                        onTap: enC.oB == AppUtils.ATTENDANCE
                            ? null
                            : () {
                                enC.searchList.clear();
                                enC.getNotations(
                                  widget.date,
                                  widget.shift,
                                  widget.clientId,
                                  AppUtils.ATTENDANCE,
                                  widget.status,
                                );
                                enC.oB = AppUtils.ATTENDANCE;
                                enC.l.value = 0;
                                enC.p.value = 0;
                                enC.wo.value = 0;
                                enC.a.value = 0;
                                setState(() {});
                              },
                        child: CustomContainer(
                          'Attendance',
                          Icons.arrow_downward,
                          enC.oB == AppUtils.ATTENDANCE ? 'yes' : '',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ),
                      ),
                    ),
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'P : ${enC.p.value.toString()}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.grey[400],
                            indent: 8.0,
                            endIndent: 8.0,
                          ),
                          Text(
                            'W.O. : ${enC.wo.value.toString()}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.grey[400],
                            indent: 8.0,
                            endIndent: 8.0,
                          ),
                          Text(
                            'L : ${enC.l.value.toString()}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.grey[400],
                            indent: 8.0,
                            endIndent: 8.0,
                          ),
                          Text(
                            'A : ${enC.a.value.toString()}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5.0),
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Row(
                          children: [
                            Visibility(
                                child: Checkbox(
                                    value: allShifts, onChanged: _onAllShifts)),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: FlatButton(
                                splashColor: Colors.grey[100],
                                color: Colors.white,
                                textColor: Colors.black,
                                child: Text(
                                  'All Shifts',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 130.0,
                      ),
                      Container(
                        width: 150,
                        height: 50,
                        child: allPresent?RaisedButton(
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          onPressed: () async {
                            ProgressDialog pr;
                            try {
                              pr = ProgressDialog(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
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
                              pr.style(
                                backgroundColor: Colors.white,
                              );
                              await pr.show();
                              var bulkRes = await RemoteServices()
                                  .getBulkAttendance(
                                      widget.shift, widget.clientId);
                              print('res:$bulkRes');
                              if (bulkRes != null) {
                                await pr.hide();
                                print('bulkRes valid: ${bulkRes['success']}');
                                if (bulkRes['success']) {
                                  enC.pr = ProgressDialog(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                  Future.delayed(
                                      Duration(milliseconds: 100),
                                      () => enC.getNotations(
                                            widget.date,
                                            widget.shift,
                                            widget.clientId,
                                            AppUtils.NAME,
                                            widget.status,
                                          ));
                                } else {}
                              }
                            } catch (e) {
                              print(e);
                              await pr.hide();
                              Get.snackbar(
                                null,
                                'Something went wrong! Please try again later',
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
                          },
                          child: Text(
                            'All Present',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ):Container(),
                      )
                    ]),
              ],
            ),
            Positioned(
              top: 200.0,
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Obx(() {
                if (enC.isLoading.value ||
                    (searchQuery.text.isNotEmpty &&
                        enC.isSearchingNotations.value)) {
                  return Column();
                } else if ((enC.res == null ||
                        enC.res['empDailyAttView'] == null) &&
                    (searchQuery.text.isEmpty && enC.searchList.isEmpty)) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  );
                } else if (searchQuery.text.isNotEmpty &&
                    enC.searchList.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  );
                }

                return Scrollbar(
                  radius: Radius.circular(
                    10.0,
                  ),
                  thickness: 5.0,
                  child: Obx(() {
                    print('des: ${enC.designationSort}');
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: enC.searchList.isNotEmpty
                          ? enC.searchList.length
                          : enC.res['empDailyAttView'].length,
                      itemBuilder: (context, index) {
                        var emp = enC.searchList.isNotEmpty
                            ? enC.searchList[index]
                            : enC.res['empDailyAttView'][index];
                        print(
                            'emp des: ${int.parse(emp['designation'].toString())}');
                        var not = enC.res['attendance_notations'];
                        var appRej = enC.aprrej;
                        var stDate = DateFormat.jm().parse(widget.time
                            .toString()
                            .split(' - ')
                            .first
                            .replaceAll('am', ' AM')
                            .replaceAll('pm', ' PM'));
                        var start = widget.date +
                            ' ' +
                            DateFormat('HH:mm').format(stDate);
                        var endDate = DateFormat.jm().parse(widget.time
                            .toString()
                            .split(' - ')
                            .last
                            .replaceAll('am', ' AM')
                            .replaceAll('pm', ' PM'));
                        var end = widget.date +
                            ' ' +
                            DateFormat('HH:mm').format(endDate);
                        var stDt = DateTime.parse(start);
                        var endDt = DateTime.parse(end);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          // height: 100.0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 18.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 310.0,
                                          child: Text(
                                            emp['empId'] +
                                                " " +
                                                emp['name']
                                                    .toString()
                                                    .trimRight(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 310.0,
                                          child: Text(
                                            enC.designationSort.isEmpty
                                                ? 'No designation'
                                                : enC.designationSort[int.parse(
                                                    emp['designation']
                                                        .toString())]['design'],
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        Visibility(
                                          visible: emp['showTime'] != ''
                                              ? true
                                              : emp['overTime'] != null
                                                  ? true
                                                  : false,
                                          child: Text(
                                            emp['showTime'] != ''
                                                ? emp['showTime']
                                                : emp['overTime'] != null
                                                    ? 'O.T. - ' +
                                                        emp['overTime'] +
                                                        ' hours'
                                                    : '',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: emp['oldEmpid'] != '' &&
                                                  emp['oldEmpid'] != null
                                              ? true
                                              : false,
                                          child: Text(
                                            emp['oldEmpid'] != '' &&
                                                    emp['oldEmpid'] != null
                                                ? 'Old EmpId : ' +
                                                    emp['oldEmpid']
                                                : '',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    emp['attendanceAlias'] != null &&
                                            emp['attendanceAlias'] != ''
                                        ? Visibility(
                                            visible: emp['showButton'] ?? true,
                                            child: RaisedButton(
                                              onPressed: () async {
                                                await Get.defaultDialog(
                                                  title: 'Are you sure?',
                                                  content: Text(
                                                    'You want to clear the attendance?',
                                                  ),
                                                  barrierDismissible: false,
                                                  radius: 5.0,
                                                  onConfirm: () async {
                                                    Get.back();
                                                    var attRes = await enC
                                                        .giveAttendance(
                                                      widget.date,
                                                      widget.shift,
                                                      widget.clientId,
                                                      '',
                                                      emp['empId'],
                                                      emp['designation'],
                                                      emp['showType'] ==
                                                              'apprej'
                                                          ? emp[
                                                              'attendanceAlias']
                                                          : '',
                                                      stDt,
                                                      endDt,
                                                      extraName: 'Clear',
                                                      extraParam: '',
                                                    );
                                                    if (attRes) {
                                                      if (emp['attendanceAlias'] ==
                                                          'P') {
                                                        enC.p.value--;
                                                      } else if (emp[
                                                              'attendanceAlias'] ==
                                                          'WO') {
                                                        enC.wo.value--;
                                                      } else if (emp[
                                                              'attendanceAlias'] ==
                                                          'L') {
                                                        enC.l.value--;
                                                      } else if (emp[
                                                              'attendanceAlias'] ==
                                                          'A') {
                                                        enC.a.value--;
                                                      }
                                                      emp['attendanceAlias'] =
                                                          '';
                                                      emp['overTime'] = null;
                                                      emp['lt'] = null;
                                                      if (emp['showType'] ==
                                                          'apprej') {
                                                        emp['status'] = '0';
                                                      }
                                                      setState(() {});
                                                    }
                                                  },
                                                  onCancel: () {},
                                                  confirmTextColor:
                                                      Colors.white,
                                                  textConfirm: 'Yes',
                                                  textCancel: 'No',
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                  vertical: 10.0,
                                                ),
                                                child: Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              color: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5.0,
                                                ),
                                                side: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Visibility(
                                            visible: emp['showButton'] ?? true,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Get.defaultDialog(
                                                  title:
                                                      'Remarks for ${emp['name']}',
                                                  content: TextField(
                                                    controller: cRemark,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(
                                                        10.0,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      hintText: 'Enter remarks',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  radius: 5.0,
                                                  barrierDismissible: false,
                                                  onConfirm: () {
                                                    if (cRemark.text != '') {
                                                      // client['remarks'] =
                                                      //     cRemark.text;
                                                      emp['remarks'] =
                                                          cRemark.text;
                                                      cRemark.text = '';
                                                      Get.back();
                                                    }
                                                  },
                                                  onCancel: () {
                                                    cRemark.text = '';
                                                  },
                                                  confirmTextColor:
                                                      Colors.white,
                                                  textConfirm: 'Add',
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                  vertical: 10.0,
                                                ),
                                                child: Text(
                                                  'Remarks',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              color: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5.0,
                                                ),
                                                side: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                emp['showType'] == 'remark' ||
                                        emp['showType'] == 'hideapprej'
                                    ? Container()
                                    : emp['showType'] == 'apprej'
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ChipsChoice<String>.single(
                                                value: emp['status'] == '1'
                                                    ? 'Approve'
                                                    : emp['status'] == '2'
                                                        ? 'Reject'
                                                        : '',
                                                onChanged: emp['status'] != '0'
                                                    ? (val) {}
                                                    : (val) async {
                                                        var atRes;
                                                        print(val);
                                                        if (val == 'Modify') {
                                                          TimeRange result =
                                                              await showTimeRangePicker(
                                                            context: context,
                                                            paintingStyle:
                                                                PaintingStyle
                                                                    .fill,
                                                            labels: [
                                                              '12 PM',
                                                              '3 AM',
                                                              '6 AM',
                                                              '9 AM',
                                                              '12 AM',
                                                              '3 PM',
                                                              '6 PM',
                                                              '9 PM',
                                                            ]
                                                                .asMap()
                                                                .entries
                                                                .map((e) {
                                                              return ClockLabel
                                                                  .fromIndex(
                                                                idx: e.key,
                                                                length: 8,
                                                                text: e.value,
                                                              );
                                                            }).toList(),
                                                            labelOffset: 35,
                                                            rotateLabels: false,
                                                            padding: 60,
                                                          );
                                                          if (result != null) {
                                                            var sth = result
                                                                .startTime.hour;
                                                            var stm = result
                                                                .startTime
                                                                .minute;
                                                            var enh = result
                                                                .endTime.hour;
                                                            var enm = result
                                                                .endTime.minute;
                                                            var stH = sth < 10
                                                                ? '0' +
                                                                    sth.toString()
                                                                : sth;
                                                            var stM = stm < 10
                                                                ? '0' +
                                                                    stm.toString()
                                                                : stm;
                                                            var enH = enh < 10
                                                                ? '0' +
                                                                    enh.toString()
                                                                : enh;
                                                            var enM = enm < 10
                                                                ? '0' +
                                                                    enm.toString()
                                                                : enm;
                                                            var dt =
                                                                widget.date;
                                                            var start = dt +
                                                                ' $stH:$stM:00.000';
                                                            var end = dt +
                                                                ' $enH:$enM:00.000';
                                                            var stDt =
                                                                DateTime.parse(
                                                                    start);
                                                            var endDt =
                                                                DateTime.parse(
                                                                    end);
                                                            atRes = await enC
                                                                .giveAttendance(
                                                              widget.date,
                                                              widget.shift,
                                                              widget.clientId,
                                                              val,
                                                              emp['empId'],
                                                              emp['designation'],
                                                              '',
                                                              stDt,
                                                              endDt,
                                                            );
                                                            if (atRes) {
                                                              emp['attendanceAlias'] =
                                                                  val;
                                                              emp['status'] =
                                                                  '1';
                                                              // Future.delayed(Duration(milliseconds: 100), () {
                                                              //   enC.getNotations(
                                                              //     widget.date,
                                                              //     widget.shift,
                                                              //     widget.clientId,
                                                              //     AppUtils.NAME,
                                                              //     widget.status,
                                                              //   );
                                                              // });
                                                            }
                                                            setState(() {});
                                                          }
                                                        } else {
                                                          atRes = await enC
                                                              .giveAttendance(
                                                            widget.date,
                                                            widget.shift,
                                                            widget.clientId,
                                                            val,
                                                            emp['empId'],
                                                            emp['designation'],
                                                            '',
                                                            stDt,
                                                            endDt,
                                                            // extraName: 'OverTime',
                                                            // extraParam: emp['overTime'],
                                                          );
                                                          if (atRes) {
                                                            emp['attendanceAlias'] =
                                                                val;
                                                            if (val ==
                                                                'Reject') {
                                                              emp['status'] =
                                                                  '2';
                                                            } else {
                                                              emp['status'] =
                                                                  '1';
                                                            }
                                                          }
                                                          setState(() {});
                                                        }
                                                      },
                                                choiceItems: C2Choice.listFrom<
                                                    String, dynamic>(
                                                  source: appRej,
                                                  value: (i, v) =>
                                                      appRej[i]['value'],
                                                  label: (i, v) =>
                                                      appRej[i]['label'],
                                                ),
                                                wrapped: true,
                                                padding: EdgeInsets.all(0),
                                                choiceActiveStyle:
                                                    C2ChoiceStyle(
                                                  showCheckmark: false,
                                                  brightness: Brightness.dark,
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      5.0,
                                                    ),
                                                  ),
                                                ),
                                                choiceStyle: C2ChoiceStyle(
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      5.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ChipsChoice<String>.single(
                                              value: emp['attendanceAlias'],
                                              onChanged: (val) async {
                                                // print(val);
                                                // print(emp['attendanceAlias']);
                                                // var ot = '';
                                                // var lt = '';
                                                print('jay');
                                                print(val);
                                                var attendanceRes;
                                                if ((val == 'OT' &&
                                                    emp['attendanceAlias'] ==
                                                        'OT')) {
                                                  otT.text = emp['overTime'];
                                                  await Get.defaultDialog(
                                                    title: 'OT hours',
                                                    content: TextField(
                                                      controller: otT,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        hintText: 'hours',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    radius: 5.0,
                                                    barrierDismissible: false,
                                                    onCancel: () {
                                                      otT.text = '';
                                                    },
                                                  );
                                                }
                                                if ((val == 'JOT' &&
                                                    emp['attendanceAlias'] ==
                                                        'JOT')) {
                                                  otT.text = emp['overTime'];
                                                  await Get.defaultDialog(
                                                    title: 'OT hours',
                                                    content: TextField(
                                                      controller: otT,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        hintText: 'hours',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    radius: 5.0,
                                                    barrierDismissible: false,
                                                    onCancel: () {
                                                      otT.text = '';
                                                    },
                                                  );
                                                }
                                                if ((val == 'COP' &&
                                                    emp['attendanceAlias'] ==
                                                        'COP')) {
                                                  otT.text = emp['overTime'];
                                                  await Get.defaultDialog(
                                                    title: 'OT hours',
                                                    content: TextField(
                                                      controller: otT,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        hintText: 'hours',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    radius: 5.0,
                                                    barrierDismissible: false,
                                                    onCancel: () {
                                                      otT.text = '';
                                                    },
                                                  );
                                                }
                                                if ((val == 'WOP' &&
                                                    emp['attendanceAlias'] ==
                                                        'WOP')) {
                                                  otT.text = emp['overTime'];
                                                  await Get.defaultDialog(
                                                    title: 'OT hours',
                                                    content: TextField(
                                                      controller: otT,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        hintText: 'hours',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    radius: 5.0,
                                                    barrierDismissible: false,
                                                    onCancel: () {
                                                      otT.text = '';
                                                    },
                                                  );
                                                }
                                                if (val == 'LT' &&
                                                    emp['attendanceAlias'] ==
                                                        'LT') {
                                                  ltT.text = emp['lt'];
                                                  await Get.defaultDialog(
                                                    title: 'Late',
                                                    content: TextField(
                                                      controller: ltT,
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        hintText: 'minutes',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    radius: 5.0,
                                                    barrierDismissible: false,
                                                    onCancel: () {
                                                      ltT.text = '';
                                                    },
                                                  );
                                                }
                                                if (emp['attendanceAlias'] ==
                                                        null ||
                                                    emp['attendanceAlias'] ==
                                                        '' ||
                                                    (emp['attendanceAlias'] ==
                                                            'P' &&
                                                        val == 'OT')) {
                                                  var empRemarks = '';
                                                  if (emp['remarks'] != null) {
                                                    empRemarks = emp['remarks'];
                                                  }
                                                  if (val == 'OT' ||
                                                      val == 'JOT' ||
                                                      val == 'COP' ||
                                                      val == 'WOP') {
                                                    otT.text = '';
                                                    await Get.defaultDialog(
                                                      title: 'OT hours',
                                                      content: TextField(
                                                        controller: otT,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        autofocus: true,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                            10.0,
                                                          ),
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          hintText: 'hours',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      radius: 5.0,
                                                      barrierDismissible: false,
                                                      onConfirm: () async {
                                                        if (otT.text != '') {
                                                          emp['overTime'] =
                                                              otT.text;
                                                          otT.text = '';
                                                          Get.back();
                                                          attendanceRes =
                                                              await enC
                                                                  .giveAttendance(
                                                            widget.date,
                                                            widget.shift,
                                                            widget.clientId,
                                                            val,
                                                            emp['empId'],
                                                            emp['designation'],
                                                            empRemarks,
                                                            stDt,
                                                            endDt,
                                                            extraName:
                                                                'OverTime',
                                                            extraParam:
                                                                emp['overTime'],
                                                          );
                                                          if (attendanceRes) {
                                                            if (emp['attendanceAlias'] !=
                                                                null) {
                                                              if (emp['attendanceAlias'] ==
                                                                  'P') {
                                                                enC.p.value--;
                                                              } else if (emp[
                                                                      'attendanceAlias'] ==
                                                                  'WO') {
                                                                enC.wo.value--;
                                                              } else if (emp[
                                                                      'attendanceAlias'] ==
                                                                  'L') {
                                                                enC.l.value--;
                                                              } else if (emp[
                                                                      'attendanceAlias'] ==
                                                                  'A') {
                                                                enC.a.value--;
                                                              }
                                                            }
                                                            emp['lt'] = null;
                                                            emp['attendanceAlias'] =
                                                                val;
                                                            if (val == 'P') {
                                                              enC.p.value++;
                                                            } else if (val ==
                                                                'WO') {
                                                              enC.wo.value++;
                                                            } else if (val ==
                                                                'L') {
                                                              enC.l.value++;
                                                            } else if (val ==
                                                                'A') {
                                                              enC.a.value++;
                                                            }
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      onCancel: () {
                                                        otT.text = '';
                                                      },
                                                      confirmTextColor:
                                                          Colors.white,
                                                      textConfirm: 'Submit',
                                                    );
                                                  } else if (val == 'LT') {
                                                    ltT.text = '';
                                                    await Get.defaultDialog(
                                                      title: 'Late',
                                                      content: TextField(
                                                        controller: ltT,
                                                        autofocus: true,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                            10.0,
                                                          ),
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          hintText: 'minutes',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      radius: 5.0,
                                                      barrierDismissible: false,
                                                      onConfirm: () async {
                                                        if (ltT.text != '') {
                                                          emp['lt'] = ltT.text;
                                                          ltT.text = '';
                                                          Get.back();
                                                          attendanceRes =
                                                              await enC
                                                                  .giveAttendance(
                                                            widget.date,
                                                            widget.shift,
                                                            widget.clientId,
                                                            val,
                                                            emp['empId'],
                                                            emp['designation'],
                                                            empRemarks,
                                                            stDt,
                                                            endDt,
                                                            extraName: 'Late',
                                                            extraParam:
                                                                emp['lt'],
                                                          );
                                                          if (attendanceRes) {
                                                            if (emp['attendanceAlias'] !=
                                                                null) {
                                                              if (emp['attendanceAlias'] ==
                                                                  'P') {
                                                                enC.p.value--;
                                                              } else if (emp[
                                                                      'attendanceAlias'] ==
                                                                  'WO') {
                                                                enC.wo.value--;
                                                              } else if (emp[
                                                                      'attendanceAlias'] ==
                                                                  'L') {
                                                                enC.l.value--;
                                                              } else if (emp[
                                                                      'attendanceAlias'] ==
                                                                  'A') {
                                                                enC.a.value--;
                                                              }
                                                            }
                                                            emp['attendanceAlias'] =
                                                                val;
                                                            emp['overTime'] =
                                                                null;
                                                            if (val == 'P') {
                                                              enC.p.value++;
                                                            } else if (val ==
                                                                'WO') {
                                                              enC.wo.value++;
                                                            } else if (val ==
                                                                'L') {
                                                              enC.l.value++;
                                                            } else if (val ==
                                                                'A') {
                                                              enC.a.value++;
                                                            }
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      onCancel: () {
                                                        ltT.text = '';
                                                      },
                                                      confirmTextColor:
                                                          Colors.white,
                                                      textConfirm: 'Submit',
                                                    );
                                                  } else {
                                                    attendanceRes = await enC
                                                        .giveAttendance(
                                                      widget.date,
                                                      widget.shift,
                                                      widget.clientId,
                                                      val,
                                                      emp['empId'],
                                                      emp['designation'],
                                                      empRemarks,
                                                      stDt,
                                                      endDt,
                                                    );
                                                    if (attendanceRes) {
                                                      emp['attendanceAlias'] =
                                                          val;
                                                      if (val == 'P') {
                                                        enC.p.value++;
                                                      } else if (val == 'WO') {
                                                        enC.wo.value++;
                                                      } else if (val == 'L') {
                                                        enC.l.value++;
                                                      } else if (val == 'A') {
                                                        enC.a.value++;
                                                      }
                                                      setState(() {});
                                                    }
                                                  }
                                                }
                                              },
                                              choiceItems: C2Choice.listFrom<
                                                  String, dynamic>(
                                                source: not,
                                                value: (i, v) =>
                                                    not[i]['alias'],
                                                label: (i, v) =>
                                                    not[i]['notation'],
                                              ),
                                              wrapped: true,
                                              padding: EdgeInsets.all(0),
                                              choiceActiveStyle: C2ChoiceStyle(
                                                showCheckmark: false,
                                                brightness: Brightness.dark,
                                                labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    5.0,
                                                  ),
                                                ),
                                              ),
                                              choiceStyle: C2ChoiceStyle(
                                                labelStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    5.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final String selected;

  CustomContainer(
    this.title,
    this.icon,
    this.selected,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
      ),
      height: 50.0,
      decoration: BoxDecoration(
        color: selected == 'yes' ? Colors.grey : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected == 'yes' ? Colors.white : Colors.black,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: selected == 'yes' ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
