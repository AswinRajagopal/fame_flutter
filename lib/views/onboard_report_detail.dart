import 'package:fame/widgets/emp_onboard_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';

class OnboardReportDetail extends StatefulWidget {
  final String clientId;

  OnboardReportDetail(this.clientId);

  @override
  _OnboardReportDetail createState() => _OnboardReportDetail();
}

class _OnboardReportDetail extends State<OnboardReportDetail> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  TextEditingController searchQuery = TextEditingController();
  bool isSearching = false;
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
    size: 30.0,
  );
  String searchText = '';
  Widget appBarTitle;

  @override
  void initState() {
    appBarTitle = Text(
      'Onboarding Report',
    );
    epC.pr = ProgressDialog(
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
    epC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      epC.getOnboardEmp(widget.clientId, AppUtils.NAME);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleSearchStart() {
    setState(() {
      isSearching = true;
    });
  }

  void handleSearchEnd() {
    setState(() {
      actionIcon = Icon(
        Icons.search,
        color: Colors.white,
        size: 30.0,
      );
      appBarTitle = Text(
        'Employee Report',
      );
      isSearching = false;
      epC.searchList.clear();
      searchQuery.clear();
    });
  }

  void onSearchTextChanged(String text) async {
    epC.searchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    epC.getEmpReportRes['empDailyAttView'].forEach((emp) {
      if (emp['name'].toString().toLowerCase().contains(text.toLowerCase()) || emp['empId'].toString().toLowerCase().contains(text.toLowerCase())) {
        epC.searchList.add(emp);
      }
    });

    // print(enC.searchList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppUtils().greyScaffoldBg,
        appBar: AppBar(title: appBarTitle),
        body: Obx(() {
          print(epC.isLoadingEmpReport.value);
          return SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 12),
                      height: 75.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            5.0,
                          ),
                        ),
                        border: Border.all(
                          color: Colors.grey[400],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${epC.added.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Added',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.grey[400],
                                indent: 8.0,
                                endIndent: 8.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${epC.approved.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Approved',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.grey[400],
                                indent: 8.0,
                                endIndent: 8.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${epC.rejected.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Rejected',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.grey[400],
                                indent: 8.0,
                                endIndent: 8.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${epC.pending.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Pending',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
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
                  ],
                ),
                Positioned(
                  top: 70.0,
                  bottom: 10.0,
                  left: 0.0,
                  right: 0.0,
                  child: Obx(() {
                    if (epC.isLoadingEmpReport.value) {
                      return Column();
                    } else if (epC.getEmpReportRes['empList'] == null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No report found',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      );
                    }
                    return Obx(() {
                      return Scrollbar(
                        radius: Radius.circular(
                          10.0,
                        ),
                        thickness: 5.0,
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: epC.searchList.isNotEmpty ? epC.searchList.length : epC.getEmpReportRes['empList'].length,
                          itemBuilder: (context, index) {
                            var emp = epC.searchList.isNotEmpty ? epC.searchList[index] : epC.getEmpReportRes['empList'][index];
                            return EmpOnboardDetailWidget(emp);
                          },
                        ),
                      );
                    });
                  }),
                ),
              ],
            ),
          );
        }));
  }
}
