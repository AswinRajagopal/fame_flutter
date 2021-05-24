import '../connection/remote_services.dart';

import '../widgets/leave_list_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/leave_controller.dart';

import 'dashboard_page.dart';

import 'apply_leave.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final LeaveController lC = Get.put(LeaveController());

  @override
  void initState() {
    lC.pr = ProgressDialog(
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
    lC.pr.style(
      backgroundColor: Colors.white,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text('Leave List'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Get.offAll(DashboardPage());
          },
        ),
      ),
      floatingActionButton:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Get.offAll(ApplyLeave());
              },
              child: Icon(
                Icons.add,
                size: 32.0,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: Scrollbar(
          radius: Radius.circular(
            10.0,
          ),
          thickness: 5.0,
          child: Obx(() {
            if (lC.isLoading.value) {
              return Column();
            } else {
              if (lC.leaveList.isEmpty || lC.leaveList.isNull) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'No leave found',
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
                physics: ScrollPhysics(),
                itemCount: lC.leaveList.length,
                itemBuilder: (context, index) {
                  var leave = lC.leaveList[index];
                  return LeaveListWidget(
                    leave,
                    index,
                    lC.leaveList.length,
                    lC,
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
