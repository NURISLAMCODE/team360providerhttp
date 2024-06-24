import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/auth_provider.dart';
import 'package:team360/src/views/ui/login/signup.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

class SignupOTPScreen extends StatefulWidget {
  const SignupOTPScreen({Key? key}) : super(key: key);

  @override
  State<SignupOTPScreen> createState() => _SignupOTPScreenState();
}

class _SignupOTPScreenState extends State<SignupOTPScreen> {
  String otp = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4F2),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      child: const Icon(
                        Icons.arrow_back,
                        color: kThemeColor,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SingUpScreen()),
                            (Route<dynamic> route) => false);
                      }),
                ),
              ),
              Container(
                height: 35.h,
                width: 70.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4F2),
                ),
                child: Image.asset("assets/images/login_2.png"),
              ),
              Container(
                // height: 55.h,
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
                        "OTP Verification",
                        style: kLargeTitleTextStyle,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Lorem Ipsum is simply dummy text of the",
                        style: ksTitelTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 2.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFBC343),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.zero,
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 89.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBC343).withOpacity(0.25),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Enter OTP",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w400,
                                  color: kThemeColor,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: OTPTextField(
                        width: size.width,
                        textFieldAlignment: MainAxisAlignment.start,
                        fieldStyle: FieldStyle.box,
                        fieldWidth: 12.4.w,
                        spaceBetween: 12,
                        length: 6,
                        onChanged: (value) {
                          otp = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        width: 40.w,
                        height: 6.h,
                        child: TextButton(
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: kThemeColor,
                              fontFamily: 'latoRagular',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {},
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(195, 203, 226, 0.31),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "You can request OTP after 01: 56",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFECA338),
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Consumer<AuthProvider>(
                        builder: (ctx, authProvider, child) =>
                            authProvider.inProgress
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: kThemeColor))
                                : SizedBox(
                                    width: 90.w,
                                    height: 6.h,
                                    child: WidgetFactory.buildButton(
                                      context: context,
                                      onPressed: () async {},
                                      text: "Verify",
                                      backgroundColor: kBlueColor,
                                      borderColor: Colors.transparent,
                                    ),
                                  ),
                      ),
                    ),
                    SizedBox(height: 7.5.h),
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
