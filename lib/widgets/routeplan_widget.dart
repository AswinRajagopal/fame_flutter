import '../views/pitstops.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RouteplanWidget extends StatelessWidget {
  final route;
  final int index;
  final int length;
  RouteplanWidget(this.route, this.index, this.length);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 3.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;

  String created() {
    return DateFormat('dd').format(route.createdOn).toString() + '-' + DateFormat('MM').format(route.createdOn).toString() + '-' + DateFormat.y().format(route.createdOn).toString() + ' @ ' + DateFormat('h:mm').format(route.createdOn).toString() + DateFormat('a').format(route.createdOn).toString().toLowerCase();
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
    return GestureDetector(
      onTap: () {
        print(route.routePlanId);
        print(route.companyId);
        Get.offAll(Pitstops(route.routePlanId, route.companyId, 'list'));
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0),
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
                      fontWeight: FontWeight.bold,
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
                    route.planName != null && route.planName != '' ? route.planName.toString() : 'N/A',
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
                      fontWeight: FontWeight.bold,
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
                    route.createdBy.toString(),
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
                      fontWeight: FontWeight.bold,
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
                      route.adminRemarks == null ? 'N/A' : route.adminRemarks.toString(),
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
                    getStatus(route.status),
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
                      created(),
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
