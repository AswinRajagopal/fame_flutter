import '../views/employee_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EmpRepDetailWidget extends StatelessWidget {
  var emp;
  final String designation;
  EmpRepDetailWidget(this.emp, this.designation);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(emp['empId']);
        Get.to(EmployeeProfile(emp));
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${emp['name']}',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Client ID : ' + emp['empId'],
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                designation,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
