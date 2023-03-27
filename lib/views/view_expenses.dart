import 'package:dropdown_search/dropdown_search.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/views/expense_manager.dart';
import 'package:fame/views/request_advance_expense.dart';
import 'package:fame/views/view_bills.dart';
import 'package:fame/widgets/advance_list_widget.dart';
import 'package:fame/widgets/expenses_list_widget.dart';
import 'package:fame/widgets/rejected_expense_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';

class ViewExpense extends StatefulWidget {
  @override
  _ViewExpenseState createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  final ExpenseController expC = Get.put(ExpenseController());
  TextEditingController empName = TextEditingController();
  TextEditingController frmDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  var fDate;
  var tDate;
  var expenseId;
  var roleId;
  var expenseTypeId;
  var empId;
  bool _isRejectedList = false;
  bool _expense = false;
  bool _advance = false;
  String _chosenValue;

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
    frmDate.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    toDate.text = DateFormat('dd-MM-yyyy').format(curDate).toString();
    fDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
    tDate = DateFormat('yyyy-MM-dd').format(curDate).toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String numberFormatter(amountform) {
    var amount = int.parse(amountform.toStringAsFixed(0));
    var formatter = NumberFormat('#,##,000');
    return formatter.format(amount).toString();
  }

  final DateTime curDate = DateTime.now();

  Future<Null> fromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fDate == null
          ? curDate
          : DateTime.parse(
              fDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365 * 2)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        frmDate.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        fDate = DateFormat('yyyy-MM-dd').format(picked).toString();
        expC.getEmpExpensesAdmin(empId, fDate, tDate);
      });
    }
  }

  Future<Null> lastDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tDate == null
          ? curDate
          : DateTime.parse(
              tDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -365 * 2)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        toDate.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        tDate = DateFormat('yyyy-MM-dd').format(picked).toString();
        expC.getEmpExpensesAdmin(empId, fDate, tDate);
      });
    }
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        return expC.isLoading.value == null
                                            ? CircularProgressIndicator()
                                            : Text(
                                                expC.expDet != null &&
                                                        expC.expDet[
                                                                'totalExpenses'] !=
                                                            null &&
                                                        expC.expDet['totalExpenses']
                                                                    ['expense']
                                                                .toString() !=
                                                            'null'
                                                    ? numberFormatter(expC
                                                                    .expDet[
                                                                'totalExpenses']
                                                            ['expense'])
                                                        .toString()
                                                    : '0.00',
                                                style: new TextStyle(
                                                    fontSize: 40.0,
                                                    color: Colors.black));
                                      }),
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
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        return expC.isLoading.value == null
                                            ? CircularProgressIndicator()
                                            : Text(
                                                expC.expDet != null &&
                                                        expC.expDet[
                                                                'totalExpenses'] !=
                                                            null &&
                                                        expC.expDet['totalExpenses']
                                                                    ['advance']
                                                                .toString() !=
                                                            'null'
                                                    ? numberFormatter(expC
                                                                    .expDet[
                                                                'totalExpenses']
                                                            ['advance'])
                                                        .toString()
                                                    : '0.00',
                                                style: new TextStyle(
                                                    fontSize: 40.0,
                                                    color: Colors.black));
                                      }),
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
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RaisedButton(
                                    onPressed: () async {
                                      Get.to(ViewBills()).then(
                                          (value) => expC.getEmpExpenses());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal: 45.0,
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
                        RaisedButton(
                          onPressed: () async {
                            Get.to(Expenses())
                                .then((value) => expC.getEmpExpenses());
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
          roleId == AppUtils.ADMIN
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                'Filter By',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.filter_alt),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : Column(),
          roleId == AppUtils.ADMIN
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.black38)),
                    child: Container(
                      height: 60.0,
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: empName,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.all(20),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Employee Name',
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          if (pattern.isNotEmpty) {
                            return await RemoteServices().getEmployees(pattern);
                          } else {
                            empId = null;
                          }
                          return null;
                        },
                        hideOnEmpty: true,
                        noItemsFoundBuilder: (context) {
                          return Text('No employee found');
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion['name'],
                            ),
                            subtitle: Text(
                              suggestion['empId'],
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          empName.text =
                              suggestion['name'].toString().trimRight() +
                                  ' - ' +
                                  suggestion['empId'];
                          empId = suggestion['empId'];
                          if (empId != null) {
                            expC.getEmpExpensesAll(empId);
                          }
                        },
                      ),
                    ),
                  ),
                )
              : Column(),
          roleId == AppUtils.ADMIN
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Text('From',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Container(
                            width: 170,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              child: TextField(
                                controller: frmDate,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Select Date',
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 25.0,
                                  ),
                                ),
                                readOnly: true,
                                keyboardType: null,
                                onTap: () {
                                  fromDate(context);
                                },
                              ),
                            ),
                          ),
                          Text('To',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Container(
                            width: 170,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              child: TextField(
                                controller: toDate,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Select Date',
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 25.0,
                                  ),
                                ),
                                readOnly: true,
                                keyboardType: null,
                                onTap: () {
                                  lastDate(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Column(),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
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
                        Spacer(),
                        Expanded(
                          child: Container(
                            width: 150.0,
                            child: DropdownSearch<String>(
                              validator: (v) =>
                                  v == null ? "required field" : null,
                              hint: "All",
                              mode: Mode.MENU,
                              dropdownSearchDecoration: InputDecoration(
                                filled: true,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              showAsSuffixIcons: true,
                              dropdownButtonBuilder: (_) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ),
                              showSelectedItem: true,
                              items: [
                                'All',
                                'Rejected List',
                                'Approved List',
                                'Expenses',
                                'Advance',
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  expC.rejectedList.clear();
                                  expC.empExpList.clear();
                                  expC.empExpAdvanceList.clear();
                                  expC.expenseBillsList.clear();
                                  _chosenValue = value;
                                  if (_chosenValue == 'Rejected List') {
                                    empId != null
                                        ? expC.getEmpExpenseAdmin(empId, '2')
                                        : expC.getEmpExpense('2');
                                    _isRejectedList = true;
                                    _advance = false;
                                    _expense = false;
                                  } else if (_chosenValue == 'Expenses') {
                                    empId != null
                                        ? expC.getEmpExpensesAll(empId)
                                        : empId == null
                                            ? expC.getEmpExpenses()
                                            : expC.getEmpExpensesAdmin(
                                                empId, fDate, tDate);
                                    _expense = true;
                                    _advance = false;
                                    _isRejectedList = false;
                                  } else {
                                    if (_chosenValue == 'Advance') {
                                      empId != null
                                          ? expC.getExpAdvAdmin(empId)
                                          : expC.getExpAdv();
                                      _advance = true;
                                      _expense = false;
                                      _isRejectedList = false;
                                    } else if (_chosenValue == 'All') {
                                      empId != null
                                          ? expC.getEmpExpensesAll(empId)
                                          : empId == null
                                              ? expC.getEmpExpenses()
                                              : expC.getEmpExpensesAdmin(
                                                  empId, fDate, tDate);
                                      _expense = true;
                                      _advance = false;
                                      _isRejectedList = false;
                                    } else {
                                      empId != null
                                          ? expC.getEmpExpenseAdmin(empId, '1')
                                          : expC.getEmpExpense('1');
                                      _isRejectedList = true;
                                      _advance = false;
                                      _expense = false;
                                    }
                                  }
                                });
                              },
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
          _isRejectedList
              ? Expanded(
                  child: Scrollbar(
                    radius: Radius.circular(
                      10.0,
                    ),
                    thickness: 5.0,
                    child: Obx(() {
                      if (expC.isLoading.value) {
                        return Column();
                      } else {
                        if (expC.rejectedList.isEmpty ||
                            expC.rejectedList.isNull) {
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
                          itemCount: expC.rejectedList.length,
                          itemBuilder: (context, index) {
                            print(expC.rejectedList[index]);
                            var rejectedExp = expC.rejectedList[index];
                            return RejectedListWidget(rejectedExp, index,
                                expC.rejectedList.length, expC);
                          },
                        );
                      }
                    }),
                  ),
                )
              : _expense
                  ? Expanded(
                      child: Scrollbar(
                        radius: Radius.circular(
                          10.0,
                        ),
                        thickness: 5.0,
                        child: Obx(() {
                          if (expC.isLoading.value) {
                            return Column();
                          } else {
                            if (expC.empExpList.isEmpty ||
                                expC.empExpList.isNull) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.2,
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
                                return ExpensesListWidget(expense, index,
                                    expC.empExpList.length, expC);
                              },
                            );
                          }
                        }),
                      ),
                    )
                  : _advance
                      ? Expanded(
                          child: Scrollbar(
                            radius: Radius.circular(
                              10.0,
                            ),
                            thickness: 5.0,
                            child: Obx(() {
                              if (expC.isLoading.value) {
                                return Column();
                              } else {
                                if (expC.empExpAdvanceList.isEmpty ||
                                    expC.empExpAdvanceList.isNull) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            'No Advance List found',
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
                                  itemCount: expC.empExpAdvanceList.length,
                                  itemBuilder: (context, index) {
                                    print(expC.empExpAdvanceList[index]);
                                    var advance = expC.empExpAdvanceList[index];
                                    return AdvanceListWidget(advance);
                                  },
                                );
                              }
                            }),
                          ),
                        )
                      : Expanded(
                          child: Scrollbar(
                            radius: Radius.circular(
                              10.0,
                            ),
                            thickness: 5.0,
                            child: Obx(() {
                              if (expC.isLoading.value) {
                                return Column();
                              } else {
                                if (expC.empExpList.isEmpty ||
                                    expC.empExpList.isNull) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                    var expense = expC.empExpList[index];
                                    return ExpensesListWidget(expense, index,
                                        expC.empExpList.length, expC);
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
