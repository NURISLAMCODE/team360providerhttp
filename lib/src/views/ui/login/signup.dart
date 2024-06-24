import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/auth_provider.dart';
import 'package:team360/src/views/ui/login/login.dart';
import 'package:team360/src/views/ui/login/signup_otp.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

import '../../widgets/custom_widget.dart';

class SingUpScreen extends StatefulWidget {

  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {

  FocusNode phoneETFocusNode = FocusNode();
  FocusNode companyNameETFocusNode = FocusNode();
  FocusNode sizeETFocusNode = FocusNode();
  FocusNode addressETFocusNode = FocusNode();
  FocusNode designationETFocusNode = FocusNode();
  FocusNode namesETFocusNode = FocusNode();
  FocusNode emailETFocusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController addressController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4F2),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [

                      Align(
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
                      Container(
                        // height: 15.h,
                        width: 45.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF4F2),
                        ),
                        child: Image.asset("assets/images/login_1.png"),
                      ),


                Container(
                  // height: 90.h,
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
                          "SIGN UP",
                          style: kLargeTitleTextStyle,
                        ),
                      ),
                       const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Sign Up now to begin an amazing journey",
                          style: ksTitelTextStyle,
                        ),
                      ),
                      //Name
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: WidgetFactory.buildTextField(
                            textInputAction: TextInputAction.next,
                            context: context,
                            label: "Name",
                            maxline: 1,
                            controller: nameController,
                            hint: "Enter Your Name",
                            focusNode: namesETFocusNode),
                      ),
                      //Email
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: WidgetFactory.buildTextField(
                          textInputType: TextInputType.emailAddress,
                          context: context,
                          label: "Email",
                          maxline: 1,
                          controller: emailController,
                          hint: "email@example.com",
                          focusNode: emailETFocusNode,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      //Phone
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: WidgetFactory.buildTextField(
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            context: context,
                            label: "Phone",
                            maxline: 1,
                            controller: phoneController,
                            hint: "Enter your contact number",
                            focusNode: phoneETFocusNode
                        ),
                      ),
                      //Designation
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: WidgetFactory.buildTextField(
                          context: context,
                          label: "Designation",
                          maxline: 1,
                          controller: designationController,
                          hint: "Enter your designation",
                          focusNode: designationETFocusNode,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      //Company Name $ Size
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20, top: 10,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60.w,
                              child: WidgetFactory.buildTextField(
                                textInputAction: TextInputAction.next,
                                context: context,
                                maxline: 1,
                                label: "Company Name",
                                controller: companyNameController,
                                hint: "Enter your company name",
                                focusNode: companyNameETFocusNode,
                              ),
                            ),

                            SizedBox(
                              height: 6.h,
                              width: 25.w,
                              child: WidgetFactory.buildTextField(
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.number,
                                context: context,
                                label: "Size",
                                maxline: 1,
                                controller: sizeController,
                                hint: "company size",
                                focusNode: sizeETFocusNode,
                              ),
                              // DropdownButtonFormField<String>(
                              //   isExpanded: true,
                              //   hint: const Text(
                              //     "10-20",
                              //     style: TextStyle(
                              //       fontFamily: 'latoRagular',
                              //       fontSize: 13,
                              //       color: Color(0xFFC4C4C4),
                              //       fontWeight: FontWeight.w400,
                              //     ),
                              //   ),
                              //   // value: dropdownValue,
                              //   decoration: InputDecoration(
                              //     filled: true,
                              //     fillColor: Colors.transparent,
                              //     contentPadding: const EdgeInsets.all(10.0),
                              //     label: const Text(
                              //       "Size",
                              //       style: TextStyle(
                              //         fontFamily: 'latoRagular',
                              //         fontWeight: FontWeight.w600,
                              //         color: Color(0xFF102048),
                              //       ),
                              //     ),
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(8),
                              //       borderSide: const BorderSide(
                              //         color: Color(0xFF808080),
                              //       ),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: const BorderSide(color: Color(0xFF808080)),
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //   ),
                              //   onChanged: (String? newValue) {
                              //     // setState(() {
                              //     //   dropdownValue = newValue!;
                              //     // });
                              //   },
                              //   items: <String>[
                              //     "10-50",
                              //     "50-100",
                              //     "100-1000+",
                              //   ].map<DropdownMenuItem<String>>((String value) {
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(value,
                              //         style: const TextStyle(
                              //           fontFamily: 'latoRagular',
                              //           color: kThemeColor,
                              //
                              //         ),),
                              //     );
                              //   }).toList(),
                              // ),
                            ),
                          ],
                        ),
                      ),
                      //Address
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: WidgetFactory.buildTextField(
                            context: context,
                            textInputAction: TextInputAction.next,
                            label: "Address",
                            maxline: 1,
                            controller: addressController,
                            hint: "Enter Company Address",
                            focusNode: addressETFocusNode

                        ),
                      ),
                      //Already have accout Sing Up
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Already have account? ",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor,
                                fontFamily: 'latoRagular',
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign in",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kBlueColor,
                                    fontFamily: 'latoRagular',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Sing Up Button
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                      return authProvider.inProgress ? Container(
                            height: MediaQuery.of(context).size.height/1,
                            width: MediaQuery.of(context).size.width /1,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ):
                           Container(
                            width: 90.w,
                            height: 8.h,
                            padding: const EdgeInsets.only(bottom: 20),
                            child: WidgetFactory.buildButton(
                              context: context,
                              onPressed: () {
                                if(nameController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Enter Your Name");
                                }else if(emailController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Enter Your Email");
                                }else if(!isEmail(emailController.text)){
                                  customWidget.showCustomSnackbar(context, "Enter Your Valid Email");
                                }else if(phoneController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Enter Your Phone Number");
                                }else if(designationController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Enter Your Designation");
                                }else if(companyNameController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, " Enter your Company Name");
                                }else if(sizeController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Enter Your Company Size");
                                }else if(addressController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Enter Your Address");
                                }else{
                                  Map<String, dynamic> data = {
                                    "name": nameController.text,
                                    "company_name": companyNameController.text,
                                    "email": emailController.text,
                                    "phone": phoneController.text,
                                    "designation": designationController.text,
                                    "address": addressController.text,
                                    "employee_size": sizeController.text
                                  };
                                  authProvider.signUp(
                                      data: data,
                                      onSuccess: (e){
                                    nameController.clear();
                                    companyNameController.clear();
                                    emailController.clear();
                                    phoneController.clear();
                                    designationController.clear();
                                    addressController.clear();
                                    sizeController.clear();
                                        customWidget.showCustomSuccessSnackbar(context, "${e}");
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                                      },
                                      onFail: (e){
                                    customWidget.showCustomSnackbar(context, "${e}");
                                      });
                                }
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const SignupOTPScreen(),
                                //   ),
                                // );
                              },
                              text: "Request",
                              backgroundColor: kBlueColor,
                              borderColor: Colors.transparent,
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}
