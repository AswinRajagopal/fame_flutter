import 'package:fame/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardListChkInWidget extends StatelessWidget {
  final dashboard;
  DashboardListChkInWidget(this.dashboard);

  String convertDateTime(date) {
    String input = date;
    DateTime dateTime = DateTime.parse('2023-03-28 $input');
    String output = DateFormat('h:mma').format(dateTime);
    return output;
  }

  String convertDate(date) {
    String inputDateStr = date;
    DateTime inputDate = DateTime.parse(inputDateStr);

    String outputDateStr = DateFormat('dd-MM-yyyy').format(inputDate);
    return outputDateStr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 24,vertical: 8.5),
          padding: EdgeInsets.symmetric(horizontal: 11,vertical: 8),
          decoration:const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  offset: Offset(0, 2),
                  blurRadius: 6,
                  spreadRadius: 0,
                )
              ]
          ),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    'Name',
                    style:TextStyle(
                        color: Colors.grey
                    ),
                  ),
                ),
                // SizedBox(width: 100,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(dashboard['name'].toString(),
                      style: TextStyle(
                          color: AppUtils().blueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],),
              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'EmpId',
                      style:TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                  // const SizedBox(width: 100.0,),
                  Expanded(
                    child: Text(
                      dashboard['empId'].toString(),
                      style: TextStyle(
                          color: AppUtils().blueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],),
              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'EmailId',
                      style:TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                  // SizedBox(width: 100,),
                  Expanded(
                    child: Text(
                      dashboard['emailId']==null||dashboard['emailId']==''?"NA"
                          :dashboard['emailId'].toString(),
                      style: TextStyle(
                          color: AppUtils().blueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              Row(
                children: [
                  Text(
                    'Gender',
                    style:TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(width:155.0,),
                  Container(
                    padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
                    child: Text(
                      dashboard['gender'].toString(),
                      style: TextStyle(
                          color:dashboard['gender']=='M'? AppUtils().blueColor:Colors.pink,
                          fontWeight: FontWeight.bold),
                    ),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color:dashboard['gender']=='M'?Colors.blue.withOpacity(0.1):Colors.pink.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Shift start time',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(dashboard['shiftStartTime']==null?"NA":
                    convertDateTime(dashboard['shiftStartTime']),
                      style: TextStyle(
                          color: AppUtils().blueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Shift end time',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(dashboard['shiftEndTime']==null?"NA":
                    convertDateTime(dashboard['shiftEndTime']),
                      style: TextStyle(
                          color: AppUtils().blueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
            ],
          ),
        ),
      ],
    );  }
}
