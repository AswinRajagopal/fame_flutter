import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/views/my_bills.dart';
import 'package:fame/widgets/view_bills_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';

class ViewBills extends StatefulWidget {
  @override
  _ViewBillsState createState() => _ViewBillsState();
}

class _ViewBillsState extends State<ViewBills> {
  final ExpenseController expC = Get.put(ExpenseController());
  var roleId;



  @override
  void initState() {
    expC.pr = ProgressDialog(
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
    expC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      () => expC.getBillsByStatus(),
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
          'My Bills List',
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
            setState(() {
              expC.expenseBillsList.clear();
            });
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.to(MyBills());
            },
            child: Icon(
              Icons.add,
              size: 32.0,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Scrollbar(
            radius: Radius.circular(
              10.0,
            ),
            thickness: 5.0,
            child: Obx(() {
              if (expC.isLoading.value) {
                return Column();
              } else {
                if (expC.expenseBillsList.isEmpty ||
                    expC.expenseBillsList.isNull) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No Bills found',
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
                  itemCount: expC.expenseBillsList.length,
                  itemBuilder: (context, index) {
                    var billsList = expC.expenseBillsList[index];
                    return BillsListWidget(
                        billsList, index, expC.expenseBillsList.length, expC);
                  },
                );
              }
            }),
          ),
        ),
        Obx((){
          return Visibility(
            visible: expC.selectedBills.length>0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        expC.getBillsToExpense();
                      },
                      color: AppUtils().blueColor,
                      child: Text(
                        'Send For Approval',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );}
        )
      ]),
    );
  }
}
