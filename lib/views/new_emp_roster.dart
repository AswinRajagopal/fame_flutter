import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/transfer_controller.dart';
import 'package:get/get.dart';

import '../connection/remote_services.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewRosterPage extends StatefulWidget {
  @override
  _NewRosterPageState createState() => _NewRosterPageState();
}

class _NewRosterPageState extends State<NewRosterPage> {
  final TransferController tC = Get.put(TransferController());
  TextEditingController empName = TextEditingController();
  TextEditingController empId = TextEditingController();
  TextEditingController currentUnit = TextEditingController();
  TextEditingController inCharge = TextEditingController();
  TextEditingController requiredUnit = TextEditingController();
  TextEditingController clientShift = TextEditingController();
  TextEditingController clientId = TextEditingController();
  TextEditingController design = TextEditingController();
  TextEditingController store = TextEditingController();
  TextEditingController fromDt = TextEditingController();
  TextEditingController toDt = TextEditingController();
  var employeeId;
  var shift;
  var toUnit;
  var fromPeriod;
  var toPeriod;
  var fD;
  var tD;

  @override
  void dispose() {
    super.dispose();
    tC.shiftList.clear();
  }

  @override
  void initState() {
    tC.pr = ProgressDialog(
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
    tC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      tC.getStores,
    );

    super.initState();
  }

  final DateTime _frmDate = DateTime.now();

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fD == null
          ? _frmDate
          : DateTime.parse(
              fD.toString(),
            ),
      firstDate: DateTime.now(),
      lastDate: tD != null
          ? DateTime.parse(tD.toString()).add(
              Duration(days: -1),
            )
          : DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${_frmDate.toString()}');
      setState(() {
        fromDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        fD = DateFormat('yyyy-MM-dd').format(picked).toString();
        fromPeriod = DateFormat('dd-MM-yyyy').format(picked).toString();
      });
    }
  }

  Future<Null> toDate(BuildContext context) async {
    final _toDate = DateTime.parse(fD.toString());
    final picked = await showDatePicker(
      context: context,
      initialDate: tD == null
          ? _toDate
          : DateTime.parse(
              tD.toString(),
            ),
      firstDate: DateTime.parse(fD.toString()),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      print('Date selected ${_toDate.toString()}');
      setState(() {
        toDt.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        tD = DateFormat('yyyy-MM-dd').format(picked).toString();
        toPeriod = DateFormat('dd-MM-yyyy').format(picked).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'New Roster',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // shrinkWrap: true,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: RemoteServices().box.get('role') != '3'
                    ? MediaQuery.of(context).size.height / 1.20
                    : MediaQuery.of(context).size.height / 1.35,
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  physics: ScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.black38)),
                              child: Container(
                                height: 60,
                                child:  Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: TypeAheadField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: empName,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
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
                                        return await RemoteServices()
                                            .getTransferEmployees(pattern);
                                      } else {
                                        employeeId = null;
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
                                          suggestion['empId'] +
                                              " " +
                                              "(" +
                                              suggestion['clientName'] +
                                              ")",
                                        ),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      print('suggest-->:$suggestion');
                                      empName.text =
                                          suggestion['name'].toString().trimRight() +
                                              " (" +
                                              suggestion['inchargeName'] +
                                              ")" +
                                              ' - ' +
                                              suggestion['empId'];
                                      empId.text = suggestion['empId'];
                                      currentUnit.text = suggestion['clientName'];
                                      employeeId = suggestion['empId'];
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.black38)),
                              child: Container(
                                height: 60,
                                child: MyTextField(
                                  'Employee Id',
                                  empId,
                                  true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                child: Container(
                                  // width: double.infinity,
                                  height: 60,
                                  child: TypeAheadField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: requiredUnit,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(left: 10.0,top: 20.0),
                                        hintStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                        hintText: 'Required for Unit',
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      print('pattern:$pattern');
                                      if (pattern.isNotEmpty) {
                                        return await RemoteServices().getUnits(pattern);
                                      } else {
                                        toUnit = null;
                                      }
                                      return null;
                                    },
                                    hideOnEmpty: true,
                                    noItemsFoundBuilder: (context) {
                                      return Text('No unit found');
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(
                                          suggestion['name'],
                                        ),
                                        // subtitle: Text(
                                        //   suggestion['empId'],
                                        // ),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      print('sug:$suggestion');
                                      toUnit = suggestion['id'];
                                      requiredUnit.text =
                                          suggestion['name'].toString().trimRight();
                                      tC.getShift(suggestion['id']);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                            child: Obx(() {
                              if (tC.isLoading.value) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(color: Colors.black38)),
                                    child: Container(
                                      // width: double.infinity,
                                      height: 60,
                                      child: MyTextField(
                                        'Select Shift',
                                        clientShift,
                                        false,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  // horizontal: 10.0,
                                  vertical: 5.0,
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: Colors.black38)),
                                  child: Container(
                                    // width: double.infinity,
                                    height: 60,
                                    child: DropdownButtonFormField(
                                      hint: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Select Shift',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 18.0,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      isExpanded: true,
                                      items: tC.shiftList.map((item) {
                                        print('item: $item');
                                        return DropdownMenuItem(
                                          child: Text(
                                            item['shift'],
                                          ),
                                          value: item,
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        // errorText: clientShift.text==null || clientShift.text == ''?'Please select shift':null,
                                        contentPadding: EdgeInsets.only(
                                          left: clientShift.text == null ||
                                              clientShift.text == ''
                                              ? 0.0
                                              : 10.0,top: 10.0
                                        ),
                                      ),
                                      onChanged: (value) {
                                        print('value: $value');
                                        setState(() {
                                          clientShift.text = value['shift'].toString();
                                          clientId.text = value['clientId'];
                                          design.text = value['design'];
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                child: Container(
                                  height: 60,
                                  child: TextField(
                                    controller: fromDt,
                                    onTap: () {
                                      fromDate(context);
                                    },
                                    readOnly: true,
                                    keyboardType: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 10,top: 20),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Required On',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width:5.0,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  child: TextField(
                                    controller: toDt,
                                    onTap: () {
                                      toDate(context);
                                    },
                                    readOnly: true,
                                    keyboardType: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left:10,top: 20),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Required Till',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (tC.isLoading.value) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal:10.0,
                            vertical: 5.0,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.black38)),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              child: MyTextField(
                                'Select Store',
                                store,
                                false,
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            height: 60.0,
                            child: DropdownButtonFormField<String>(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Select Store',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              isExpanded: true,
                              items: tC.stores.map((item) {
                                print('item: $item');
                                return DropdownMenuItem(
                                  child: Text(
                                    item['storeName'] + " - " + item['storeCode'],
                                  ),
                                  value: item['storeCode'].toString(),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // errorText: clientShift.text==null || clientShift.text == ''?'Please select shift':null,
                                contentPadding: EdgeInsets.only(
                                    left: store.text == null || store.text == ''
                                        ? 0.0
                                        : 10.0,top: 10.0
                                ),
                              ),
                              onChanged: (value) {
                                print('value: $value');
                                setState(() {
                                  store.text = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }),
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
                            if (employeeId == null ||
                                fromPeriod == null ||
                                toPeriod == null ||
                                currentUnit.text == null ||
                                toUnit == null) {
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
                            } else if (clientShift.text == null ||
                                clientShift.text.isEmpty) {
                              Get.snackbar(
                                null,
                                'Please provide shift',
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
                            } else if (store.text == null ||
                                store.text.isEmpty) {
                              Get.snackbar(
                                null,
                                'Please provide store',
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
                              print('empId: $employeeId');
                              print('fromPeriod: $fromPeriod');
                              print('toPeriod: $toPeriod');
                              print('fromUnit: ${currentUnit.text}');
                              print('shift: ${clientShift.text}');
                              print('toUnit: $toUnit');
                              print('storeCode:${store.text}');
                              print('design:${design.text}');
                              print('clientid:${clientId.text}');
                              toPeriod = DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy').parse(toPeriod));
                              fromPeriod = DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy').parse(fromPeriod));
                              print('fromPeriod: $fromPeriod');
                              print('toPeriod: $toPeriod');
                              tC.newRoster(
                                  employeeId,
                                  fromPeriod,
                                  toPeriod,
                                  currentUnit.text,
                                  clientShift.text,
                                  toUnit,
                                  store.text,clientId.text,design.text);
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
        horizontal:0.0,
        vertical: 10.0,
      ),
      child: TextField(
        controller: inputController,
        readOnly: readOnly,
        decoration: InputDecoration(
          border: InputBorder.none,
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
