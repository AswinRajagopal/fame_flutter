import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EmpOnboardDetailWidget extends StatelessWidget {
  var emp;

  EmpOnboardDetailWidget(this.emp);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${emp['empId']}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6.0,
            ),
            Text(
              'Emp Name : ' + emp['empFname'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
                crossAxisAlignment:CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(
              emp['empstatus'] == '1' ? 'Approved' :emp['empstatus'] == '0' ? 'Pending' : 'Rejected',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            if(emp['createdBy'] != null)
              Text(emp['createdBy']+' on '+DateFormat('dd-MM-yy').format(DateTime.parse(emp['createdOn'])))]),
            if (emp['empstatus'] == '2' && emp['empRemarks'] !=null)
              Row(children: [
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Remarks : ' + emp['empRemarks'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
