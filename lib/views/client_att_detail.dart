import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ClientAttDetail extends StatefulWidget {
  final String clientId;
  final String date;
  final String shift;
  ClientAttDetail(this.clientId, this.date, this.shift);

  @override
  _ClientAttDetailState createState() => _ClientAttDetailState();
}

class _ClientAttDetailState extends State<ClientAttDetail> {
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
      'Client Report',
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
      epC.getClientReport(widget.clientId, widget.date, widget.shift, AppUtils.NAME);
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
        'Client Report',
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

    epC.getClientRepRes['empDailyAttView'].forEach((emp) {
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
                                epC.getClientReport(widget.clientId, widget.date, widget.shift, AppUtils.NAME);
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
                                epC.getClientReport(widget.clientId, widget.date, widget.shift, AppUtils.EMP_ID);
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
                if (epC.isLoadingAtt.value) {
                  return Column();
                } else if (epC.getClientRepRes['empDailyAttView'] == null) {
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
                      itemCount: epC.searchList.isNotEmpty ? epC.searchList.length : epC.clientReport.length,
                      itemBuilder: (context, index) {
                        var client = epC.searchList.isNotEmpty ? epC.searchList[index] : epC.clientReport[index];
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
                                      '${client['name'] + ' : ' + client['empId']}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).primaryColor,
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
                                      epC.designation[int.parse(
                                          client['designation']
                                              .toString())]['design'],
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
                                  children: [
                                    Text(
                                      'Timing : ${client['showtime']}',
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
                                      'Status : ${client['attendanceAlias'] ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Creator : ${client['checkInLatitude'] == '0E-8' ? 'Unit incharge' : 'Self'}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: AppUtils().orangeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
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
