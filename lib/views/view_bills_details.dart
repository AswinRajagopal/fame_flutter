import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
    if (status == 0) {
      return 'Pending';
    } else if (status == 1) {
      return 'Approved';
    } else {
      return 'Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'My Bills Details',
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
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
                Card(
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
                          RowWidget('ExpenseBillId', billsList['expenseBillId'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('EmpExpenseId',
                              billsList['empExpenseId'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('EmpId', billsList['empId'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('Amount', billsList['amount'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('Remarks',
                              billsList['remarks'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget(
                            'Status',
                            getStatus(billsList['status']),
                          ),
                          SizedBox(height: 15.0),
                          RowWidget(
                              'UpdatedOn', convertDate(billsList['updatedOn'])),
                          SizedBox(height: 15.0),
                          RowWidget(
                              'CreatedOn', convertDate(billsList['createdOn'])),
                          SizedBox(height: 15.0),
                          roleId == AppUtils.ADMIN
                              ? Column(
                            children: [
                              SizedBox(
                                height: 15.0,
                              ),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: Colors.grey,
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        // expenses['status']=getStatus(expenses['status']);
                                      },
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                        side: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    RaisedButton(
                                      onPressed: () async {
                                      },
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      color: AppUtils().blueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                        side: BorderSide(
                                          color: AppUtils().blueColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                              : Column(),
                        ],
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
    );
  }

  Widget imageDialog(img) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
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
            child: Image.network(img,
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
