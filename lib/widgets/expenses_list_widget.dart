import 'package:dotted_line/dotted_line.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/views/expenses_list_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ExpensesListWidget extends StatelessWidget {
  final expenses;
  ExpensesListWidget(this.expenses);
  final TextEditingController expense = TextEditingController();

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString() +
        '\n @ ' +
        DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toLowerCase();
  }

  var status = 0;
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
    return GestureDetector(
      onTap: () {
        if (roleId == AppUtils.ADMIN) {
          Get.to(ExpensesDetailList(expenses));
        }
      },
      child: Card(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      convertDate(expenses['createdOn']),
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Column(children: [
                      Text(
                        expenses['empName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        expenses['empId'],
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      )
                    ]),
                    SizedBox(
                      width: 40.0,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 70.0,
                          height: 30.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: status == 0
                                ? Colors.blue[100]
                                : Colors.yellow[100],
                            border: Border.all(
                              color: status == 0
                                  ? Colors.blue[100]
                                  : Colors.yellow[100], // Set border color
                            ), // Set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                2.0)), // Set rounded corner radius
                          ),
                          child: Text(
                            getStatus(expenses['status']),
                            style: TextStyle(
                                color:
                                    status == 0 ? Colors.blue : Colors.yellow,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 30.0),
                    Column(children: [
                      IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              expenses['amount'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}