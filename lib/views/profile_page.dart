import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    profileController.pr = ProgressDialog(
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    profileController.pr.style(
      backgroundColor: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
        actions: [
          FlatButton(
            onPressed: () {
              RemoteServices().logout();
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
                      if (profileController.isLoading.value) {
                        return Container(
                          height: 460.0,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          // height: 220.0,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Image.network(
                                'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png',
                                // fit: BoxFit.cover,
                                height: 100.0,
                                width: 100.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  profileController
                                      .profileResponse.empdetails.name,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  profileController
                                      .profileResponse.empdetails.empId,
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
                                profileController
                                    .profileResponse.empdetails.address,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_call.png',
                                profileController
                                    .profileResponse.empdetails.phone,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ProfileDetailRow(
                                'assets/images/icon_profile_mail.png',
                                profileController
                                    .profileResponse.empdetails.emailId,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Center(
                                child: Text(
                                  'Version 2.0.1',
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
                  text == '' ? 'N/A' : text,
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
