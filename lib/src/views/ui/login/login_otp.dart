import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/auth_provider.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';
import 'package:team360/src/views/ui/login/login.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

import 'new_password_set_screen.dart';

class LoginOTPScreen extends StatefulWidget {

  String email;
  int time;

  LoginOTPScreen({Key? key, required this.email,required this.time,}) : super(key: key);

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {

  String otp = "";
  late Timer _timer;


  @override
  void initState() {
    _startCountdown();
    super.initState();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.time > 0) {
          widget.time--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Color(0xFFEAF4F2),
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
                                builder: (context) => const LoginScreen()),
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
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   child: Text(
                    //     "Lorem Ipsum is simply dummy text of the",
                    //     style: ksTitelTextStyle,
                    //   ),
                    // ),
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
                              color:
                              const Color(0xFFFBC343).withOpacity(0.25),
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
                      padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
                      child: OTPTextField(
                        width: size.width,
                        textFieldAlignment: MainAxisAlignment.start,
                        fieldStyle: FieldStyle.box,
                        fieldWidth: 12.4.w,
                        spaceBetween: 12,
                        length: 6,
                        onChanged: (value) {
                          otp = value;
                          print(otp);
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
                      "You can request OTP after ${_formatTime(widget.time)}",
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
                                ? const Center(child: CircularProgressIndicator(color: kThemeColor))
                                : SizedBox(
                                    width: 90.w,
                                    height: 6.h,
                                    child: WidgetFactory.buildButton(
                                      context: context,
                                      onPressed: () async {
                                        AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                                        bool response = await authProvider.verifyOTP(email: widget.email, otp: otp);
                                        print(otp);
                                        print(response);
                                        if(response) {
                                          if (!mounted){
                                            return;
                                          }else if(authProvider.otpVerifyResponse?.data?.requireChangePassword == true){
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const NewPasswordSetScreen()), (
                                               Route<dynamic> route) => false);
                                          }else{
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => const BottomNavScreenLayout()),
                                                    (Route<dynamic> route) => false
                                            );
                                          }

                                        } else {
                                          if (!mounted) return;
                                          customWidget.showCustomSnackbar(context, authProvider.errorResponse?.message);
                                        }
                                      },
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