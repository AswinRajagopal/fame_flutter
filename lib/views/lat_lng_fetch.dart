import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fame/controllers/checkin_controller.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:number_to_character/number_to_character.dart';
import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import 'checkin_page.dart';

class LatLng extends StatefulWidget {

  @override
  _LatLngState createState() => _LatLngState();
}

class _LatLngState extends State<LatLng> {
  final CheckinController cinC = Get.put(CheckinController());

var appFeatures;

  @override
  void initState() {
    cinC.pr = ProgressDialog(
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
    cinC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      cinC.nearestSite,
    );
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     appFeatures = jsonDecode(RemoteServices().box.get('appFeature'));
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Nearest Site',
        ),
      ),
      body: WillPopScope(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 250,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.all(25.0),
                    child:Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                                children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Client Name:', style: new TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black)),
                                              Obx(() {
                                                return cinC.isLoading.value == null
                                                    ? CircularProgressIndicator()
                                                    : Text(
                                                    cinC.site != null &&
                                                        cinC.site[
                                                        'clientDetail'] !=
                                                            null &&
                                                        cinC.site['clientDetail']
                                                        ['name']
                                                            .toString() !=
                                                            'null'
                                                        ?cinC
                                                        .site[
                                                    'clientDetail']
                                                    ['name']
                                                        .toString()
                                                        : 'N/A',
                                                    style: new TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black));
                                              }),
                                            ]),
                                        SizedBox(height: 15.0,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Client Id:', style: new TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black)),
                                              ElevatedButton(
                                                onPressed: (){
                                                  Get.to(CheckinPage(
                                                      RemoteServices()
                                                          .box
                                                          .get(
                                                          'faceApi'),
                                                      appFeatures[
                                                      'checkinLocation']));
                                                },
                                                child: Obx(() {
                                                  return cinC.isLoading.value == null
                                                      ? CircularProgressIndicator()
                                                      : Text(
                                                      cinC.site != null &&
                                                          cinC.site[
                                                          'clientDetail'] !=
                                                              null &&
                                                          cinC.site['clientDetail']
                                                          ['id']
                                                              .toString() !=
                                                              'null'
                                                          ? cinC
                                                          .site[
                                                      'clientDetail']
                                                      ['id']
                                                          .toString()
                                                          : 'N/A',
                                                      style: new TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white));
                                                }),
                                              ),
                                            ]),
                                  SizedBox(height: 15.0,),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Client Address:', style: new TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black)),
                                        Obx(() {
                                          return cinC.isLoading.value == null
                                              ? CircularProgressIndicator()
                                              : Text(
                                              cinC.site != null &&
                                                  cinC.site[
                                                  'clientDetail'] !=
                                                      null &&
                                                  cinC.site['clientDetail']
                                                  ['pfAddress']
                                                      .toString() !=
                                                      'null'
                                                  ? cinC
                                                  .site[
                                              'clientDetail']
                                              ['pfAddress']
                                                  .toString()
                                                  : 'N/A',
                                              style: new TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black));
                                        }),
                                      ]),

                                ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

