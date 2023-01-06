import 'package:flutter/material.dart';

class CustomVerticalDivider extends StatelessWidget {
  final double thickness;
  final double height;
  final double width;
  final double indent;
  final double endIndent;
  final Color color;

  CustomVerticalDivider(
      {this.thickness,
      this.height,
      this.width,
      this.indent,
      this.endIndent,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: Container(
          height: height,
          // width: thickness,
          margin: EdgeInsetsDirectional.only(top: indent, bottom: endIndent),
          decoration: BoxDecoration(
            border: Border(
              left: Divider.createBorderSide(context,
                  color: color, width: thickness),
            ),
          ),
        ),
      ),
    );
  }
}
