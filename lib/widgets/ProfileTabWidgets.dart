import 'dart:convert';

import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalInfoTab extends StatelessWidget {
  const PersonalInfoTab({
    Key key,
    this.pC,
  }) : super(key: key);
  final ProfileController pC;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 120, bottom: 40),
      primary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // address line - add new
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                size: 21,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Emp Id",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        pC.profileRes['empDetails']['empId'] ??
                                            'N/A',
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.family_restroom,
                                size: 21,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Father Name",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        pC.profileRes['empDetails']
                                                ['empFatherName'] ??
                                            'N/A',
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.cake_outlined,
                                size: 21,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date of Birth",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        pC.profileRes['empDetails']['dob'] !=
                                                null
                                            ? DateFormat('dd-MM-yyyy').format(
                                                    DateTime.parse(
                                                        pC.profileRes[
                                                                'empDetails']
                                                            ['dob'])) ??
                                                'N/A'
                                            : '',
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                size: 21,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date of Join",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        pC.profileRes['empDetails']['doj'] !=
                                                null
                                            ? DateFormat('dd-MM-yyyy').format(
                                                    DateTime.parse(
                                                        pC.profileRes[
                                                                'empDetails']
                                                            ['doj'])) ??
                                                'N/A'
                                            : '',
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone_android,
                                size: 21,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mobile No.",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        pC.profileRes['empDetails']['phone'] ??
                                            'N/A',
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 21,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        pC.profileRes['empDetails']
                                                ['emailId'] ??
                                            'N/A',
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              elevation: 10,
              shadowColor: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 4, left: 4, right: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Address",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.home,
                                size: 24,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pC.profileRes['empDetails']['address']
                                              .toString()
                                              .replaceAll(',,', ',') ??
                                          '',
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          // mobile
          // PersonalInfoRow(
          //   iconName: 'assets/images/icon_profile_call.png',
          //   heading: "Mobile",
          //   text: pC.profileRes['empDetails']['phone'] ?? 'N/A',
          // ),
          // email
        ],
      ),
    );
  }
}

class CompilanceInfoTab extends StatelessWidget {
  CompilanceInfoTab({
    Key key,
    this.pC,
  }) : super(key: key);
  final ProfileController pC;
  var encEmpId;

  @override
  Widget build(BuildContext context) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    encEmpId = stringToBase64
        .encode(RemoteServices().box.get('empid').toString())
        .toString();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 120, bottom: 40),
      primary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            new Center(
              child: new ButtonBar(
                mainAxisSize: MainAxisSize.min,
                // this will take space as minimum as posible(to center)
                children: <Widget>[
                  Column(children: [
                    MaterialButton(
                      onPressed: () {
                        var url = jsonDecode(RemoteServices()
                                .box
                                .get('appFeature'))['paySlipUrl']
                            .toString()
                            .replaceAll(
                                'DownloadPayslip.aspx', 'docdownloads.aspx');
                        url = url +
                            '?empId=' +
                            encEmpId.toString() +
                            '&documentType=' +
                            'IDCard';
                        Get.to(DetailScreen(url));
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.perm_identity,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    Text('ID Card')
                  ]),
                  Container(
                    width: 10,
                  ),
                  Column(children: [
                    MaterialButton(
                      onPressed: () {
                        var url = jsonDecode(RemoteServices()
                                .box
                                .get('appFeature'))['paySlipUrl']
                            .toString()
                            .replaceAll(
                                'DownloadPayslip.aspx', 'docdownloads.aspx');
                        url = url +
                            '?empId=' +
                            encEmpId.toString() +
                            '&documentType=' +
                            'AppointmentLetter'.toString();
                        Get.to(DetailScreen((url)));
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.book,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    Text('Appointment')
                  ]),
                  Container(
                    width: 10,
                  ),
                  Column(
                    children: [
                      MaterialButton(
                        onPressed: () async{
                          var url= jsonDecode(RemoteServices()
                              .box
                              .get('appFeature'))['insuranceUrl'].toString();
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.shield,
                          size: 24,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                      ),
                      Text('Insurance')
                    ],
                  ),
                  Container(
                    width: 10,
                  ),
                  Column(
                      children: [
                    MaterialButton(
                      onPressed: () {
                        var url = jsonDecode(RemoteServices()
                                .box
                                .get('appFeature'))['paySlipUrl']
                            .toString()
                            .replaceAll(
                                'DownloadPayslip.aspx', 'docdownloads.aspx');
                        url = url +
                            '?empId=' +
                            encEmpId.toString() +
                            '&documentType=' +
                            'ESICCard'.toString();
                        Get.to(DetailScreen(url));
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.local_hospital,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    Text('ESI Card')
                  ]),
                ],
              ),
            ),
          ]),
          Container(height: 10),
          // address line - add new
          // mobile
          // PersonalInfoRow(
          //   iconName: 'assets/images/icon_profile_call.png',
          //   heading: "Mobile",
          //   text: pC.profileRes['empDetails']['phone'] ?? 'N/A',
          // ),
          // email
          pC.profileRes['empDetails']['aadhaarid'] != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.account_circle_outlined,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Aadhaar No.",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['aadhaarid'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
          pC.profileRes['empDetails']['panNo'] != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "PAN",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['panNo'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
          pC.profileRes['empDetails']['pfNo'] != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.account_circle_outlined,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "PF No.",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['pfNo'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
          pC.profileRes['empDetails']['insurancePolicy'] != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.medical_services_outlined,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Insurance Policy No.",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['insurancePolicy'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
          pC.profileRes['empDetails']['empUANNumber'] != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.food_bank,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "UAN",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['empUANNumber'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
          pC.profileRes['empDetails']['esiNo'] != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.local_hospital_outlined,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ESI No.",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['esiNo'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
          pC.profileRes['empDetails']['empBankAcNo'] != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      size: 21,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bank A/C No.",
                                            style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              pC.profileRes['empDetails']
                                                      ['empBankAcNo'] ??
                                                  'N/A',
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class PersonalInfoRow extends StatelessWidget {
  const PersonalInfoRow({Key key, this.heading, this.iconName, this.text})
      : super(key: key);
  final String iconName;
  final String heading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 10,
        shadowColor: Colors.white60,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              padding:
                  const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          iconName,
                          height: 21,
                          width: 21,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 6.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                heading,
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      fontFamily: "Sofia",
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class FamilyTab extends StatelessWidget {
  const FamilyTab({Key key, this.pC}) : super(key: key);
  final ProfileController pC;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 145, bottom: 40),
      primary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // myself
                  Expanded(
                    flex: 1,
                    child: Material(
                      elevation: 10,
                      color: Colors.white,
                      shadowColor: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: new AssetImage(
                                      'assets/images/profile.png'),
                                  radius: 30.0,
                                ),
                                const Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Text(
                                    "John Doe",
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Center(
                                  child: Material(
                                    elevation: 10,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.red,
                                              Colors.red.withOpacity(0.9)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Text(
                                            "Myself",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Material(
                            elevation: 10,
                            color: Colors.white,
                            shadowColor: Colors.white60,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 10, right: 10, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: new AssetImage(
                                            'assets/images/profile.png'),
                                        radius: 25.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Jane Doe",
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "Wife",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Material(
                            elevation: 10,
                            color: Colors.white,
                            shadowColor: Colors.white60,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 10, right: 10, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: new AssetImage(
                                            'assets/images/profile.png'),
                                        radius: 25.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Janet Doe",
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "Daughter",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          GridView.count(
            crossAxisSpacing: 10,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 2,
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                child: Material(
                  elevation: 10,
                  color: Colors.white,
                  shadowColor: Colors.white60,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, left: 10, right: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Janet Doe",
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Daughter",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VitalsTab extends StatelessWidget {
  const VitalsTab({Key key, this.pC}) : super(key: key);
  final ProfileController pC;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 100, bottom: 40),
      primary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 6 / 5,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemCount: 6,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                child: Material(
                  elevation: 10,
                  color: Colors.white,
                  shadowColor: Colors.white60,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, left: 10, right: 10, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.filter_vintage_outlined,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Daughter",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "900",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "rate",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String url;

  DetailScreen(this.url);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SfPdfViewer.network(url, key: _pdfViewerKey,
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
      Get.snackbar(
        null,
        'Document not found for the Employee',
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
    })));
  }
}
