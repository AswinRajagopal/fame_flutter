import '../widgets/emp_rep_detail_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class EmpReportDetail extends StatefulWidget {
  final String clientId;
  EmpReportDetail(this.clientId);

  @override
  _EmpReportDetailState createState() => _EmpReportDetailState();
}

class _EmpReportDetailState extends State<EmpReportDetail> {
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
      'Employee Report',
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
      epC.getEmpReport(widget.clientId, AppUtils.NAME);
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
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (actionIcon.icon == Icons.search) {
                  actionIcon = Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30.0,
                  );
                  appBarTitle = TextField(
                    controller: searchQuery,
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                    onChanged: (query) {
                      onSearchTextChanged(query);
                    },
                  );
                  handleSearchStart();
                } else {
                  handleSearchEnd();
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
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
                            onTap: () {
                              if (epC.reportType != 'name') {
                                epC.getEmpReport(widget.clientId, AppUtils.NAME);
                              }
                              setState(() {
                                epC.reportType = 'name';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: epC.reportType == 'name' ? Colors.white : Theme.of(context).primaryColor,
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
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: epC.reportType == 'name' ? Theme.of(context).primaryColor : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (epC.reportType != 'empid') {
                                epC.getEmpReport(widget.clientId, AppUtils.EMP_ID);
                              }
                              setState(() {
                                epC.reportType = 'empid';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: epC.reportType == 'empid' ? Colors.white : Theme.of(context).primaryColor,
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
                                      'Emp ID',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: epC.reportType == 'empid' ? Theme.of(context).primaryColor : Colors.white,
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
                ],
              ),
            ),
            Positioned(
              top: 70.0,
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Obx(() {
                if (epC.isLoadingEmpReport.value) {
                  return Column();
                } else if (epC.getEmpReportRes['empDailyAttView'] == null) {
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
                      itemCount: epC.searchList.isNotEmpty ? epC.searchList.length : epC.getEmpReportRes['empDailyAttView'].length,
                      itemBuilder: (context, index) {
                        var emp = epC.searchList.isNotEmpty ? epC.searchList[index] : epC.getEmpReportRes['empDailyAttView'][index];
                        return EmpRepDetailWidget(emp,  epC.designation[int.parse(emp['designation'].toString())]['design']);
                      },
                    ),
                  );
                });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
