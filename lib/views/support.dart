import 'package:dotted_line/dotted_line.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/support_controller.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final SupportController sC = Get.put(SupportController());

  @override
  void initState() {
    sC.pr = ProgressDialog(
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
    sC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      sC.getSupport,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Support',
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 25.0,
              ),
              child: Obx(() {
                if (sC.isLoading.value) {
                  return Column();
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        // Mail
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/mail.png',
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      var url = 'mailto:${sC.res.support.email}';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text(
                                      sC.res.support.email,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 55.0),
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 340.0,
                                lineThickness: 1.5,
                                dashLength: 4.0,
                                dashColor: Colors.grey[500],
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        // Call
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/call.png',
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      var url = 'tel:${sC.res.support.phone}';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text(
                                      sC.res.support.phone,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 55.0),
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 340.0,
                                lineThickness: 1.5,
                                dashLength: 4.0,
                                dashColor: Colors.grey[500],
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        // Whatsapp
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/whatsapp.png',
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      var url = 'https://api.whatsapp.com/send?phone=${sC.res.support.whatsapp}&text=Hi';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text(
                                      sC.res.support.whatsapp,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 55.0),
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 340.0,
                                lineThickness: 1.5,
                                dashLength: 4.0,
                                dashColor: Colors.grey[500],
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        // Website
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/website.png',
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      var url = '${sC.res.support.url}';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text(
                                      sC.res.support.url,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 55.0),
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: 340.0,
                                lineThickness: 1.5,
                                dashLength: 4.0,
                                dashColor: Colors.grey[500],
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
