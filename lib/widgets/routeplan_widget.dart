import 'package:dotted_line/dotted_line.dart';
import '../controllers/emprplan_controller.dart';
import '../connection/remote_services.dart';

import '../views/pitstops.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RouteplanWidget extends StatelessWidget {
  final EmprplanController epC;
  final route;
  final int index;
  final int length;
  RouteplanWidget(this.epC, this.route, this.index, this.length);

  final double firstWidth = 48.0;
  final double secondWidth = 7.0;
  final double rowAfterSize = 8.0;
  final double titleSize = 16.0;
  final double textSize = 16.0;
  final double sBox = 130.0;
  final double sBoxSpace = 10.0;

  String created() {
    return DateFormat('dd').format(route.createdOn).toString() + '-' + DateFormat('MM').format(route.createdOn).toString() + '-' + DateFormat.y().format(route.createdOn).toString() + ' @ ' + DateFormat('h:mm').format(route.createdOn).toString() + DateFormat('a').format(route.createdOn).toString().toLowerCase();
  }

  String getStatus(status, pendingCount) {
    if (pendingCount == 0) {
      return 'Completed';
    }
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
        // Get.offAll(Pitstops(route.routePlanId, route.companyId, 'list'));
        Get.to(Pitstops(route.routePlanId, route.companyId, route.status.toString(), 'list'));
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
                  SizedBox(
                    width: sBox,
                    child: Text(
                      'Plan Name',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: sBoxSpace,
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
                  SizedBox(
                    width: sBox,
                    child: Text(
                      'Created By',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sBoxSpace,
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
                  SizedBox(
                    width: sBox,
                    child: Text(
                      'Admin Remarks',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sBoxSpace,
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
                  SizedBox(
                    width: sBox,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sBoxSpace,
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
                    getStatus(route.status, route.pendingCount),
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
                  SizedBox(
                    width: sBox,
                    child: Text(
                      'Created On',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sBoxSpace,
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
              route.status == 0 && RemoteServices().box.get('role') == '4'
                  ? Column(
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
                                  epC.aprRejRoutePlan(index, route.routePlanId, '2');
                                },
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                color: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  epC.aprRejRoutePlan(index, route.routePlanId, '1');
                                },
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 5.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
