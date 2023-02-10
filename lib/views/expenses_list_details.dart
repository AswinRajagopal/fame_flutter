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

class ExpensesDetailList extends StatefulWidget {
  var expenses;
  final int length;
  final int index;
  final ExpenseController expC;
  ExpensesDetailList(
    this.expenses,
    this.index,
    this.length,
    this.expC,
  );

  @override
  _ExpensesDetailListState createState() => _ExpensesDetailListState(
        this.expenses,
        this.index,
        this.length,
        this.expC,
      );
}

class _ExpensesDetailListState extends State<ExpensesDetailList> {
  final ExpenseController expC = Get.put(ExpenseController());
  TextEditingController expense = TextEditingController();
  TextEditingController adminRemarks=TextEditingController();
  var expenses;
  final int length;
  final int index;
  _ExpensesDetailListState(
    this.expenses,
    this.index,
    this.length,
    ExpenseController expC,
  );
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
      expC.getExpAttachments(expenses['expenseEmpId']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          expC.attachment.clear();
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: AppUtils().innerScaffoldBg,
        appBar: AppBar(
          title: Text(
            'Expenses Details',
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
              setState(() {
                expC.attachment.clear();
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
                      'Expenses detail not available.',
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
                            RowWidget('Employee Name', expenses['empName']),
                            SizedBox(height: 15.0),
                            RowWidget('ExpenseEmpId',
                                expenses['expenseEmpId'].toString()),
                            SizedBox(height: 15.0),
                            RowWidget('EmpId', expenses['empId'].toString()),
                            SizedBox(height: 15.0),
                            RowWidget(
                                'Amount', expenses['amount'].toString() + "0"),
                            SizedBox(height: 15.0),
                            RowWidget('ExpenseType',
                                expenses['expenseType'].toString()),
                            SizedBox(height: 15.0),
                            RowWidget(
                              'Status',
                              getStatus(expenses['status']),
                            ),
                            SizedBox(height: 15.0),
                            RowWidget(
                              'Admin Remarks', expenses['adminRemarks'],
                            ),
                            SizedBox(height: 15.0),
                            RowWidget(
                                'UpdatedOn', convertDate(expenses['updatedOn'])),
                            SizedBox(height: 15.0),
                            RowWidget(
                                'CreatedOn', convertDate(expenses['createdOn'])),
                            SizedBox(height: 15.0),
                            Row(
                              children: [
                                expC.attachment.length > 0
                                    ? GestureDetector(
                                        onTap: () async {
                                          var pitstop = expC.attachment[0];
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
                                                width: 1, color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(expC
                                                    .attachment[0]
                                                    .toString()),
                                                fit: BoxFit.cover), //<-- SEE HERE
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 20.0,
                                ),
                                expC.attachment.length > 1
                                    ? GestureDetector(
                                        onTap: () async {
                                          var pitstop = expC.attachment[1];
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
                                                width: 1, color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(expC
                                                    .attachment[1]
                                                    .toString()),
                                                fit: BoxFit.cover), //<-- SEE HERE
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 15.0,
                                ),
                                expC.attachment.length > 2
                                    ? GestureDetector(
                                        onTap: () async {
                                          var pitstop = expC.attachment[2];
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
                                                width: 1, color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(expC
                                                    .attachment[2]
                                                    .toString()),
                                                fit: BoxFit.cover), //<-- SEE HERE
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
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
                                              onPressed: () async {
                                                await Get.defaultDialog(
                                                    title: 'Expenses',
                                                    titleStyle: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                    radius: 20.0,
                                                    content: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          bottom: 50.0),
                                                      child: Card(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black38)),
                                                        child: TextField(
                                                            controller: adminRemarks,
                                                          maxLength: 160,
                                                          maxLengthEnforced: true,
                                                          maxLines: 4,
                                                          keyboardType: TextInputType.multiline,
                                                            decoration:
                                                            InputDecoration(
                                                                border:
                                                                InputBorder
                                                                    .none,
                                                                contentPadding:
                                                                EdgeInsets
                                                                    .all(
                                                                    10.0),
                                                              hintStyle: TextStyle(
                                                                color: Colors.grey[600],
                                                                fontSize: 18.0,
                                                              ),
                                                              hintText: 'Remarks',),
                                                          ),
                                                      ),
                                                    ),
                                                    barrierDismissible: false,
                                                    confirmTextColor:
                                                    Colors.white,
                                                    textConfirm: 'Reject',
                                                    buttonColor:
                                                    AppUtils().blueColor,
                                                    onConfirm: () async {
                                                      expenses['adminRemarks']=adminRemarks.text.toString();
                                                      expC.aprRejExpense(
                                                          adminRemarks.text,
                                                          expense.text,
                                                          expenses['empId'],
                                                          expenses['expenseEmpId'],
                                                          '2');
                                                    });
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
                                                expense.text =
                                                    expenses['amount'].toString();
                                                await Get.defaultDialog(
                                                    title: 'Expenses',
                                                    titleStyle: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    radius: 20.0,
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 50.0),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black38)),
                                                        child: Column(children: [
                                                          TextField(
                                                            controller: expense,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                10.0),
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          18.0,
                                                                    )),
                                                          ),
                                                          TextField(
                                                            controller: adminRemarks,
                                                            decoration:
                                                            InputDecoration(
                                                                border:
                                                                InputBorder
                                                                    .none,
                                                                contentPadding:
                                                                EdgeInsets
                                                                    .all(
                                                                    10.0),
                                                                hintStyle:
                                                                TextStyle(
                                                                  color: Colors
                                                                      .grey[
                                                                  600],
                                                                  fontSize:
                                                                  18.0,
                                                                )),
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                    barrierDismissible: false,
                                                    confirmTextColor:
                                                        Colors.white,
                                                    textConfirm: 'Submit',
                                                    buttonColor:
                                                        AppUtils().blueColor,
                                                    onConfirm: () async {
                                                      expenses['adminRemarks']=adminRemarks.text.toString();
                                                      expenses['amount'] =
                                                          expense.text.toString();
                                                      expC.aprRejExpense(
                                                          adminRemarks.text,
                                                          expense.text,
                                                          expenses['empId'],
                                                          expenses['expenseEmpId'],
                                                          '1');
                                                      var expRes =
                                                          await RemoteServices()
                                                              .sendFeedback(
                                                                  expense.text);
                                                      if (expRes['success']) {
                                                        Get.back();
                                                      }
                                                    });
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
