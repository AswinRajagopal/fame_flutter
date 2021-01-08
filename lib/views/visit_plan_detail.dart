import '../utils/utils.dart';
import 'package:timelines/timelines.dart';

import '../controllers/employee_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class VisitPlanDetail extends StatefulWidget {
  final String empId;
  final String date;
  VisitPlanDetail(this.empId, this.date);

  @override
  _VisitPlanDetailState createState() => _VisitPlanDetailState();
}

class _VisitPlanDetailState extends State<VisitPlanDetail> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());

  @override
  void initState() {
    epC.pr = ProgressDialog(
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
    epC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      epC.getTimelineReport(widget.empId, widget.date, type: 'visit');
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Visit Plan',
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (epC.isLoadingTimeline.value) {
            return Column();
          } else if (epC.pitsStops.isNullOrBlank) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'No data found for employee and selected date',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
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
                      itemCount: epC.pitsStops.length,
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
                        var pitstop = epC.pitsStops[index];
                        return TimelineTile(
                          nodeAlign: TimelineNodeAlign.basic,
                          // mainAxisExtent: 200.0,
                          direction: Axis.vertical,
                          nodePosition: 0.01,
                          contents: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.only(
                              left: 10.0,
                              bottom: index == epC.pitsStops.length - 1 ? 50.0 : 20.0,
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
                                      pitstop['address'],
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      pitstop['datetime'],
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          node: TimelineNode(),
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
