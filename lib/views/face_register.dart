import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import '../utils/utils.dart';
import 'dashboard_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../controllers/face_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceRegister extends StatefulWidget {
  final String endPoint;
  FaceRegister(this.endPoint);

  @override
  _FaceRegisterState createState() => _FaceRegisterState();
}

class _FaceRegisterState extends State<FaceRegister> {
  final FaceRegisterController faceRegC = Get.put(FaceRegisterController());
  CameraController controller;
  List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    initCam();
    faceRegC.pr = ProgressDialog(
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
    faceRegC.pr.style(
      backgroundColor: Colors.white,
    );
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

  void takePicture() async {
    if (!controller.value.isInitialized) {
      Get.snackbar(
        'Error',
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
    var file = File(filePath);
    // networkcall(file);
    var res = await faceRegC.uploadImage(file, widget.endPoint);
    print(res);
    if (res) {
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
                'Face registered successfully',
                style: TextStyle(
                  fontSize: 18.0,
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
      'Error',
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
          'Error',
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return Container();
    final size = MediaQuery.of(context).size;
    // final deviceRatio = size.width / size.height;
    // final xScale = controller.value.aspectRatio / deviceRatio;
    // Modify the yScale if you are in Landscape
    // final yScale = 1.0;
    // print(size.height / 2.45);
    // print(size.width / 1.194);
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            // Container(
            //   child: AspectRatio(
            //     aspectRatio: deviceRatio,
            //     child: Transform(
            //       alignment: Alignment.center,
            //       transform: Matrix4.diagonal3Values(xScale, yScale, 1),
            //       child: CameraPreview(
            //         controller,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                top: 120.0,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(250.0),
                  ),
                  child: Container(
                    height: size.height / 2.45,
                    width: size.width / 1.194,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
              ),
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
                            fontWeight: FontWeight.bold,
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
                      padding: const EdgeInsets.fromLTRB(
                        20.0,
                        20.0,
                        20.0,
                        50.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Please look straight into the phone and place your face inside the frame.',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Please remove mask or cap for registration purpose.',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: takePicture,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 18.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Face Register',
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
                    ),
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
