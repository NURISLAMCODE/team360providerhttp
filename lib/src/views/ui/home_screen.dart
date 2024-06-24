import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team360/src/business_logics/models/notice_model/department_list_class.dart';
import 'package:team360/src/business_logics/models/scadual_calender_class/next_sevenday_working_Scadual.dart';
import 'package:team360/src/business_logics/models/task_model/assigned_to_me_model.dart';
import 'package:team360/src/business_logics/providers/all_notice_provider.dart';
import 'package:team360/src/business_logics/providers/task_provider.dart';
import 'package:team360/src/views/ui/attendence_screen.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_layout.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/expense_screen.dart';
import 'package:team360/src/views/ui/leave_screen.dart';
import 'package:team360/src/views/ui/notice/noteice_screen.dart';
import 'package:team360/src/views/ui/schedule_all.dart';
import 'package:team360/src/views/ui/task/task_details.dart';
import 'package:team360/src/views/ui/task/task_screen.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';
import 'package:team360/src/views/utils/tooltip.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../business_logics/models/attendence_task_report.dart';
import '../../business_logics/models/notice_model/notice_type_class.dart';
import '../../business_logics/models/notice_model/sub_department_list_class.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/providers/attendance_report_provider.dart';
import '../../business_logics/providers/schadual_provider.dart';
import '../../services/shared_preference_services/shared_preference_services.dart';
import 'bottomnav/bottomnav_screen_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String dropdownLeaveValue = "Team";
  final maxLines = 5;
  TextEditingController noticeFromDate = TextEditingController();
  TextEditingController noticeToDate = TextEditingController();
  TextEditingController notice = TextEditingController();
  String? dropDownValue = "";
  late final Function onRefresh;
  List<Tasks> tasks = [];
  int allTask = 0;
  int completeTask = 0;
  int newTask = 0;
  int inProgressTask = 0;
  NoticeType? dropDownnoticeType;
  Divisions? dropDowndivisions;
  SubDepartment? dropDownSubDepartment;
  List<NoticeType> noticeTypeList = [];
  List<Divisions> departmentList = [];
  List<SubDepartment> submitSubDepartment = [];
  List<SubDepartment> subDepartmentList = [];
  List<Result> results = [];
  int resultLenght = 0;
  bool isVisible = false;
  bool isNotVisible = true;
  int selectedIndex = 0;
  bool loading = true;
  final CarouselController caroselController = CarouselController();


  @override
  void initState() {
    super.initState();
    loading = true;
    Future.delayed(Duration(microseconds: 1), ()async {
      final stopwatch = Stopwatch()..start();
      AllNoticeProvider allNoticeProvider = Provider.of<AllNoticeProvider>(context, listen: false);
      await allNoticeProvider.getAllNoticeData();
      await allNoticeProvider.getAllNoticeType().then((value){
        if(value!.data!.noticeType!.isNotEmpty == true){
          setState(() {
            value.data!.noticeType!.forEach((element) {
              noticeTypeList.add(element);
            });
          });
        }
      });
      await allNoticeProvider.getAllDepartmentList().then((value){
        if(value!.data!.divisions!.isNotEmpty == true){
          setState(() {
            value.data!.divisions!.forEach((element) {
              departmentList.add(element);
            });
          });
        }
      });
      AttendanceReportProvider attendanceReportProvider = Provider.of<AttendanceReportProvider>(context, listen: false);
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      await attendanceReportProvider.attendenceReport(month: month, year: year).then((value) {
        setState(() {
          if(value?.data?.result?.isNotEmpty == true){
            resultLenght = value!.data!.result!.length;
            value.data!.result!.forEach((element) {
              results.add(element);
            });
          }
        });
      });
      TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.getAssignedToMeTask(
          status: "All",
          assigned_to: "",
          assigned_date_from: "",
          assigned_date_to: "",
          due_date_from: "",
          due_date_to: "",
          filter_status: "",
          type: "",
          title: "").then((value){
            allTask = value!.data!.tasks!.length!;
            value.data!.tasks!.forEach((element) {
              tasks.add(element);
            });
      });
      await taskProvider.getAssignedToMeTask(
          status: "Completed",
          assigned_to: "",
          assigned_date_from: "",
          assigned_date_to: "",
          due_date_from: "",
          due_date_to: "",
          filter_status: "",
          type: "",
          title: "").then((value){
            completeTask = value!.data!.tasks!.length!;
          });
      await taskProvider.getAssignedToMeTask(
          status: "In Progress",
          assigned_to: "",
          assigned_date_from: "",
          assigned_date_to: "",
          due_date_from: "",
          due_date_to: "",
          filter_status: "",
          type: "",
          title: "").then((value){
        inProgressTask = value!.data!.tasks!.length!;
      });
      await taskProvider.getAssignedToMeTask(
          status: "New",
          assigned_to: "",
          assigned_date_from: "",
          assigned_date_to: "",
          due_date_from: "",
          due_date_to: "",
          filter_status: "",
          type: "",
          title: "").then((value){
            newTask = value!.data!.tasks!.length!;
      });
      stopwatch.stop();
      print('Function Execution Time : ${stopwatch.elapsed}');
      await loadingStop();
    });
  }

  Future<void> loadingStop() async {
    Future.delayed(Duration(seconds: 1),() {
      setState((){
        loading = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String greeting = '';

    if (now.hour >= 0 && now.hour < 6) {
      greeting = 'Good Night';
    } else if (now.hour >= 6 && now.hour < 12) {
      greeting = 'Good Morning';
    } else if (now.hour >= 12 && now.hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }



    return RefreshIndicator(
     onRefresh: () async{
       Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
     },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4F2),
        extendBodyBehindAppBar: true,
        drawer: const DrawerScreen(),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEAF4F2),
          elevation: 0,
          title: Text(
            "${greeting}, ${UserData.name}",
            style: kTitleTextStyle,
          ),
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

        body: loading ==true ? Container(
            height: MediaQuery.of(context).size.height/ 1, 
          width: MediaQuery.of(context).size.width/ 1,
          child : Center(child: CircularProgressIndicator()),
        ) : SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: 13.h),
              child: Column(
                children: [

                  // notice section
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w),
                    child: Row(children: [
                      const Text("Notice" , style: kTitleTextStyle,),
                      const   Spacer(),
                      SharedPrefsServices.getBoolData("isLead") == false ? SizedBox.shrink() : CircleAvatar(
                          backgroundColor: const Color(0xFF1C69FA),
                          child: TextButton(
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: (){
                                if(noticeTypeList.isEmpty == true){
                                  customWidget.showCustomSnackbar(context, "Notice type is not available");
                                }else if(departmentList.isEmpty == true){
                                  customWidget.showCustomSnackbar(context, "Department is not available");
                                }else{
                                  noticeFromDate.clear();
                                  noticeToDate.clear();
                                  notice.clear();
                                  submitSubDepartment.clear();
                                  subDepartmentList.clear();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return addNoticeDialog();
                                    },
                                  );
                                }
                              },
                              child: Center(
                                  child: Icon(
                                    Icons.add, color: Colors.white,),
                              ),
                          )
                      ),
                    ],),
                  ),

                  //Notice list
                  Consumer<AllNoticeProvider>(
                      builder: (context, allNoticeProvider, child) {
                        return allNoticeProvider.allNoticeResponseModel!.data!.notices!.length >=1 ?
                        Padding(
                          padding: EdgeInsets.only(left: 4.w,right: 4.w),
                          child: SizedBox(
                              height: 10.h,
                              child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                      viewportFraction: 0.8,
                                      height: 10.h,
                                      autoPlay: true,
                                      // autoPlayCurve: Curves.bounceIn,
                                      reverse: false,
                                      animateToClosest: false,
                                      autoPlayInterval:
                                      const Duration(seconds: 3)),
                                  itemCount: allNoticeProvider.allNoticeResponseModel?.data?.notices?.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return Center(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => NoticeScreen(),
                                              ));
                                        },

                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 2.w,
                                                height: 6.h,
                                                decoration:
                                                const BoxDecoration(
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
                                                width: 70.w,
                                                height: 6.h,
                                                decoration:
                                                const BoxDecoration(
                                                  color: Color(0xFFFEF0D0),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.zero,
                                                    topRight: Radius.circular(10.0),
                                                    bottomLeft: Radius.zero,
                                                    bottomRight: Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10),
                                                  child: Text(
                                                    (allNoticeProvider.allNoticeResponseModel?.data?.notices?[index].notice != null || allNoticeProvider.allNoticeResponseModel?.data?.notices?[index].notice != "")
                                                        ? "${allNoticeProvider.allNoticeResponseModel?.data?.notices?[index].notice}"
                                                        : "N/A",
                                                    style:
                                                    kSubTitleTextStyle,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  ),
                          ),
                        )
                            : SizedBox(
                          height: 10.h,
                          child: Center(
                            child: Text(
                              'No Notice Available',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF515151),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      }),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  //Attendence Screen
                  results.isNotEmpty == true ?
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavScreenLayout(page: 1,),
                          ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 16.h,
                      width: 95.w,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: 'Reached Office ?\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF515151),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Give Attendance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF515151),
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 3.h,
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xFF263238)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Today In Time  ",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF263238),
                                          ),
                                        ),
                                        Text(
                                          results[resultLenght-1].attendance!.isEmpty ? "N/A" :
                                          results[resultLenght-1].attendance![0].checkIn == null ? "N/A" :
                                          (DateTime.parse(results[resultLenght-1].attendance![0].checkIn!).day) != (DateTime.now().day) ? "N/A" :
                                          formatTime((DateTime.parse(results[resultLenght-1].attendance![0].checkIn!).millisecondsSinceEpoch).toString()),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: const Color(0xFF263238),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 3.h,
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(0xFF263238),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Last Out Time  ",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF263238),
                                          ),
                                        ),
                                        Text(
                                          results[resultLenght-1].attendance!.isEmpty ? "N/A" :
                                          results[resultLenght-1].attendance![0].checkOut == null ? "N/A" :
                                          (DateTime.parse(results[resultLenght-1].attendance![0].checkOut!).day) != (DateTime.now().day) ? "N/A" :
                                          formatTime((DateTime.parse(results[resultLenght-1].attendance![0].checkOut!).millisecondsSinceEpoch).toString()),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: const Color(0xFF263238),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                // height: 13.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF1C69FA),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          // right: 30,
                                          // left: 30,
                                          bottom: 5),
                                      child: SizedBox(
                                        height: 6.h,
                                        width: 12.w,
                                        child: const Image(
                                          image: AssetImage(
                                              "assets/images/checkin.png"),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Check In",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavScreenLayout(page: 1,),
                          ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 16.h,
                      width: 95.w,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: 'Reached Office ?\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF515151),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Give Attendance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF515151),
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 3.h,
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xFF263238)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Today In Time  ",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF263238),
                                          ),
                                        ),
                                        Text(
                                          "N/A",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: const Color(0xFF263238),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 3.h,
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(0xFF263238),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Last Out Time  ",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF263238),
                                          ),
                                        ),
                                        Text(
                                          "N/A",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: const Color(0xFF263238),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                // height: 13.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF1C69FA),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          // right: 30,
                                          // left: 30,
                                          bottom: 5),
                                      child: SizedBox(
                                        height: 6.h,
                                        width: 12.w,
                                        child: const Image(
                                          image: AssetImage(
                                              "assets/images/checkin.png"),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Check In",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //TASKS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TaskScreen()));
                      },
                      child: Container(
                        height: 18.h,
                        width: 95.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                        child: Container(
                          height: 18.h,
                          width: MediaQuery.of(context).size.width/1,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 18.h,
                                width: 83.05.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 1.5.h,
                                            width: 3.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              color: const Color(0xFF00B3B3),
                                            ),
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            "All",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              const Color(0xFF00B3B3),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),

                                          Container(
                                            height: 1.5.h,
                                            width: 3.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              color:
                                              const Color(0xFFFF7248),
                                            ),
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            "New",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              const Color(0xFFFF7248),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),

                                          Container(
                                            height: 1.5.h,
                                            width: 3.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              color: const Color(0xFFFD4155),
                                            ),
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            "In Progress",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              const Color(0xFFFD4155),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),

                                          Container(
                                            height: 1.5.h,
                                            width: 3.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              color:
                                              const Color(0xFF857BF9),
                                            ),
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            "Complete",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              const Color(0xFF857BF9),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 6.5.h,
                                                  width: 41.5.w,
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage("assets/images/task1.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: 3.5.h,
                                                          width: 12.w,
                                                          child: Image.asset("assets/images/new.png"),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Text(
                                                            "${allTask}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 6.5.h,
                                                  width: 41.5.w,
                                                  decoration:
                                                  const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage("assets/images/task2.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: 3.5.h,
                                                          width: 12.w,
                                                          child: Image.asset("assets/images/clock.png"),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(right: 10),
                                                          child: Text(
                                                            "${newTask}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 6.5.h,
                                                  width: 41.5.w,
                                                  decoration:
                                                  const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage("assets/images/task3.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: 3.5.h,
                                                          width: 12.w,
                                                          child: Image.asset("assets/images/chart.png"),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Text(
                                                            "${inProgressTask}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 6.5.h,
                                                  width: 41.5.w,
                                                  decoration:
                                                  const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage("assets/images/task4.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: 3.3.h,
                                                          width: 12.w,
                                                          child: Image.asset("assets/images/timer.png"),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(right: 10),
                                                          child: Text(
                                                            "${completeTask}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 18.h,
                                width: 10.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: const Color(0xFFEAF4F2),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 1.w,
                                    child: Text(
                                      "T A S K S",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 16.4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF263238),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Expense & My Schedule & Leave
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 10, top: 10, left: 10),
                    child: Container(
                      height: 6.h,
                      width: 95.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          //Expense
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ExpenseScreen(),
                                  ));
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 4.h,
                                      width: 4.h,
                                      child: Image.asset(
                                          "assets/images/expence.png"),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 4.h,
                                    child: Text(
                                      "Expense",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF102048),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.h,)
                                ],
                              ),
                            ),
                          ),

                          //My Schedule
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AllSchedule(isFirst: true,)));
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 4.h,
                                      width: 4.h,
                                      child: Image.asset(
                                          "assets/images/myschedule.png"),
                                    ),
                                  ),
                                  SizedBox(width: .5.h,),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 4.h,
                                    child: Text(
                                      "Schedule",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF102048),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.h,)
                                ],
                              ),
                            ),
                          ),

                          //Leave
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LeaveScreen(),
                                  ));
                            },
                            child: Container(
                              height: 6.h,
                              width: 28.w,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 4.h,
                                      width: 4.h,
                                      child:
                                      Image.asset("assets/images/leave.png"),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 4.h,
                                    child: Text(
                                      "Leave",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF102048),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.h,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Task
                  Column(
                    children: [
                      if (isNotVisible)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() =>
                              (isNotVisible = !isNotVisible) ==
                                  (isVisible = !isVisible));
                            },
                            child: Container(
                              // height: 57.5.h,
                              width: MediaQuery.of(context).size.width/1,
                              decoration: const BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20, bottom: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Tasks ',
                                                style: kTitleTextStyle,
                                              ),
                                              TextSpan(
                                                text: '(${completeTask.toString()}/${allTask.toString()})',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'latoRagular',
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      69, 90, 100, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const TaskScreen()));
                                              },
                                              child: Container(
                                                height: 2.5.h,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  color:
                                                  const Color(0xFF3B3631),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "VIEW ALL",
                                                    style: TextStyle(
                                                      color: kWhiteColor,
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(
                                              Icons.keyboard_arrow_up_rounded,
                                              color: kThemeColor,
                                              size: 3.h,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          //task 1
                                          tasks.length >= 1 ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetailsScreen(index: tasks[0].id!,isAssignedByMeTask: false,)));
                                            },
                                            child: Container(
                                              // height: 15.h,
                                              width: 95.w,
                                              decoration: BoxDecoration(
                                                color: kWhiteColor,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 5,
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "${tasks[0].title}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: const Color(0xFF252930),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            customContainer(
                                                                label: "Phone",
                                                                kData: ": ${tasks[0].assignedTo!.phone}"),
                                                            customContainer(
                                                                label: "Due Date",
                                                                kData: ": ${dateFormation(date: DateFormat("d MMM y").format(DateTime.parse(tasks[0].dueDate!)))}"),
                                                            customContainer(
                                                                label: "Assigned By",
                                                                kData: ": ${tasks[0].assignedTo!.name}"),
                                                            customContainer(
                                                                label: "Note",
                                                                kData: ":  ${tasks[0].description}."),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 22.5.sp,
                                                          color: const Color(
                                                              0xFF102048),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  tasks[0].urgent == true ? Positioned(
                                                    left: 69.5.w,
                                                    child: Container(
                                                      height: 3.h,
                                                      width: 20.w,
                                                      decoration:
                                                      const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topRight:
                                                          Radius.circular(
                                                              10),
                                                          bottomLeft:
                                                          Radius.circular(
                                                              10),
                                                        ),
                                                        color:
                                                        Color(0xFFFC694C),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child: Text(
                                                          "Urgent",
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'latoRagular',
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: 14.sp,
                                                            color: kWhiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ) : Positioned(child: SizedBox.shrink()),
                                                ],
                                              ),
                                            ),
                                          ) : SizedBox.shrink() ,
                                          //task 2
                                          const SizedBox(height: 10),
                                          tasks.length >= 2 ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetailsScreen(index: tasks[1].id!,isAssignedByMeTask: false,)));
                                            },
                                            child: Container(
                                              // height: 15.h,
                                              width: 95.w,
                                              decoration: BoxDecoration(
                                                color: kWhiteColor,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 5,
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "${tasks[1].title}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: const Color(0xFF252930),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            customContainer(
                                                                label: "Phone",
                                                                kData: ": ${tasks[1].assignedTo!.phone}"),
                                                            customContainer(
                                                                label: "Due Date",
                                                                kData: ": ${dateFormation(date: DateFormat("d MMM y").format(DateTime.parse(tasks[1].dueDate!)))}"),
                                                            customContainer(
                                                                label: "Assigned By",
                                                                kData: ": ${tasks[1].assignedTo!.name}"),
                                                            customContainer(
                                                                label: "Note",
                                                                kData: ":  ${tasks[1].description}."),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 22.5.sp,
                                                          color: const Color(
                                                              0xFF102048),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  tasks[1].urgent == true ? Positioned(
                                                    left: 69.5.w,
                                                    child: Container(
                                                      height: 3.h,
                                                      width: 20.w,
                                                      decoration:
                                                      const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topRight:
                                                          Radius.circular(
                                                              10),
                                                          bottomLeft:
                                                          Radius.circular(
                                                              10),
                                                        ),
                                                        color:
                                                        Color(0xFFFC694C),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child: Text(
                                                          "Urgent",
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'latoRagular',
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: 14.sp,
                                                            color: kWhiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ) : Positioned(child: SizedBox.shrink()),
                                                ],
                                              ),
                                            ),
                                          ) : SizedBox.shrink(),
                                          //task 3
                                          const SizedBox(height: 10),
                                          tasks.length >= 3 ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetailsScreen(index: tasks[2].id!,isAssignedByMeTask: false,)));
                                            },
                                            child: Container(
                                              // height: 15.h,
                                              width: 95.w,
                                              decoration: BoxDecoration(
                                                color: kWhiteColor,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 5,
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "${tasks[2].title}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: const Color(0xFF252930),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            customContainer(
                                                                label: "Phone",
                                                                kData: ": ${tasks[2].assignedTo!.phone}"),
                                                            customContainer(
                                                                label: "Due Date",
                                                                kData: ": ${dateFormation(date: DateFormat("d MMM y").format(DateTime.parse(tasks[2].dueDate!)))}"),
                                                            customContainer(
                                                                label: "Assigned By",
                                                                kData: ": ${tasks[2].assignedTo!.name}"),
                                                            customContainer(
                                                                label: "Note",
                                                                kData: ":  ${tasks[2].description}."),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 22.5.sp,
                                                          color: const Color(
                                                              0xFF102048),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  tasks[2].urgent == true ? Positioned(
                                                    left: 69.5.w,
                                                    child: Container(
                                                      height: 3.h,
                                                      width: 20.w,
                                                      decoration:
                                                      const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topRight:
                                                          Radius.circular(
                                                              10),
                                                          bottomLeft:
                                                          Radius.circular(
                                                              10),
                                                        ),
                                                        color:
                                                        Color(0xFFFC694C),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child: Text(
                                                          "Urgent",
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'latoRagular',
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: 14.sp,
                                                            color: kWhiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ) : Positioned(child: SizedBox.shrink()),
                                                ],
                                              ),
                                            ),
                                          ) : SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (isVisible)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() =>
                              (isNotVisible = !isNotVisible) ==
                                  (isVisible = !isVisible));
                            },
                            child: Container(
                              height: 7.h,
                              width: 90.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kWhiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Tasks",
                                      style: kTitleTextStyle,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: kThemeColor,
                                      size: 3.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  //End Of Task Section


                  //Schedule
                  Consumer<SchadualProvider>(
                      builder: (context,schadualProvider,child){
                        return FutureBuilder<NextSevendayWorkSchadual?>(
                            future: schadualProvider.getNextSevenDayWorkingDay(),
                            builder: (context,snapsort){
                              if(snapsort.hasData){
                                return  Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 10, bottom: 20, left: 10),
                                  child: Container(
                                    width: 95.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kWhiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "My Next 7 Day’s Schedule",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF102048),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => const AllSchedule(isFirst: true,)));
                                                },
                                                child: Container(
                                                  height: 3.h,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: const Color(0xFF3B3631),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "VIEW ALL",
                                                      style: TextStyle(
                                                        fontFamily: 'latoRagular',
                                                        color: kWhiteColor,
                                                        fontSize: 12.5.sp,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 6.h,
                                              width: 95.w,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: snapsort.data!.data!.length,
                                                  itemBuilder: (context,int index){
                                                    if(snapsort.data!.data![index].workingDay == true &&
                                                        snapsort.data!.data![index].leave == false &&
                                                        snapsort.data!.data![index].weekend == false &&
                                                        snapsort.data!.data![index].holiday == false){
                                                      return Padding(
                                                        padding: EdgeInsets.only(left: 2.w),
                                                        child: customDay(snapsort.data!.data![index].day!.toUpperCase(), const Color(0xFF04BF00)),
                                                      );
                                                    }else if(snapsort.data!.data![index].workingDay == false &&
                                                        snapsort.data!.data![index].leave == true &&
                                                        snapsort.data!.data![index].weekend == false &&
                                                        snapsort.data!.data![index].holiday == false){
                                                      return Padding(
                                                        padding: EdgeInsets.only(left: 2.w),
                                                        child: customDay(snapsort.data!.data![index].day!.toUpperCase(), const Color(0xFF7887C2)),
                                                      );
                                                    }else if(snapsort.data!.data![index].workingDay == false &&
                                                        snapsort.data!.data![index].leave == false &&
                                                        snapsort.data!.data![index].weekend == true &&
                                                        snapsort.data!.data![index].holiday == false){
                                                      return Padding(
                                                        padding: EdgeInsets.only(left: 2.w),
                                                        child: customDay(snapsort.data!.data![index].day!.toUpperCase(), const Color(0xFFFF6347)),
                                                      );
                                                    }else if(snapsort.data!.data![index].workingDay == false &&
                                                        snapsort.data!.data![index].leave == false &&
                                                        snapsort.data!.data![index].weekend == false &&
                                                        snapsort.data!.data![index].holiday == true){
                                                      return Padding(
                                                        padding: EdgeInsets.only(left: 2.w),
                                                        child: customDay(snapsort.data!.data![index].day!.toUpperCase(), const Color(0xFF3E425D)),
                                                      );
                                                    }else{
                                                      return Padding(
                                                        padding: EdgeInsets.only(left: 2.w),
                                                        child: customDay("${snapsort.data!.data![index].day!.toUpperCase()} *", const Color.fromRGBO(30, 80, 235, .8)),
                                                      );
                                                    }
                                                  }
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              dayType("WORKING DAY", const Color(0xFF04BF00)),
                                              dayType("LEAVE", const Color(0xFF7887C2)),
                                              dayType("WEEKEND", const Color(0xFFFF6347)),
                                              dayType("HOLIDAY", const Color(0xFF3E425D)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 10, bottom: 20, left: 10),
                                  child: Container(
                                    width: 95.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kWhiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                    child: Center(child: CircularProgressIndicator(),)
                                  ),
                                );
                              }
                            },
                        );
                      }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addNoticeDialog(){
    return Consumer<AllNoticeProvider>(
        builder: (context,allNoticeProvider,child){
          return StatefulBuilder(
              builder: (context,setState){
                return SingleChildScrollView(
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    insetPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 170),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7.5,bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add New Notice",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                    height: 4.h,
                                    width: 8.w,
                                    child: const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Image(
                                        image: AssetImage("assets/images/cancel.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //From Date
                          InkWell(
                            onTap: () async {
                              DateTime? fromPickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2040),
                              );
                              if (fromPickedDate != null) {
                                setState(
                                      () {
                                    noticeFromDate.text = DateFormat('yyyy-MM-dd')
                                        .format(fromPickedDate);
                                  },
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextField(
                                enabled: false,
                                controller: noticeFromDate,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  label: const Text(
                                    "From Date *",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102048),
                                    ),
                                  ),

                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                  suffixIcon: Icon(Icons.calendar_month_outlined,size: 18.sp,),
                                  // Icon(Icons.calendar_month_outlined),
                                  hintText: "yyyy-MM-dd",
                                  hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                  border:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kLightGreyColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: kLightGreyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                ),
                              ),
                            ),
                          ),

                          //To Date
                          InkWell(
                            onTap: () async {
                              DateTime? toPickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(noticeFromDate.text),
                                firstDate: DateTime.parse(noticeFromDate.text),
                                lastDate: DateTime(2040),
                              );
                              if (toPickedDate != null) {
                                setState(
                                      () {
                                    noticeToDate.text = DateFormat('yyyy-MM-dd')
                                        .format(toPickedDate);
                                  },
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextField(
                                enabled: false,
                                controller: noticeToDate,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  label: const Text(
                                    "To *",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102048),
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                  suffixIcon: Icon(Icons.calendar_month_outlined,size: 18.sp),
                                  // Icon(Icons.calendar_month_outlined),
                                  hintText: "yyyy-MM-dd",
                                  hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                  border:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kLightGreyColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: kLightGreyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //Notice type
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: DropdownButtonFormField<NoticeType>(
                                hint: Text(
                                  "Notice type",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  label: Text(
                                    "Notice type * ",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102048),
                                    ),
                                  ),
                                  hintText: "Select a notice type",
                                  hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kLightGreyColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kLightGreyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (NoticeType? newValue) {
                                  setState(() {
                                    dropDownnoticeType = newValue!;
                                    print(dropDownnoticeType!.name);
                                  });
                                },
                                items: noticeTypeList.map<DropdownMenuItem<NoticeType>>((NoticeType? value) {
                                  return DropdownMenuItem<NoticeType>(
                                    value: value,
                                    child: Text(
                                      value!.name!,
                                      style: const TextStyle(
                                        fontFamily: 'latoRagular',
                                        color: kThemeColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),


                          //Department
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: DropdownButtonFormField<Divisions>(
                                hint: Text(
                                  "Department",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  label: Text(
                                    "Department * ",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102048),
                                    ),
                                  ),
                                  hintText: "Select a department",
                                  hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kLightGreyColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kLightGreyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (Divisions? newValue) async {
                                  dropDowndivisions = newValue;
                                  submitSubDepartment.clear();
                                  subDepartmentList.clear();
                                  print(dropDowndivisions!.name);
                                  await allNoticeProvider.getAllSubDepartment(dropDowndivisions!.id!).then((value){
                                    setState(() {
                                      value!.subDepartment!.forEach((element) {
                                        subDepartmentList.add(element);
                                      });
                                    });
                                  });
                                },
                                items: departmentList.map<DropdownMenuItem<Divisions>>((Divisions value) {
                                  return DropdownMenuItem<Divisions>(
                                    value: value,
                                    child: Text(
                                      value.name!,
                                      style: const TextStyle(
                                        fontFamily: 'latoRagular',
                                        color: kThemeColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),


                          //Sub Department
                          subDepartmentList.isEmpty == true ?
                          SizedBox.shrink() : SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: DropdownButtonFormField<SubDepartment>(
                                hint: Text(
                                  "Sub Department",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  label: Text(
                                    "Sub Department",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102048),
                                    ),
                                  ),
                                  hintText: "Select a sub department",
                                  hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 14.5.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kLightGreyColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kLightGreyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (SubDepartment? newValue) {
                                  setState(() {
                                    if(submitSubDepartment.contains(newValue) == true){
                                      customWidget.showCustomSnackbar(context, "Sub department already exist in the list");
                                    }
                                    else if(newValue!.name == "Select a sub department"){
                                      customWidget.showCustomSnackbar(context, "Please select a department");
                                    }else{
                                      submitSubDepartment.add(newValue);
                                      print(submitSubDepartment.length);
                                    }
                                  });
                                },
                                items: subDepartmentList.map<DropdownMenuItem<SubDepartment>>((SubDepartment value) {
                                  return DropdownMenuItem<SubDepartment>(
                                    value: value,
                                    child: Text(
                                      value.name!,
                                      style: const TextStyle(
                                        fontFamily: 'latoRagular',
                                        color: kThemeColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),


                          submitSubDepartment.isEmpty == true ?
                          SizedBox.shrink() :
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 6.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color.fromRGBO(12, 12, 12, .1),width: 1,),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                  itemCount: submitSubDepartment.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context,int index){
                                    return Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(205, 205, 205, 1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        height: 5.h,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${submitSubDepartment[index].name}",
                                              style: TextStyle(
                                                fontFamily: 'latoRagular',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(12, 12, 12, 1),
                                                fontSize: 14.5.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                              width: 6.w,
                                              child: IconButton(
                                                  onPressed: (){
                                                    setState((){
                                                      submitSubDepartment.removeAt(index);
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Color.fromRGBO(12, 12, 12, 1),
                                                    size: 14,
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ),


                          //Notice
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: SizedBox(
                              child: TextField(
                                controller: notice,
                                maxLines: maxLines,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: "Notice ....",
                                  hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 15.sp,
                                  ),
                                  label: const Text(
                                    "Notice * ",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102048),
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                  border:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kLightGreyColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: kLightGreyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          //Submit Button
                          Consumer<AllNoticeProvider>(
                              builder: (context, allNoticeProvider, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  child: SizedBox(
                                    height: 6.h,
                                    width: 100.w,
                                    child: TextButton(
                                      onPressed: () {
                                        if(noticeFromDate.text.isEmpty == true){
                                          customWidget.showCustomSnackbar(context, "Please fill the notice from date");
                                        }else if(noticeToDate.text.isEmpty == true){
                                          customWidget.showCustomSnackbar(context, "Please fill the notice to date");
                                        }else if(dropDownnoticeType == null){
                                          customWidget.showCustomSnackbar(context, "Please select a notice type");
                                        }else if(dropDowndivisions == null){
                                          customWidget.showCustomSnackbar(context, "Please select a department");
                                        }else if(notice.text.isEmpty == true){
                                          customWidget.showCustomSnackbar(context, "Please fill the notice description");
                                        }else{
                                          setState((){
                                            List<int> subDepartmentId = [];
                                            if(submitSubDepartment.isNotEmpty == true){
                                              submitSubDepartment.forEach((element) {
                                                subDepartmentId.add(element.id!);
                                              });
                                            }
                                            Map<String,dynamic> data = {
                                              "office_division_id": dropDowndivisions!.id,
                                              "department_id": subDepartmentId,
                                              "from_date": noticeFromDate.text,
                                              "to_date": noticeToDate.text,
                                              "notice_type_id": dropDownnoticeType!.id,
                                              "notice": notice.text,
                                              "status": true
                                            };
                                            print(jsonEncode(data));
                                            allNoticeProvider.createNotice(
                                                data: data,
                                                onSuccess: (e){
                                                  setState((){
                                                    customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
                                                  });
                                                },
                                                onFail: (e){
                                                  setState((){
                                                    customWidget.showCustomSnackbar(context, "${e}");
                                                    Navigator.pop(context);
                                                  });
                                                }
                                            );
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          const Color(0xFF1294F2),
                                        ),
                                      ),
                                      child: Text(
                                        "Publish",
                                        style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            color: kWhiteColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          )

                        ],
                      ),
                    ),

                  ),
                );
              }
          );
        }
    );
  }

  Widget buildFloatingButton() => FloatingActionButton(
      child: Icon(Icons.edit),
      onPressed: (){}

  );

}


String dateFormation({required String date}){
  String formattedDate = date.replaceFirstMapped(
    RegExp(r'\d+'),
        (match) {
      int day = int.parse(match.group(0)!);
      String suffix = _getDaySuffix(day);
      return '$day$suffix';
    },
  );
  return formattedDate;
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

Widget customContainer({required label, required kData}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: 2.h,
        width: 20.w,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'latoRagular',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF808080),
          ),
        ),
      ),
      SizedBox(
        height: 2.h,
        width: 55.w,
        child: Text(
          kData,
          style: TextStyle(
            fontFamily: 'latoRagular',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF808080),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget customDay(day, kColor) {
  return Tooltip(
    message: 'Duty Time\n9:00 AM - 3:00PM',
    textAlign: TextAlign.center,
    padding: const EdgeInsets.all(5),
    showDuration: const Duration(seconds: 5),
    decoration: ShapeDecoration(
      color: Colors.blue,
      shape: ToolTipCustomShape(),
    ),
    textStyle: const TextStyle(color: Colors.white),
    preferBelow: false,
    child: Container(
      alignment: Alignment.center,
      height: 5.h,
      width: 5.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kColor,
      ),
      child: Text(day,
          style: TextStyle(
              fontFamily: 'latoRagular',
              color: kWhiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.5.sp)),
    ),
  );
}

Widget dayType(day, color) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      children: [
        Container(
          height: 1.h,
          width: 2.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 3),
          child: Text(
            day,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF102048),
            ),
          ),
        ),
      ],
    ),
  );
}


String formatTime(String? timestamp) {
  if (timestamp == null) {
    return 'N/A';
  }

  int millisecondsSinceEpoch;
  try {
    millisecondsSinceEpoch = int.parse(timestamp);
  } catch (e) {
    print('Error parsing timestamp: $e');
    return '';
  }

  DateTime dateTime =
  DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(dateTime);
}

Widget buildFloatingButton() => FloatingActionButton(
    child: Icon(Icons.edit),
    onPressed: (){}

);

//Add Notice Alert Dialog
