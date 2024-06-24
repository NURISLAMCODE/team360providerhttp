import 'package:team360/src/views/widgets/profile_avatar.dart';
import 'package:team360/src/views/widgets/textfield_factory.dart';
import 'package:flutter/material.dart';

import 'button_factory.dart';

class WidgetFactory {

  static Widget buildButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
  }) {
    return PlatformButton(Theme.of(context).platform).build(
      context: context,
      onPressed: onPressed,
      text: text,
      backgroundColor: backgroundColor,

      textColor: textColor,
      borderColor: borderColor
    );
  }

  static Widget buildTextField({
    required BuildContext context,
    TextEditingController? controller,
    TextInputType? textInputType,
    TextInputAction? textInputAction,
    bool? enabled,
    onChanged,
    validator,
    bool? obscureText,
    required String label,
    required String hint,
    Color? hintColor,
    Color? borderColor,
    Widget? suffixIcon,
    FocusNode? focusNode,
    int? maxline

  }) {
    return PlatformTextField(Theme.of(context).platform).build(
      context: context,
      controller: controller,
      textInputType: textInputType,
      textInputAction: textInputAction,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      label: label,
      hint: hint,
      hintColor: hintColor,
      borderColor: borderColor,
      suffixIcon: suffixIcon,
      focusNode: focusNode,
      maxline: maxline,
    );
  }

  static Widget buildProfileAvatar({
    required BuildContext context,
    String? url,
    required double radius,
    ImageType? imageType
  }) {
    return ProfileAvatarWidget(
      url: url,
      radius: radius,
      imageType: imageType
    ).build(context);
  }
}
