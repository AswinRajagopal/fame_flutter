import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:checkdigit/checkdigit.dart';

import '../controllers/admin_controller.dart';
import 'package:flutter/material.dart';

class AddEmployeeNew extends StatefulWidget {
  @override
  _AddEmployeeNewState createState() => _AddEmployeeNewState();
}

class _AddEmployeeNewState extends State<AddEmployeeNew> with AutomaticKeepAliveClientMixin<AddEmployeeNew>, SingleTickerProviderStateMixin {
  final AdminController adminC = Get.put(AdminController());
  TextEditingController name = TextEditingController();
  TextEditingController dtOfBirth = TextEditingController();
  TextEditingController dtOfJoin = TextEditingController();
  TextEditingController language = TextEditingController();
  TextEditingController empPhone = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController reporting = TextEditingController();
  TextEditingController presenthouseNo = TextEditingController();
  TextEditingController presentStreet = TextEditingController();
  TextEditingController presentColony = TextEditingController();
  TextEditingController permanenthouseNo = TextEditingController();
  TextEditingController permanentStreet = TextEditingController();
  TextEditingController permanentColony = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController ageFather = TextEditingController();
  TextEditingController aadharNumberFather = TextEditingController();
  TextEditingController dobFather = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController ageFamily = TextEditingController();
  TextEditingController aadharNumberFamily = TextEditingController();
  TextEditingController dobFamily = TextEditingController();
  TextEditingController proofAadharNumber = TextEditingController();
  TextEditingController proofAadharNumberConfirm = TextEditingController();
  TextEditingController proofNumber2 = TextEditingController();
  TextEditingController proofNumber3 = TextEditingController();
  TextEditingController proof1 = TextEditingController();
  TextEditingController proof2 = TextEditingController();
  TextEditingController proof3 = TextEditingController();
  TextEditingController proof4 = TextEditingController();
  TextEditingController proof5 = TextEditingController();
  TextEditingController proof6 = TextEditingController();
  File aadhar1;
  File aadhar2;
  File proof11;
  File proof12;
  File proof21;
  File proof22;
  TabController tabController;
  var gender = 'M';
  var mStatus = 'UnMarried';
  var department;
  var client;
  var blood;
  var designation;
  var sitePostedTo;
  var dob;
  var doj;
  var presentState;
  var bank;
  var presentCity;
  var permanentState;
  var permanentCity;
  var shirtSize;
  var pantSize;
  var shoeSize;
  var dobFatherVal;
  var dobFamilyVal;
  var idProof1;
  var idProof2;
  var relFather = 'Father';
  var relFamily;
  var currentTabIndex = 0;
  bool copyAdd = false;
  bool nominee1 = false;
  bool nominee2 = false;

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
    Future.delayed(Duration(milliseconds: 100), adminC.getData);
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  var curDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Future<Null> getDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dob != null
          ? DateTime.parse(
              dob.toString(),
            )
          : DateTime.parse(
              curDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -36500)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // print('Date selected ${dtOfBirth.text.toString()}');
      setState(() {
        dtOfBirth.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        dob = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> getFatherDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dobFatherVal != null
          ? DateTime.parse(
              dobFatherVal.toString(),
            )
          : DateTime.parse(
              curDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -36500)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // print('Date selected ${dtOfBirth.text.toString()}');
      setState(() {
        dobFather.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        dobFatherVal = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> getFamilyDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dobFamilyVal != null
          ? DateTime.parse(
              dobFamilyVal.toString(),
            )
          : DateTime.parse(
              curDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -36500)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // print('Date selected ${dtOfBirth.text.toString()}');
      setState(() {
        dobFamily.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        dobFamilyVal = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> getJoiningDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: doj != null
          ? DateTime.parse(
              doj.toString(),
            )
          : DateTime.parse(
              curDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -60)),
      lastDate: DateTime.now().add(Duration(days: 120)),
    );

    if (picked != null) {
      // print('Date selected ${dtOfBirth.text.toString()}');
      setState(() {
        dtOfJoin.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        doj = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  bool validateStep(step) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (step == 0) {
      if (name.isNullOrBlank || dtOfBirth.isNullOrBlank || language.isNullOrBlank || empPhone.isNullOrBlank || dtOfJoin.isNullOrBlank || department == null || client == null || blood == null || designation == null || qualification == null || reporting == null) {
        Get.snackbar(
          null,
          'Please fill all data',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        return false;
      } else if (empPhone.text.length != 10) {
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
        return false;
      } else {
        return true;
      }
    } else if (step == 1) {
      if (bank == null || accountNo.isNullOrBlank || ifsc.isNullOrBlank || shirtSize == null || pantSize == null || shoeSize == null) {
        Get.snackbar(
          null,
          'Please fill all data',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        return false;
      } else {
        return true;
      }
    } else if (step == 2) {
      if (presenthouseNo.isNullOrBlank || presentStreet.isNullOrBlank || presentColony.isNullOrBlank || presentState == null || presentCity == null || permanenthouseNo.isNullOrBlank || permanentStreet.isNullOrBlank || permanentColony.isNullOrBlank || permanentState == null || permanentCity == null) {
        Get.snackbar(
          null,
          'Please fill all data',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        return false;
      } else {
        return true;
      }
    } else if (step == 3) {
      if (fatherName.isNullOrBlank || dobFather.isNullOrBlank || ageFather.isNullOrBlank || aadharNumberFather.isNullOrBlank || relFather == null || familyName.isNullOrBlank || dobFamily.isNullOrBlank || ageFamily.isNullOrBlank || aadharNumberFamily.isNullOrBlank || relFamily == null) {
        Get.snackbar(
          null,
          'Please fill all data',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        return false;
      } else if (!verhoeff.validate(aadharNumberFather.text) || !verhoeff.validate(aadharNumberFamily.text)) {
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
        return false;
      } else {
        return true;
      }
    } else if (step == 4) {
      //     File aadhar1;
      // File aadhar2;
      // File proof11;
      // File proof12;
      // File proof21;
      // File proof22;
      if (proofAadharNumber.isNullOrBlank || proofAadharNumberConfirm.isNullOrBlank || proofNumber2.isNullOrBlank || proofNumber3.isNullOrBlank || aadhar1 == null || aadhar2 == null || proof11 == null || proof12 == null || proof21 == null || proof22 == null || idProof1 == null || idProof2 == null) {
        Get.snackbar(
          null,
          'Please fill all data',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
        return false;
      } else if (!verhoeff.validate(aadharNumberFather.text) || !verhoeff.validate(aadharNumberFamily.text)) {
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
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppUtils().innerScaffoldBg,
        appBar: AppBar(
          title: Text(
            'Add Employee',
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: ColoredBox(
              color: Colors.white,
              child: TabBar(
                // onTap: (gotoIndex) {
                //   print('currentTabIndex: $currentTabIndex');
                //   print('gotoIndex: $gotoIndex');
                //   setState(() {
                //     currentTabIndex = gotoIndex;
                //   });
                // },
                isScrollable: true,
                indicatorColor: Colors.grey,
                unselectedLabelColor: Theme.of(context).primaryColor,
                indicatorWeight: 5.0,
                labelStyle: TextStyle(
                  fontSize: 18.0,
                ),
                labelColor: Theme.of(context).primaryColor,
                tabs: [
                  GestureDetector(
                    onTap: () {
                      tabController.animateTo(0);
                      setState(() {
                        currentTabIndex = 0;
                      });
                    },
                    child: Tab(
                      text: 'Personal Info',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('currentTabIndex: $currentTabIndex');
                      print('goto: 1');
                      if (currentTabIndex > 1) {
                        tabController.animateTo(1);
                        setState(() {
                          currentTabIndex = 1;
                        });
                      } else if (validateStep(currentTabIndex)) {
                        tabController.animateTo(1);
                        setState(() {
                          currentTabIndex = 1;
                        });
                      }
                    },
                    child: Tab(
                      text: 'Bank & Uniform',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('currentTabIndex: $currentTabIndex');
                      print('goto: 2');
                      if (currentTabIndex > 2) {
                        tabController.animateTo(2);
                        setState(() {
                          currentTabIndex = 2;
                        });
                      } else if (validateStep(currentTabIndex)) {
                        tabController.animateTo(2);
                        setState(() {
                          currentTabIndex = 2;
                        });
                      }
                    },
                    child: Tab(
                      text: 'Address',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('currentTabIndex: $currentTabIndex');
                      print('goto: 3');
                      if (currentTabIndex > 3) {
                        tabController.animateTo(3);
                        setState(() {
                          currentTabIndex = 3;
                        });
                      } else if (validateStep(currentTabIndex)) {
                        tabController.animateTo(3);
                        setState(() {
                          currentTabIndex = 3;
                        });
                      }
                    },
                    child: Tab(
                      text: 'Family Detail',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('currentTabIndex: $currentTabIndex');
                      print('goto: 4');
                      if (currentTabIndex > 4) {
                        tabController.animateTo(4);
                        setState(() {
                          currentTabIndex = 4;
                        });
                      } else if (validateStep(currentTabIndex)) {
                        tabController.animateTo(4);
                        setState(() {
                          currentTabIndex = 4;
                        });
                      }
                    },
                    child: Tab(
                      text: 'Photos',
                    ),
                  ),
                ],
                controller: tabController,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              // STEP 1 - Personal Info
              Obx(() {
                if (adminC.isLoadingData.value) {
                  return Column();
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.29,
                        child: ListView(
                          shrinkWrap: true,
                          primary: true,
                          physics: ScrollPhysics(),
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: name,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Name',
                                ),
                              ),
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
                                    groupValue: gender,
                                    onChanged: (sVal) {
                                      setState(() {
                                        gender = sVal;
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
                                    groupValue: gender,
                                    onChanged: (sVal) {
                                      setState(() {
                                        gender = sVal;
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
                                            value: 'UnMarried',
                                            groupValue: mStatus,
                                            onChanged: (sVal) {
                                              setState(() {
                                                mStatus = sVal;
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
                                            value: 'Married',
                                            groupValue: mStatus,
                                            onChanged: (sVal) {
                                              setState(() {
                                                mStatus = sVal;
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
                                            value: 'Divorcee',
                                            groupValue: mStatus,
                                            onChanged: (sVal) {
                                              setState(() {
                                                mStatus = sVal;
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
                                            value: 'Widow',
                                            groupValue: mStatus,
                                            onChanged: (sVal) {
                                              setState(() {
                                                mStatus = sVal;
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
                              child: TextField(
                                controller: dtOfBirth,
                                readOnly: true,
                                keyboardType: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Date of Birth',
                                  prefixIcon: Image.asset(
                                    'assets/images/icon_calender.png',
                                    color: Colors.grey,
                                    scale: 1.2,
                                  ),
                                ),
                                onTap: () {
                                  getDate(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: language,
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
                                controller: empPhone,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Phone No.',
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
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select Department',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: true,
                                value: department,
                                items: adminC.departmentsList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['deptName'],
                                    ),
                                    value: item['deptId'].toString(),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/branch.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  department = value;
                                  // setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select Client',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: false,
                                value: client,
                                items: adminC.clientList.map((item) {
                                  //print('item: $item');
                                  var sC = item['name'] + ' - ' + item['id'].toString();
                                  return DropdownMenuItem(
                                    child: Text(
                                      sC,
                                    ),
                                    value: item['id'],
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/siteposted.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  client = value;
                                  // setState(() {});
                                },
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
                                value: blood,
                                items: adminC.bloodGroupsList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['bloodGroupName'],
                                    ),
                                    value: item['bloodGroupId'],
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
                                  blood = value;
                                  // setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select Designation',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: false,
                                value: designation,
                                items: adminC.designationsList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['design'],
                                    ),
                                    value: item['designId'],
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/designation.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  designation = value;
                                  // setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: dtOfJoin,
                                readOnly: true,
                                keyboardType: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Date of Joining',
                                  prefixIcon: Image.asset(
                                    'assets/images/icon_calender.png',
                                    color: Colors.grey,
                                    scale: 1.2,
                                  ),
                                ),
                                onTap: () {
                                  getJoiningDate(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: qualification,
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
                                controller: reporting,
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      print('Cancel');
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
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if (validateStep(0)) {
                                        tabController.animateTo(1);
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
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // STEP 2 - Bank & Uniform
              Obx(() {
                if (adminC.isLoadingData.value) {
                  return Column();
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.29,
                        child: ListView(
                          shrinkWrap: true,
                          primary: true,
                          physics: ScrollPhysics(),
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Text(
                                'Bank Details',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Select Bank',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                isExpanded: false,
                                value: bank,
                                items: adminC.bankNamesList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        item['bankname'],
                                      ),
                                    ),
                                    value: item['bankId'],
                                  );
                                }).toList(),
                                // decoration: InputDecoration(
                                //   prefixIcon: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Image.asset(
                                //         'assets/images/state.png',
                                //         color: Colors.grey[400],
                                //         scale: 2.0,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  bank = value;
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: accountNo,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Account No.',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: ifsc,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'IFSC',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Text(
                                'Uniform Details',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Select Shirt Size',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                isExpanded: false,
                                value: shirtSize,
                                items: adminC.shirtSizes.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        item,
                                      ),
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                // decoration: InputDecoration(
                                //   prefixIcon: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Image.asset(
                                //         'assets/images/state.png',
                                //         color: Colors.grey[400],
                                //         scale: 2.0,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  shirtSize = value;
                                  // setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Select Pant Size',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                isExpanded: false,
                                value: pantSize,
                                items: adminC.pantSizes.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        item,
                                      ),
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                // decoration: InputDecoration(
                                //   prefixIcon: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Image.asset(
                                //         'assets/images/state.png',
                                //         color: Colors.grey[400],
                                //         scale: 2.0,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  pantSize = value;
                                  // setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Select Shoe Size',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                isExpanded: false,
                                value: shoeSize,
                                items: adminC.shoeSizes.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        item,
                                      ),
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                // decoration: InputDecoration(
                                //   prefixIcon: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Image.asset(
                                //         'assets/images/state.png',
                                //         color: Colors.grey[400],
                                //         scale: 2.0,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  shoeSize = value;
                                  // setState(() {});
                                },
                              ),
                            ),
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if (validateStep(1)) {
                                        tabController.animateTo(2);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 100.0,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // STEP 3 - Address Step
              Obx(() {
                if (adminC.isLoadingData.value) {
                  return Column();
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.29,
                        child: ListView(
                          shrinkWrap: true,
                          primary: true,
                          physics: ScrollPhysics(),
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Text(
                                'Present Address',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: presenthouseNo,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'House No.',
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/home.png',
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
                                controller: presentStreet,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Street',
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/street.png',
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
                                controller: presentColony,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Colony',
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/colony.png',
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
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select State',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: false,
                                value: presentState,
                                items: adminC.statesList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['state'],
                                    ),
                                    value: item['stateID'],
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/state.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  presentState = value;
                                  setState(() {});
                                  adminC.getCities(int.parse(value), 'present');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select City',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: false,
                                value: presentCity,
                                items: adminC.citiesList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['city'],
                                    ),
                                    value: item['cityID'],
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/city.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  presentCity = value;
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: copyAdd,
                                    onChanged: (value) {
                                      print(value);
                                      if (presenthouseNo.text.isNullOrBlank || presentStreet.text.isNullOrBlank || presentColony.text.isNullOrBlank || presentState == null || presentCity == null) {
                                        Get.snackbar(
                                          null,
                                          'Please fill present address first',
                                          colorText: Colors.white,
                                          backgroundColor: Colors.black87,
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                          borderRadius: 5.0,
                                        );
                                      } else {
                                        if (value) {
                                          permanenthouseNo.text = presenthouseNo.text;
                                          permanentStreet.text = presentStreet.text;
                                          permanentColony.text = presentColony.text;
                                          permanentState = presentState;
                                          permanentCity = presentCity;
                                          adminC.percitiesList.addAll(adminC.citiesList);
                                        } else {
                                          permanenthouseNo.clear();
                                          permanentStreet.clear();
                                          permanentColony.clear();
                                          permanentState = null;
                                          permanentCity = null;
                                          adminC.percitiesList.clear();
                                        }
                                        copyAdd = value;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  Text(
                                    'Copy to Permanent Address',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.0,
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
                              child: Text(
                                'Permanent Address',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: TextField(
                                controller: permanenthouseNo,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'House No.',
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/home.png',
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
                                controller: permanentStreet,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Street',
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/street.png',
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
                                controller: permanentColony,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                  ),
                                  hintText: 'Colony',
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/colony.png',
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
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select State',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: false,
                                value: permanentState,
                                items: adminC.statesList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['state'],
                                    ),
                                    value: item['stateID'],
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/state.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  permanentState = value;
                                  setState(() {});
                                  adminC.getCities(int.parse(value), 'permanent');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: DropdownButtonFormField<dynamic>(
                                hint: Text(
                                  'Select City',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isExpanded: false,
                                value: permanentCity,
                                items: adminC.percitiesList.map((item) {
                                  //print('item: $item');
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['city'],
                                    ),
                                    value: item['cityID'],
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/city.png',
                                        color: Colors.grey[400],
                                        scale: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  permanentCity = value;
                                  setState(() {});
                                },
                              ),
                            ),
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if (validateStep(2)) {
                                        tabController.animateTo(3);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 100.0,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // STEP 4 - Family Detail
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.29,
                      child: ListView(
                        shrinkWrap: true,
                        primary: true,
                        physics: ScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Text(
                              'S. No. 1',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: TextField(
                              controller: fatherName,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Father Name',
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/user.png',
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
                              controller: dobFather,
                              readOnly: true,
                              keyboardType: null,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Date of Birth',
                                prefixIcon: Image.asset(
                                  'assets/images/icon_calender.png',
                                  color: Colors.grey,
                                  scale: 1.2,
                                ),
                              ),
                              onTap: () {
                                getFatherDate(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: TextField(
                              controller: ageFather,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Age',
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/age.png',
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
                              controller: aadharNumberFather,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Aadhar Number',
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
                            child: DropdownButtonFormField<dynamic>(
                              hint: Text(
                                'Select Relation',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              isExpanded: false,
                              value: relFather,
                              items: adminC.relationShip.map((item) {
                                //print('item: $item');
                                return DropdownMenuItem(
                                  child: Text(
                                    item,
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/relation.png',
                                      color: Colors.grey[400],
                                      scale: 2.0,
                                    ),
                                  ],
                                ),
                              ),
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                relFather = value;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.asset(
                                    'assets/images/nominee.png',
                                    color: Colors.grey[400],
                                    scale: 2.2,
                                  ),
                                ),
                                Checkbox(
                                  value: nominee1,
                                  onChanged: (value) {
                                    print(value);
                                    nominee1 = value;
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  'Nominee',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.0,
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
                            child: Text(
                              'S. No. 2',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: TextField(
                              controller: familyName,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Name',
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/user.png',
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
                              controller: dobFamily,
                              readOnly: true,
                              keyboardType: null,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Date of Birth',
                                prefixIcon: Image.asset(
                                  'assets/images/icon_calender.png',
                                  color: Colors.grey,
                                  scale: 1.2,
                                ),
                              ),
                              onTap: () {
                                getFamilyDate(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: TextField(
                              controller: ageFamily,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Age',
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/age.png',
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
                              controller: aadharNumberFamily,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Aadhar Number',
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
                            child: DropdownButtonFormField<dynamic>(
                              hint: Text(
                                'Select Relation',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              isExpanded: false,
                              value: relFamily,
                              items: adminC.relationShip.map((item) {
                                //print('item: $item');
                                return DropdownMenuItem(
                                  child: Text(
                                    item,
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/relation.png',
                                      color: Colors.grey[400],
                                      scale: 2.0,
                                    ),
                                  ],
                                ),
                              ),
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                relFamily = value;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.asset(
                                    'assets/images/nominee.png',
                                    color: Colors.grey[400],
                                    scale: 2.2,
                                  ),
                                ),
                                Checkbox(
                                  value: nominee2,
                                  onChanged: (value) {
                                    print(value);
                                    nominee2 = value;
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  'Nominee',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if (validateStep(3)) {
                                      tabController.animateTo(4);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 100.0,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // STEP 5 - Photos
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.29,
                      child: ListView(
                        shrinkWrap: true,
                        primary: true,
                        physics: ScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Text(
                              'ID Proof 1',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: proof1,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Upload ID Proof',
                                      suffixIcon: Image.asset(
                                        'assets/images/uplode_proof.png',
                                        // color: Colors.grey,
                                        scale: 2.2,
                                      ),
                                    ),
                                    readOnly: true,
                                    keyboardType: null,
                                    onTap: () async {
                                      var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        aadhar1 = File(pickedFile.path);
                                        proof1.text = path.basename(pickedFile.path);
                                        setState(() {});
                                      } else {
                                        print('No image selected.');
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: proof2,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Upload ID Proof',
                                      suffixIcon: Image.asset(
                                        'assets/images/uplode_proof.png',
                                        // color: Colors.grey,
                                        scale: 2.2,
                                      ),
                                    ),
                                    readOnly: true,
                                    keyboardType: null,
                                    onTap: () async {
                                      var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        aadhar2 = File(pickedFile.path);
                                        proof2.text = path.basename(pickedFile.path);
                                        setState(() {});
                                      } else {
                                        print('No image selected.');
                                      }
                                    },
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
                            child: TextField(
                              controller: proofAadharNumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Aadhar Number',
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
                              controller: proofAadharNumberConfirm,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Re-enter Aadhar Number',
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
                            child: Text(
                              'ID Proof 2',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: DropdownButtonFormField<dynamic>(
                              hint: Text(
                                'Select ID Proof',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              isExpanded: false,
                              value: idProof1,
                              items: adminC.proofList.map((item) {
                                //print('item: $item');
                                return DropdownMenuItem(
                                  child: Text(
                                    item,
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              decoration: InputDecoration(
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
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                idProof1 = value;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: proof3,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Upload ID Proof',
                                      suffixIcon: Image.asset(
                                        'assets/images/uplode_proof.png',
                                        // color: Colors.grey,
                                        scale: 2.2,
                                      ),
                                    ),
                                    readOnly: true,
                                    keyboardType: null,
                                    onTap: () {
                                      // fromDate(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: proof4,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Upload ID Proof',
                                      suffixIcon: Image.asset(
                                        'assets/images/uplode_proof.png',
                                        // color: Colors.grey,
                                        scale: 2.2,
                                      ),
                                    ),
                                    readOnly: true,
                                    keyboardType: null,
                                    onTap: () {},
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
                            child: TextField(
                              controller: proofNumber2,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Enter Selected ID Proof Number',
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
                            child: Text(
                              'ID Proof 3',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: DropdownButtonFormField<dynamic>(
                              hint: Text(
                                'Select ID Proof',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              isExpanded: false,
                              value: idProof2,
                              items: adminC.proofList.map((item) {
                                //print('item: $item');
                                return DropdownMenuItem(
                                  child: Text(
                                    item,
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              decoration: InputDecoration(
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
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                idProof2 = value;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: proof5,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Upload ID Proof',
                                      suffixIcon: Image.asset(
                                        'assets/images/uplode_proof.png',
                                        // color: Colors.grey,
                                        scale: 2.2,
                                      ),
                                    ),
                                    readOnly: true,
                                    keyboardType: null,
                                    onTap: () {
                                      // fromDate(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: proof6,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Upload ID Proof',
                                      suffixIcon: Image.asset(
                                        'assets/images/uplode_proof.png',
                                        // color: Colors.grey,
                                        scale: 2.2,
                                      ),
                                    ),
                                    readOnly: true,
                                    keyboardType: null,
                                    onTap: () {},
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
                            child: TextField(
                              controller: proofNumber3,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Enter Selected ID Proof Number',
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if (validateStep(4)) {
                                      print('done');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 50.0,
                                    ),
                                    child: Text(
                                      'Send For Approval',
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
