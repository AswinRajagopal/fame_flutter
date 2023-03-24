import 'package:dropdown_search/dropdown_search.dart';
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
  RegularizeAttendancePage(this.dtFormat, this.event, this.checkInTime,
      this.checkOutTime, this.attId);
  @override
  _RegularizeAttendancePageState createState() =>
      _RegularizeAttendancePageState(this.dtFormat, this.event,
          this.checkInTime, this.checkOutTime, this.attId);
}

class _RegularizeAttendancePageState extends State<RegularizeAttendancePage> {
  final RegularizeAttController raC = Get.put(RegularizeAttController());
  TextEditingController checkInDt = TextEditingController();
  TextEditingController checkOutDt = TextEditingController();
  TextEditingController reason = TextEditingController();
  var checkIn;
  var checkOut;
  var dtFormat;
  var event;
  var checkInTime;
  var checkOutTime;
  String _alias;
  var attId;
  _RegularizeAttendancePageState(this.dtFormat, this.event, this.checkInTime,
      this.checkOutTime, this.attId);


  Future<void> _checkInSelectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(context).toString());
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        String inputDate = dtFormat;
        DateTime date = DateFormat("dd-MM-yyyy").parse(inputDate);
        String outputDate = DateFormat("yyyy-MM-dd").format(date);
        checkIn = outputDate + " " + formattedTime.toString();
        checkInDt.text = DateFormat('hh:mm a').format(parsedTime);
      });
    } else {
      print("Time is not selected");
    }
  }

  Future<void> _checkOutSelectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context, //context of current state
    );

    if (pickedTime != null) {
      DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(context).toString());
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        String inputDate = dtFormat;
        DateTime date = DateFormat("dd-MM-yyyy").parse(inputDate);
        String outputDate = DateFormat("yyyy-MM-dd").format(date);
        checkOut = outputDate + " " + formattedTime.toString();
        checkOutDt.text = DateFormat('hh:mm a').format(parsedTime);
      });
    } else {
      print("Time is not selected");
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
        child: SingleChildScrollView(
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
                      child: DropdownSearch<String>(
                        validator: (v) => v == null ? "required field" : null,
                        hint: "Alias",
                        mode: Mode.MENU,
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0, top: 20.0),
                          fillColor: Colors.white,
                          filled: true,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        showAsSuffixIcons: true,
                        dropdownButtonBuilder: (_) => Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 15.0),
                          child: const Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        showSelectedItem: true,
                        items: [
                          'P'
                        ],
                        onChanged: (String value) {
                          setState(() {
                            _alias = value;
                          });
                        },
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
                        _checkInSelectTime(context);
                        // _checkInTime(context);
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
                        _checkOutSelectTime(context);
                        // _checkOutTime(context);
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
                      borderRadius:
                      BorderRadius
                          .circular(
                          5.0),
                      side: BorderSide(
                          color: Colors
                              .black38)),
                  child: Container(
                    child: TextField(
                      controller: reason,
                      maxLength: 1000,
                      maxLines: 4,
                      decoration:
                      InputDecoration(
                        border:
                        InputBorder
                            .none,
                        isDense: true,
                        contentPadding:
                        EdgeInsets
                            .all(10),
                        hintStyle:
                        TextStyle(
                          color: Colors
                              .grey[600],
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                        hintText:
                        'Reason',
                      ),
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
                    if (_alias == null || checkIn == null || checkOut == null) {
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
                    }else if (reason.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            title: Text(
                              'Reason..?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Please provide reason.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      raC.addRegularizeAtt(_alias, checkIn, checkOut, attId,reason.text);
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
              color:
                  type != null && type == 'link' ? Colors.black : Colors.black,
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
