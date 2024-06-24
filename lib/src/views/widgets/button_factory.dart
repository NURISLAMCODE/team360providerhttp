import 'package:flutter/material.dart';
import 'package:team360/src/views/utils/colors.dart';

abstract class PlatformButton {
  factory PlatformButton(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return AndroidRaisedButton();
      case TargetPlatform.iOS:
        return IOSRaisedButton();
      default:
        return WebRaisedButton();
    }
  }

  Widget build({
    required BuildContext context,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    required VoidCallback onPressed
  });
}

class AndroidRaisedButton implements PlatformButton {
  @override
  Widget build({
    required BuildContext context,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? kThemeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: borderColor ?? kThemeColor)
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(text, style: TextStyle(color: textColor ?? kWhiteColor))
    );
  }
}

class IOSRaisedButton implements PlatformButton {
  @override
  Widget build({
    required BuildContext context,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? kThemeColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: borderColor ?? kThemeColor)
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(text, style: TextStyle(color: textColor ?? kWhiteColor))
    );
  }
}

class WebRaisedButton implements PlatformButton {
  @override
  Widget build({
    required BuildContext context,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? kThemeColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: borderColor ?? kThemeColor)
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(text, style: TextStyle(color: textColor ?? kWhiteColor))
    );
  }
}
