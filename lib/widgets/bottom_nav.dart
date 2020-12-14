import '../views/leave_page.dart';

import '../views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNav extends StatelessWidget {
  final String page;
  BottomNav(this.page);

  @override
  Widget build(BuildContext context) {
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
        } else if (index == 4) {}
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      fixedColor: Colors.blue,
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
          icon: Icon(
            Icons.date_range,
            size: 30.0,
          ),
          label: 'Leave',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: 30.0,
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Visibility(
            visible: false,
            child: Icon(
              Icons.widgets_sharp,
              size: 30.0,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            size: 30.0,
          ),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.more_vert,
            size: 30.0,
          ),
          label: 'More',
        ),
      ],
    );
  }
}
