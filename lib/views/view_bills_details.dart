import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'edit_bills.dart';

class ViewBillsDetailList extends StatefulWidget {
  var billsList;
  ViewBillsDetailList(this.billsList);

  @override
  _ViewBillsDetailListState createState() =>
      _ViewBillsDetailListState(this.billsList);
}

class _ViewBillsDetailListState extends State<ViewBillsDetailList> {
  final ExpenseController expC = Get.put(ExpenseController());
  var billsList;

  _ViewBillsDetailListState(this.billsList);
  var expenseEmpId;

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString();
  }

  String getStatus(status) {
    if (status == '0') {
      return 'Pending';
    } else if (status == '1') {
      return 'Approved';
    } else {
      return 'Rejected';
    }
  }

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
    Future.delayed(Duration(milliseconds: 100), () {
      expC.getBillAttachments(billsList['expenseBillId']);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          expC.billAttachment.clear();
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: AppUtils().innerScaffoldBg,
        appBar: AppBar(
          title: Text(
            'My Bills Details',
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
              setState(() {
                expC.billAttachment.clear();
              });
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          maintainBottomViewPadding: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Obx(() {
              if (expC.isLoading.value) {
                return LoadingWidget(
                  containerColor: Colors.white,
                  containerHeight: MediaQuery.of(context).size.height - 55.0,
                  loaderColor: AppUtils().lightBlueColor,
                  loaderSize: 30.0,
                );
              } else if (expC.empExpList == null) {
                return Container(
                  height: MediaQuery.of(context).size.height - 150.0,
                  child: Center(
                    child: Text(
                      'Expenses detail not available',
                      style: TextStyle(
                        color: AppUtils().darkBlueColor,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(EditBills(billsList));
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 25.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowWidget('ExpenseBillId',
                                  billsList['expenseBillId'].toString()),
                              SizedBox(height: 15.0),
                              RowWidget('EmpExpenseId',
                                  billsList['empExpenseId'].toString()),
                              SizedBox(height: 15.0),
                              RowWidget('ExpenseTypeId',
                                  billsList['expenseTypeId'].toString()),
                              SizedBox(height: 15.0),
                              RowWidget('EmpId', billsList['empId'].toString()),
                              SizedBox(height: 15.0),
                              RowWidget('Amount',
                                  billsList['amount'].toString() + "0"),
                              SizedBox(height: 15.0),
                              RowWidget(
                                  'Remarks', billsList['remarks'].toString()),
                              SizedBox(height: 15.0),
                              RowWidget(
                                'Status',
                                getStatus(billsList['status']),
                              ),
                              SizedBox(height: 15.0),
                              RowWidget('UpdatedOn',
                                  convertDate(billsList['updatedOn'])),
                              SizedBox(height: 15.0),
                              RowWidget('CreatedOn',
                                  convertDate(billsList['createdOn'])),
                              SizedBox(height: 15.0),
                              Row(
                                children: [
                                  expC.billAttachment.length > 0
                                      ? GestureDetector(
                                          onTap: () async {
                                            var pitstop =
                                                expC.billAttachment[0];
                                            if (pitstop != null) {
                                              await showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      imageDialog(pitstop));
                                            }
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 150.0,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(expC
                                                      .billAttachment[0]
                                                      .toString()),
                                                  fit: BoxFit
                                                      .cover), //<-- SEE HERE
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  expC.billAttachment.length > 1
                                      ? GestureDetector(
                                          onTap: () async {
                                            var pitstop =
                                                expC.billAttachment[1];
                                            if (pitstop != null) {
                                              await showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      imageDialog(pitstop));
                                            }
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 150.0,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(expC
                                                      .billAttachment[1]
                                                      .toString()),
                                                  fit: BoxFit
                                                      .cover), //<-- SEE HERE
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  expC.billAttachment.length > 2
                                      ? GestureDetector(
                                          onTap: () async {
                                            var pitstop =
                                                expC.billAttachment[2];
                                            if (pitstop != null) {
                                              await showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      imageDialog(pitstop));
                                            }
                                          },
                                          child: Container(
                                            width: 100.0,
                                            height: 150.0,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(expC
                                                      .billAttachment[2]
                                                      .toString()),
                                                  fit: BoxFit
                                                      .cover), //<-- SEE HERE
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget imageDialog(img) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            width: 400,
            height: 400,
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  final String leftSide;
  final String rightSide;
  final String type;
  RowWidget(this.leftSide, this.rightSide, {this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          leftSide,
          style: TextStyle(
            fontSize: 18.0,
            color: AppUtils().blueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Text(
            rightSide != null && rightSide != '' && rightSide != 'null'
                ? rightSide
                : 'N/A',
            style: TextStyle(
              fontSize: 18.0,
              color: type != null && type == 'link'
                  ? AppUtils().blueColor
                  : AppUtils().blueColor,
            ),
            textAlign: TextAlign.end,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
