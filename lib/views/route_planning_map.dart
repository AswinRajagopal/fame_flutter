import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import 'route_planning.dart';
import '../widgets/custom_app_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/route_planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_page.dart';

class RoutePlanningMap extends StatefulWidget {
  @override
  _RoutePlanningMapState createState() => _RoutePlanningMapState();
}

class _RoutePlanningMapState extends State<RoutePlanningMap> {
  final RoutePlanningController rpC = Get.put(RoutePlanningController());
  TextEditingController planName = TextEditingController();
  TextEditingController empName = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController cRemark = TextEditingController();
  var assignedTo;

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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    rpC.pr.style(
      backgroundColor: Colors.black,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(DashboardPage());
  }

  final DateTime _frmDate = DateTime.now();

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date.text.isEmpty
          ? _frmDate
          : DateTime.parse(
              date.text.toString(),
            ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${date.text.toString()}');
      setState(() {
        date.text = DateFormat('yyyy-M-d').format(picked).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CustomAppBar('Route Planning'),
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
                              color: Colors.blue,
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
                                  onTap: () {
                                    Get.offAll(RoutePlanning());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          50.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7.0,
                                        horizontal: 25.0,
                                      ),
                                      child: Text(
                                        'From Clients',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                        vertical: 7.0,
                                        horizontal: 25.0,
                                      ),
                                      child: Text(
                                        'From Map',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
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
                  height: RemoteServices().box.get('role') != '3' ? MediaQuery.of(context).size.height / 1.24 : MediaQuery.of(context).size.height / 1.44,
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    children: [
                      MyTextField(
                        'Enter plan name',
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
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Enter employee name',
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            // print(pattern);
                            if (pattern.isNotEmpty) {
                              return await RemoteServices().getEmployees(pattern);
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
                        'Enter remarks',
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
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Select date',
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
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    'Enter address',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    var p = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: AppUtils.GKEY,
                                      mode: Mode.overlay,
                                      language: 'en',
                                      components: [
                                        Component(
                                          Component.country,
                                          'in',
                                        ),
                                      ],
                                    );
                                    // print('P: $p');
                                    if (p != null) {
                                      var places = GoogleMapsPlaces(
                                        apiKey: AppUtils.GKEY,
                                      );
                                      var detail = await places.getDetailsByPlaceId(
                                        p.placeId,
                                      );
                                      print(p.placeId);
                                      print(p.description);
                                      // print(detail.result.geometry.location.lat
                                      //     .toString());
                                      // print(detail.result.geometry.location.lng
                                      //     .toString());
                                      var map = {
                                        'address': p.description.toString(),
                                        'clientId': '',
                                        'lat': detail.result.geometry.location.lat.toString(),
                                        'lng': detail.result.geometry.location.lng.toString(),
                                        'mapId': p.placeId.toString(),
                                      };
                                      print(rpC.mapID);
                                      if (!rpC.mapID.contains(p.placeId)) {
                                        rpC.mapCL.add(map);
                                        rpC.mapID.add(p.placeId);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Already added',
                                          colorText: Colors.white,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 10.0,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                    ),
                                    child: Image.asset(
                                      'assets/images/add_icon.png',
                                      scale: 30.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey[900],
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (rpC.mapCL.isNull || rpC.mapCL.isEmpty) {
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please add address from map,\n click on + icon to add',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
                                  itemCount: rpC.mapCL.length,
                                  itemBuilder: (context, index) {
                                    var address = rpC.mapCL[index];
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
                                                  if (rpC.sC.contains(address)) {
                                                    rpC.sC.remove(address);
                                                  } else {
                                                    rpC.sC.add(address);
                                                  }
                                                },
                                                child: Obx(() {
                                                  return Container(
                                                    height: 25.0,
                                                    width: 25.0,
                                                    decoration: BoxDecoration(
                                                      color: rpC.sC.contains(address) ? Colors.blue : Colors.white,
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
                                            SizedBox(
                                              width: 220.0,
                                              child: Text(
                                                address['address'].toString(),
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
                                                  title: 'Remarks',
                                                  content: TextField(
                                                    controller: cRemark,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.all(10),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      hintText: 'Enter remarks',
                                                    ),
                                                  ),
                                                  barrierDismissible: false,
                                                  onConfirm: () {
                                                    if (cRemark.text != '') {
                                                      address['remarks'] = cRemark.text;
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
                              print('Cancel');
                              // Get.back();
                              Get.offAll(DashboardPage());
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
                              print('Submit');
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (planName.text == null || planName.text == '' || empName.text == null || empName.text == '' || remarks.text == null || remarks.text == '' || date.text == null || date.text == '' || assignedTo == null) {
                                Get.snackbar(
                                  'Error',
                                  'Please fill all data',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 10.0,
                                  ),
                                );
                              } else if (rpC.sC.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Please select atleast one address',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 10.0,
                                  ),
                                );
                              } else {
                                // print(rpC.sC.length);
                                print(rpC.sC);
                                var pitstops = [];
                                for (var i = 0; i < rpC.sC.length; i++) {
                                  var addData;
                                  if (rpC.sC[i]['remarks'] == null) {
                                    addData = {
                                      'lat': rpC.sC[i]['lat'].toString(),
                                      'lng': rpC.sC[i]['lng'].toString(),
                                      'clientId': '',
                                      'date': date.text,
                                    };
                                  } else {
                                    addData = {
                                      'lat': rpC.sC[i]['lat'].toString(),
                                      'lng': rpC.sC[i]['lng'].toString(),
                                      'clientId': '',
                                      'date': date.text,
                                      'adminRemarks': rpC.sC[i]['remarks'].toString(),
                                    };
                                  }
                                  pitstops.add(addData);
                                }
                                print(pitstops);
                                rpC.saveRPlan(
                                  assignedTo,
                                  planName.text,
                                  date.text,
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
            fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
