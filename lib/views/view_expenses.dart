import 'package:dropdown_search/dropdown_search.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/views/expense_manager.dart';
import 'package:fame/views/my_bills.dart';
import 'package:fame/views/request_advance_expense.dart';
import 'package:fame/views/view_bills.dart';
import 'package:fame/widgets/expenses_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../connection/remote_services.dart';
import '../utils/utils.dart';

class ViewExpense extends StatefulWidget {
  @override
  _ViewExpenseState createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  final ExpenseController expC = Get.put(ExpenseController());
  var expenseId;
  var roleId;
  bool _isVisible = true;
  var expenseTypeId;

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
      expC.getEmpExpenses();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Expenses List',
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 140,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Column(children: [
                                  new Text(
                                      expC.expDet != null &&
                                              expC.expDet['totalExpenses'] !=
                                                  null &&
                                              expC.expDet['totalExpenses']
                                                          ['expense']
                                                      .toString() !=
                                                  'null'
                                          ? expC.expDet['totalExpenses']
                                                  ['expense']
                                              .toString()
                                          : '-',
                                      style: new TextStyle(
                                          fontSize: 40.0, color: Colors.black)),
                                  Text('Expenses This Month',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.green))
                                ]),
                                VerticalDivider(
                                  width: 100.0,
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                                Column(children: [
                                  new Text(
                                      expC.expDet != null &&
                                              expC.expDet['totalExpenses'] !=
                                                  null &&
                                              expC.expDet['totalExpenses']
                                                          ['advance']
                                                      .toString() !=
                                                  'null'
                                          ? expC.expDet['totalExpenses']
                                                  ['advance']
                                              .toString()
                                          : '-',
                                      style: new TextStyle(
                                          fontSize: 40.0, color: Colors.black)),
                                  Text('Advance This Month',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.red))
                                ]),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Flexible(
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        roleId == AppUtils.ADMIN
                            ? Column(children: [
                                RaisedButton(
                                  onPressed: () async {
                                    if (roleId == AppUtils.ADMIN) {
                                      Get.to(RequestExpense());
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 20.0,
                                    ),
                                    child: Text(
                                      'Add Advance',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
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
                              ])
                            : Spacer(),
                        RaisedButton(
                          onPressed: () async {
                            Get.to(Expenses());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              'Add Expense',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () async {
                    Get.to(ViewBills());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'My Bills',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height:15.0,
          ),
          Row(
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Flexible(
                        child: DropdownSearch(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            isFilteredOnline: true,
                            dropDownButton: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              size: 18.0,
                            ),
                            hint: 'All',
                            showSelectedItem: true,
                            items: expC.exp.map((item) {
                              print(item['expenseType']);
                              print("items" + item['expenseType']);
                              var sC = item['expenseType'].toString();
                              return sC.toString();
                            }).toList(),
                            onChanged: (value) {
                              for (var e in expC.exp) {
                                if (e['expenseType'] == value) {
                                  expenseTypeId = e['expenseTypeId'];
                                  break;
                                }
                              }
                              setState(() {});
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
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
                  if (expC.empExpList.isEmpty || expC.empExpList.isNull) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'No Expenses List found',
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
                    itemCount: expC.empExpList.length,
                    itemBuilder: (context, index) {
                      print(expC.empExpList[index]);
                      var expense = expC.empExpList[index];
                      return ExpensesListWidget(
                          expense, index, expC.empExpList.length, expC);
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
