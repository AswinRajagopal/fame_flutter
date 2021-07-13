import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../controllers/broadcast_controller.dart';
import '../utils/utils.dart';
import '../widgets/broadcast_list_widget.dart';
import 'new_broadcast.dart';

class ViewBroadcast extends StatefulWidget {
  @override
  _ViewBroadcastState createState() => _ViewBroadcastState();
}

class _ViewBroadcastState extends State<ViewBroadcast> {
  final BroadcastController bC = Get.put(BroadcastController());
  // var roleId = RemoteServices().box.get('role');
  var roleId;

  @override
  void initState() {
    bC.pr = ProgressDialog(
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
    bC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      bC.getBroadcast,
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
          'Broadcast Messages',
        ),
      ),
      floatingActionButton: roleId==AppUtils.ADMIN?Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Get.offAll(ApplyLeave());
              Get.to(Broadcast());
            },
            child: Icon(
              Icons.add,
              size: 32.0,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ):Container(),
      body: SafeArea(
        child: Scrollbar(
          radius: Radius.circular(
            10.0,
          ),
          thickness: 5.0,
          child: Obx(() {
            if (bC.isLoading.value) {
              return Column();
            } else {
              if (bC.broadcastList.isEmpty || bC.broadcastList.isNull) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'No message found',
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
                itemCount: bC.broadcastList.length,
                itemBuilder: (context, index) {
                  var broadcast = bC.broadcastList[index];
                  return BroadcastListWidget(broadcast);
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
