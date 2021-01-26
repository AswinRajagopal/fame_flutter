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
  TabController tabController;
  var gender = 'M';
  var sitePostedTo;
  var dob;
  var currentTabIndex = 0;

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
    // Future.delayed(
    //   Duration(milliseconds: 100),
    //   adminC.getDesignation,
    // );
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
        // dtOfBirth.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        dob = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
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
                  Tab(
                    text: 'Personal Info',
                  ),
                  Tab(
                    text: 'Bank & Uniform',
                  ),
                  Tab(
                    text: 'Address',
                  ),
                  Tab(
                    text: 'Family Detail',
                  ),
                  Tab(
                    text: 'Photos',
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
              // Test('Tab 1 goes here'),
              StepOne(),
              Test('Tab 2 goes here'),
              Test('Tab 3 goes here'),
              Test('Tab 4 goes here'),
              Test('Tab 5 goes here'),
            ],
          ),
        ),
      ),
    );
  }
}

class StepOne extends StatefulWidget {
  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  var gender = 'M';

  @override
  Widget build(BuildContext context) {
    return Container(
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
              // controller: name,
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
                    // setState(() {
                    //   gender = sVal;
                    // });
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
                    // setState(() {
                    //   gender = sVal;
                    // });
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
                          value: 'M',
                          groupValue: gender,
                          onChanged: (sVal) {
                            // setState(() {
                            //   gender = sVal;
                            // });
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
                          value: 'F',
                          groupValue: gender,
                          onChanged: (sVal) {
                            // setState(() {
                            //   gender = sVal;
                            // });
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
                          value: 'F',
                          groupValue: gender,
                          onChanged: (sVal) {
                            // setState(() {
                            //   gender = sVal;
                            // });
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
                          value: 'F',
                          groupValue: gender,
                          onChanged: (sVal) {
                            // setState(() {
                            //   gender = sVal;
                            // });
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
              // controller: dtOfBirth,
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
                // getDate(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: TextField(
              // controller: dtOfBirth,
              readOnly: true,
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
              onTap: () {
                // getDate(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: TextField(
              // controller: empPhone,
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
        ],
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
