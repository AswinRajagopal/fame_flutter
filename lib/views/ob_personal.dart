import 'package:checkdigit/checkdigit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../controllers/admin_controller.dart';
import '../utils/utils.dart';
import '../widgets/ob_top_navigation.dart';
import 'ob_scanner.dart';
import 'ob_vaccine.dart';

class OBPersonal extends StatefulWidget {
  @override
  _OBPersonalState createState() => _OBPersonalState();
}

class _OBPersonalState extends State<OBPersonal> {
  final AdminController adminC = Get.put(AdminController());
  bool _isManual = false;

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
    Future.delayed(Duration(milliseconds: 100), () {
      if (adminC.reload) {
        adminC.draftLoded(false);
        adminC.aadharScan = false;
        adminC.famIndex(0);
        adminC.famName.clear();
        adminC.famDob.clear();
        adminC.famAge.clear();
        adminC.famAadhar.clear();
        adminC.famRelation.clear();
        adminC.famNominee.clear();
        adminC.famPercent.clear();
        adminC.familyDetail.clear();
        adminC.getObMandateFields();
        adminC.getData();
        adminC.setupFamily(0);
        adminC.step1(false);
        adminC.step2(false);
        adminC.step3(false);
        adminC.step4(false);
        adminC.step5(false);
        adminC.step6(false);
        Future.delayed(Duration(milliseconds: 100), () {
          adminC.reload = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Info',
        ),
        actions: [
          Column(
            children: [
              FlatButton(
                onPressed: () {
                  adminC.saveEmployeeAsDraft();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Save as Draft',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Obx(() {
              print(adminC.updatingData);
              if (adminC.isLoadingData.value) {
                return Column();
              }
              return SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OBTopNavigation('personal'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(OBScanner());
                            },
                            child: Text(
                              'Scan Aadhaar',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Obx(() {
                        return TextField(
                          controller: adminC.name,
                          maxLength: 160,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z -. A-Z]")),
                          ],
                          decoration: InputDecoration(
                            enabled: !adminC.disabledName.value,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            labelText: 'Name*',
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 18.0),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Obx(() {
                        return TextField(
                          controller: adminC.fatherName,
                          maxLength: 160,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z -. A-Z]")),
                          ],
                          decoration: InputDecoration(
                            enabled: !adminC.disabledFatherName.value,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            labelText: 'Father Name*',
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 18.0),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Gender',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Radio(
                            value: 'M',
                            groupValue: adminC.gender,
                            onChanged: (sVal) {
                              setState(() {
                                adminC.gender = sVal;
                              });
                            },
                          ),
                          Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Radio(
                            value: 'F',
                            groupValue: adminC.gender,
                            onChanged: (sVal) {
                              setState(() {
                                adminC.gender = sVal;
                              });
                            },
                          ),
                          Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Marital Status',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 'S',
                                    groupValue: adminC.mStatus,
                                    onChanged: (sVal) {
                                      setState(() {
                                        adminC.mStatus = sVal;
                                      });
                                    },
                                  ),
                                  Text(
                                    'UnMarried',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'M',
                                    groupValue: adminC.mStatus,
                                    onChanged: (sVal) {
                                      setState(() {
                                        adminC.mStatus = sVal;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Married',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'D',
                                    groupValue: adminC.mStatus,
                                    onChanged: (sVal) {
                                      setState(() {
                                        adminC.mStatus = sVal;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Divorcee',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 'W',
                                    groupValue: adminC.mStatus,
                                    onChanged: (sVal) {
                                      setState(() {
                                        adminC.mStatus = sVal;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Widow',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Obx(() {
                        return TextField(
                          controller: adminC.aadhar,
                          keyboardType: TextInputType.number,
                          enabled: !adminC.disabledAadhar.value,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            labelText: 'Aadhaar Number*',
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 18.0),
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/aadhar.png',
                                  color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.dtOfBirth,
                        readOnly: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Date of Birth*',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Image.asset(
                            'assets/images/icon_calender.png',
                            color: Colors.grey,
                            scale: 1.2,
                          ),
                        ),
                        onTap: adminC.disabledDob.value
                            ? null
                            : () {
                                adminC.getDate(context);
                              },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.language,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Mother Tongue',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Image.asset(
                            'assets/images/language.png',
                            color: Colors.grey,
                            scale: 2.2,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.empPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Phone No.*',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/phone.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.empESINumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'ESI Number',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.empUANNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'UAN Number',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: adminC.deptAu,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            labelText: 'Enter Department',
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 18.0),
                            prefixIcon: Column(
                              children: [
                                Image.asset(
                                  'assets/images/branch.png',
                                  color: Colors.grey[400],
                                  scale: 1.8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          // print(pattern);
                          if (pattern.isNotEmpty) {
                            return await RemoteServices().getDeptSugg(pattern);
                          } else {
                            adminC.department = null;
                          }
                          return null;
                        },
                        hideOnEmpty: true,
                        noItemsFoundBuilder: (context) {
                          return Text('No Department found');
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion['deptName'],
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          adminC.department = suggestion['deptId'].toString();
                          adminC.deptAu.text =
                              suggestion['deptName'].toString().trimRight();
                        },
                        autoFlipDirection: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 280.0, top: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isManual,
                              onChanged: (value) {
                                setState(() {
                                  _isManual = value;
                                });
                              },
                            ),
                            Text(
                              'Manual Client ID',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _isManual
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: adminC.clientMu,
                              maxLength: 160,
                              maxLengthEnforced: true,
                              decoration: InputDecoration(
                                  labelText: 'Enter Client Name',
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                  prefixIcon: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/siteposted.png',
                                        color: Colors.grey[400],
                                        scale: 1.8,
                                      ),
                                    ],
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey[600],
                                  )),
                            ),
                          )
                        : Container(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: adminC.clientAu,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  labelText: 'Enter Client Name*',
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                  prefixIcon: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/siteposted.png',
                                        color: Colors.grey[400],
                                        scale: 1.8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                // print(pattern);
                                if (pattern.isNotEmpty) {
                                  return await RemoteServices()
                                      .getBranchClientsSugg(pattern);
                                } else {
                                  adminC.sitePostedTo = null;
                                }
                                return null;
                              },
                              hideOnEmpty: true,
                              noItemsFoundBuilder: (context) {
                                return Text('No client found');
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion['name'],
                                  ),
                                  subtitle: Text(
                                    suggestion['id'],
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                print(suggestion);
                                print(suggestion['name']);
                                adminC.client = suggestion['id'];
                                adminC.clientAu.text =
                                    suggestion['name'].toString().trimRight() +
                                        " (" +
                                        suggestion['clientShortName'] +
                                        ")" +
                                        ' - ' +
                                        suggestion['id'];
                                adminC.sitePostedTo = suggestion['id'];
                              },
                              autoFlipDirection: true,
                            ),
                          )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select Blood Group',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.blood,
                        items: adminC.bloodGroupsList.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item['bloodGroupName'],
                            ),
                            value: item['bloodGroupId'].toString(),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/blood.png',
                                color: Colors.grey[400],
                                scale: 2.0,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.blood = value;
                          // setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: adminC.desigAu,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            labelText: 'Enter Designation *',
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 18.0),
                            prefixIcon: Column(
                              children: [
                                Image.asset(
                                  'assets/images/designation.png',
                                  color: Colors.grey[400],
                                  scale: 1.8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          // print(pattern);
                          if (pattern.isNotEmpty) {
                            return await RemoteServices()
                                .getDesignSugg(pattern);
                          } else {
                            adminC.designation = null;
                          }
                          return null;
                        },
                        hideOnEmpty: true,
                        noItemsFoundBuilder: (context) {
                          return Text('No Designation found');
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion['design'],
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          adminC.designation = suggestion['designId'];
                          adminC.desigAu.text =
                              suggestion['design'].toString().trimRight();
                        },
                        autoFlipDirection: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.dtOfJoin,
                        readOnly: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Date of Joining*',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Image.asset(
                            'assets/images/icon_calender.png',
                            color: Colors.grey,
                            scale: 1.2,
                          ),
                        ),
                        onTap: () {
                          adminC.getJoiningDate(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.qualification,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Qualification',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/qualification.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.reporting,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Reporting Manager',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/reportingmanager.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.remarks,
                        maxLength: 160,
                        maxLengthEnforced: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Remarks',
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Image.asset(
                                'assets/images/remarks.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            onPressed: () {
                              print('Cancel');
                              // backButtonPressed();
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
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (_isManual &&
                                  adminC.clientMu.text.length > 0) {
                                adminC.client = adminC.clientMu.text;
                              }
                              adminC.step1(false);
                              if (AppUtils.checkTextisNull(
                                  adminC.name, 'Name') && adminC.mandateList['mandateFields']
                              ['name']) {
                                  Get.snackbar(
                                    null,
                                    'Please provide Name',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );

                              } else if (AppUtils.checkTextisNull(
                                  adminC.fatherName, 'FatherName') &&
                                  adminC.mandateList['mandateFields']['fatherName']) {
                                  Get.snackbar(
                                    null,
                                    'Please provide Father Name',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );

                              } else if (adminC.aadhar.isNullOrBlank &&
                                  adminC.mandateList['mandateFields']
                              ['aadharNumber'] ) {
                                Get.snackbar(
                                  null,
                                  'Please enter Aadhaar Number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (!verhoeff
                                  .validate(adminC.aadhar.text)) {
                                Get.snackbar(
                                  null,
                                  'Please add valid aadhaar number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (AppUtils.checkTextisNull(
                                  adminC.dtOfBirth, 'Dob') && adminC.mandateList['mandateFields']
                              ['dob']) {
                                  Get.snackbar(
                                    null,
                                    'Please provide DOB',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );
                              } else if (adminC.empPhone.text.length != 10 &&
                                  adminC.mandateList['mandateFields']
                                  ['phoneNumber']) {
                                  Get.snackbar(
                                    null,
                                    'Please provide 10 digit phone number',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );

                              } else if (adminC.client == null && !_isManual
                              && adminC.mandateList['mandateFields']
                                  ['enterClientName']) {
                                  Get.snackbar(
                                    null,
                                    'Client is not selected',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );
                              } else if (adminC.designation == null &&
                              adminC.mandateList['mandateFields']
                              ['designation']) {
                                  Get.snackbar(
                                    null,
                                    'Designation is not selected',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );
                              } else if (AppUtils.checkTextisNull(
                                      adminC.dtOfJoin, 'Joining Date') &&
                                  adminC.mandateList['mandateFields']['dateOfJoining']) {
                                  Get.snackbar(
                                    null,
                                    'Please provide Joining Date',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 18.0),
                                    borderRadius: 5.0,
                                  );
                              } else {
                                adminC.proofAadharNumber.text =
                                    adminC.aadhar.text;
                                adminC.proofAadharNumberConfirm.text =
                                    adminC.aadhar.text;
                                Get.to(OBVaccine());
                                adminC.step1(true);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 50.0,
                              ),
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
