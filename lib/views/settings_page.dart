import 'onboarding_page.dart';
import 'transfer_list.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import 'package:share/share.dart';

import 'sos.dart';

import 'new_broadcast.dart';

import 'view_broadcast.dart';

import 'support.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:in_app_review/in_app_review.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final InAppReview inAppReview = InAppReview.instance;
  TextEditingController feedback = TextEditingController();
  bool isAvailable = false;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      inAppReview.isAvailable().then((value) {
        print('value: $value');
        isAvailable = value;
        setState(() {});
      });
    });

    pr = ProgressDialog(
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
    pr.style(
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                Get.to(TransferList());
              },
              child: ListContainer(
                'assets/images/icon_transfer.png',
                'Transfer',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(OnboardingPage());
              },
              child: Visibility(
                visible: roleId == '3' ? true : false,
                child: ListContainer(
                  'assets/images/onboarding.png',
                  'Onboarding',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('isAvailable: $isAvailable');
                // inAppReview.openStoreListing();
                if (isAvailable) {
                  inAppReview.requestReview();
                }
              },
              child: ListContainer(
                'assets/images/icon_rating.png',
                'Rate The App',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(Support());
              },
              child: ListContainer(
                'assets/images/supportic.png',
                'Support',
              ),
            ),
            Visibility(
              // visible: roleId == '3' ? true : false,
              visible: true,
              child: GestureDetector(
                onTap: () {
                  Get.to(ViewBroadcast());
                },
                child: ListContainer(
                  'assets/images/msgic.png',
                  'View Broadcast',
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Get.defaultDialog(
                  title: 'Feedback',
                  radius: 5.0,
                  content: TextField(
                    controller: feedback,
                    // autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(
                        10.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.0,
                      ),
                      hintText: 'Please share your valuable feedback',
                      // labelText: 'Feedback',
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                  confirmTextColor: Colors.white,
                  textConfirm: 'Submit',
                  onCancel: () {
                    feedback.text = '';
                  },
                  onConfirm: () async {
                    if (feedback.text != null && feedback.text != '') {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await pr.show();
                      var fbRes = await RemoteServices().sendFeedback(feedback.text);
                      if (fbRes != null) {
                        await pr.hide();
                        if (fbRes['success']) {
                          Get.back();
                          setState(() {
                            feedback.clear();
                          });
                          Get.snackbar(
                            null,
                            'Feedback submitted successfully',
                            colorText: Colors.white,
                            backgroundColor: AppUtils().greenColor,
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
                            duration: Duration(
                              seconds: 2,
                            ),
                          );
                        } else {
                          Get.snackbar(
                            null,
                            'Feedback send failed',
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
                      }
                    }
                  },
                );
              },
              child: ListContainer(
                'assets/images/feedbacki.png',
                'Feedback',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(SOS());
              },
              child: ListContainer(
                'assets/images/icon_attendance.png',
                'My SOS',
              ),
            ),
            GestureDetector(
              onTap: () {
                Share.share(
                  'Check out Pocket FaME ${AppUtils.PLAYSTORE}',
                );
              },
              child: ListContainer(
                'assets/images/shareic.png',
                'Share',
              ),
            ),
            Visibility(
              visible: roleId == '3' ? true : false,
              child: GestureDetector(
                onTap: () {
                  Get.to(Broadcast());
                },
                child: ListContainer(
                  'assets/images/msgic.png',
                  'Broadcast',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ListContainer extends StatelessWidget {
  final String image;
  final String title;
  ListContainer(this.image, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        10.0,
        12.0,
        10.0,
        0.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    image,
                    height: 40.0,
                    width: 40.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 250.0,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                size: 35.0,
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            indent: 50.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }
}
