import 'package:intl/intl.dart';

import '../utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ShortageReportDetail extends StatefulWidget {
  final String clientId;
  final String date;
  final String shift;
  ShortageReportDetail(this.clientId, this.date, this.shift);

  @override
  _ShortageReportDetailState createState() => _ShortageReportDetailState();
}

class _ShortageReportDetailState extends State<ShortageReportDetail> {
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
      epC.getShortageReport(widget.clientId, widget.date, widget.shift);
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
        title: Text('Shortage Report'),
      ),
      body: Obx(() {
        if (epC.isLoadingShortage.value) {
          return Column();
        }
        var sR = epC.shortageRes['shortageReport'];
        var p = sR['present'];
        var l = sR['leave'];
        var lt = sR['late'];
        var ot = sR['ot'];
        var suspense = sR['suspense'];
        var x = sR['x'];
        var ee = sR['ee'];
        var mP = int.parse(epC.shortageRes['manpower']);
        var shortage = mP - p < 0 ? 0 : mP - p;
        var total = p + l + lt + ot + x + ee + suspense;
        var showGraph = true;
        if (p == 0 && l == 0 && lt == 0 && ot == 0) {
          showGraph = false;
        }
        return SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            5.0,
                          ),
                        ),
                        border: Border.all(
                          color: Colors.grey[400],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${( ot + p).toString()}/${mP.toString()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Present',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.grey[400],
                            indent: 8.0,
                            endIndent: 8.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${shortage.toString()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Shortage',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: Column(
                        children : [
                          Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5.0,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.grey[400],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child :Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${p.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Present',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )),
                            VerticalDivider(
                              thickness: 1,
                              color: Colors.grey[400],
                              indent: 8.0,
                              endIndent: 8.0,
                            ),
                            Expanded(
                                child :Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${l.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Leave',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )),
                            VerticalDivider(
                              thickness: 1,
                              color: Colors.grey[400],
                              indent: 8.0,
                              endIndent: 8.0,
                            ),
                            Expanded(
                                child :Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${ot.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Overtime',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5.0,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.grey[400],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child :Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${x.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Auto Checkout',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )),
                            VerticalDivider(
                              thickness: 1,
                              color: Colors.grey[400],
                              indent: 8.0,
                              endIndent: 8.0,
                            ),
                            Expanded(
                                child : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${ee.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Early Exit',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )),
                            VerticalDivider(
                              thickness: 1,
                              color: Colors.grey[400],
                              indent: 8.0,
                              endIndent: 8.0,
                            ),
                            Expanded(
                              child : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${suspense.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Suspense',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                            ),
                          ],
                        ),
                      ),
                    ]),)
                  ],
                ),
              ),
              Positioned(
                top: 365.0,
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        // '24 Dec 2020',
                                        DateFormat('dd').format(DateTime.parse(widget.date)).toString() + ' ' + DateFormat.MMM().format(DateTime.parse(widget.date)).toString() + ' ' + DateFormat.y().format(DateTime.parse(widget.date)).toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      Visibility(
                                        visible: showGraph,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.greenAccent,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'P',
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.pink[300],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'L',
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'Auto.',
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'EE',
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'S.',
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.cyanAccent,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'Late',
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    50.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'OT',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 5.0,
                              // ),
                              Center(
                                child: !showGraph
                                    ? Text(
                                        'No Graph to show',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      )
                                    : SfCircularChart(
                                        palette: [
                                          Colors.greenAccent,
                                          Colors.pink[300],
                                          Colors.cyanAccent,
                                          Colors.indigo,
                                          Colors.grey,
                                          Colors.blue,
                                          Colors.yellow,
                                        ],
                                        series: <CircularSeries>[
                                          RadialBarSeries<ChartData, String>(
                                            dataSource: [
                                              if(p!=0) ChartData('Present', (p * 100 / total)),
                                              if(l!=0) ChartData('Leave', (l * 100 / total)),
                                              if(lt!=0) ChartData('Late', (lt * 100 / total)),
                                              if(ot!=0) ChartData('OT', (ot * 100 / total)),
                                              if(x!=0) ChartData('Auto.', (x * 100 / total)),
                                              if(ee!=0) ChartData('EE', (ee * 100 / total)),
                                              if(suspense!=0) ChartData('Susp.', (suspense * 100 / total)),
                                            ],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                            // Corner style of radial bar segment
                                            cornerStyle: CornerStyle.bothCurve,
                                            trackColor: Colors.white,
                                            gap: 4.toString(),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}
