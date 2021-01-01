import 'transfer.dart';
import '../widgets/transfer_list_widget.dart';

import '../utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/transfer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferList extends StatefulWidget {
  @override
  _TransferListState createState() => _TransferListState();
}

class _TransferListState extends State<TransferList> {
  final TransferController tC = Get.put(TransferController());

  @override
  void initState() {
    tC.pr = ProgressDialog(
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
    tC.pr.style(
      backgroundColor: Colors.white,
    );
    super.initState();
    Future.delayed(Duration(milliseconds: 100), tC.getTransferList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text('Transfer List'),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //   ),
        //   onPressed: () {
        //     // Get.offAll(DashboardPage());
        //   },
        // ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Get.offAll(ApplyLeave());
              Get.to(TransferPage());
            },
            child: Icon(
              Icons.add,
              size: 32.0,
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Obx(() {
            if (tC.isLoading.value) {
              return Column();
            } else {
              if (tC.transferList.isEmpty || tC.transferList.isNull) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No transfer found',
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
                itemCount: tC.transferList.length,
                itemBuilder: (context, index) {
                  var transfer = tC.transferList[index];
                  return TransferListWidget(
                    transfer,
                    index,
                    tC.transferList.length,
                    tC,
                  );
                },
              );
            }
          }),
          SizedBox(
            height: 35.0,
          ),
        ],
      ),
    );
  }
}
