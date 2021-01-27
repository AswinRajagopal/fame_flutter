import '../utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/admin_controller.dart';
import 'package:flutter/material.dart';

class AddEmployeeNew extends StatefulWidget {
  @override
  _AddEmployeeNewState createState() => _AddEmployeeNewState();
}

class _AddEmployeeNewState extends State<AddEmployeeNew> with SingleTickerProviderStateMixin {
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
  TabController tabController;
  var gender = 'M';
  var mStatus = 'Married';
  var department;
  var client;
  var blood;
  var designation;
  var sitePostedTo;
  var dob;
  var doj;
  var presentState;
  var presentCity;
  var permanentState;
  var permanentCity;
  var currentTabIndex = 0;
  bool copyAdd = false;

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
      initialDate: DateTime.parse(
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

  Future<Null> getJoiningDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
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
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: (gotoIndex) {
                  print('currentTabIndex: $currentTabIndex');
                  print('gotoIndex: $gotoIndex');
                  setState(() {
                    currentTabIndex = gotoIndex;
                  });
                },
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
                      // print('clicked');
                      tabController.animateTo(0);
                    },
                    child: Tab(
                      text: 'Personal Info',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // print('clicked');
                      var checkValidation = validateStep(currentTabIndex);
                      if (checkValidation) {
                        tabController.animateTo(1);
                      }
                    },
                    child: Tab(
                      text: 'Bank & Uniform',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // print('clicked');
                      tabController.animateTo(2);
                    },
                    child: Tab(
                      text: 'Address',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // print('clicked');
                      tabController.animateTo(3);
                    },
                    child: Tab(
                      text: 'Family Detail',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // print('clicked');
                      tabController.animateTo(4);
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
                                // value: json.encode(aC.clientList.first.clientManpowerList),
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
              Test('Tab 2 goes here'),
              // Test('Tab 3 goes here'),
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
              Test('Tab 4 goes here'),
              Test('Tab 5 goes here'),
            ],
          ),
        ),
      ),
    );
  }
}

class Test extends StatelessWidget {
  final String title;
  Test(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}
