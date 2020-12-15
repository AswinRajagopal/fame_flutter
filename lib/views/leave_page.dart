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
      backgroundColor: AppUtils().sccaffoldBg,
      appBar: AppBar(
        title: Text('Leave'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.to(ApplyLeave());
            },
            child: Icon(
              Icons.add,
              size: 32.0,
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: Container(),
      ),
    );
  }
}
