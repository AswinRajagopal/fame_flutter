import 'pin_my_visit.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../widgets/routeplan_widget.dart';

import '../utils/utils.dart';
import 'route_planning.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/emprplan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_page.dart';

class RouteplanList extends StatefulWidget {
  @override
  _RouteplanListState createState() => _RouteplanListState();
}

class _RouteplanListState extends State<RouteplanList> {
  final EmprplanController epC = Get.put(EmprplanController());

  @override
  void initState() {
    epC.pr = ProgressDialog(
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
    epC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      epC.getEmprPlan,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> backButtonPressed() {
    return Get.offAll(DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text('Route Plan List'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Get.offAll(DashboardPage());
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          size: 22,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        visible: true,
        curve: Curves.easeInOut,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.add,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Get.offAll(
                RoutePlanning(
                  goBackTo: 'list',
                ),
              );
            },
            label: 'New Route Plan',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.0,
            ),
            labelBackgroundColor: Theme.of(context).primaryColor,
          ),
          SpeedDialChild(
            child: Icon(
              Icons.pin_drop,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Get.to(PinMyVisit());
            },
            label: 'Pin My Visit',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.0,
            ),
            labelBackgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: backButtonPressed,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Obx(() {
              if (epC.isEmpLoading.value) {
                return Column();
              } else {
                if (epC.empRes.routePlanList.isEmpty || epC.empRes.routePlanList == null) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No route plan found',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: epC.empRes.routePlanList.length,
                  itemBuilder: (context, index) {
                    var route = epC.empRes.routePlanList[index];
                    // print(route);
                    return RouteplanWidget(
                      route,
                      index,
                      epC.empRes.routePlanList.length,
                    );
                  },
                );
              }
            }),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
