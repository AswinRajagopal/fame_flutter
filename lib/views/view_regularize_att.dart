import 'package:fame/controllers/regularize_attendance_controller.dart';
import 'package:fame/widgets/regularize_att_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../controllers/broadcast_controller.dart';
import '../utils/utils.dart';
import '../widgets/broadcast_list_widget.dart';
import 'new_broadcast.dart';

class ViewRegularizeAtt extends StatefulWidget {
  @override
  _ViewRegularizeAttState createState() => _ViewRegularizeAttState();
}

class _ViewRegularizeAttState extends State<ViewRegularizeAtt> {
  final RegularizeAttController raC = Get.put(RegularizeAttController());
  var roleId;

  @override
  void initState() {
    raC.pr = ProgressDialog(
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
    raC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      raC.getRegularizeAtt,
    );
    roleId = RemoteServices().box.get('role');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Regularize Attendance List',
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            raC.regAttList.clear();
          });
          return true;
        },
        child: SafeArea(
          child: Scrollbar(
            radius: Radius.circular(
              10.0,
            ),
            thickness: 5.0,
            child: Obx(() {
              if (raC.isLoading.value) {
                return Column();
              } else {
                if (raC.regAttList.isEmpty || raC.regAttList.isNull) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No List found',
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
                  itemCount: raC.regAttList.length,
                  itemBuilder: (context, index) {
                    var regAtt = raC.regAttList[index];
                    return RegAttListWidget(regAtt,raC);
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
