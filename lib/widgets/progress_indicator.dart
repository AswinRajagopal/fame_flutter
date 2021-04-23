import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomProgressIndicator extends StatelessWidget {
  final String centerText;
  final String footerText;
  final double radius;
  final double percent;
  final double footerTop;
  CustomProgressIndicator(
    this.centerText,
    this.footerText,
    this.radius,
    this.percent, {
    this.footerTop,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      center: Text(
        centerText,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      radius: radius,
      percent: percent,
      animation: true,
      animationDuration: 2000,
      curve: Curves.easeInOut,
      backgroundColor: Colors.grey[350],
      progressColor: Theme.of(context).primaryColor,
      circularStrokeCap: CircularStrokeCap.round,
      footer: Padding(
        padding: EdgeInsets.only(top: footerTop ?? 10.0),
        child: Text(
          footerText,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
