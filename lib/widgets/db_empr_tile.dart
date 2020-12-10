import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DBEmprTile extends StatelessWidget {
  final empRoute;
  final int index;
  final int length;
  DBEmprTile(this.empRoute, this.index, this.length);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 3.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    var created = DateFormat.d().format(empRoute.createdOn).toString() +
        '-' +
        DateFormat.M().format(empRoute.createdOn).toString() +
        '-' +
        DateFormat.y().format(empRoute.createdOn).toString() +
        ' at ' +
        DateFormat().add_jm().format(empRoute.createdOn).toString();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        index == 0 ? 20.0 : 5.0,
        10.0,
        index == length - 1 ? 20.0 : 5.0,
        10.0,
      ),
      child: Container(
        width: 350.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              15.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Plan name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(
                    width: secondWidth,
                  ),
                  Text(
                    empRoute.planName != null && empRoute.planName != ''
                        ? empRoute.planName.toString()
                        : 'N/A',
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: rowAfterSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Created by',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                  SizedBox(
                    width: firstWidth,
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(
                    width: secondWidth,
                  ),
                  Text(
                    empRoute.createdBy.toString(),
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: rowAfterSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Admin Remarks',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(
                    width: secondWidth,
                  ),
                  Flexible(
                    child: Text(
                      empRoute.adminRemarks == null
                          ? 'N/A'
                          : empRoute.adminRemarks.toString(),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: rowAfterSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                  SizedBox(
                    width: 80.0,
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(
                    width: secondWidth,
                  ),
                  Text(
                    empRoute.status == 1 ? 'Approved' : 'Pending',
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: rowAfterSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Created on',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                  SizedBox(
                    width: firstWidth,
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(
                    width: secondWidth,
                  ),
                  Flexible(
                    child: Text(
                      created,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
