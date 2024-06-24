import 'package:flutter/material.dart';

import '../utils/colors.dart';

abstract class PlatformTextField {
  factory PlatformTextField(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return IOSTextField();
      default:
        return AndroidTextField();
    }
  }

  Widget build({
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
    int? maxline,
  });
}

class AndroidTextField implements PlatformTextField {

  @override
  Widget build({
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
    maxline
  }) {
    return TextFormField(
      maxLines: maxline,
      controller: controller,
      textInputAction: textInputAction ?? TextInputAction.done,
      keyboardType: textInputType,
      enabled: enabled ?? true,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFC4C4C4),fontFamily: 'latoRagular',),
        label: Text(label, style: (focusNode != null && focusNode.hasFocus) ? const TextStyle(color: kBlueColor,fontWeight: FontWeight.w600,fontFamily: 'latoRagular') : const TextStyle(color: kThemeColor,fontWeight: FontWeight.w600,fontFamily: 'latoRagular',)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF808080)),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF808080)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: const BorderSide(color: kBlueColor),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon
      ),
    );
  }
}

class IOSTextField implements PlatformTextField {
  @override
  Widget build({
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
    maxline
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction ?? TextInputAction.done,
      keyboardType: textInputType,
      enabled: enabled ?? true,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          hintText: hint,
          hintStyle: TextStyle(color: hintColor),
          label: Text(label, style: (focusNode != null && focusNode.hasFocus) ? const TextStyle(color: Colors.red) : const TextStyle(color: kThemeColor)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: kLightGreyColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kLightGreyColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: suffixIcon
      ),
    );
  }
}
