import '../widgets/notification_list_widget.dart';

import '../utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController nC = Get.put(NotificationController());

  @override
  void initState() {
    nC.pr = ProgressDialog(
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
    nC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      nC.getNotification,
    );
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
          'Notification',
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Obx(() {
              if (nC.isLoading.value) {
                return Column();
              } else {
                if (nC.notificationList.isEmpty || nC.notificationList.isNull) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No notification found',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: nC.notificationList.length,
                  itemBuilder: (context, index) {
                    var notification = nC.notificationList[index];
                    return NotificationListWidget(notification);
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
