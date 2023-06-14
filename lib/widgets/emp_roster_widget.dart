import 'package:fame/utils/utils.dart';
import 'package:fame/views/modify_emp_roster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmpRosterWidget extends StatelessWidget {
  final roster;
  var empName;
  var empId;
  EmpRosterWidget(
    this.roster,this.empId,this.empName
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
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 31,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return singleWidget('5', roster, index,empName,empId);
            }),
      ),
    );
  }
}

Widget singleWidget(dateList, roster, index,empName,empID) {
  String day = 'day' + index;
  return GestureDetector(
    onTap: () {
      Get.to(RosterPage(
          dateList,
          roster['empId'],
          roster[day] != null && roster[day] != ""  ? roster[day].split(' ')[0] : '',
          roster['clientId'],
          roster[day] != null && roster[day] != ""  ? roster[day].split(" ")[2] : '',
          roster['name'],empName,empID));
    },
    child: titleParams('Name', 'ClientId',
        '1', roster[day] ?? 'NA', roster[day]),
  );
}

Widget titleParams(name, id, date, shift, empId) {
  return Container(
    // width: 440,
    // height: 150,
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
    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 8),
    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 8),
    child:
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 2,
            child:
            Column(
              children: [
                Container(
                  // alignment: Alignment.centerLeft,
                  child:
                  Text(
                    "${date}",
                    style:
                   TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color:  Color(0xff555555), fontFamily: 'PoppinsRegular')              ),
                ),
              ],
            )),
        SizedBox(width: 10,),
        Container(width: 1,height: 70, color:  Color(0xff555555).withOpacity(0.3),),
        SizedBox(width: 10,),
        Expanded(
            flex: 7,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      shift.contains('\$')
                          ?  Expanded(
                        flex: 1,
                        child: Container(
                          // alignment: Alignment.centerLeft,
                          child:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                    "Store: ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Colors.red.withOpacity(0.8), fontFamily: 'PoppinsRegular')
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    '${shift.split(' \$- ').last != null ? shift.split(' \$- ').last.toString() : 'N/A'}',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Colors.red, fontFamily: 'PoppinsRegular')
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                          : Column(),

                      shift.contains('\$')
                          ? Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                    "StoreCode: ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Colors.green.withOpacity(0.8), fontFamily: 'PoppinsRegular')
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    '${shift.split(' ')[2].toString()}',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Colors.green, fontFamily: 'PoppinsRegular')
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Column(),

                    ])),


                shift.contains('\$')? SizedBox(height: 30,):SizedBox() ,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            // alignment: Alignment.centerLeft,
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                      "Client:",
                                      style:
                                      TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Color(
                                          0xc7555555), fontFamily: 'PoppinsRegular')
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                      " ${name??"N.A."}",
                                      style:
                                      TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  Color(0xff555555), fontFamily: 'PoppinsRegular')
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        shift.contains('\$')
                            ?  Expanded(
                          flex: 1,
                          child:  Container(
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppUtils().blueColor.withOpacity(0.2),
                              // border: Border.all(
                              //     width: 2.0,
                              //     color: AppUtils().blueColor), // Set border width
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: FittedBox(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Shift:${shift.contains('\$') ? shift.substring(0, shift.indexOf('\$')).trim() : shift}',
                                      style:       TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color:  AppUtils().blueColor, fontFamily: 'PoppinsRegular')
                                  )
                              ),
                            ),
                          ),
                        )
                            : Column(),

                      ]),
                ),

              ],
            )
        ),
      ],
    ),

    // Column(
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Flexible(
    //           flex: 2,
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(children: [
    //                   Text(
    //                     date,
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.w600,
    //                         fontSize: 18,
    //                         color: Colors.black.withOpacity(0.6),
    //                         fontFamily: 'PoppinsRegular'), )   //                   )
    //                 ]),
    //               ),
    //
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(children: [
    //                   Text(
    //                     name,
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.w500,
    //                         fontSize: 18,
    //                         color: Colors.black.withOpacity(0.6),
    //                         fontFamily: 'PoppinsRegular'),)    //                   )
    //                 ]),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(15.0),
    //           child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Flexible(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       name,
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.w800,
    //                         fontSize: 15.0,
    //                         color: Colors.grey,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Flexible(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       id,
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.w500,
    //                         fontSize: 15.0,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 shift.contains('\$')
    //                     ? Flexible(
    //                         child: Container(
    //                           width: 100,
    //                           alignment: Alignment.center,
    //                           decoration: BoxDecoration(
    //                             color: Colors.red,
    //                             border: Border.all(
    //                                 width: 2.0,
    //                                 color: Colors.red), // Set border width
    //                             borderRadius:
    //                                 BorderRadius.all(Radius.circular(5.0)),
    //                           ),
    //                           child: FittedBox(
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Text(
    //                                   '${shift.split(' ').last != null ? shift.split(' ').last.toString() : 'N/A'}',
    //                                   style: TextStyle(
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 16,
    //                                       color: Colors.white,
    //                                       fontFamily: 'PoppinsRegular'))
    //                             ),
    //                           ),
    //                         ),
    //                       )
    //                     : Column(),
    //               ]),
    //         ),
    //         Container(
    //           width: 2.0,
    //           height: 50.0,
    //           color: AppUtils().blueColor,
    //         ),
    //         Flexible(
    //           flex: 3,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //
    //               shift.contains('\$')
    //                   ? Flexible(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(15.0),
    //                   child: Container(
    //                     alignment: Alignment.center,
    //                     decoration: BoxDecoration(
    //                       color: Colors.green,
    //                       border: Border.all(
    //                           width: 2.0,
    //                           color: Colors.green), // Set border width
    //                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //                     ),
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(5.0),
    //                       child: Text(
    //                         '${shift.split(' ')[2].toString()}',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 12,
    //                             color: Colors.white,
    //                             fontFamily: 'PoppinsRegular'),    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               )
    //               ): SizedBox(),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //             Flexible(
    //               child: Container(
    //                 width: 80,
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                   color: AppUtils().blueColor,
    //                   border: Border.all(
    //                       width: 2.0,
    //                       color: AppUtils().blueColor), // Set border width
    //                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //                 ),
    //                 child: FittedBox(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                         'Shift:${shift.contains('\$') ? shift.substring(0, shift.indexOf('\$')).trim() : shift}',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w600,
    //                             fontSize: 16,
    //                             color: Colors.white,
    //                             fontFamily: 'PoppinsRegular'))
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 5.0,
    //             ),
    //             Flexible(
    //               child: Container(
    //                 width: 80,
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                   color: Colors.black,
    //                   border: Border.all(color: Colors.black), // Set border width
    //                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //                 ),
    //                 child: FittedBox(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(5.0),
    //                     child: Text('${empId != null ? empId.toString() : 'N/A'}',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w600,
    //                             fontSize: 16,
    //                             color: Colors.white,
    //                             fontFamily: 'PoppinsRegular'))
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ]),
    //         ),
    //         SizedBox(
    //           height: 10.0,
    //         )
    //       ],
    //     ),
    //   ],
    // ),
  );
}
