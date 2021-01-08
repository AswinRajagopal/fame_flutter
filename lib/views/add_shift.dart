import 'package:time_range_picker/time_range_picker.dart';

import '../utils/utils.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/admin_controller.dart';
import 'package:flutter/material.dart';

class AddShift extends StatefulWidget {
  @override
  _AddShiftState createState() => _AddShiftState();
}

class _AddShiftState extends State<AddShift> {
  final AdminController adminC = Get.put(AdminController());
  TextEditingController shiftname = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController endtime = TextEditingController();

  @override
  void initState() {
    adminC.pr = ProgressDialog(
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
    adminC.pr.style(
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
          'Add Shift',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.24,
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  physics: ScrollPhysics(),
                  children: [
                    MyTextField(
                      'Shift Name',
                      shiftname,
                      false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: starttime,
                        readOnly: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Start Time',
                        ),
                        onTap: () async {
                          TimeRange result = await showTimeRangePicker(
                            context: context,
                            paintingStyle: PaintingStyle.fill,
                            labels: [
                              '12 PM',
                              '3 AM',
                              '6 AM',
                              '9 AM',
                              '12 AM',
                              '3 PM',
                              '6 PM',
                              '9 PM',
                            ].asMap().entries.map((e) {
                              return ClockLabel.fromIndex(
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
                            var sth = result.startTime.hour;
                            var stm = result.startTime.minute;
                            var enh = result.endTime.hour;
                            var enm = result.endTime.minute;
                            var stH = sth < 9 ? '0' + sth.toString() : sth;
                            var stM = stm < 9 ? '0' + stm.toString() : stm;
                            var enH = enh < 9 ? '0' + enh.toString() : enh;
                            var enM = enm < 9 ? '0' + enm.toString() : enm;
                            var start = '$stH:$stM:00.000';
                            var end = '$enH:$enM:00.000';
                            print('start: $start');
                            print('end: $end');
                            setState(() {
                              starttime.text = '$stH:$stM:00';
                              endtime.text = '$enH:$enM:00';
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: endtime,
                        readOnly: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'End Time',
                        ),
                        onTap: () {
                          Get.snackbar(
                            'Error',
                            'Click on start time to change the time',
                            colorText: Colors.white,
                            backgroundColor: Colors.black87,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 10.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
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
                            // print('Cancel');
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
                            print('Submit');
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (shiftname.text.isNullOrBlank || starttime.text.isNullOrBlank || endtime.text.isNullOrBlank) {
                              Get.snackbar(
                                'Error',
                                'Please fill all fields',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                              );
                            } else {
                              print('shift name: ${shiftname.text}');
                              print('start time: ${starttime.text}');
                              print('end time: ${endtime.text}');
                              adminC.addShift(shiftname.text, starttime.text, endtime.text);
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
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController inputController;
  final bool readOnly;
  MyTextField(this.hintText, this.inputController, this.readOnly);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: TextField(
        controller: inputController,
        readOnly: readOnly,
        keyboardType: hintText == 'Phone Number'
            ? TextInputType.phone
            : hintText == 'Email'
                ? TextInputType.emailAddress
                : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
