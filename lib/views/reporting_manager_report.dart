import 'package:fame/controllers/reporting_manager_att_controller.dart';
import 'package:fame/widgets/reporting_manager_widget.dart';
import 'package:fame/widgets/reporting_manager_emp_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';

class ViewReport extends StatefulWidget {
  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  final RepoManagerAttController rmaC = Get.put(RepoManagerAttController());
  TextEditingController empName = TextEditingController();
  TextEditingController date = TextEditingController();
  var sDate;

  @override
  void initState() {
    rmaC.pr = ProgressDialog(
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
    rmaC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      rmaC.getRepoManagerEmpDt();
      // rmaC.getRepoManagerEmpAtt(sDate);
    });Future.delayed(Duration(milliseconds: 50), () {
      rmaC.empDetailsList.clear();
      // rmaC.getRepoManagerEmpAtt(sDate);
    });
    super.initState();
    // date.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    // sDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
  }




  @override
  void dispose() {
    super.dispose();
  }

  final DateTime curDate = DateTime.now();

  Future<Null> getDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: sDate == null
          ? curDate
          : DateTime.parse(
              sDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365 * 2)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        sDate = DateFormat('yyyy-MM-dd').format(picked).toString();
        rmaC.getRepoManagerEmpAtt(sDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Report List',
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 10.0),
                    child: Row(
                      children: [
                         Text(
                            'Filter By',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        Icon(Icons.filter_alt),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:50.0),
                    child: Container(
                      width: 50.0,
                      height: 2.0,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Text('Select Date',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Container(
                      width: 170,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: TextField(
                          controller: date,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Select Date',
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              size: 25.0,
                            ),
                          ),
                          readOnly: true,
                          keyboardType: null,
                          onTap: () {
                            getDate(context);
                            rmaC.repoAttViewList.clear();
                            rmaC.empDetailsList.clear();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(onPressed:(){
                      rmaC.getRepoManagerEmpDt();
                      date.clear();
                      setState(() {
                        rmaC.repoAttViewList.clear();
                      });
                    }, child: Text('Employees',style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold)))
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          date.text.isNotEmpty?
          Expanded(
            child: Scrollbar(
              radius: Radius.circular(
                10.0,
              ),
              thickness: 5.0,
              child: Obx(() {
                if (rmaC.isLoading.value) {
                  return Column();
                } else {
                  if (rmaC.repoAttViewList.isEmpty ||
                      rmaC.repoAttViewList.isNull) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'No Reports found',
                              style: TextStyle(
                                fontSize: 18.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    itemCount: rmaC.repoAttViewList.length,
                    itemBuilder: (context, index) {
                      print(rmaC.repoAttViewList[index]);
                      var report = rmaC.repoAttViewList[index];
                      return ReportingManagerAttWidget(report, index,
                          rmaC.repoAttViewList.length, rmaC);
                    },
                  );
                }
              }),
            ),
          )
          :Expanded(
            child: Scrollbar(
              radius: Radius.circular(
                10.0,
              ),
              thickness: 5.0,
              child: Obx(() {
                if (rmaC.isLoading.value) {
                  return Column();
                } else {
                  if (rmaC.empDetailsList.isEmpty ||
                      rmaC.empDetailsList.isNull) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'No Employee details found',
                              style: TextStyle(
                                fontSize: 18.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    itemCount: rmaC.empDetailsList.length,
                    itemBuilder: (context, index) {
                      print(rmaC.empDetailsList[index]);
                      var details = rmaC.empDetailsList[index];
                      return ReportingManagerEmpWidget(details, index,
                          rmaC.empDetailsList.length, rmaC);
                    },
                  );
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}
