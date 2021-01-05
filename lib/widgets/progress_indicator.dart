import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomProgressIndicator extends StatelessWidget {
  final String centerText;
  final String footerText;
  final double radius;
  final double percent;
  CustomProgressIndicator(
    this.centerText,
    this.footerText,
    this.radius,
    this.percent,
  );

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
      progressColor: Colors.blue,
      circularStrokeCap: CircularStrokeCap.round,
      footer: Padding(
        padding: const EdgeInsets.only(top: 10.0),
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
