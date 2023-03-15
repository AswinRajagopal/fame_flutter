import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/dashboard_controller.dart';
import 'package:fame/controllers/profile_controller.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_page.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  var faceApi, checkinLocation;
  var chkInDt;
  var chkOutDt;
  CheckoutPage(this.faceApi, this.checkinLocation, this.chkInDt, this.chkOutDt);

  @override
  _CheckoutPageState createState() =>
      _CheckoutPageState(this.chkInDt, this.chkOutDt);
}

class _CheckoutPageState extends State<CheckoutPage> {
  final DashboardController dbC = Get.put(DashboardController());
  final ProfileController pC = Get.put(ProfileController());
  final CheckoutController checkoutController = Get.put(CheckoutController());
  CameraController controller;
  List<CameraDescription> cameras;
  var currentTime = DateFormat.yMd().add_jm().format(DateTime.now()).toString();
  var size;
  var deviceRatio;
  var xScale;
  var chkInDt;
  String chkOutDt;
  _CheckoutPageState(this.chkInDt, this.chkOutDt);
  var totalWorkingHours = '';
  var hours;
  var userCheckOutTime;
  var checkOutTime;

  Future<Null> workSession() {
    final DateTime checkOutTime = DateTime.now();
    if (checkOutTime != null) {
      setState(() {
        final totalWorkingHours =
            checkOutTime.difference(DateTime.parse(chkInDt)).inHours;
        hours = totalWorkingHours;
      });
    }
  }

  String convertTimeWithParse(time) {
    return DateFormat('h:mm')
            .format(DateFormat('HH:mm:ss').parse(time))
            .toString() +
        DateFormat('a')
            .format(DateFormat('HH:mm:ss').parse(time))
            .toString()
            .toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      String timeString = chkOutDt;
      TimeOfDay apiTimeOfDay =
          TimeOfDay.fromDateTime(DateTime.parse('2023-03-11 $timeString'));
      DateTime apiDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        apiTimeOfDay.hour,
        apiTimeOfDay.minute,
      );
      if (DateTime.now().isBefore(apiDateTime)) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                'Early Exit..!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Are you sure you want to exit?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Get.to(DashboardPage());
                  },
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
      } else {
        Column();
      }
    });
    workSession();
    if (widget.checkinLocation != null && !widget.checkinLocation) {
      checkoutController.currentAddress.value = 'Site';
    }
    if (widget.faceApi == 1) {
      initCam();
    } else if (widget.checkinLocation == null || widget.checkinLocation) {
      checkoutController.getCurrentLocation();
    }
    checkoutController.pr = ProgressDialog(
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
    checkoutController.pr.style(
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void initCam() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    if (widget.checkinLocation == null || widget.checkinLocation) {
      checkoutController.getCurrentLocation();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  void takePicture(type) async {
    var file;
    var res;
    if (type == 1) {
      if (!controller.value.isInitialized) {
        Get.snackbar(
          null,
          'select a camera first.',
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
        return null;
      }
      final extDir = await getApplicationDocumentsDirectory();
      final dirPath = '${extDir.path}/Pictures/flutter_test';
      await Directory(dirPath).create(recursive: true);
      final filePath = '$dirPath/image.jpg';
      var dir = Directory(filePath);
      try {
        dir.deleteSync(recursive: true);
      } catch (e) {
        print(e.toString());
      }
      if (controller.value.isTakingPicture) {
        // A capture is already pending, do nothing.
        return null;
      }

      try {
        await controller.takePicture(filePath);
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
      file = File(filePath);
      // networkcall(file);
      res = await checkoutController.uploadImage(file);
    } else {
      res = await checkoutController.justCheckout();
    }

    print(res);
    if (res != null && res) {
      // ignore: unawaited_futures
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Container(
                width: MediaQuery.of(context).size.height / 2.5,
                height: MediaQuery.of(context).size.height / 1.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    Image.asset(
                      'assets/images/success.png',
                      scale: 2.0,
                      color: AppUtils().greenColor,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Thank you!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    file != null
                        ? ClipOval(
                            child: Image.file(
                              file,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png',
                              // fit: BoxFit.cover,
                            ),
                            radius: 100.0,
                          ),
                    // }),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Mr.' + RemoteServices().box.get('empName'),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Employee ID',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                RemoteServices().box.get('empid').toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Check Out Time',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                DateFormat()
                                    .add_jm()
                                    .format(DateTime.now())
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  width: 150.0,
                                  height: 85.0,
                                  child: Obx(() {
                                    return Text(
                                      checkoutController.currentAddress.value,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
                                )
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shift',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      convertTimeWithParse(
                                          dbC.response['empdetails']
                                              ['shiftStartTime']),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' to ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      convertTimeWithParse(
                                          dbC.response['empdetails']
                                              ['shiftEndTime']),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Worked for',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '$hours' 'hours',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(DashboardPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 15.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppUtils().greenColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30.0,
                            ),
                          ),
                        ),
                        child: Text(
                          'Okay',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    )
                  ],
                ),
              ),
            );
          });
      // Timer(Duration(seconds: 2), () {
      //   Get.offAll(DashboardPage());
      // });
    }
  }

  void _showCameraException(CameraException e) {
    print(e.code + e.description);
    Get.snackbar(
      null,
      '${e.code}\n${e.description}',
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

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        Get.snackbar(
          null,
          '${controller.value.errorDescription}',
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
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null && widget.faceApi == 1) return Container();
    if (widget.faceApi == 1) {
      size = MediaQuery.of(context).size;
      deviceRatio = size.width / size.height;
      xScale = controller.value.aspectRatio / deviceRatio;
    }
    // Modify the yScale if you are in Landscape
    final yScale = 1.0;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            widget.faceApi == 1
                ? Container(
                    child: AspectRatio(
                      aspectRatio: deviceRatio,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(xScale, yScale, 1),
                        child: CameraPreview(
                          controller,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: AppUtils().greyScaffoldBg,
                  ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    left: 15.0,
                  ),
                  child: Container(
                    width: 90.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          30.0,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Container(
                    height: 150.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 180.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Address:',
                                  style: TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                  height: 8.0,
                                ),
                                Obx(() {
                                  return Text(
                                    checkoutController.currentAddress.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            height: 100.0,
                            width: 2.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Obx(() {
                            return Text(
                              checkoutController.todayString.value,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Obx(() {
                      return RaisedButton(
                        onPressed: checkoutController.currentAddress.value ==
                                'Fetching your location...'
                            ? null
                            : () {
                                takePicture(widget.faceApi);
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 18.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Check Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Image.asset(
                                'assets/images/arrow_right.png',
                                scale: 1.5,
                              )
                            ],
                          ),
                        ),
                        color: AppUtils().greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ),
                          side: BorderSide(
                            color: AppUtils().greenColor,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  final double radius;

  CircleClipper({this.radius});

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
