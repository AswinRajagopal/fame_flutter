import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DBActivityTile extends StatelessWidget {
  final empAct;
  final int index;
  final int length;
  DBActivityTile(this.empAct, this.index, this.length);

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() + '-' + DateFormat('MM').format(DateTime.parse(date)).toString() + '-' + DateFormat.y().format(DateTime.parse(date)).toString() + ' @ ' + DateFormat('hh:mm').format(DateTime.parse(date)).toString() + '' + DateFormat('a').format(DateTime.parse(date)).toString().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        index == 0 ? 20.0 : 5.0,
        10.0,
        index == length - 1 ? 20.0 : 5.0,
        10.0,
      ),
      child: Container(
        width: 330.0,
        decoration: BoxDecoration(
          color: Colors.teal[300],
          // color: HexColor('06c5d1'),
          borderRadius: BorderRadius.all(
            Radius.circular(
              15.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 18.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    empAct['activity'].toString().contains('Leave')
                        ? 'Leave Status'
                        : empAct['activity'].toString().contains('Attendance')
                            ? 'Attendance Status'
                            : 'Activity Status',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      empAct['activity'].toString().contains('Approved') ? 'Approved' : 'Rejected',
                    ),
                    backgroundColor: Colors.teal[200],
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                empAct['activity'].toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Text(
              //     convertDate(empAct['createdOn'].toString()),
              //     style: TextStyle(
              //       fontSize: 16.0,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Container(
              //     height: 30.0,
              //     width: 30.0,
              //     decoration: BoxDecoration(
              //       color: Colors.black45,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(
              //           50.0,
              //         ),
              //       ),
              //     ),
              //     child: GestureDetector(
              //       onTap: () {},
              //       child: Icon(
              //         Icons.chevron_right,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
