import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/ui/drawer.dart';

import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../business_logics/models/contact_list_model/Contact_list_model.dart';
import '../../business_logics/utils/constants.dart';
import 'employee_list.dart';


class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({Key? key,required this.contacts}) : super(key: key);
  final Contacts contacts;
  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> EmployeeList()));
        return true;
      },
      child: Scaffold(
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10,
            //   ),
            //   child: IconButton(
            //     icon: Image.asset('assets/images/appbar_contact.png'),
            //     onPressed: () {},
            //   ),
            // ),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 5.h,
                    width: 40.w,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EmployeeList()));
                          },
                          child: Container(
                            height: 5.h,
                            width: 10.w,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child:
                                  Image.asset("assets/images/arrow_left.png"),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Contact List",
                            style: kTitleTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Other
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Column(
                      children: [
                        Container(
                          // height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                            color: kWhiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Column(
                              children: [
                                Container(
                                  height: 13.h,
                                  width: 26.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: const Color(0xFFC6EAE9),
                                      width: 4,
                                    ),
                                  ),
                                  child: widget.contacts.image == null ||
                                      widget.contacts.image == "null" ||
                                      widget.contacts.image == "" ? const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/user_avatar.png"),
                                  ) : CircleAvatar(
                                    backgroundImage: NetworkImage("${BASE_URL_IMAGE}/assets/${widget.contacts.image}"),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  widget.contacts.users?.name == null ||
                                      widget.contacts.users?.name == "null" ||
                                      widget.contacts.users?.name == "" ?
                                  "N/A" :  widget.contacts.users!.name!,
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor,
                                  ),
                                ),
                                Text(
                                  widget.contacts.officeDivisions == null ||
                                      widget.contacts.officeDivisions?.name == "null" ||
                                      widget.contacts.officeDivisions?.name == "" ? "N/A" : widget.contacts.officeDivisions!.name!,
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFAEAEAE),
                                  ),
                                ),
                                Text(
                                  widget.contacts.jobTypes == null ||
                                      widget.contacts.jobTypes?.name == "null" ||
                                      widget.contacts.jobTypes?.name == "" ? "N/A" : widget.contacts.jobTypes!.name!,
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFAEAEAE),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 4.h,
                                      width: 8.5.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFF19888E),
                                      ),
                                      child: IconButton(
                                        onPressed: widget.contacts.users?.phone == null ||
                                            widget.contacts.users?.phone == "null" ||
                                            widget.contacts.users?.phone == "" ? (){
                                          customWidget.showCustomSnackbar(context, "User phone number is not set");
                                        } : () {
                                          launchUrl(
                                            Uri(scheme: 'tel', path: "${widget.contacts.users!.phone}"),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.phone,
                                          color: kWhiteColor,
                                          size: 2.h,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      height: 4.h,
                                      width: 8.5.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFF19888E),
                                      ),
                                      child: IconButton(
                                        onPressed:  widget.contacts.users?.phone == null ||
                                            widget.contacts.users?.phone == "null" ||
                                            widget.contacts.users?.phone == "" ? (){
                                          customWidget.showCustomSnackbar(context, "User phone number is not set");
                                        } : () {
                                          launchUrl(Uri(scheme: 'sms', path: widget.contacts.users!.phone));
                                        },
                                        icon: Icon(
                                          Icons.chat,
                                          color: kWhiteColor,
                                          size: 2.h,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      height: 4.h,
                                      width: 8.5.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFF19888E),
                                      ),
                                      child: IconButton(
                                        onPressed:  widget.contacts.users?.email == null ||
                                            widget.contacts.users?.email == "null" ||
                                            widget.contacts.users?.email == "" ? (){
                                          customWidget.showCustomSnackbar(context, "User phone email is not set");
                                        } : () {
                                          launchUrl(Uri(scheme: 'mailto', path: widget.contacts.users!.email));
                                        },
                                        icon: Icon(
                                          Icons.mail,
                                          color: kWhiteColor,
                                          size: 2.h,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    // Container(
                                    //   height: 4.h,
                                    //   width: 8.5.w,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     color: const Color(0xFF19888E),
                                    //   ),
                                    //   child: IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(
                                    //       Icons.ac_unit_outlined,
                                    //       color: kWhiteColor,
                                    //       size: 2.h,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                              height: 3.h,
                              width: 30.w,
                              child: Text(
                                "Phone",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                              child: Text(
                                widget.contacts.users?.phone == null ||
                                    widget.contacts.users?.phone == "null" ||
                                    widget.contacts.users?.phone == "" ? ": N/A" :  ":  ${widget.contacts.users!.phone}",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF151515),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 3.h,
                              width: 30.w,
                              child: Text(
                                "Email",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                              child: Text(
                                widget.contacts.users?.email == null ||
                                    widget.contacts.users?.email == "null" ||
                                    widget.contacts.users?.email == "" ? ": N/A" :  ":  ${widget.contacts.users!.email}",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF151515),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 3.h,
                              width: 30.w,
                              child: Text(
                                "Department",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                              child: Text(
                                widget.contacts.officeDivisions == null ||
                                    widget.contacts.officeDivisions?.name == "null" ||
                                    widget.contacts.officeDivisions?.name == "" ? ": N/A" :  ":  ${widget.contacts.officeDivisions!.name}",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF151515),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 3.h,
                              width: 30.w,
                              child: Text(
                                "Blood Group",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                              child: Text(
                                widget.contacts.bloodGroup == null ||
                                    widget.contacts.bloodGroup == "null" ||
                                    widget.contacts.bloodGroup == "" ? ": N/A" :  ":  ${widget.contacts.bloodGroup}",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF151515),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
