import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import '../utils/utils.dart';
import 'pitstops.dart';
import '../connection/remote_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../controllers/pitstops_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpdatePitstops extends StatefulWidget {
  var pit;
  final String company;
  final String goBackTo;
  UpdatePitstops(this.pit, this.company, this.goBackTo);

  @override
  _UpdatePitstopsState createState() => _UpdatePitstopsState();
}

class _UpdatePitstopsState extends State<UpdatePitstops> {
  final PitstopsController psC = Get.put(PitstopsController());
  CameraController controller;
  List<CameraDescription> cameras;
  var currentTime = DateFormat().add_jm().format(DateTime.now()).toString();
  File attachment;
  final TextEditingController remarks = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCam();
    psC.pr = ProgressDialog(
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
    psC.pr.style(
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
    psC.getCurrentLocation(jsonDecode(widget.pit));
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

  void takePicture() async {
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
    var file = File(filePath);
    // networkcall(file);
    var res = await psC.uploadImage(file);
    print(res);
    if (res) {
      await Get.defaultDialog(
        title: 'Attach Image or Remarks',
        radius: 5.0,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaisedButton(
              onPressed: () async {
                var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  attachment = File(pickedFile.path);
                } else {
                  print('No image selected.');
                }
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Attachment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            TextField(
              controller: remarks,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(
                  10.0,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                hintText: 'Enter remarks',
              ),
            ),
          ],
        ),
        barrierDismissible: false,
        onConfirm: () async {
          await psC.pr.show();
          var pit = jsonDecode(widget.pit);
          // print('pitstopId: ${pit['pitstopId']}');
          // print('empId: ${pit['clientId']}');
          // print('checkinLat: ${psC.currentPosition.latitude}');
          // print('checkinLng: ${psC.currentPosition.longitude}');
          // print('empRemarks: ${remarks.text}');
          // print('attachment: $attachment');
          var base64String = '';
          if (attachment != null) {
            final bytes = await File(attachment.path).readAsBytes();
            // print(base64.encode(bytes));
            base64String = base64.encode(bytes);
          }
          var updatePit = await RemoteServices().updatePitstops(
            pitstopId: pit['pitstopId'],
            empId: pit['clientId'],
            checkinLat: psC.currentPosition.latitude,
            checkinLng: psC.currentPosition.longitude,
            empRemarks: remarks.text,
            attachment: base64String,
          );
          print(updatePit);
          if (updatePit != null && updatePit['success'] == true) {
            await psC.pr.hide();
            await Get.offAll(Pitstops(pit['routePlanId'], widget.company, pit['status'], widget.goBackTo));
          } else {
            await psC.pr.hide();
            Get.snackbar(
              null,
              'Something went wrong! Please try again later',
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
        // onCancel: () {
        //   remarks.text = '';
        // },
        confirmTextColor: Colors.white,
        textConfirm: 'Submit',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return Container();
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final xScale = controller.value.aspectRatio / deviceRatio;
    // Modify the yScale if you are in Landscape
    final yScale = 1.0;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                        height: 170.0,
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
                                        psC.currentAddress.value,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      );
                                    }),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Distance from site:',
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
                                        psC.dis.value,
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
                                  psC.todayString.value,
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
                        onPressed: psC.currentAddress.value == 'Fetching your location...' || psC.dis.value == 'Finding distance from site...' ? null : takePicture,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 18.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Complete',
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
