import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io' as Io;

import 'package:dio/dio.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/visit_plan_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'visit_plan_route.dart';

import '../utils/utils.dart';
import 'package:timelines/timelines.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class VisitPlanDetail extends StatefulWidget {
  final String empId;
  final String fDate;
  final String tDate;
  VisitPlanDetail(this.empId, this.fDate, this.tDate);

  @override
  _VisitPlanDetailState createState() => _VisitPlanDetailState();
}

class _VisitPlanDetailState extends State<VisitPlanDetail> {
  final VisitPlanController vpC = Get.put(VisitPlanController());

  @override
  void initState() {
    vpC.pr = ProgressDialog(
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
    vpC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      vpC.getPitstopByFromToDate(widget.empId, widget.fDate, widget.tDate);
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
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.download_sharp,
                color: Colors.white,
                semanticLabel: 'pdf',
              ),
              onPressed: () {
                RemoteServices().getVisitDownloads(
                    widget.empId, widget.fDate, widget.tDate);
              })
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.to(VisitPlanRoute(widget.empId, widget.fDate));
            },
            child: Icon(
              Icons.location_on,
              size: 32.0,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (vpC.isLoadingFromToDate.value) {
            return Column();
          } else if (vpC.datePitsStop.isNullOrBlank) {
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
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scrollbar(
            radius: Radius.circular(
              10.0,
            ),
            thickness: 5.0,
            child: Column(
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
                        itemCount: vpC.datePitsStop.length,
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
                          var pitstop = vpC.datePitsStop[index];
                          return TimelineTile(
                            nodeAlign: TimelineNodeAlign.basic,
                            // mainAxisExtent: 200.0,
                            direction: Axis.vertical,
                            nodePosition: 0.01,
                            contents: GestureDetector(
                                onTap: () async {
                                  if (pitstop['attachment']) {
                                    var getPitstopAttachment =
                                        await RemoteServices().getPitstopAttch(
                                            pitstop['pitstopId'].toString());
                                    print(getPitstopAttachment);
                                    var img;
                                    if (getPitstopAttachment['success'] !=
                                        null) {
                                      var url = getPitstopAttachment['imgUrl'];
                                      print("url:$url");
                                      img = getPitstopAttachment[
                                          'pitstopAttachment']['pitstopImage'];
                                      img = img.contains('data:image')
                                          ? img.split(',').last
                                          : img;
                                      await showDialog(
                                          context: context,
                                          builder: (_) =>
                                              imageDialog(img, url));
                                    }
                                  }
                                },
                                child: Card(
                                  elevation: 5.0,
                                  margin: EdgeInsets.only(
                                    left: 10.0,
                                    bottom: index == vpC.datePitsStop.length - 1
                                        ? 50.0
                                        : 20.0,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          pitstop['clientId'] != null
                                              ? Column(children: [
                                                  Text(
                                                    'Client : ' +
                                                        pitstop['clientId'],
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6.0,
                                                  )
                                                ])
                                              : Container(),
                                          pitstop['activity'] != null
                                              ? Column(children: [
                                                  Text(
                                                    'Activity : ' +
                                                        pitstop['activity'],
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6.0,
                                                  )
                                                ])
                                              : Container(),
                                          Text(
                                            pitstop['address'],
                                            style: TextStyle(
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Container(),
                                          Text(
                                            'Remarks : ' +
                                                pitstop['empRemarks'],
                                            style: TextStyle(
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  pitstop['datetime'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                pitstop['attachment'] == true
                                                    ? Icon(Icons
                                                        .remove_red_eye_sharp)
                                                    : Container()
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            node: TimelineNode(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget imageDialog(img, url) {
    Dio dio = Dio();
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            width: 400,
            height: 400,
            child: img == null
                ? NetworkImage(url // fit: BoxFit.cover,
                    )
                : Image.memory(
                    base64.decode(
                      img.replaceAll('\n', ''),
                    ),
                    fit: BoxFit.cover,
                  ),
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () async {
                    print(url);
                    final encodedStr = img;
                    Uint8List bytes = base64.decode(encodedStr);
                    String dir =
                        (await getApplicationDocumentsDirectory()).path;
                    File file = File("$dir/" +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        ".jpeg");
                    await file.writeAsBytes(bytes);
                    Share.shareFiles([file.path]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.download_rounded,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
