import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/providers/user_provider.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/edit_profile.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../business_logics/models/profile_response_model.dart';
import '../../business_logics/utils/constants.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  ProfileResponseModel? profileResponseModel;
  bool loading = true;
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
    var mheight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
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
        body: loading == true ?
        Container(
          height: MediaQuery.of(context).size.height/1,
          width: MediaQuery.of(context).size.width/1,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) :
        Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
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
                                "Profile",
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
                //Other
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: mheight - 140,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          // height: 30.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey.shade300,
                              ),
                            ],
                            color: kWhiteColor,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  height: 15.h,
                                  width: 32.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFC6EAE9),
                                      width: 4,
                                    ),
                                  ),
                                  child: profileResponseModel?.data?.employee?.image == null ||
                                      profileResponseModel?.data?.employee?.image == "null" ||
                                      profileResponseModel?.data?.employee?.image == ""
                                      ? CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/user_avatar.png"

                                    ),
                                  ) : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "${BASE_URL_IMAGE}/assets/${profileResponseModel?.data?.employee?.image}"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                profileResponseModel?.data?.name == null
                                    || profileResponseModel?.data?.name == "null" ||
                                    profileResponseModel?.data?.name == "" ? "N/A" : profileResponseModel!.data!.name!,
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor,
                                ),
                              ),
                              Text(
                                profileResponseModel?.data?.employee?.officeDivisions == null
                                    || profileResponseModel?.data?.employee?.officeDivisions?.name == "null" ||
                                    profileResponseModel?.data?.employee?.officeDivisions?.name == "" ? "N/A" :
                                profileResponseModel!.data!.employee!.officeDivisions!.name!,
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFAEAEAE),
                                ),
                              ),
                              Text(
                                profileResponseModel?.data?.type  == null
                                    || profileResponseModel?.data?.type  == "null" ||
                                    profileResponseModel?.data?.type  == "" ? "N/A" :
                                 profileResponseModel!.data!.type!,
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFAEAEAE),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfile(
                                              joinDate: profileResponseModel?.data?.employee?.joiningDate,
                                              employeeId: profileResponseModel?.data?.employee?.idNo,
                                              name: profileResponseModel?.data?.name,
                                              mobileNumber: profileResponseModel?.data?.phone,
                                              email: profileResponseModel?.data?.email,
                                              gender: profileResponseModel?.data?.employee?.gender,
                                              emergencyContact: profileResponseModel?.data?.employee?.emergencyContactPhone,
                                              bloodGroup: profileResponseModel?.data?.employee?.bloodGroup,
                                              designation: profileResponseModel?.data?.employee?.designations?.name,
                                              image: profileResponseModel?.data?.employee?.image,
                                            )),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1294F2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 16, left: 20, right: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                customContainer(
                                    label: "Joining Date",
                                    employeeData: profileResponseModel?.data?.employee?.joiningDate?.substring(0, 10) == null ||
                                        profileResponseModel?.data?.employee?.joiningDate?.substring(0, 10) == "null" ||
                                        profileResponseModel?.data?.employee?.joiningDate?.substring(0, 10) == ""? ": N/A" : ": "
                                        "${DateFormat('dd/MM/yyyy').format(DateTime.parse(profileResponseModel!.data!.employee!.joiningDate!.substring(0, 10)))}"
                                ) ,
                                //employeeData: ": ${userProfileProvider.profileResponseModel?.data?.dateOfBirth?.substring(0, 10) ?? "N/A"}"),
                                customContainer(
                                    label: "Employee ID",
                                    employeeData: ": ${profileResponseModel?.data?.employee?.idNo == null
                                        || profileResponseModel?.data?.employee?.idNo == "null"
                                        || profileResponseModel?.data?.employee?.idNo == "" ? "N/A" :
                                           profileResponseModel!.data!.employee!.idNo}"),
                                customContainer(
                                    label: "Phone",
                                    employeeData: ": ${profileResponseModel?.data?.phone == null
                                        || profileResponseModel?.data?.phone == "null"
                                        || profileResponseModel?.data?.phone == ""? "N/A" : profileResponseModel!.data!.phone}"),
                                customContainer(
                                    label: "Email",
                                    employeeData: ": ${profileResponseModel?.data?.email == null
                                        || profileResponseModel?.data?.email == "null"
                                        || profileResponseModel?.data?.email == ""? "N/A" :
                                           profileResponseModel!.data!.email}"),
                                customContainer(
                                    label: "Gender",
                                    employeeData: ": ${profileResponseModel?.data?.employee?.gender == null
                                        || profileResponseModel?.data?.employee?.gender == "null"
                                        || profileResponseModel?.data?.employee?.gender == ""? "N/A" :
                                           profileResponseModel!.data!.employee!.gender}"),
                                customContainer(
                                    label: "Department",
                                    employeeData: ": ${profileResponseModel?.data?.employee?.officeDivisions == null
                                        || profileResponseModel?.data?.employee?.officeDivisions?.name == "null"
                                        || profileResponseModel?.data?.employee?.officeDivisions?.name == "" ? "N/A" :
                                           profileResponseModel?.data?.employee?.officeDivisions?.name}"),
                                customContainer(
                                    label: "Blood Group", employeeData: ": ${profileResponseModel?.data?.employee?.bloodGroup == null
                                    || profileResponseModel?.data?.employee?.bloodGroup == "null"
                                    || profileResponseModel?.data?.employee?.bloodGroup == "" ? "N/A" :
                                       profileResponseModel!.data!.employee!.bloodGroup}"),
                                customContainer(
                                    label: "Emergency Contact",
                                    employeeData: ": ${profileResponseModel?.data?.employee?.emergencyContactPhone == null
                                        || profileResponseModel?.data?.employee?.emergencyContactPhone == "null"
                                        || profileResponseModel?.data?.employee?.emergencyContactPhone == "" ? "N/A" :
                                           profileResponseModel!.data!.employee!.emergencyContactPhone}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

Widget customContainer({label, employeeData}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
      children: [
        SizedBox(
          height: 3.h,
          width: 40.w,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 15.sp,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF808080),
            ),
          ),
        ),
        SizedBox(
          height: 3.h,
          child: Text(
            employeeData,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF151515),
            ),
          ),
        )
      ],
    ),
  );
}
