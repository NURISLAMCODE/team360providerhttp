import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/user_provider.dart';
import 'package:team360/src/views/ui/home_screen.dart';

import '../utils/colors.dart';
import '../widgets/custom_widget.dart';
import '../widgets/scaffold_message.dart';
import '../widgets/widget_factory.dart';
import 'drawer.dart';
import 'employee_list.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  bool isLoading = false;
  FocusNode currentPassFocusNode = FocusNode();
  FocusNode newPassFocusNode = FocusNode();
  FocusNode conPassFocusNode = FocusNode();
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  bool isSecureCurPassword = true;
  bool isSecureNewPassword = true;
  bool isSecureConPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      drawer: const DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: IconButton(
              icon: Image.asset('assets/images/notification.png'),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: IconButton(
              icon: Image.asset('assets/images/appbar_contact.png'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmployeeList()));
              },
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset("assets/images/appbar_menu.png"),
            ),
          ),
        ),
      ),
      body: isLoading == true
          ? Container(
              height: MediaQuery.of(context).size.height / 1,
              width: MediaQuery.of(context).size.width / 1,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Consumer<UserProfileProvider>(
              builder: (context, userProfileProvider, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 5.h,
                          width: 80.w,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
                                },
                                child: Container(
                                  height: 4.5.h,
                                  width: 9.w,
                                  decoration: const BoxDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                        "assets/images/arrow_left.png"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Password Change",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ],
                          color: kWhiteColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: CustomScrollView(slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                width: 90.w,
                                child: WidgetFactory.buildTextField(
                                  focusNode: currentPassFocusNode,
                                  controller: currentPassController,
                                  obscureText: isSecureCurPassword,
                                  suffixIcon: toggoleCurPassword(),
                                  context: context,
                                  label: "Current Password",
                                  maxline: 1,
                                  hint: "Enter your Current Password",
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                              child: SizedBox(
                            height: 2.h,
                          )),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                width: 90.w,
                                child: WidgetFactory.buildTextField(
                                  focusNode: newPassFocusNode,
                                  controller: newPassController,
                                  obscureText: isSecureNewPassword,
                                  suffixIcon: toggoleNewPassword(),
                                  context: context,
                                  maxline: 1,
                                  label: "New Password",
                                  hint: "Enter your New Password",
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                              child: SizedBox(
                            height: 2.h,
                          )),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                width: 90.w,
                                child: WidgetFactory.buildTextField(
                                  focusNode: conPassFocusNode,
                                  controller: conPassController,
                                  obscureText: isSecureConPassword,
                                  suffixIcon: toggoleConPassword(),
                                  context: context,
                                  maxline: 1,
                                  label: "Confirm Password",
                                  hint: "Enter your Confirm Password",
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                              child: SizedBox(
                            height: 3.h,
                          )),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 6.h,
                              width: 90.w,
                              child: WidgetFactory.buildButton(
                                context: context,
                                onPressed: () {
                                  if (currentPassController.text.isEmpty) {
                                    customWidget.showCustomSnackbar(context,
                                        "Please Fill The Current Password");
                                  } else if(newPassController.text.isEmpty) {
                                    customWidget.showCustomSnackbar(context,
                                        "Please Fill The New Password");
                                  } else if (conPassController.text.isEmpty) {
                                    customWidget.showCustomSnackbar(context,
                                        "Please Fill The Confirm Password");
                                  }else if(newPassController.text != conPassController.text){
                                    customWidget.showCustomSnackbar(context, "Not Match New And Confirm Password");
                                  }
                                  else {
                                    isLoading = true;
                                    Map<String, dynamic> data = {
                                      "current_password":
                                          currentPassController.text,
                                      "new_password": newPassController.text,
                                      "confirm_password": conPassController.text
                                    };
                                    userProfileProvider.passwordChange(
                                        data: data,
                                        onSuccess: (e) {
                                          currentPassController.clear();
                                          newPassController.clear();
                                          conPassController.clear();

                                          customWidget.showCustomSuccessSnackbar(context, "${e}");
                                          print(e);
                                          isLoading = false;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen()));
                                        },
                                        onFail: (e) {
                                          customWidget.showCustomSnackbar(context, "${e}");
                                          print(e);
                                          // isLoading =false;
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //         const PasswordChangeScreen()));
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //         const PasswordChangeScreen()));
                                        });
                                  }
                                },
                                text: "Update",
                                backgroundColor: kBlueColor,
                                borderColor: Colors.transparent,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  )
                ],
              );
            }),
    );
  }

  Widget toggoleCurPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecureCurPassword = !isSecureCurPassword;
        });
      },
      icon: isSecureCurPassword
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }

  Widget toggoleNewPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecureNewPassword = !isSecureNewPassword;
        });
      },
      icon: isSecureNewPassword
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }

  Widget toggoleConPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecureConPassword = !isSecureConPassword;
        });
      },
      icon: isSecureConPassword
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }
}
