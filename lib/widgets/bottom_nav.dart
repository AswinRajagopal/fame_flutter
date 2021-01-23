import '../connection/remote_services.dart';

import '../views/settings_page.dart';

import '../views/more_page.dart';

import '../views/leave_page.dart';

import '../views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class BottomNav extends StatelessWidget {
  final String page;
  BottomNav(this.page);

  @override
  Widget build(BuildContext context) {
    var roleId = RemoteServices().box.get('role');
    // final currentIndex = 0;

    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          // Get.to(CalendarDemo());
          Get.offAll(LeavePage());
        } else if (index == 1) {
          Get.to(ProfilePage());
        } else if (index == 2) {
        } else if (index == 3) {
          if (roleId == '2' || roleId == '3') {
            Get.to(MorePage());
          } else {
            Get.snackbar(
              null,
              'Only FO and admin can access this',
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
        } else if (index == 4) {
          Get.to(SettingsPage());
        }
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      fixedColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(
        color: Colors.black,
      ),
      selectedLabelStyle: TextStyle(
        color: Colors.black,
      ),
      unselectedFontSize: 14.0,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              'assets/images/leave.png',
              height: 30.0,
            ),
          ),
          label: 'Leave',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              'assets/images/profile.png',
              height: 30.0,
            ),
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Visibility(
            visible: false,
            child: Image.asset(
              'assets/images/navicon-dashboard.png',
            ),
          ),
          label: '',
          backgroundColor: HexColor('386eff'),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              'assets/images/report.png',
              height: 30.0,
            ),
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              'assets/images/more.png',
              height: 30.0,
            ),
          ),
          label: 'More',
        ),
      ],
    );
  }
}
