import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../business_logics/models/privacy_policy_model.dart';
import '../../business_logics/providers/privacy_policy_provider.dart';
import '../utils/colors.dart';
import 'bottomnav/bottomnav_screen_layout.dart';
import 'drawer.dart';
import 'employee_list.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 4.h,
                    width: 80.w,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavScreenLayout(
                                      page: 0,
                                    )));
                          },
                          child: Container(
                            height: 4.5.h,
                            width: 9.w,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset("assets/images/arrow_left.png"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Privacy Policy",
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
            Consumer<PrivacyPolicyProvider>(
              builder: (context,privacyPolicyProvider,child){
                return FutureBuilder<PrivacyPolicyModel?>(
                    future: privacyPolicyProvider.getPrivacyPolicyData(),
                    builder: (context,snapsort){
                      if(snapsort.hasData){
                        return
                          Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10,bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width/1,
                            child: HtmlWidget( '''
                            ${snapsort.data!.data!.policy}''',
                              textStyle: TextStyle(fontSize: 14),),
                          )
                        );
                      }else{
                        return Container(
                          height: MediaQuery.of(context).size.height/1,
                          width: MediaQuery.of(context).size.width/1,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                );
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(12),
            //   // child: Container(
            //   // //  height: 80.h,
            //   //   width: MediaQuery.of(context).size.width,
            //   //
            //   //   decoration: BoxDecoration(
            //   //     boxShadow: [
            //   //       BoxShadow(
            //   //         offset: const Offset(0, 1),
            //   //         blurRadius: 5,
            //   //         color: Colors.grey.withOpacity(0.3),
            //   //       ),
            //   //     ],
            //   //     color: kWhiteColor,
            //   //     borderRadius: const BorderRadius.only(
            //   //       topLeft: Radius.circular(30),
            //   //       topRight: Radius.circular(30),
            //   //
            //   //     ),
            //   //   ),
            //   child:
            //   Column(children: [
            //     InkWell(
            //       onTap: (){
            //        // Navigator.push(context, MaterialPageRoute(builder: (context)=> const PasswordChangeScreen()));
            //       },
            //       child: IntrinsicHeight(
            //         child: Container(
            //           height: 7.h,
            //           width: 90.w,
            //           decoration: BoxDecoration(
            //             color: kWhiteColor,
            //             borderRadius: BorderRadius.circular(10),
            //             boxShadow: [
            //               BoxShadow(
            //                 offset: const Offset(0, 1),
            //                 blurRadius: 5,
            //                 color: Colors.grey.withOpacity(0.3),
            //               ),
            //             ],
            //           ),
            //           child:Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   """Password Change""",
            //                   style: TextStyle(
            //                     fontFamily: 'latoRagular',
            //                     fontSize: 16.5.sp,
            //                     fontWeight: FontWeight.w700,
            //                     color: const Color(0xFF252930),
            //                   ),
            //                 ),
            //                 Icon(
            //                   Icons.arrow_forward_ios_rounded,
            //                   size: 20.5.sp,
            //                   color: const Color(0xFF102048),
            //                 ),
            //               ],
            //             ),
            //           ),
            //
            //           // Padding(
            //           //   padding: const EdgeInsets.all(5),
            //           //   child: Row(
            //           //     mainAxisAlignment: MainAxisAlignment.start,
            //           //     children: [
            //           //       SizedBox(
            //           //         height: 5.h,
            //           //         width: 15.w,
            //           //         child: const Image(
            //           //           image: AssetImage(
            //           //               "assets/images/Rectangle 90 (1).png"),
            //           //         ),
            //           //       ),
            //           //       const VerticalDivider(
            //           //         color: Color(0xFFD9D9D9),
            //           //         thickness: 1,
            //           //         indent: 10,
            //           //         endIndent: 10,
            //           //       ),
            //           //
            //           //     ],
            //           //   ),
            //           // ),
            //         ),
            //       ),
            //     ),
            //   ],),
            // ),

            // ),
          ],
        ),
      ),
    );
  }
}
