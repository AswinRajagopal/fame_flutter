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
        // _selectedMonthYear =
        //     '${picked.month.toString().padLeft(2, '0')}${picked.year.toString().substring(2)}';
        // calC.getRoster(_selectedMonthYear, empId);
        // print(_selectedMonthYear);
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
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 8.0,left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      roleId!='1'?Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 10,),
                          // Text("Select Employee",   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: Color(0xff555555),),
                          // ),
                          // SizedBox(height: 4,),
                          Container(
                            height:  58 ,
                            // width:  MediaQuery.of(context).size.width ,
                            // padding: EdgeInsets.all(8),
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: empName,
                                decoration:  InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffF9F9F9),
                                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: Color(0xff555555),),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(
                                          0xff8f8f93).withOpacity(0.25),width: 0.8,),
                                      borderRadius: BorderRadius.all(Radius.circular(1.71))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff8f8f93).withOpacity(0.25),width: 0.8),
                                      borderRadius: BorderRadius.all(Radius.circular(1.71))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff8f8f93).withOpacity(0.25),width: 0.8),
                                      borderRadius: BorderRadius.all(Radius.circular(1.71)
                                      )),
                                  prefixIcon:   InkWell(
                                      onTap: () {
                                      },
                                      child: Icon(
                                        Icons.search_sharp,
                                        size: 25,
                                        color: AppUtils().dividerColor,
                                      )),

                                  hintText: "Employee Name",
                                )
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
                            ),
                          ),
                        ],
                      ):Container(),
                      SizedBox(height: 1,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:0.0),
                        child: Text("Select Month",   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: Color(0xff555555),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child:  InkWell(
                          onTap: () {
                            _selectMonth(context);
                          },
                          child: Container(
                            height: 58,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: date,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: Color(0xff555555),),
                                decoration:InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffF9F9F9),
                                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: Color(0xff555555),),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff8f8f93).withOpacity(0.25),width: 0.8,),
                                      borderRadius: BorderRadius.all(Radius.circular(1.71))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff8f8f93).withOpacity(0.25),width: 0.8),
                                      borderRadius: BorderRadius.all(Radius.circular(1.71))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff8f8f93).withOpacity(0.25),width: 0.8),
                                      borderRadius: BorderRadius.all(Radius.circular(1.71)
                                      )),
                                  hintText: 'Select Date',
                                  // errorText: _validateStarts ? 'Please select Date' : null,
                                  prefixIcon:   InkWell(
                                      onTap: () {
                                      },
                                      child: Icon(
                                        Icons.calendar_today,
                                        size: 25,
                                        color: AppUtils().dividerColor,
                                      )),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // _validateStarts = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              if (picked != null) {
                                setState(() {
                                  _selectedMonthYear =
                                  '${picked.month.toString().padLeft(2, '0')}${picked.year.toString().substring(2)}';
                                  calC.getRoster(_selectedMonthYear, empId);
                                  print(_selectedMonthYear);
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                // border: Border.all(
                                //     width: 2.0,
                                //     color: AppUtils().blueColor), // Set border width
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: FittedBox(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Submit",
                                        style:TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Colors.white, fontFamily: 'PoppinsRegular')
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child:
              //
              //   Row(children: [
              //     Text('Select Month:',
              //         style: TextStyle(
              //             fontSize: 20.0, fontWeight: FontWeight.bold)),
              //     Container(
              //       width: 170,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 10.0,
              //           vertical: 5.0,
              //         ),
              //         child: TextField(
              //           controller: date,
              //           decoration: InputDecoration(
              //             isDense: true,
              //             contentPadding: EdgeInsets.all(10),
              //             hintStyle: TextStyle(
              //               color: Colors.grey[600],
              //               fontSize: 18.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             hintText: 'Select Date',
              //             suffixIcon: Icon(
              //               Icons.calendar_today,
              //               size: 25.0,
              //             ),
              //           ),
              //           readOnly: true,
              //           keyboardType: null,
              //           onTap: () {
              //             _selectMonth(context);
              //           },
              //         ),
              //       ),
              //     ),
              //   ]),
              // ),
              SizedBox(height: 10,),
              Divider(thickness: 2,color: AppUtils().dividerColor,),
              SizedBox(height: 10,),
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
                      physics: ClampingScrollPhysics(),
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
      child: titleParams(   roster['name'], 'ClientId',
          DateFormat('dd-MM-yy').format(thisDate).toString(), roster[day] ?? 'NA', roster[day]),
    );
  }
}
