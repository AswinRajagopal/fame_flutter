import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../connection/remote_services.dart';
import '../controllers/dbcal_controller.dart';
import '../utils/utils.dart';
import '../widgets/emp_roster_widget.dart';
import 'new_emp_roster.dart';

class ViewEmpRoster extends StatefulWidget {
  @override
  _ViewViewEmpRosterState createState() => _ViewViewEmpRosterState();
}

class _ViewViewEmpRosterState extends State<ViewEmpRoster> {
  final DBCalController calC = Get.put(DBCalController());
  TextEditingController date = TextEditingController();
  // var roleId = RemoteServices().box.get('role');
  var roleId;
  var _selectedMonthYear;

  @override
  void initState() {
    calC.pr = ProgressDialog(
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
    calC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      () => calC.getRoster(_selectedMonthYear),
    );

    roleId = RemoteServices().box.get('role');
    super.initState();
    _selectedMonthYear =
        '${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year.toString().substring(2)}';
    date.text = DateFormat('MMMM-yyyy').format(DateTime.now()).toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final DateTime cureMonth = DateTime.now();

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        date.text = DateFormat('MMMM-yyyy').format(picked).toString();
        print(picked);
        _selectedMonthYear =
            '${picked.month.toString().padLeft(2, '0')}${picked.year.toString().substring(2)}';
        calC.getRoster(_selectedMonthYear);
        print(_selectedMonthYear);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Employee Roster',
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.to(NewRosterPage());
            },
            child: Icon(
              Icons.add,
              size: 32.0,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Scrollbar(
            radius: Radius.circular(
              10.0,
            ),
            thickness: 5.0,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Text('Select Month:',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Container(
                    width: 170,
                    child: Padding(
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
                          _selectMonth(context);
                        },
                      ),
                    ),
                  ),
                ]),
              ),
              Obx(() {
                if (calC.isEventLoading.value) {
                  return Column();
                } else {
                  if (calC.empRosterList.isEmpty || calC.empRosterList.isNull) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'No roster found',
                              style: TextStyle(
                                fontSize: 18.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    itemCount: calC.empRosterList.length,
                    itemBuilder: (context, index) {
                      var rosterList = calC.empRosterList[index];
                      return EmpRosterWidget(
                          rosterList, calC.combined, calC.dateList);
                    },
                  );
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }
}
