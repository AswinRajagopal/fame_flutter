import 'package:checkdigit/checkdigit.dart';
import 'package:flutter/material.dart';
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
        adminC.getData();
        adminC.setupFamily(0);
        adminC.step1(false);
        adminC.step2(false);
        adminC.step3(false);
        adminC.step4(false);
        adminC.step5(false);
        adminC.step6(false);
        adminC.reload = false;
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
                              'Scan Aadhar',
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
                          decoration: InputDecoration(
                            enabled: !adminC.disabledName.value,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            hintText: 'Name*',
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
                            hintText: 'Aadhar Number*',
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
                          hintText: 'Date of Birth*',
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
                          hintText: 'Mother Toungue',
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
                          hintText: 'Phone No.*',
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
                        controller: adminC.empUANNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'UAN Number',
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
                            hintText: 'Enter Department',
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
                          adminC.deptAu.text = suggestion['deptName'].toString().trimRight();
                          /* sitePostedTo = suggestion['id'];*/
                        },
                        autoFlipDirection: true,
                      ),
                    ),
                    Padding(
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
                            hintText: 'Enter Client Name*',
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
                            return await RemoteServices().getBranchClientsSugg(pattern);
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
                          adminC.clientAu.text = suggestion['name'].toString().trimRight() + ' - ' + suggestion['id'];
                          adminC.sitePostedTo = suggestion['id'];
                        },
                        autoFlipDirection: true,
                      ),
                    ),
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
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.blood,
                        items: adminC.bloodGroupsList.map((item) {
                          //print('item: $item');
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
                            hintText: 'Enter Designation *',
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
                            return await RemoteServices().getDesignSugg(pattern);
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
                          adminC.desigAu.text = suggestion['design'].toString().trimRight();
                          // sitePostedTo = suggestion['id'];
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
                          hintText: 'Date of Joining*',
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
                          hintText: 'Qualification',
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
                          hintText: 'Reporting Manager',
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
                              adminC.step1(false);
                              if (AppUtils.checkTextisNull(adminC.name, 'Name')) {
                                Get.snackbar(
                                  null,
                                  'Please provide Name',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.aadhar.isNullOrBlank) {
                                Get.snackbar(
                                  null,
                                  'Please enter Aadhar Number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (!verhoeff.validate(adminC.aadhar.text)) {
                                Get.snackbar(
                                  null,
                                  'Please add valid aadhar number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (AppUtils.checkTextisNull(adminC.dtOfBirth, 'Dob')) {
                                Get.snackbar(
                                  null,
                                  'Please provide DOB',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.empPhone.text.length != 10) {
                                Get.snackbar(
                                  null,
                                  'Please provide 10 digit phone number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.client == null) {
                                Get.snackbar(
                                  null,
                                  'Client is not selected',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.designation == null) {
                                Get.snackbar(
                                  null,
                                  'Designation is not selected',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (AppUtils.checkTextisNull(adminC.dtOfJoin, 'Joining Date')) {
                                Get.snackbar(
                                  null,
                                  'Please provide Joining Date',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else {
                                adminC.proofAadharNumber.text = adminC.aadhar.text;
                                adminC.proofAadharNumberConfirm.text = adminC.aadhar.text;
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
