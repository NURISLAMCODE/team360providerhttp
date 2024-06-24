import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/providers/user_provider.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/views/ui/attendence_screen.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';
import 'package:team360/src/views/ui/expense_screen.dart';
import 'package:team360/src/views/ui/leave_screen.dart';
import 'package:team360/src/views/ui/login/login.dart';
import 'package:team360/src/views/ui/privacy_policy_screen.dart';
import 'package:team360/src/views/ui/profile_screen.dart';
import 'package:team360/src/views/ui/setting_list_screen.dart';
import 'package:team360/src/views/ui/task/task_screen.dart';
import 'package:team360/src/views/ui/tearm_and_condition_screen.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../business_logics/models/profile_response_model.dart';
import '../../services/shared_preference_services/shared_preference_services.dart';
import 'notice/noteice_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  bool loading = true;
  ProfileResponseModel? profileResponseModel;
  @override
  void initState() {
    super.initState();
    loading = true;
    Future.delayed(Duration(milliseconds: 1), () async {
      UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      await userProfileProvider.getProfileData().then((value){
        setState(() {
          profileResponseModel = value;
        });
      });
      await loadingStop();
    });
  }

  Future<void> loadingStop() async {
    Future.delayed(Duration(seconds: 1),(){
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == true ?
    Container(
      width: 75.w,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : Consumer<UserProfileProvider>(
        builder: (context,userProfileProvider,child){
          return Container(
            width: 75.w,
            decoration: const BoxDecoration(
              color: kWhiteColor,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 24.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF19888E),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      // child: Padding(
                      //   padding: const EdgeInsets.only(top: 205, left: 10, right: 10),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "27",
                      //             style: TextStyle(
                      //               fontFamily: 'latoRagular',
                      //               fontSize: 17.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: kWhiteColor,
                      //             ),
                      //           ),
                      //           Text(
                      //             "Total Employee",
                      //             style: TextStyle(
                      //               fontFamily: 'latoRagular',
                      //               fontSize: 13.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: kWhiteColor,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "27",
                      //             style: TextStyle(
                      //               fontFamily: 'latoRagular',
                      //               fontSize: 17.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: kWhiteColor,
                      //             ),
                      //           ),
                      //           Text(
                      //             "Total Project",
                      //             style: TextStyle(
                      //               fontFamily: 'latoRagular',
                      //               fontSize: 13.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: kWhiteColor,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "27",
                      //             style: TextStyle(
                      //               fontFamily: 'latoRagular',
                      //               fontSize: 17.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: kWhiteColor,
                      //             ),
                      //           ),
                      //           Text(
                      //             "Total Expenses",
                      //             style: TextStyle(
                      //               fontFamily: 'latoRagular',
                      //               fontSize: 13.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: kWhiteColor,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                    Container(
                      // height: 24.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Container(
                              height: 10.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFC6EAE9),
                                  width: 4,
                                ),
                              ),
                              child: profileResponseModel?.data?.employee?.image == null ||
                                  profileResponseModel?.data?.employee?.image == "null" ||
                                  profileResponseModel?.data?.employee?.image == "" ?
                              CircleAvatar(
                                backgroundImage:
                                AssetImage("assets/images/user_avatar.png"),
                              ) : CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${BASE_URL_IMAGE}/assets/${profileResponseModel!.data!.employee!.image}"
                                ),
                              )
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              profileResponseModel?.data?.name == null
                                  || profileResponseModel?.data?.name == "null"
                                  || profileResponseModel?.data?.name == ""
                                  ? "N/A"
                                  : "${profileResponseModel!.data!.name}",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: kBlackColor,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              profileResponseModel?.data?.employee?.officeDivisions == null
                                  || profileResponseModel?.data?.employee?.officeDivisions?.name == "null"
                                  || profileResponseModel?.data?.employee?.officeDivisions?.name == ""
                                  ? "N/A"
                                  : "${profileResponseModel!.data!.employee!.officeDivisions!.name}",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5.sp,
                                color: kBlackColor,
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Dashboard
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 5, top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/carbon_dashboard.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Profile
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/Vector (2).png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Attendance
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavScreenLayout(page: 1,),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/ion_finger-print.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Attendance",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Task Management
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskScreen(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/Vector (3).png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Task Management",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Leave
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaveScreen(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/gg_coffee.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Leave",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Expenses
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseScreen(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/fa6-solid_file-invoice-dollar.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Expenses",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Notification
                InkWell(
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const NoticeScreen(),
                    //     ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/carbon_notification-new.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Notification",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Setting
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SettingListScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/akar-icons_gear.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Setting",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Holiday
                // Padding(
                //   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         height: 4.h,
                //         width: 4.5.w,
                //         child: const Image(
                //           image: AssetImage(
                //             "assets/images/fluent_beach-24-regular.png",
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       Text(
                //         "Holiday",
                //         style: TextStyle(
                //           fontFamily: 'latoRagular',
                //           fontWeight: FontWeight.w400,
                //           fontSize: 17.sp,
                //           color: kBlackColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // //Share With Friends
                // Padding(
                //   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         height: 4.h,
                //         width: 4.5.w,
                //         child: const Image(
                //           image: AssetImage(
                //             "assets/images/carbon_share.png",
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       Text(
                //         "Share With Friends",
                //         style: TextStyle(
                //           fontFamily: 'latoRagular',
                //           fontWeight: FontWeight.w400,
                //           fontSize: 17.sp,
                //           color: kBlackColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                //Privacy Policy
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrivacyPolicyScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/ci_warning-outline.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Log Out
                GestureDetector(
                  onTap: () async{
                    await SharedPrefsServices.clearAllData();
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await SharedPrefsServices.setStringData('accessToken', '');
                    // prefs.setBool('hasCheckedIn', false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                            (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 4.h,
                          width: 4.5.w,
                          child: const Image(
                            image: AssetImage(
                              "assets/images/octicon_sign-out-16.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Log Out",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.sp,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermAndConScreen()),
                            (route) => false);

                  },
                  child: Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontWeight: FontWeight.w400,
                      fontSize: 17.sp,
                      color: kBlackColor,
                    ),
                  ),
                ),
                SizedBox(height: 2.h,),
              ],
            ),
          );
        }
    );
  }
}



// class DrawerScreen extends StatelessWidget {
//   const DrawerScreen({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserProfileProvider>(
//       builder: (context,userProfileProvider,child){
//         return Container(
//           width: 75.w,
//           decoration: const BoxDecoration(
//             color: kWhiteColor,
//           ),
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     height: 24.h,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF19888E),
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(28),
//                         bottomRight: Radius.circular(28),
//                       ),
//                     ),
//                     // child: Padding(
//                     //   padding: const EdgeInsets.only(top: 205, left: 10, right: 10),
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     //     children: [
//                     //       Column(
//                     //         children: [
//                     //           Text(
//                     //             "27",
//                     //             style: TextStyle(
//                     //               fontFamily: 'latoRagular',
//                     //               fontSize: 17.sp,
//                     //               fontWeight: FontWeight.w600,
//                     //               color: kWhiteColor,
//                     //             ),
//                     //           ),
//                     //           Text(
//                     //             "Total Employee",
//                     //             style: TextStyle(
//                     //               fontFamily: 'latoRagular',
//                     //               fontSize: 13.sp,
//                     //               fontWeight: FontWeight.w600,
//                     //               color: kWhiteColor,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //       Column(
//                     //         children: [
//                     //           Text(
//                     //             "27",
//                     //             style: TextStyle(
//                     //               fontFamily: 'latoRagular',
//                     //               fontSize: 17.sp,
//                     //               fontWeight: FontWeight.w600,
//                     //               color: kWhiteColor,
//                     //             ),
//                     //           ),
//                     //           Text(
//                     //             "Total Project",
//                     //             style: TextStyle(
//                     //               fontFamily: 'latoRagular',
//                     //               fontSize: 13.sp,
//                     //               fontWeight: FontWeight.w600,
//                     //               color: kWhiteColor,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //       Column(
//                     //         children: [
//                     //           Text(
//                     //             "27",
//                     //             style: TextStyle(
//                     //               fontFamily: 'latoRagular',
//                     //               fontSize: 17.sp,
//                     //               fontWeight: FontWeight.w600,
//                     //               color: kWhiteColor,
//                     //             ),
//                     //           ),
//                     //           Text(
//                     //             "Total Expenses",
//                     //             style: TextStyle(
//                     //               fontFamily: 'latoRagular',
//                     //               fontSize: 13.sp,
//                     //               fontWeight: FontWeight.w600,
//                     //               color: kWhiteColor,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ),
//                   Container(
//                     // height: 24.h,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: const BoxDecoration(
//                       color: kWhiteColor,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 40),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 10.h,
//                             width: 20.w,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color(0xFFC6EAE9),
//                                 width: 4,
//                               ),
//                             ),
//                             child: userProfileProvider.profileResponseModel!.data!.employee!.image != null ? CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                   "https://teams360.nextgenitltd.com/backend/assets/${userProfileProvider.profileResponseModel!.data!.employee!.image}"
//                               ),
//                             ) :
//                             CircleAvatar(
//                               backgroundImage:
//                               AssetImage("assets/images/face1.png"),
//                             ),
//                           ),
//                           SizedBox(height: 1.h),
//                           Text(
//                             userProfileProvider.profileResponseModel!.data!.name == null
//                                 ? "N/A"
//                                 : "${userProfileProvider.profileResponseModel!.data!.name}",
//                             style: TextStyle(
//                               fontFamily: 'latoRagular',
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                               color: kBlackColor,
//                             ),
//                           ),
//                           SizedBox(height: 0.5.h),
//                           Text(
//                             userProfileProvider.profileResponseModel!.data!.employee!.departments!.name == null
//                                 ? "N/A"
//                                 : "${userProfileProvider.profileResponseModel!.data!.employee!.departments!.name}",
//                             style: TextStyle(
//                               fontFamily: 'latoRagular',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 13.5.sp,
//                               color: kBlackColor,
//                             ),
//                           ),
//                           SizedBox(height: 1.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               //Dashboard
//               InkWell(
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 25, right: 25, bottom: 5, top: 20),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/carbon_dashboard.png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Dashboard",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Profile
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const Profile(),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/Vector (2).png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Profile",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Attendance
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BottomNavScreenLayout(page: 1,),
//                       ));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/ion_finger-print.png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Attendance",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Task Management
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const TaskScreen(),
//                       ));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/Vector (3).png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Task Management",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Leave
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LeaveScreen(),
//                       ));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/gg_coffee.png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Leave",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Expenses
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ExpenseScreen(),
//                       ));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/fa6-solid_file-invoice-dollar.png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Expenses",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Notification
//               InkWell(
//                 onTap: () {
//                   // Navigator.pop(context);
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //       builder: (context) => const NoticeScreen(),
//                   //     ));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/carbon_notification-new.png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Notification",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Setting
//               Padding(
//                 padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 4.h,
//                       width: 4.5.w,
//                       child: const Image(
//                         image: AssetImage(
//                           "assets/images/akar-icons_gear.png",
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Text(
//                       "Setting",
//                       style: TextStyle(
//                         fontFamily: 'latoRagular',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 17.sp,
//                         color: kBlackColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //Holiday
//               // Padding(
//               //   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//               //   child: Row(
//               //     children: [
//               //       SizedBox(
//               //         height: 4.h,
//               //         width: 4.5.w,
//               //         child: const Image(
//               //           image: AssetImage(
//               //             "assets/images/fluent_beach-24-regular.png",
//               //           ),
//               //         ),
//               //       ),
//               //       const SizedBox(width: 20),
//               //       Text(
//               //         "Holiday",
//               //         style: TextStyle(
//               //           fontFamily: 'latoRagular',
//               //           fontWeight: FontWeight.w400,
//               //           fontSize: 17.sp,
//               //           color: kBlackColor,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // //Share With Friends
//               // Padding(
//               //   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//               //   child: Row(
//               //     children: [
//               //       SizedBox(
//               //         height: 4.h,
//               //         width: 4.5.w,
//               //         child: const Image(
//               //           image: AssetImage(
//               //             "assets/images/carbon_share.png",
//               //           ),
//               //         ),
//               //       ),
//               //       const SizedBox(width: 20),
//               //       Text(
//               //         "Share With Friends",
//               //         style: TextStyle(
//               //           fontFamily: 'latoRagular',
//               //           fontWeight: FontWeight.w400,
//               //           fontSize: 17.sp,
//               //           color: kBlackColor,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               //Privacy Policy
//               Padding(
//                 padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 4.h,
//                       width: 4.5.w,
//                       child: const Image(
//                         image: AssetImage(
//                           "assets/images/ci_warning-outline.png",
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Text(
//                       "Privacy Policy",
//                       style: TextStyle(
//                         fontFamily: 'latoRagular',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 17.sp,
//                         color: kBlackColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //Log Out
//               GestureDetector(
//                 onTap: () async{
//                   await SharedPrefsServices.clearAllData();
//                   // SharedPreferences prefs = await SharedPreferences.getInstance();
//                   // await SharedPrefsServices.setStringData('accessToken', '');
//                   // prefs.setBool('hasCheckedIn', false);
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginScreen()),
//                           (route) => false);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                         width: 4.5.w,
//                         child: const Image(
//                           image: AssetImage(
//                             "assets/images/octicon_sign-out-16.png",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Text(
//                         "Log Out",
//                         style: TextStyle(
//                           fontFamily: 'latoRagular',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17.sp,
//                           color: kBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     );
//   }
// }
