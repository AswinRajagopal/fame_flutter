import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/profile_controller.dart';
import 'package:fame/widgets/ProfileTabWidgets.dart';
import 'package:package_info/package_info.dart';

// import 'face_register.dart';

// import '../connection/remote_services.dart';
// import 'package:progress_dialog/progress_dialog.dart';

// import '../controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'face_register.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController pC = Get.put(ProfileController());
  String version;
  int selectedTabIndex = 0;

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

  Expanded buildTabButton(bool selected, String text, Function onTap) {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: onTap,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 24),
            child: Text(text,
                style: selected
                    ? const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)
                    : const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List bodyList = [
      PersonalInfoTab(
        pC: pC,
      ),
      CompilanceInfoTab(
        pC: pC,
      )
    ];
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
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              // bg _image
              Container(
                height: size.height / 2,
                width: size.width,
                color: Colors.blue,
                // child: Image.asset(
                //   'assets/images/red_bg.jpg',
                //   fit: BoxFit.cover,
                // ),
              ),
              // app bar
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Color(0xFFffffff),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
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
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        pC.pr.show();
                                        RemoteServices().logout();
                                      },
                                      child: Text('YES'),
                                    ),
                                    ElevatedButton(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // my profile

              //body
              Obx(() {
                if (pC.isLoading.value) {
                  return Container(
                    height: 460.0,
                    width: MediaQuery.of(context).size.width,
                  );
                } else {
                  var img;
                  if (pC.profileRes['profileImage'] != null) {
                    img = pC.profileRes['profileImage']['image'];
                    img =
                        img.contains('data:image') ? img.split(',').last : img;

                    print('img.length: ${img.length}');
                  }

                  return // body

                      Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      width: double.infinity,
                      height: size.height - 300,
                      child: bodyList[selectedTabIndex],
                    ),
                  );
                  return Container(
                    // height: 220.0,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
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

              Padding(
                padding: const EdgeInsets.only(top: 60, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "My",
                      style: TextStyle(
                          fontFamily: "Sofia",
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontFamily: "Sofia",
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // profile block with tab options

              Obx(() {
                if (pC.isLoading.value) {
                  return Container(
                    height: 460.0,
                    width: MediaQuery.of(context).size.width,
                  );
                } else {
                  var img;
                  var url;
                  if (pC.profileRes['profileImage'] != null) {
                    img = pC.profileRes['profileImage']['image'];
                    img =
                        img.contains('data:image') ? img.split(',').last : img;
                  } else {
                    url = pC.profileRes['imageUrl'];
                  }

                  return // body

                      Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                  height: 190.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 15.0,
                                        spreadRadius: 10.0,
                                        color: Colors.black12.withOpacity(0.03),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 60.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              pC.profileRes['empDetails']
                                                      ['name'] ??
                                                  'N/A',
                                              style: const TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        child: Theme(
                                          data: ThemeData(
                                            highlightColor: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              buildTabButton(
                                                  selectedTabIndex == 0,
                                                  "Personal Info",
                                                  () => setState(() =>
                                                      selectedTabIndex = 0)),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20),
                                                  height: 30,
                                                  width: 2,
                                                  color: Colors.greenAccent),
                                              buildTabButton(
                                                  selectedTabIndex == 1,
                                                  "Compliance Info",
                                                  () => setState(() =>
                                                      selectedTabIndex = 1))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('take picture');
                                if (jsonDecode(RemoteServices()
                                    .box
                                    .get('appFeature'))['faceReregister']) {
                                  Get.to(FaceRegister(pC.endPoint));
                                } else {
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
                              child: CircleAvatar(
                                // backgroundImage:AssetImage('assets/images/person_male.png'),
                                backgroundImage: url != null
                                    ? CachedNetworkImage(
                                        imageUrl: url,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                            value: progress.progress,
                                          ),
                                        ),
                                      )
                                    : img != null
                                        ? MemoryImage(base64.decode(
                                            img.replaceAll('\n', ''),
                                          ))
                                        : NetworkImage(
                                            'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png',
                                            // fit: BoxFit.cover,
                                          ),
                                radius: 60.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              }),

              // body
              // TODO: integrate this

              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     child: SingleChildScrollView(
              //       child: Card(
              //         color: Colors.white,
              //         elevation: 6.0,
              //         margin: EdgeInsets.only(
              //           top: 20.0,
              //           right: 20.0,
              //           left: 20.0,
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(
              //             15.0,
              //           ),
              //         ),
              //         child: Obx(() {
              //           if (pC.isLoading.value) {
              //             return Container(
              //               height: 460.0,
              //               width: MediaQuery.of(context).size.width,
              //             );
              //           } else {
              //             var img;
              //             if (pC.profileRes['profileImage'] != null) {
              //               img = pC.profileRes['profileImage']['image'];
              //               img = img.contains('data:image') ? img.split(',').last : img;
              //
              //               print('img.length: ${img.length}');
              //             }
              //
              //             return // body
              //
              //                 Padding(
              //               padding: EdgeInsets.only(top: 300),
              //               child: Container(
              //                 decoration: const BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.only(
              //                         topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              //                 width: double.infinity,
              //                 height: size.height - 300,
              //                 child: bodyList[selectedTabIndex],
              //               ),
              //             );
              //             return Container(
              //               // height: 220.0,
              //               width: MediaQuery.of(context).size.width,
              //               child: ListView(
              //                 shrinkWrap: true,
              //                 children: [
              //                   ProfileDetailRow(
              //                     'assets/images/icon_profile_address.png',
              //                     pC.profileRes['empDetails']['address'] ?? 'N/A',
              //                   ),
              //                   SizedBox(
              //                     height: 10.0,
              //                   ),
              //                   ProfileDetailRow(
              //                     'assets/images/icon_profile_call.png',
              //                     pC.profileRes['empDetails']['phone'] ?? 'N/A',
              //                   ),
              //                   SizedBox(
              //                     height: 10.0,
              //                   ),
              //                   ProfileDetailRow(
              //                     'assets/images/icon_profile_mail.png',
              //                     pC.profileRes['empDetails']['emailId'] ?? 'N/A',
              //                   ),
              //                   SizedBox(
              //                     height: 15.0,
              //                   ),
              //                   Center(
              //                     child: Text(
              //                       'Version $version',
              //                       style: TextStyle(
              //                         color: Colors.grey,
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     height: 15.0,
              //                   ),
              //                 ],
              //               ),
              //             );
              //           }
              //         }),
              //       ),
              //     ),
              //   ),
              // ),
              //
            ],
          ),
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
