import 'package:share/share.dart';

import 'sos.dart';

import 'new_broadcast.dart';

import 'view_broadcast.dart';

import 'support.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var roleId = RemoteServices().box.get('role');
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
              onTap: () {},
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
                'assets/images/icon_rating.png',
                'Support',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(ViewBroadcast());
              },
              child: ListContainer(
                'assets/images/msgic.png',
                'View Broadcast',
              ),
            ),
            GestureDetector(
              onTap: () {},
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
                'assets/images/icon_attendance.png',
                'Share',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(Broadcast());
              },
              child: ListContainer(
                'assets/images/msgic.png',
                'Broadcast',
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
                    height: 60.0,
                    width: 60.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 250.0,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
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
            indent: 65.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }
}
