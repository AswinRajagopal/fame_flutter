import 'package:fame/views/modify_emp_roster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  TextEditingController empName = TextEditingController();
  var _selectedMonthYear;
  var empId = '';
  DateTime picked = DateTime.now();

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
      () => calC.getRoster(_selectedMonthYear, empId),
    );

    roleId = RemoteServices().box.get('role');
    super.initState();
    _selectedMonthYear =
        '${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year.toString().substring(2)}';
    date.text = DateFormat('MMMM-yyyy').format(DateTime.now()).toString();
    picked = picked.subtract(Duration(days: picked.day-1));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final DateTime cureMonth = DateTime.now();

  Future<void> _selectMonth(BuildContext context) async {
    picked = await showMonthPicker(
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
        calC.getRoster(_selectedMonthYear, empId);
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
              roleId!='1'?TypeAheadField(
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
              ):Container(),
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
                  }else {
                    var rosterList = calC.empRosterList[0];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: DateTime(picked.year, picked.month + 1, 0).day,
                      itemBuilder: (context, index) {
                        return singleWidget( rosterList, index);
                      },
                    );
                  }
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }
  Widget singleWidget( roster, index) {
    String day = 'day' + index.toString();
    DateTime thisDate = picked.add( Duration(days: index));
    return GestureDetector(
      onTap: () {
        if (roleId!='1'){
          Get.to(RosterPage(
              DateFormat('dd-MM-yyyy').format(thisDate).toString(),
              roster['empId'],
              roster[day] != null ? roster[day].split(' ')[0] : '',
              roster['clientId'],
              roster[day] != null ? roster[day].split(" ")[2] : '',
              roster['name']));
        }
      },
      child: titleParams('Name', 'ClientId',
          DateFormat('dd-MM-yy').format(thisDate).toString(), roster[day] ?? 'NA', roster[day]),
    );
  }
}
