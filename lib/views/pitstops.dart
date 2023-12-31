import 'dart:convert';

import 'package:hexcolor/hexcolor.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'update_pitstops.dart';
import 'package:timelines/timelines.dart';

import '../utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/pitstops_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_page.dart';
import 'routeplan_list.dart';

class Pitstops extends StatefulWidget {
  final String id;
  final String company;
  final String status;
  final String goBackTo;
  Pitstops(this.id, this.company, this.status, this.goBackTo);

  @override
  _PitstopsState createState() => _PitstopsState();
}

class _PitstopsState extends State<Pitstops> {
  final PitstopsController psC = Get.put(PitstopsController());

  @override
  void initState() {
    psC.pr = ProgressDialog(
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
    psC.pr.style(
      backgroundColor: Colors.white,
    );
    super.initState();
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        psC.getPitstops(widget.id, widget.company);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> backButtonPressed() {
    return widget.goBackTo == 'db' ? Get.offAll(DashboardPage()) : Get.offAll(RouteplanList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Pitstops',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: backButtonPressed,
        ),
        // actions: [
        //   IconButton(
        //     icon: Image.asset(
        //       'assets/images/bell_icon.png',
        //       height: 22.0,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (psC.isLoading.value) {
            return Column();
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 0.0,
                  ),
                  child: Timeline.tileBuilder(
                    theme: TimelineThemeData(
                      direction: Axis.vertical,
                      nodePosition: 0.01,
                    ),
                    builder: TimelineTileBuilder.connected(
                      itemCount: psC.pitsStops.length,
                      connectorBuilder: (context, index, type) {
                        return DashedLineConnector(
                          dash: 6.0,
                          gap: 3.0,
                          color: Theme.of(context).primaryColor,
                        );
                      },
                      indicatorBuilder: (context, index) {
                        return OutlinedDotIndicator(
                          size: 25.0,
                          backgroundColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          borderWidth: 7.0,
                        );
                      },
                      indicatorPositionBuilder: (context, index) {
                        return index == 0 ? 0.30 : 0.08;
                      },
                      contentsBuilder: (context, index) {
                        var pitstop = psC.pitsStops[index];
                        return GestureDetector(
                          onTap: pitstop['checkinLat'] != null
                              ? null
                              : () {
                                  print('clicked');
                                  print(widget.status);
                                  if (widget.status == '0') {
                                    Get.snackbar(
                                      null,
                                      'Route Plan is not approved by admin yet',
                                      colorText: Colors.white,
                                      backgroundColor: Colors.black87,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 10.0,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 18.0,
                                      ),
                                      borderRadius: 5.0,
                                    );
                                  } else {
                                    Get.defaultDialog(
                                      title: 'Navigate or Complete?',
                                      radius: 5.0,
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            onPressed: () {
                                              Get.back();
                                              MapsLauncher.launchCoordinates(double.parse(pitstop['lat']), double.parse(pitstop['lng']));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Navigate',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            color: Colors.black87,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              print(pitstop['pitstopId']);
                                              print(pitstop['clientId']);
                                              Get.back();
                                              Get.to(UpdatePitstops(jsonEncode(pitstop), widget.company, widget.goBackTo));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Complete',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            color: Colors.black87,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                          child: TimelineTile(
                            nodeAlign: TimelineNodeAlign.basic,
                            // mainAxisExtent: 200.0,
                            direction: Axis.vertical,
                            nodePosition: 0.01,
                            contents: Card(
                              elevation: 0.0,
                              margin: EdgeInsets.only(
                                left: 10.0,
                                bottom: index == psC.pitsStops.length - 1 ? 50.0 : 20.0,
                                top: index == 0 ? 50.0 : 0.0,
                                right: 10.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Container(
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
                                      Text(
                                        pitstop['clientName'] + ' ' + pitstop['clientId'],
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        pitstop['address'],
                                        style: TextStyle(
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      pitstop['checkinLat'] != null
                                          ? Chip(
                                              label: Text(
                                                'Completed',
                                              ),
                                              backgroundColor: HexColor('ccf8d8'),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: HexColor('ccf8d8'),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: HexColor('3f7f33'),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Chip(
                                              label: Text(
                                                'Not Completed',
                                              ),
                                              backgroundColor: HexColor('ffeae6'),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: HexColor('ffeae6'),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: HexColor('bf695b'),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            node: TimelineNode(
                                // indicator: OutlinedDotIndicator(
                                //   size: 25.0,
                                //   backgroundColor: Colors.white,
                                //   color: Theme.of(context).primaryColor,
                                //   borderWidth: 7.0,
                                // ),
                                // indicatorPosition: 0.15,
                                // startConnector: Visibility(
                                //   visible: index == 0 ? false : true,
                                //   child: DashedLineConnector(
                                //     dash: 6.0,
                                //     gap: 3.0,
                                //     color: Theme.of(context).primaryColor,
                                //   ),
                                // ),
                                // endConnector: Visibility(
                                //   visible: index == psC.pitsStops.length - 1 ? false : true,
                                //   child: DashedLineConnector(
                                //     dash: 6.0,
                                //     gap: 3.0,
                                //     color: Theme.of(context).primaryColor,
                                //   ),
                                // ),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
