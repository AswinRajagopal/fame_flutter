import 'dart:convert';

import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EmployeeProfile extends StatefulWidget {
  var emp;
  EmployeeProfile(this.emp);

  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
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
      epC.getEmpDetail(widget.emp['empId']);
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
      appBar: AppBar(
        title: Text(
          'Employee Profile',
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 6.0,
                    margin: EdgeInsets.only(
                      top: 20.0,
                      right: 20.0,
                      left: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    child: Obx(() {
                      if (epC.isLoadingEmpDetail.value) {
                        return Container(
                          height: 460.0,
                          width: MediaQuery.of(context).size.width,
                        );
                      } else {
                        var img;
                        if (epC.getEmpDetailRes['profileImage'] != null) {
                          img = epC.getEmpDetailRes['profileImage']['image'];
                          img = img.contains('data:image') ? img.split(',').last : img;

                          print('img.length: ${img.length}');
                        }
                        return Container(
                          // height: 220.0,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              img == null
                                  ? Image.network(
                                      'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png',
                                      // fit: BoxFit.cover,
                                      height: 100.0,
                                      width: 100.0,
                                    )
                                  : Image.memory(
                                      base64.decode(
                                        img.replaceAll('\n', ''),
                                      ),
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  epC.getEmpDetailRes['empDetails']['name'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  epC.getEmpDetailRes['empDetails']['empId'],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_address.png',
                                epC.getEmpDetailRes['empDetails']['address'],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_call.png',
                                epC.getEmpDetailRes['empDetails']['phone'],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_mail.png',
                                epC.getEmpDetailRes['empDetails']['emailId'],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_myteam.png',
                                epC.getEmpDetailRes['loginDetails'] != null ? epC.getEmpDetailRes['loginDetails']['userName'] : 'N/A',
                                scale: 1.4,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/logout_icon.png',
                                epC.getEmpDetailRes['loginDetails'] != null ? epC.getEmpDetailRes['loginDetails']['password'] : 'N/A',
                                scale: 1.7,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String image;
  final String text;
  final double scale;
  ProfileDetailRow(this.image, this.text, {this.scale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: scale == null ? 0.0 : 5.0,
              ),
              Image.asset(
                image,
                scale: scale ?? 1.2,
              ),
              SizedBox(
                width: scale == null ? 0.0 : 5.0,
              ),
              Flexible(
                child: Text(
                  text == '' ? 'N/A' : text,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: scale == null ? 0.0 : 8.0,
          ),
          Divider(
            color: Colors.black,
            height: 5.0,
            thickness: 1.2,
          ),
        ],
      ),
    );
  }
}
