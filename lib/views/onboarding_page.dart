import 'add_employee_new.dart';

import 'add_employee.dart';

import 'add_shift.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_client.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Onboarding',
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
                Get.to(AddClient());
              },
              child: ListContainer(
                'assets/images/client.png',
                'Add Client',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(AddShift());
              },
              child: ListContainer(
                'assets/images/shift.png',
                'Add Shift',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(AddEmployee());
              },
              child: ListContainer(
                'assets/images/employee.png',
                'Add Employee',
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(AddEmployeeNew());
              },
              child: ListContainer(
                'assets/images/employee.png',
                'Onboard Employee',
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
  final double height;
  final double width;
  ListContainer(this.image, this.title, {this.height, this.width});

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
                    height: height ?? 40.0,
                    width: width ?? 40.0,
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
