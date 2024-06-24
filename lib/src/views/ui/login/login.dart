import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/providers/auth_provider.dart';
import 'package:team360/src/views/ui/login/forget_password.dart';
import 'package:team360/src/views/ui/login/login_otp.dart';
import 'package:team360/src/views/ui/login/signup.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

import '../bottomnav/bottomnav_screen_layout.dart';
import 'new_password_set_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode usernameETFocusNode = FocusNode();
  FocusNode passwordETFocusNode = FocusNode();
  var usernameETController = TextEditingController();
  var passwordETController = TextEditingController();
  bool isSecurePassword = true;

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
                width: 70.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4F2),
                ),
                child: Image.asset("assets/images/login_1.png"),
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
                        "SIGN IN",
                        style: kLargeTitleTextStyle,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Sign In now to begin an amazing journey",
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
                          label: "Username",
                          hint: "user@example.com",
                          focusNode: usernameETFocusNode),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: WidgetFactory.buildTextField(
                        controller: passwordETController,
                        context: context,
                        obscureText: isSecurePassword,
                        suffixIcon: toggolePassword(),
                        label: "Password",
                        hint: "Password",
                        focusNode: passwordETFocusNode,
                        maxline: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "",
                              style: TextStyle(
                                fontSize: 15.5.sp,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor,
                                fontFamily: 'latoRagular',
                              ),
                              children: [
                                TextSpan(
                                  text: "Request for a demo account? ",
                                  style: TextStyle(
                                    fontSize: 16.5.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kBlueColor,
                                    fontFamily: 'latoRagular',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SingUpScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                fontSize: 16.5.sp,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor,
                                fontFamily: 'latoRagular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Consumer<AuthProvider>(
                        builder: (ctx, authProvider, child) {
                          return authProvider.inProgress
                              ? const Center(
                              child: CircularProgressIndicator(
                                  color: kThemeColor))
                              : SizedBox(
                            height: 6.h,
                            width: 90.w,
                            child: WidgetFactory.buildButton(
                              context: context,
                             // onPressed: () {
                             //    Navigator.push(context, MaterialPageRoute(builder: (c)=> NewPasswordSetScreen()));
                             //
                             // },
                              onPressed: () async {
                                String username = usernameETController.text.toString();
                                String password = passwordETController.text.toString();
                                AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                                bool response = await authProvider.login(username: username, password: password);
                                if (response) {
                                  int? time = authProvider.loginResponse?.data?.time;
                                  if (!mounted){
                                    return;
                                  } else if(authProvider.loginResponse?.data?.requireSendOtp == true && authProvider.loginResponse?.data?.requireChangePassword == true){
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginOTPScreen(email: username,time: time as int),
                                        ),
                                            (Route<dynamic> route) => false);
                                } else if(authProvider.loginResponse?.data?.requireSendOtp == true && authProvider.loginResponse?.data?.requireChangePassword == false){
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginOTPScreen(email: username,time: time as int),
                                        ),
                                            (Route<dynamic> route) => false);
                                  } else if(authProvider.loginResponse?.data?.requireChangePassword == true && authProvider.loginResponse?.data?.requireSendOtp == false){
                                    UserData.accessToken = authProvider.loginResponse?.data?.token;
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const NewPasswordSetScreen()), (
                                        Route<dynamic> route) => false);
                                  }else{
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavScreenLayout()), (Route<dynamic> route) => false);
                                  }
                                }
                                else {
                                  if (!mounted) return;
                                  customWidget.showCustomSnackbar(context, authProvider.errorResponse?.message);
                                }
                              },

                              text: "Sign In",
                              backgroundColor: kBlueColor,
                              borderColor: Colors.transparent,
                            ),
                          );
                        }),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggolePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecurePassword = !isSecurePassword;
        });
      },
      icon: isSecurePassword
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }
}
