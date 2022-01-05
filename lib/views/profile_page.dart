import 'dart:convert';

import 'package:package_info/package_info.dart';

import 'face_register.dart';

import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController pC = Get.put(ProfileController());
  String version;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), pC.getEmpDetails);
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      // String buildNumber = packageInfo.buildNumber;
      version = packageInfo.version;
      print('version: ${packageInfo.version}');
      print('appName: ${packageInfo.appName}');
      print('packageName: ${packageInfo.packageName}');
      print('buildNumber: ${packageInfo.buildNumber}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    pC.pr = ProgressDialog(
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
    pC.pr.style(
      backgroundColor: Colors.white,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
        actions: [
          FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text(
                    'Are you sure?',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Get.back();
                        pC.pr.show();
                        RemoteServices().logout();
                      },
                      child: Text('YES'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('NO'),
                    ),
                  ],
                ),
              );
              // Get.defaultDialog(
              //   title: 'Logout',
              //   radius: 10.0,
              //   content: Text(
              //     'Are you sure?',
              //   ),
              //   barrierDismissible: false,
              //   onConfirm: () {
              //     RemoteServices().logout();
              //   },
              //   onCancel: () {},
              //   confirmTextColor: Colors.white,
              //   textConfirm: 'Yes',
              //   textCancel: 'No',
              // );
            },
            child: Text(
              'LOGOUT',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
                    color: Theme.of(context).primaryColor,
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
                      if (pC.isLoading.value) {
                        return Container(
                          height: 460.0,
                          width: MediaQuery.of(context).size.width,
                        );
                      } else {
                        var img;
                        if (pC.profileRes['profileImage'] != null) {
                          img = pC.profileRes['profileImage']['image'];
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
                              GestureDetector(
                                onTap: () {
                                  print('take picture');
                                  if(jsonDecode(RemoteServices().box.get('appFeature'))['faceReregister']) {
                                    Get.to(FaceRegister(pC.endPoint));
                                  }else{
                                    Get.snackbar(
                                      'Re-registration disabled',
                                      'Please contact your Incharge for Re-registration',
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
                                  }
                                },
                                child: img == null
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
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  pC.profileRes['empDetails']['name'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  pC.profileRes['empDetails']['empId'] ?? 'N/A',
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
                                pC.profileRes['empDetails']['address'] ?? 'N/A',
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_call.png',
                                pC.profileRes['empDetails']['phone'] ?? 'N/A',
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_mail.png',
                                pC.profileRes['empDetails']['emailId'] ?? 'N/A',
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_insno.png',
                                pC.profileRes['empDetails']['insurancePolicy'] ?? 'N/A',
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Center(
                                child: Text(
                                  'Version $version',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
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
  ProfileDetailRow(
    this.image,
    this.text,
  );

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
              Image.asset(
                image,
                scale: 1.2,
              ),
              Flexible(
                child: Text(
                  text == null || text == '' ? 'N/A' : text,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
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
