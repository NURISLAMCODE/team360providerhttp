import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/auth_provider.dart';
import 'package:team360/src/views/ui/home_screen.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../utils/colors.dart';
import '../../utils/custom_text_style.dart';
import '../../widgets/widget_factory.dart';
import '../bottomnav/bottomnav_screen_layout.dart';
import 'login.dart';

class NewPasswordSetScreen extends StatefulWidget {
  const NewPasswordSetScreen({super.key});

  @override
  State<NewPasswordSetScreen> createState() => _NewPasswordSetScreenState();
}

class _NewPasswordSetScreenState extends State<NewPasswordSetScreen> {
  FocusNode usernameETFocusNode = FocusNode();
  FocusNode passwordETFocusNode = FocusNode();
  var newPassController = TextEditingController();
  var conPasswordController = TextEditingController();
bool isSecurePassword = true;
bool isSecurePassword1 = true;
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
                        "Set Your Personal Password",
                        style: ksTitelTextStyle,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
                      child: WidgetFactory.buildTextField(
                          controller: newPassController,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          context: context,
                          suffixIcon: toggolePassword(),
                          obscureText: isSecurePassword,
                          label: "New Password",
                          maxline: 1,
                          hint: "new password",
                          focusNode: usernameETFocusNode),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: WidgetFactory.buildTextField(
                          controller: conPasswordController,
                          context: context,
                          suffixIcon: toggolePassword1(),
                          obscureText: isSecurePassword1,
                          label: "Confirm Password",
                          hint: "confirm password",
                          maxline: 1,
                          focusNode: passwordETFocusNode),
                    ),

                    SizedBox(height: 5.h),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.inProgress ?  Container(
                        height: MediaQuery.of(context).size.height/1,
                        width: MediaQuery.of(context).size.width /1,
                        child: const Center(
                        child: CircularProgressIndicator(),
                        ),
                        ):
                         SizedBox(
                          height: 6.h,
                          width: 90.w,
                          child: WidgetFactory.buildButton(
                            context: context,
                            onPressed: () async {
                              if(newPassController.text.isEmpty){
                                customWidget.showCustomSnackbar(context, "Enter New Password");
                              }else if(conPasswordController.text.isEmpty){
                                customWidget.showCustomSnackbar(context, "Enter Your Confirm Password");
                              }else if(newPassController.text != conPasswordController.text){
                                customWidget.showCustomSnackbar(context, "No Match Your Password");
                              }
                              else{
                                Map<String, dynamic>  data = {
                                  "new_password":newPassController.text,
                                  "confirm_password": conPasswordController.text
                                };
                                authProvider.setPassword(
                                    data: data,
                                    onSuccess: (e){
                                      customWidget.showCustomSuccessSnackbar(context, "${e}");
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (Route<dynamic> route) => false);

                                    },
                                    onFail: (e){
                                      customWidget.showCustomSnackbar(context, "${e}");

                                    }
                                );
                              }
                            },
                            text: "Submit",
                            backgroundColor: kBlueColor,
                            borderColor: Colors.transparent,
                          ),
                        );
                      }
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
  Widget toggolePassword1() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecurePassword1 = !isSecurePassword1;
        });
      },
      icon: isSecurePassword1
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }
}

