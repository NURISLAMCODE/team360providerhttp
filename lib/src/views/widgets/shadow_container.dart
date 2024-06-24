import 'package:team360/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {

  final double? width;
  final double? height;
  EdgeInsets? padding;
  final double radius;
  Color? color;
  Border? border;
  final Widget child;

  ShadowContainer({
    Key? key,
    this.width,
    this.height,
    this.padding,
    required this.radius,
    this.color,
    this.border,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? kWhiteColor,
        border: border,
        boxShadow: const [
          BoxShadow(blurStyle: BlurStyle.solid,
            color: kLightGreyColor,
            spreadRadius: .5,
            blurRadius: 10,
            offset: Offset(0, 0.3),
          )
        ],
        borderRadius: BorderRadius.circular(radius)
      ),
      child: child,
    );
  }
}
