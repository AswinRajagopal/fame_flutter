import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import '../views/ob_address.dart';
import '../views/ob_bank.dart';
import '../views/ob_family.dart';
import '../views/ob_personal.dart';
import '../views/ob_photos.dart';
import '../views/ob_vaccine.dart';

class OBTopNavigation extends StatefulWidget {
  final String page;
  OBTopNavigation(this.page);

  @override
  _OBTopNavigationState createState() => _OBTopNavigationState();
}

class _OBTopNavigationState extends State<OBTopNavigation> {
  final AdminController adminC = Get.put(AdminController());
  ScrollController sController = ScrollController();
  var cellWidht = 165.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sController.animateTo(duration: null, curve: null);
  }

  @override
  Widget build(BuildContext context) {
    var scrollTo = 0.0;
    if (widget.page == 'bank') {
      scrollTo = cellWidht;
    } else if (widget.page == 'address') {
      scrollTo = cellWidht * 2;
    } else if (widget.page == 'family') {
      scrollTo = cellWidht * 3;
    } else if (widget.page == 'photos') {
      scrollTo = cellWidht * 4;
    }
    Future.delayed(Duration(milliseconds: 200), () {
      sController.animateTo(
        scrollTo,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
    return Container(
      height: 55.0,
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: sController,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.page != 'personal' && adminC.step1.value) {
                Get.to(OBPersonal());
              }
            },
            child: Container(
              height: 55.0,
              // width: MediaQuery.of(context).size.width / 3.0,
              width: cellWidht,
              decoration: BoxDecoration(
                color: widget.page == 'personal' ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Personal Info',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.page == 'personal' ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.page != 'vaccine' && adminC.step2.value) {
                Get.to(OBVaccine());
              }
            },
            child: Container(
              height: 55.0,
              // width: MediaQuery.of(context).size.width / 3.0,
              width: cellWidht,
              decoration: BoxDecoration(
                color: widget.page == 'vaccine' ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Vaccination',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.page == 'vaccine' ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.page != 'bank' && adminC.step3.value) {
                Get.to(OBBank());
              }
            },
            child: Container(
              height: 55.0,
              // width: MediaQuery.of(context).size.width / 3.0,
              width: cellWidht,
              decoration: BoxDecoration(
                color: widget.page == 'bank' ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Bank & Uniform',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.page == 'bank' ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.page != 'address' && adminC.step4.value) {
                Get.to(OBAddress());
              }
            },
            child: Container(
              height: 55.0,
              // width: MediaQuery.of(context).size.width / 3.0,
              width: cellWidht,
              decoration: BoxDecoration(
                color: widget.page == 'address' ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.page == 'address' ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.page != 'family' && adminC.step5.value) {
                Get.to(OBFamily());
              }
            },
            child: Container(
              height: 55.0,
              // width: MediaQuery.of(context).size.width / 3.0,
              width: cellWidht,
              decoration: BoxDecoration(
                color: widget.page == 'family' ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Family Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.page == 'family' ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.page != 'photos' && adminC.step6.value) {
                Get.to(OBPhotos());
              }
            },
            child: Container(
              height: 55.0,
              // width: MediaQuery.of(context).size.width / 3.0,
              width: cellWidht,
              decoration: BoxDecoration(
                color: widget.page == 'photos' ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.page == 'photos' ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
