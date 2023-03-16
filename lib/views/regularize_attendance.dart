import 'package:fame/controllers/regularize_attendance_controller.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/sos_controller.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class RegularizeAttendancePage extends StatefulWidget {
  final String dtFormat;
  final String event;
  final String checkInTime;
  final String checkOutTime;
  final String attId;
  RegularizeAttendancePage(
      this.dtFormat, this.event, this.checkInTime, this.checkOutTime,this.attId);
  @override
  _RegularizeAttendancePageState createState() =>
      _RegularizeAttendancePageState(
          this.dtFormat, this.event, this.checkInTime, this.checkOutTime,this.attId);
}

class _RegularizeAttendancePageState extends State<RegularizeAttendancePage> {
  final RegularizeAttController raC = Get.put(RegularizeAttController());
  TextEditingController alias = TextEditingController();
  TextEditingController checkInDt = TextEditingController();
  TextEditingController checkOutDt = TextEditingController();
  var checkIn;
  var checkOut;
  var dtFormat;
  var event;
  var checkInTime;
  var checkOutTime;
  var attId;
  _RegularizeAttendancePageState(
      this.dtFormat, this.event, this.checkInTime, this.checkOutTime,this.attId);

  Future<void> _checkInTime(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          checkIn = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          checkInDt.text = DateFormat('dd-MM-yyyy hh:mm a')
              .format(DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              ))
              .toString();
        });
      }
    }
  }

  Future<void> _checkOutTime(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          checkOut = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          checkOutDt.text = DateFormat('dd-MM-yyyy hh:mm a')
              .format(DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              ))
              .toString();
        });
      }
    }
  }

  @override
  void initState() {
    raC.pr = ProgressDialog(
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
    raC.pr.style(
      backgroundColor: Colors.white,
    );
    // Future.delayed(Duration(milliseconds: 100), sC.getEmpDetails);
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
          'Regularize Attendance',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.white)),
                child: Container(
                  width: 500,
                  height: 150.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(child: RowWidget('Date', dtFormat)),
                        Expanded(
                          child: RowWidget('Attendance Alias', event),
                        ),
                        Expanded(
                          child: RowWidget('Checkin Time', checkInTime),
                        ),
                        Expanded(
                          child: RowWidget('Checkout Time', checkOutTime),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black38)),
                  child: Container(
                    height: 60,
                    child: TextField(
                      controller: alias,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                        labelText: 'Alias',
                        labelStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 18.0),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.black38)),
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: checkInDt,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.0,
                        // fontWeight: FontWeight.bold,
                      ),
                      labelText: 'CheckIn Time',
                      labelStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 18.0),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: 25.0,
                      ),
                    ),
                    readOnly: true,
                    keyboardType: null,
                    onTap: () {
                      _checkInTime(context);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.black38)),
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: checkOutDt,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.0,
                        // fontWeight: FontWeight.bold,
                      ),
                      labelText: 'CheckOut Time',
                      labelStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 18.0),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: 25.0,
                      ),
                    ),
                    readOnly: true,
                    keyboardType: null,
                    onTap: () {
                      _checkOutTime(context);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20.0,
              ),
              child: RaisedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (alias.text == null ||
                      checkIn == null ||
                      checkOut == null) {
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
                  } else if (checkIn == null) {
                    Get.snackbar(
                      null,
                      'Please provide check-in date and time.',
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
                  } else if (checkOut == null) {
                    Get.snackbar(
                      null,
                      'Please provide check-out date and time.',
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
                    print(alias.text.capitalize.toString());
                    print(checkInDt.text.toString());
                    print(checkOutDt.text.toString());
                    raC.addRegularizeAtt(alias.text.capitalize, checkIn, checkOut,attId);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 12.0),
                  child: Text(
                    'Send For Approval',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            )
          ],
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
        keyboardType: TextInputType.phone,
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

class RowWidget extends StatelessWidget {
  final String leftSide;
  final String rightSide;
  final String type;
  RowWidget(this.leftSide, this.rightSide, {this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          leftSide,
          style: TextStyle(
            fontSize: 18.0,
            color: AppUtils().blueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Text(
            rightSide != null && rightSide != '' && rightSide != 'null'
                ? rightSide
                : 'N/A',
            style: TextStyle(
              fontSize: 18.0,
              color: type != null && type == 'link'
                  ? Colors.black
                  : Colors.black,
            ),
            textAlign: TextAlign.end,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
