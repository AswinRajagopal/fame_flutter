import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final double containerHeight;
  final double loaderSize;
  final Color loaderColor;
  final Color containerColor;
  LoadingWidget(
      {this.containerColor,
      this.containerHeight,
      this.loaderSize,
      this.loaderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor ?? Colors.white,
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitPulse(
            color: loaderColor,
            size: loaderSize,
          ),
        ],
      ),
    );
  }
}
