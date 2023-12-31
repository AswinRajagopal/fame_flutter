import 'dart:convert';

import 'package:fame/controllers/dashboard_controller.dart';
import 'package:fame/controllers/reporting_manager_att_controller.dart';
import 'package:fame/views/change_password.dart';
import 'package:fame/views/reporting_manager_report.dart';
import 'package:fame/views/view_expenses.dart';
import 'package:fame/views/view_emp_roster.dart';
import 'package:fame/views/view_regularize_att.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_page.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';

import '../connection/remote_services.dart';
import '../controllers/admin_controller.dart';
import '../utils/utils.dart';
import 'grievance_report.dart';
import 'ob_personal.dart';
import 'policy_doc_list.dart';
import 'sos.dart';
import 'support.dart';
import 'transfer_list.dart';
import 'view_broadcast.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DashboardController dbC = Get.put(DashboardController());
  final RepoManagerAttController rmaC = Get.put(RepoManagerAttController());
  final InAppReview inAppReview = InAppReview.instance;
  TextEditingController feedback = TextEditingController();
  final AdminController adminC = Get.put(AdminController());
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
      body: WillPopScope(
        child: SafeArea(
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
                child: Visibility(
                  visible: roleId != '1' ? true : false,
                  child: ListContainer(
                    'assets/images/icon_transfer.png',
                    'Transfer',
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(AddEmployeeNew());
              //   },
              //   child: Visibility(
              //     visible: ((roleId == AppUtils.ADMIN || roleId == AppUtils.MANAGER) && jsonDecode(RemoteServices().box.get('appFeature'))[' ing']) ? true : false,
              //     child: ListContainer(
              //       'assets/images/employee.png',
              //       'Onboarding',
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  adminC.reload = true;
                  Get.to(OBPersonal());
                },
                child: Visibility(
                  visible: ((roleId != '1') &&
                          jsonDecode(RemoteServices().box.get('appFeature'))[
                              'onboarding'])
                      ? true
                      : false,
                  child: ListContainer(
                    'assets/images/employee.png',
                    'Onboarding',
                  ),
                ),
              ),
              dbC.newBroadcast == true
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          dbC.newBroadcast = false;
                        });
                        Get.to(ViewBroadcast());
                      },
                      child: Stack(children: [
                        ListContainer(
                          'assets/images/msgic.png',
                          'Broadcast Messages',
                        ),
                        Positioned(
                          top: 10.0,
                          left: 40.0,
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.to(ViewBroadcast());
                      },
                      child: ListContainer(
                        'assets/images/msgic.png',
                        'Broadcast Messages',
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  Get.to(ViewExpense());
                },
                child: Visibility(
                  visible: jsonDecode(RemoteServices().box.get('appFeature'))[
                          'expenseManager']
                      ? true
                      : false,
                  child: ListContainer(
                    'assets/images/expense.png',
                    'Expense Management',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ViewRegularizeAtt());
                },
                child: ListContainer(
                  'assets/images/regAtt.png',
                  'Regularize Attendance',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ViewReport());
                },
                child: Visibility(
                  visible: ((roleId != '1') &&
                          jsonDecode(RemoteServices().box.get('appFeature'))[
                              'repoManagerAtt'])
                      ? true
                      : false,
                  child: ListContainer(
                    'assets/images/repo_manager.png',
                    'Reporting Employee Attendance',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ViewEmpRoster());
                },
                child: ListContainer(
                  'assets/images/Roster.png',
                  'Employee Roster',
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
                  Get.to(GrievanceReport());
                },
                child: ListContainer(
                  'assets/images/shortage_report.png',
                  'Grievance Reports',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(PolicyDocs());
                },
                child: ListContainer(
                  'assets/images/employee_report.png',
                  'Policy Documents',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ChangePassword());
                },
                child: ListContainer(
                  'assets/images/changepassword.png',
                  'Change Password',
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
                        var fbRes =
                            await RemoteServices().sendFeedback(feedback.text);
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
                  Get.to(Support());
                },
                child: ListContainer(
                  'assets/images/supportic.png',
                  'Support',
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
                  'Share This App',
                ),
              ),
            ],
          ),
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
