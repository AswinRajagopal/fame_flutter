import 'package:fame/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:fame/views/modify_emp_roster.dart';

class EmpRosterWidget extends StatelessWidget {
  final roster;
  final combined;
  var dateList;

  EmpRosterWidget(
    this.roster,
    this.combined,
    this.dateList,
  );

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString();
  }

  String convertDateTime(date) {
    return DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toUpperCase();
  }

  String widgetDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat('MM').format(DateTime.parse(date)).toString() +
        '-' +
        DateFormat.y().format(DateTime.parse(date)).toString() +
        ' @ ' +
        DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
        '' +
        DateFormat('a').format(DateTime.parse(date)).toString().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppUtils().greyScaffoldBg,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 4.5,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(
                            dateList[0].toString(),
                            roster['empId'],
                            roster['day1'] != null
                                ? roster['day1'].split(' ')[0]
                                : '',
                            roster['clientId'],
                          roster['day1']!=null?
                          roster['day1'].split(" ")[2]:'',roster['name']
                        ));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[0].toString(),
                          roster['day1'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(
                            dateList[1].toString(),
                            roster['empId'],
                            roster['day2'] != null
                                ? roster['day2'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day2']!=null?
                        roster['day2'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[1].toString(),
                          roster['day2'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[2].toString(),roster['empId'],
                            roster['day3'] != null
                                ? roster['day3'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day3']!=null?
                            roster['day3'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[2].toString(),
                          roster['day3'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[3].toString(),roster['empId'],
                            roster['day4'] != null
                                ? roster['day4'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day4']!=null?
                            roster['day4'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[3].toString(),
                          roster['day4'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[4].toString(),roster['empId'],
                            roster['day5'] != null
                                ? roster['day5'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day5']!=null?
                            roster['day5'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[4].toString(),
                          roster['day5'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[5].toString(),roster['empId'],
                            roster['day6'] != null
                                ? roster['day6'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day6']!=null?
                            roster['day6'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[5].toString(),
                          roster['day6'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[6].toString(),roster['empId'],
                            roster['day7'] != null
                                ? roster['day7'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day7']!=null?
                            roster['day7'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[6].toString(),
                          roster['day7'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[7].toString(),roster['empId'],
                            roster['day8'] != null
                                ? roster['day8'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day8']!=null?
                            roster['day8'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[7].toString(),
                          roster['day8'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[8].toString(),roster['empId'],
                            roster['day9'] != null
                                ? roster['day9'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day9']!=null?
                            roster['day9'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[8].toString(),
                          roster['day9'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[9].toString(),roster['empId'],
                            roster['day10'] != null
                                ? roster['day10'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day10']!=null?
                            roster['day10'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[9].toString(),
                          roster['day10'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[10].toString(),roster['empId'],
                            roster['day11'] != null
                                ? roster['day11'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day11']!=null?
                            roster['day11'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[10].toString(),
                          roster['day11'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[11].toString(),roster['empId'],
                            roster['day12'] != null
                                ? roster['day12'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day12']!=null?
                            roster['day12'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[11].toString(),
                          roster['day12'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[12].toString(),roster['empId'],
                            roster['day13'] != null
                                ? roster['day13'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day13']!=null?
                            roster['day13'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[12].toString(),
                          roster['day13'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[13].toString(),roster['empId'],
                            roster['day14'] != null
                                ? roster['day14'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day14']!=null?
                            roster['day14'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[13].toString(),
                          roster['day14'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[14].toString(),roster['empId'],
                            roster['day15'] != null
                                ? roster['day15'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day15']!=null?
                            roster['day15'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[14].toString(),
                          roster['day15'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[15].toString(),roster['empId'],
                            roster['day16'] != null
                                ? roster['day16'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day16']!=null?
                            roster['day16'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[15].toString(),
                          roster['day16'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[16].toString(),roster['empId'],
                            roster['day17'] != null
                                ? roster['day17'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day17']!=null?
                            roster['day17'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[16].toString(),
                          roster['day17'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[17].toString(),roster['empId'],
                            roster['day18'] != null
                                ? roster['day18'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day18']!=null?
                            roster['day18'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[17].toString(),
                          roster['day18'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[18].toString(),roster['empId'],
                            roster['day19'] != null
                                ? roster['day19'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day19']!=null?
                            roster['day19'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[18].toString(),
                          roster['day19'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[19].toString(),roster['empId'],
                            roster['day20'] != null
                                ? roster['day20'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day20']!=null?
                            roster['day20'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[19].toString(),
                          roster['day20'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[20].toString(),roster['empId'],
                            roster['day21'] != null
                                ? roster['day21'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day21']!=null?
                            roster['day21'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[20].toString(),
                          roster['day21'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[21].toString(),roster['empId'],
                            roster['day22'] != null
                                ? roster['day22'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day22']!=null?
                            roster['day22'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[21].toString(),
                          roster['day22'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[22].toString(),roster['empId'],
                            roster['day23'] != null
                                ? roster['day23'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day23']!=null?
                            roster['day23'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[22].toString(),
                          roster['day23'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[23].toString(),roster['empId'],
                            roster['day24'] != null
                                ? roster['day24'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day24']!=null?
                            roster['day24'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[23].toString(),
                          roster['day24'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[24].toString(),roster['empId'],
                            roster['day25'] != null
                                ? roster['day25'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day25']!=null?
                            roster['day25'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[24].toString(),
                          roster['day25'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[25].toString(),roster['empId'],
                            roster['day26'] != null
                                ? roster['day26'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day26']!=null?
                            roster['day26'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[25].toString(),
                          roster['day26'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[26].toString(),roster['empId'],
                            roster['day27'] != null
                                ? roster['day27'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day27']!=null?
                            roster['day27'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[26].toString(),
                          roster['day27'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[27].toString(),roster['empId'],
                            roster['day28'] != null
                                ? roster['day28'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day28']!=null?
                            roster['day28'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[27].toString(),
                          roster['da28'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[28].toString(),roster['empId'],
                            roster['day29'] != null
                                ? roster['day29'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day29']!=null?
                            roster['day29'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[28].toString(),
                          roster['day29'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RosterPage(dateList[29].toString(),roster['empId'],
                            roster['day30'] != null
                                ? roster['day30'].split(' ')[0]
                                : '',
                            roster['clientId'],roster['day30']!=null?
                            roster['day30'].split(" ")[2]:'',roster['name']));
                      },
                      child: titleParams(
                          roster['name'],
                          roster['clientId'],
                          dateList[29].toString(),
                          roster['day30'] ?? 'NA',
                          combined,
                          roster['empId']),
                    ),
                    dateList[30] != dateList[0]
                        ? GestureDetector(
                            onTap: () {
                              Get.to(RosterPage(dateList[30].toString(),roster['empId'],
                                  roster['day31'] != null
                                      ? roster['day31'].split(' ')[0]
                                      : '',
                                  roster['clientId'],roster['day31']!=null?
                                  roster['day31'].split(" ")[2]:'',roster['name']));
                            },
                            child: titleParams(
                                roster['name'],
                                roster['clientId'],
                                dateList[30].toString(),
                                roster['day31'] ?? 'NA',
                                combined,
                                roster['empId']),
                          )
                        : Column(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

Widget titleParams(name, id, date, shift, combined, empId) {
  return Container(
    width: 440,
    height: 140,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Shadow color
          spreadRadius: 0.5, // Spread radius
          blurRadius: 2, // Blur radius
          offset: Offset(0, 1), // Offset in x and y directions
        ),
      ],
      color: Colors.white,
    ),
    margin: EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      id,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                shift.contains('\$')
                    ? Flexible(
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(
                                width: 2.0,
                                color: Colors.red), // Set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '${shift.split(' ').last != null ? shift.split(' ').last.toString() : 'N/A'}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'PoppinsRegular')),
                            ),
                          ),
                        ),
                      )
                    : Column(),
              ]),
        ),
        Container(
          width: 2.0,
          height: 50.0,
          color: AppUtils().blueColor,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Text(
                    date,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                        fontFamily: 'PoppinsRegular'),
                  )
                ]),
              ),
            ),
            shift.contains('\$')
                ? Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                              width: 2.0,
                              color: Colors.green), // Set border width
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            '${shift.split(' ')[2].toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'PoppinsRegular'),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              child: Container(
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppUtils().blueColor,
                  border: Border.all(
                      width: 2.0,
                      color: AppUtils().blueColor), // Set border width
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Shift:${shift.contains('\$') ? shift.substring(0, shift.indexOf('\$')).trim() : shift}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'PoppinsRegular')),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Flexible(
              child: Container(
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black), // Set border width
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${empId != null ? empId.toString() : 'N/A'}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'PoppinsRegular')),
                  ),
                ),
              ),
            )
          ]),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    ),
  );
}
