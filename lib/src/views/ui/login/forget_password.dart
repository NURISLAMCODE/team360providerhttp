import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/ui/login/forget_password_otp.dart';
import 'package:team360/src/views/ui/login/login.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

import '../../../business_logics/providers/auth_provider.dart';
import '../../widgets/scaffold_message.dart';
import 'login_otp.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController forgotEmailController = TextEditingController();

  FocusNode usernameETFocusNode = FocusNode();
  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
  @override
  Widget build(BuildContext context) {
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
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
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
                width: 80.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4F2),
                ),
                child: Image.asset("assets/images/login3.png"),
              ),
              Container(
                height: 55.h,
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
                        "Forgot password ?",
                        style: kLargeTitleTextStyle,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Enter your username to reset password",
                        style: ksTitelTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 50),
                      child: Container(
                        child: WidgetFactory.buildTextField(
                            textInputType: TextInputType.emailAddress,
                            context: context,
                            label: "Email",
                            hint: "user@example.com",
                            controller: forgotEmailController,
                            focusNode: usernameETFocusNode),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                        return authProvider.inProgress
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: kThemeColor))
                            : SizedBox(
                                width: 90.w,
                                height: 6.h,
                                child: WidgetFactory.buildButton(
                                  context: context,
                                  onPressed: () {
                                    // if (forgotEmailController.text.isEmpty) {
                                    //   customWidget.showCustomSnackbar(
                                    //       context, "Enter Your Email");
                                    // }else if(!isEmail(forgotEmailController.text)){
                                    //   customWidget.showCustomSnackbar(
                                    //       context, "Enter Your Valid Email");
                                    // }else {
                                    //   // AuthProvider authProvider =
                                    //   //     Provider.of<AuthProvider>(context,
                                    //   //         listen: false);
                                    //   Map<String, dynamic> data = {
                                    //     "user_email": forgotEmailController.text
                                    //   };
                                    //   authProvider.forgotPassword(
                                    //       data: data,
                                    //       onSuccess: (e) {
                                    //         forgotEmailController.clear();
                                    //         authProvider.forgotPassword(
                                    //             data: data,
                                    //             onSuccess: (e){
                                    //               Navigator.pushReplacement(
                                    //                 context,
                                    //                 MaterialPageRoute(
                                    //                   builder: (context) =>
                                    //                       ForgetPasswordOTPScreen(),
                                    //                 ),
                                    //               );
                                    //             },
                                    //             onFail: (e){
                                    //
                                    //             });
                                    //         // showScaffoldMessage(
                                    //         //     context, "${e}");
                                    //         Navigator.pushReplacement(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 ForgetPasswordOTPScreen(),
                                    //           ),
                                    //         );
                                    //       },
                                    //       onFail: (e) {
                                    //         showScaffoldMessage(
                                    //             context, "${e}");
                                    //       });
                                    // }
                                    if(forgotEmailController.text.isEmpty){
                                      customWidget.showCustomSnackbar(context, "Enter Your Email");
                                    }else if(!isEmail(forgotEmailController.text)){
                                      customWidget.showCustomSnackbar(context, "Enter Your Valid Email");
                                    }else{
                                      Map<String,dynamic> data = {
                                        "user_email":forgotEmailController.text
                                      };
                                      authProvider.forgotPassword(
                                          data: data,
                                          onSuccess: (e){
                                            forgotEmailController.clear();
                                            customWidget.showCustomSuccessSnackbar(context, "${e}");
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginScreen()), (Route<dynamic> route) => false);
                                          },
                                          onFail: (e){
                                            customWidget.showCustomSnackbar(context, "${e}");
                                          });
                                    }
                                  },

                                  text: "Reset Password",
                                  backgroundColor: kBlueColor,
                                  borderColor: Colors.transparent,
                                ),
                              );
                      }),
                    ),
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
