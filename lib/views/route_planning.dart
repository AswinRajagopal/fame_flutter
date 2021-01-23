import 'package:badges/badges.dart';
import 'routeplan_list.dart';

import 'route_planning_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/route_planning_controller.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_page.dart';

class RoutePlanning extends StatefulWidget {
  final String goBackTo;
  RoutePlanning({this.goBackTo});

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  final RoutePlanningController rpC = Get.put(RoutePlanningController());
  TextEditingController planName = TextEditingController();
  TextEditingController empName = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController cRemark = TextEditingController();
  var assignedTo;
  var sDate;

  @override
  void initState() {
    rpC.pr = ProgressDialog(
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
    rpC.pr.style(
      backgroundColor: Colors.white,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> backButtonPressed() {
    if (widget.goBackTo != null && widget.goBackTo == 'list') {
      return Get.offAll(RouteplanList());
    }
    return Get.offAll(DashboardPage());
  }

  final DateTime _frmDate = DateTime.now();

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: sDate == null
          ? _frmDate
          : DateTime.parse(
              sDate.toString(),
            ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${date.text.toString()}');
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
          'Route Planning',
        ),
        leading: IconButton(
          onPressed: backButtonPressed,
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RemoteServices().box.get('role') != '3'
                    ? Container()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                          ),
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  50.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          50.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 28.0,
                                      ),
                                      child: SizedBox(
                                        width: 120.0,
                                        height: 23.0,
                                        child: Center(
                                          child: Text(
                                            'From Clients',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offAll(RoutePlanningMap());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          50.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                        horizontal: 28.0,
                                      ),
                                      child: SizedBox(
                                        width: 120.0,
                                        height: 23.0,
                                        child: Center(
                                          child: Text(
                                            'From Map',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                Container(
                  height: RemoteServices().box.get('role') != '3' ? MediaQuery.of(context).size.height / 1.20 : MediaQuery.of(context).size.height / 1.35,
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    children: [
                      MyTextField(
                        'Enter Plan Name',
                        planName,
                      ),
                      // MyTextField(
                      //   'Enter employee name',
                      //   empName,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: TypeAheadField(
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
                              hintText: 'Enter Employee Name',
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            // print(pattern);
                            if (pattern.isNotEmpty) {
                              return await RemoteServices().getEmployees(pattern);
                            } else {
                              assignedTo = null;
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
                            empName.text = suggestion['name'];
                            assignedTo = suggestion['empId'];
                          },
                        ),
                      ),
                      MyTextField(
                        'Enter Remarks',
                        remarks,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: TextField(
                          controller: date,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Select Date',
                            suffixIcon: Image.asset(
                              'assets/images/icon_calender.png',
                              scale: 1.5,
                              color: Colors.grey[600],
                            ),
                          ),
                          readOnly: true,
                          keyboardType: null,
                          onTap: () {
                            fromDate(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          10.0,
                          10.0,
                          10.0,
                          0.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                'Select Client',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Obx(() {
                              return Badge(
                                badgeContent: Text(
                                  rpC.sC.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                shape: BadgeShape.circle,
                                badgeColor: AppUtils().orangeColor,
                                toAnimate: true,
                                animationType: BadgeAnimationType.scale,
                                padding: EdgeInsets.all(
                                  rpC.sC.length < 10 ? 7.0 : 5.0,
                                ),
                                position: BadgePosition.topEnd(
                                  top: -5,
                                  end: 0,
                                ),
                                child: Image.asset(
                                  'assets/images/routenoti.png',
                                  scale: 1.5,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (rpC.isLoading.value) {
                          return Container();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Container(
                              height: 230.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10.0,
                                  ),
                                ),
                                border: Border.all(
                                  color: Colors.grey[400],
                                ),
                              ),
                              child: Scrollbar(
                                radius: Radius.circular(
                                  10.0,
                                ),
                                thickness: 3.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: rpC.clientList.length,
                                  itemBuilder: (context, index) {
                                    var client = rpC.clientList[index];
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 12.0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // print(client);
                                                  // print(rpC.sC.contains(client));
                                                  // print(rpC.sC);
                                                  if (rpC.sC.contains(client)) {
                                                    rpC.sC.remove(client);
                                                  } else {
                                                    rpC.sC.add(client);
                                                  }
                                                },
                                                child: Obx(() {
                                                  return Container(
                                                    height: 25.0,
                                                    width: 25.0,
                                                    decoration: BoxDecoration(
                                                      color: rpC.sC.contains(client) ? Theme.of(context).primaryColor : Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                          5.0,
                                                        ),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              client['id'].toString(),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            SizedBox(
                                              width: 150.0,
                                              child: Text(
                                                client['name'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                print('remarks');
                                                Get.defaultDialog(
                                                  title: 'Remarks for ${client['id'].toString()}',
                                                  radius: 5.0,
                                                  content: TextField(
                                                    controller: cRemark,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.all(10),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18.0,
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                      hintText: 'Enter remarks',
                                                    ),
                                                  ),
                                                  barrierDismissible: false,
                                                  onConfirm: () {
                                                    if (cRemark.text != '') {
                                                      client['remarks'] = cRemark.text;
                                                      cRemark.text = '';
                                                      Get.back();
                                                    }
                                                  },
                                                  onCancel: () {
                                                    cRemark.text = '';
                                                  },
                                                  confirmTextColor: Colors.white,
                                                  textConfirm: 'Add',
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/msgicitem.png',
                                                  scale: 1.8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey[400],
                                          endIndent: 12.0,
                                          indent: 12.0,
                                          height: 2.0,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      })
                    ],
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
                              // Get.offAll(DashboardPage());
                              backButtonPressed();
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
                              if (planName.text == null || planName.text == '' || empName.text == null || empName.text == '' || remarks.text == null || remarks.text == '' || sDate == null || sDate == '' || assignedTo == null) {
                                Get.snackbar(
                                  'Message',
                                  'Please fill all data',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 10.0,
                                  ),
                                );
                              } else if (rpC.sC.isEmpty) {
                                Get.snackbar(
                                  'Message',
                                  'Please select atleast one client',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 10.0,
                                  ),
                                );
                                // print('fromDate: ${fromDt.text}');
                                // print('toDate: ${toDt.text}');
                                // print('reason: ${reason.text}');
                                // print('dayType: $stVal');
                                // print('leaveTypeId: $leaveType');
                              } else {
                                // print(rpC.sC.length);
                                print(rpC.sC);
                                var pitstops = [];
                                for (var i = 0; i < rpC.sC.length; i++) {
                                  var addData;
                                  if (rpC.sC[i]['remarks'] == null) {
                                    addData = {
                                      'lat': rpC.sC[i]['latitude'].toString(),
                                      'lng': rpC.sC[i]['longitude'].toString(),
                                      'clientId': rpC.sC[i]['id'].toString(),
                                      'date': sDate,
                                    };
                                  } else {
                                    addData = {
                                      'lat': rpC.sC[i]['latitude'].toString(),
                                      'lng': rpC.sC[i]['longitude'].toString(),
                                      'clientId': rpC.sC[i]['id'].toString(),
                                      'date': sDate,
                                      'adminRemarks': rpC.sC[i]['remarks'].toString(),
                                    };
                                  }
                                  pitstops.add(addData);
                                }
                                print(pitstops);
                                rpC.saveRPlan(
                                  assignedTo,
                                  planName.text,
                                  sDate,
                                  pitstops,
                                );
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
