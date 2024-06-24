import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key,}) : super(key: key);
  // final String token;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  FocusNode usernameETFocusNode = FocusNode();
  FocusNode passwordETFocusNode = FocusNode();
  var usernameETController = TextEditingController();
  var passwordETController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4F2),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: mHeight/2.1,
                width: 80.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4F2),
                ),
                child: Image.asset("assets/images/login3.png"),
              ),
              Container(
                // height: mHeight/1.9,
                width: 100.w,
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text(
                        "Reset Password",
                        style: kLargeTitleTextStyle,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Enter your new password",
                        style: ksTitelTextStyle,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
                      child: WidgetFactory.buildTextField(
                          controller: usernameETController,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          context: context,
                          label: "New Password",
                          hint: "123456",
                          focusNode: usernameETFocusNode),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: WidgetFactory.buildTextField(
                          controller: passwordETController,
                          context: context,
                          label: "Confirm Password",
                          hint: "123456",
                          focusNode: passwordETFocusNode),
                    ),

                    SizedBox(height: 15.h),
                    SizedBox(
                            height: 6.h,
                            width: 90.w,
                            child: WidgetFactory.buildButton(
                              context: context,
                              onPressed: () async {},
                              text: "Sign In",
                              backgroundColor: kBlueColor,
                              borderColor: Colors.transparent,
                            ),
                          ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
