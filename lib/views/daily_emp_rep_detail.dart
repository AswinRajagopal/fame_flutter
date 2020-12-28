import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class DailyEmpRepDetail extends StatefulWidget {
  final String empId;
  final String fdate;
  final String tdate;
  DailyEmpRepDetail(this.empId, this.fdate, this.tdate);

  @override
  _DailyEmpRepDetailState createState() => _DailyEmpRepDetailState();
}

class _DailyEmpRepDetailState extends State<DailyEmpRepDetail> {
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
      'Daily Employee Report',
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    epC.pr.style(
      backgroundColor: Colors.black,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      epC.getDailyEmployeeReport(widget.empId, widget.fdate, widget.tdate, AppUtils.NAME);
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
        'Daily Employee Report',
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

    epC.getEmpDetailRepRes['empDailyAttView'].forEach((emp) {
      if (emp['name'].toString().toLowerCase().contains(text.toLowerCase()) || emp['empId'].toString().toLowerCase().contains(text.toLowerCase())) {
        epC.searchList.add(emp);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: appBarTitle,
        // actions: <Widget>[
        //   IconButton(
        //     icon: actionIcon,
        //     onPressed: () {
        //       setState(() {
        //         if (actionIcon.icon == Icons.search) {
        //           actionIcon = Icon(
        //             Icons.close,
        //             color: Colors.white,
        //             size: 30.0,
        //           );
        //           appBarTitle = TextField(
        //             controller: searchQuery,
        //             autofocus: true,
        //             style: TextStyle(
        //               color: Colors.white,
        //             ),
        //             decoration: InputDecoration(
        //               prefixIcon: Icon(
        //                 Icons.search,
        //                 color: Colors.white,
        //                 size: 30.0,
        //               ),
        //               hintText: 'Search...',
        //               hintStyle: TextStyle(
        //                 color: Colors.white,
        //               ),
        //               enabledBorder: InputBorder.none,
        //             ),
        //             cursorColor: Colors.white,
        //             onChanged: (query) {
        //               onSearchTextChanged(query);
        //             },
        //           );
        //           handleSearchStart();
        //         } else {
        //           handleSearchEnd();
        //         }
        //       });
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Center(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //           vertical: 15.0,
            //         ),
            //         child: Container(
            //           height: 50.0,
            //           width: MediaQuery.of(context).size.width / 1.3,
            //           decoration: BoxDecoration(
            //             color: Colors.blue,
            //             borderRadius: BorderRadius.all(
            //               Radius.circular(
            //                 50.0,
            //               ),
            //             ),
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               GestureDetector(
            //                 onTap: () {
            //                   if (epC.reportType != 'name') {
            //                     epC.getDailyEmployeeReport(widget.empId, widget.fdate, widget.tdate, AppUtils.NAME);
            //                   }
            //                   setState(() {
            //                     epC.reportType = 'name';
            //                   });
            //                 },
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     color: epC.reportType == 'name' ? Colors.white : Colors.blue,
            //                     borderRadius: BorderRadius.all(
            //                       Radius.circular(
            //                         50.0,
            //                       ),
            //                     ),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                       vertical: 7.0,
            //                       horizontal: 45.0,
            //                     ),
            //                     child: Text(
            //                       'Name',
            //                       style: TextStyle(
            //                         fontSize: 18.0,
            //                         fontWeight: FontWeight.bold,
            //                         color: epC.reportType == 'name' ? Colors.blue : Colors.white,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               GestureDetector(
            //                 onTap: () {
            //                   if (epC.reportType != 'empid') {
            //                     epC.getDailyEmployeeReport(widget.empId, widget.fdate, widget.tdate, AppUtils.EMP_ID);
            //                   }
            //                   setState(() {
            //                     epC.reportType = 'empid';
            //                   });
            //                 },
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     color: epC.reportType == 'empid' ? Colors.white : Colors.blue,
            //                     borderRadius: BorderRadius.all(
            //                       Radius.circular(
            //                         50.0,
            //                       ),
            //                     ),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                       vertical: 7.0,
            //                       horizontal: 45.0,
            //                     ),
            //                     child: Text(
            //                       'Emp ID',
            //                       style: TextStyle(
            //                         fontSize: 18.0,
            //                         fontWeight: FontWeight.bold,
            //                         color: epC.reportType == 'empid' ? Colors.blue : Colors.white,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Positioned(
              // top: 70.0,
              top: 10.0,
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Obx(() {
                if (epC.isLoadingDaily.value) {
                  return Column();
                } else if (epC.getEmpDetailRepRes['empDailyAttView'] == null) {
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
                return SingleChildScrollView(
                  child: Obx(() {
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: epC.searchList.isNotEmpty ? epC.searchList.length : epC.dailySearch.length,
                      itemBuilder: (context, index) {
                        var emp = epC.searchList.isNotEmpty ? epC.searchList[index] : epC.dailySearch[index];
                        return Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date : ${emp['date']}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Timing : ${emp['time']}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Client ID : ' + emp['empId'],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Status : ${emp['attendanceAlias'] ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Creator : ${emp['checkInLatitude'] == '0E-8' ? 'Unit incharge' : 'Self'}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
