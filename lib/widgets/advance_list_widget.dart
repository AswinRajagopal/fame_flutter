import 'package:dotted_line/dotted_line.dart';
import 'package:fame/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvanceListWidget extends StatelessWidget {
  final advance;
  AdvanceListWidget(this.advance);



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Text(
                      advance['empExpAdvanceId'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      advance['empId'],
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ]),
                  SizedBox(
                    width: 80.0,
                  ),
                  Expanded(
                    child: Text(
                      advance['purpose'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: AppUtils().blueColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(width: 20.0),
                  Column(children: [
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              advance['amount'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
