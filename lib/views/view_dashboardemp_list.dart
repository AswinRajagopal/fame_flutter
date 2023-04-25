import 'package:fame/controllers/dashboard_controller.dart';
import 'package:fame/widgets/dashboard_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import 'dashboard_page.dart';

class ViewDashboardEmpList extends StatefulWidget {
  @override
  _ViewDashboardEmpListState createState() => _ViewDashboardEmpListState();
}

class _ViewDashboardEmpListState extends State<ViewDashboardEmpList> {
  final DashboardController dC = Get.put(DashboardController());
  // var roleId = RemoteServices().box.get('role');
  var roleId;

  @override
  void initState() {
    dC.pr = ProgressDialog(
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
    dC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      ()=>dC.getDashboardList('Employees'),
    );
    roleId = RemoteServices().box.get('role');
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
        title: Text(
          'Employees',
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop:backButtonPressed ,
          child: Scrollbar(
            radius: Radius.circular(
              10.0,
            ),
            thickness: 5.0,
            child: Obx(() {
              if (dC.isLoading.value) {
                return Column();
              } else {
                if (dC.empDetailsList.isEmpty || dC.empDetailsList.isNull) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No Employees found',
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
                  itemCount: dC.empDetailsList.length,
                  itemBuilder: (context, index) {
                    var dashboard = dC.empDetailsList[index];
                    return DashboardListWidget(dashboard);
                  },
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
