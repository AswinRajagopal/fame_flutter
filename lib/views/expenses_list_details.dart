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

class ExpensesDetailList extends StatefulWidget{
  var expenses;
  ExpensesDetailList(this.expenses);

  @override
  _ExpensesDetailListState createState()=> _ExpensesDetailListState(this.expenses);
}

class _ExpensesDetailListState extends State<ExpensesDetailList>{
  final ExpenseController expC =Get.put(ExpenseController());
  TextEditingController expense=TextEditingController();
  var expenses;
  _ExpensesDetailListState(this.expenses);

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
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Expenses Details',
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
                          RowWidget('Employee Name', expenses['empName']),
                          SizedBox(height: 15.0),
                          RowWidget('ExpenseEmpId', expenses['expenseEmpId'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('EmpId', expenses['empId'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('Amount', expenses['amount'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('ExpenseType', expenses['expenseType'].toString()),
                          SizedBox(height: 15.0),
                          RowWidget('Status', getStatus(expenses['status']),),
                          SizedBox(height: 15.0),
                          RowWidget('UpdatedOn', convertDate(expenses['updatedOn'])),
                          SizedBox(height: 15.0),
                          RowWidget('CreatedOn', convertDate(expenses['createdOn'])),
                          SizedBox(height: 15.0),
                          Column(
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        expC.aprRejExpense('2');
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
                                        borderRadius: BorderRadius.circular(5.0),
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
                                        expense.text=expenses['amount'].toString();
                                        await Get.defaultDialog(
                                            title: 'Expenses',
                                            titleStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                            radius: 20.0,
                                            content: Padding(
                                              padding: const EdgeInsets.only(bottom:50.0),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    side: BorderSide(color: Colors.black38)),
                                                child: TextField(
                                                  controller:expense,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding: EdgeInsets.all(10.0),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18.0,
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                            barrierDismissible: false,
                                            confirmTextColor: Colors.white,
                                            textConfirm: 'Submit',
                                            buttonColor:AppUtils().blueColor,
                                            // onCancel: (){
                                            //   expense.text='';
                                            // },
                                            onConfirm: ()async{
                                              expenses['amount']=expense.text.toString();
                                              expC.aprRejExpense('1');
                                              var expRes=await RemoteServices().sendFeedback(expense.text);
                                              if(expRes['success']){
                                                Get.back();
                                              }
                                            }
                                        );
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
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(
                                          color: AppUtils().blueColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
            rightSide != null && rightSide != '' && rightSide != 'null' ? rightSide : 'N/A',
            style: TextStyle(
              fontSize: 18.0,
              color: type != null && type == 'link' ? AppUtils().blueColor : AppUtils().blueColor,
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