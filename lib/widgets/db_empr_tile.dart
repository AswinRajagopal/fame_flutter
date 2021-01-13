import '../views/pitstops.dart';

import '../views/routeplan_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DBEmprTile extends StatelessWidget {
  final empRoute;
  final int index;
  final int length;
  DBEmprTile(this.empRoute, this.index, this.length);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 8.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;

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
    // print('index: $index');
    // print('length: $length');
    var created = DateFormat('dd').format(empRoute.createdOn).toString() +
        '-' +
        DateFormat('MM').format(empRoute.createdOn).toString() +
        '-' +
        DateFormat.y().format(empRoute.createdOn).toString() +
        ' at ' +
        // DateFormat().add_jm().format(empRoute.createdOn).toString();
        DateFormat('h:mm').format(empRoute.createdOn).toString() +
        DateFormat('a').format(empRoute.createdOn).toString().toLowerCase();

    return index >= 4
        ? Padding(
            padding: EdgeInsets.fromLTRB(
              10.0,
              85.0,
              10.0,
              85.0,
            ),
            child: RaisedButton(
              onPressed: () {
                print('go to route list');
                Get.offAll(RouteplanList());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  // vertical: 12.0,
                  horizontal: 18.0,
                ),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Image.asset(
                      'assets/images/arrow_right.png',
                      scale: 1.5,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              print(empRoute.routePlanId);
              print(empRoute.companyId);
              Get.offAll(Pitstops(empRoute.routePlanId, empRoute.companyId, 'db'));
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                index == 0 ? 10.0 : 5.0,
                10.0,
                index == length ? 20.0 : 5.0,
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
                    vertical: 25.0,
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
                              // fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(
                            width: 54.0,
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
                            empRoute.planName != null && empRoute.planName != '' ? empRoute.planName.toString() : 'N/A',
                            style: TextStyle(
                              fontSize: textSize,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
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
                              // fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),
                          SizedBox(
                            width: 48.0,
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
                            maxLines: 1,
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
                              // fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),
                          SizedBox(
                            width: 13.0,
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
                              empRoute.adminRemarks == null ? 'N/A' : empRoute.adminRemarks.toString(),
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
                              // fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),
                          SizedBox(
                            width: 86.0,
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
                            // empRoute.status == 1 ? 'Approved' : 'Pending',
                            getStatus(empRoute.status),
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
                              // fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),
                          SizedBox(
                            width: 48.0,
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
            ),
          );
  }
}
