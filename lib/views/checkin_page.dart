import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import '../utils/utils.dart';
import 'dashboard_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../controllers/checkin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CheckinPage extends StatefulWidget {
  var faceApi;
  CheckinPage(this.faceApi);

  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final CheckinController checkinController = Get.put(CheckinController());
  CameraController controller;
  List<CameraDescription> cameras;
  var currentTime = DateFormat().add_jm().format(DateTime.now()).toString();
  // Position _currentPosition;
  // String currentAddress = 'Fetching your location...';
  var size;
  var deviceRatio;
  var xScale;

  @override
  void initState() {
    super.initState();
    if (widget.faceApi == 1) {
      initCam();
    } else {
      checkinController.getCurrentLocation();
    }
    checkinController.pr = ProgressDialog(
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
    checkinController.pr.style(
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
    checkinController.getCurrentLocation();
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
          'Message',
          'select a camera first.',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
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
      res = await checkinController.uploadImage(file);
    } else {
      res = await checkinController.justCheckin();
    }

    print(res);
    if (res != null && res) {
      // ignore: unawaited_futures
      Get.bottomSheet(
        Container(
          height: MediaQuery.of(context).size.height / 2.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/success.png',
                scale: 2.0,
                color: AppUtils().greenColor,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Thank you for Login at',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                DateFormat().add_jm().format(DateTime.now()).toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 12.0,
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
                  'Thank You !',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // isDismissible: false,
      );
      Timer(Duration(seconds: 2), () {
        Get.offAll(DashboardPage());
      });
    }
  }

  void _showCameraException(CameraException e) {
    print(e.code + e.description);
    Get.snackbar(
      'Message',
      '${e.code}\n${e.description}',
      colorText: Colors.white,
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0,
      ),
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
          'Message',
          '${controller.value.errorDescription}',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
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
              padding: const EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
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
                                        checkinController.currentAddress.value,
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
                                  checkinController.todayString.value,
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
                    SizedBox(
                      height: 30.0,
                    ),
                    Obx(() {
                      return RaisedButton(
                        onPressed: checkinController.currentAddress.value == 'Fetching your location...'
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
                                'Check In',
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
