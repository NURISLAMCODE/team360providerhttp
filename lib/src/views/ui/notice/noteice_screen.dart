import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/providers/all_notice_provider.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../../business_logics/models/all_notice_response_model.dart';
import '../../../business_logics/models/notice_model/department_list_class.dart';
import '../../../business_logics/models/notice_model/notice_type_class.dart';
import '../../../business_logics/models/notice_model/sub_department_list_class.dart';
import '../../../services/shared_preference_services/shared_preference_services.dart';
import '../../widgets/custom_widget.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);
  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  String dropdownLeaveValue = "Team";
  final maxLines = 5;
  TextEditingController noticeFromDate = TextEditingController();
  TextEditingController noticeToDate = TextEditingController();
  TextEditingController notice = TextEditingController();
  String? dropDownValue = "";
  NoticeType? dropDownnoticeType;
  Divisions? dropDowndivisions;
  SubDepartment? dropDownSubDepartment;
  List<NoticeType> noticeTypeList = [];
  List<Divisions> departmentList = [];
  List<SubDepartment> submitSubDepartment = [];
  List<SubDepartment> subDepartmentList = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 1),() async {
      AllNoticeProvider allNoticeProvider = Provider.of<AllNoticeProvider>(context, listen: false);
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
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4F2),
        drawer: const DrawerScreen(),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEAF4F2),
          elevation: 0,
          // title: const Text(
          //   "Good Morning, Imran",
          //   style: kTitleTextStyle,
          // ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeList()));
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
        body: isLoading == true ?
        Container(
          height: MediaQuery.of(context).size.height / 1,
          width: MediaQuery.of(context).size.width / 1,
          child: const Center(
            child: CircularProgressIndicator()
          ),
        ) : Consumer<AllNoticeProvider>(
          builder: (context,allNoticeProvider,child){
            return FutureBuilder<AllNoticeResponseModel?>(
                future: allNoticeProvider.getAllNoticeInNoticePage(),
                builder: (context,snapsort){
                  if(snapsort.hasData){
                    return CustomScrollView(
                      slivers: [

                        SliverAppBar(
                          expandedHeight: 5.h,
                          backgroundColor: const Color(0xFFEAF4F2),
                          automaticallyImplyLeading: false,
                          pinned: true,
                          floating: false,
                          flexibleSpace: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 4.5.h,
                                  width: 9.w,
                                  decoration: const BoxDecoration(),
                                  child: TextButton(
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset("assets/images/arrow_left.png"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "All Notice",
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
                        ),

                        SliverFillRemaining(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
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
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                              ),
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context,int index){
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: const Color(0xFFE2F1FF),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: const Offset(0, 1),
                                                            blurRadius: 3,
                                                            color: Colors.grey.withOpacity(0.3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 10,bottom: 10),
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  """${snapsort.data!.data!.notices![index].notice}""",
                                                                  style: TextStyle(
                                                                    fontFamily: 'latoRagular',
                                                                    fontSize: 15.sp,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: const Color(
                                                                      0xFF141414,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                RichText(
                                                                  text: TextSpan(
                                                                    text:
                                                                    'Published By : ${snapsort.data!.data!.notices![index].users!.name}',
                                                                    style: TextStyle(
                                                                      fontFamily: 'latoRagular',
                                                                      fontSize: 14.sp,
                                                                      color: const Color(0xFF8390BB),
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: ' ${snapsort.data!.data!.notices![index].officeDivisions!.name}',
                                                                        style: TextStyle(
                                                                          fontFamily: 'latoRagular',
                                                                          fontSize: 11.sp,
                                                                          color: const Color(0xFF858585),
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  // "31st July 2022",
                                                                  _formatMillisecondsToDateString(snapsort.data!.data!.notices![index].createdAtUnix!),
                                                                  style: TextStyle(
                                                                    fontFamily: 'latoRagular',
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14.sp,
                                                                    color: kBlackColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SharedPrefsServices.getBoolData("isLead") == true
                                                      ? Positioned(
                                                    right: 3.w,
                                                    top: 1.h,
                                                    child: Container(
                                                      height: 4.h,
                                                      width: 8.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: kWhiteColor,
                                                          width: 2,
                                                        ),
                                                        color: Colors.blue,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await allNoticeProvider.getAllSubDepartment(snapsort.data!.data!.notices![index].officeDivisions!.id!).then((value){
                                                            if(value!.subDepartment!.isNotEmpty == true){
                                                              setState((){
                                                                submitSubDepartment.clear();
                                                                subDepartmentList.clear();
                                                                value!.subDepartment!.forEach((element) {
                                                                  subDepartmentList.add(element);
                                                                });
                                                              });
                                                            }
                                                          });
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return  editNoticeDialog(notices: snapsort.data!.data!.notices![index]);
                                                            },
                                                          );
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(6),
                                                          child: Image(
                                                            image: AssetImage(
                                                              "assets/images/pen.png",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                      : const SizedBox.shrink(),

                                                  SharedPrefsServices.getBoolData("isLead") == true
                                                      ? Positioned(
                                                    right: 3.w,
                                                    top: 10.h,
                                                    child: Container(
                                                      height: 4.h,
                                                      width: 8.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Color.fromRGBO(234, 34, 56, 1),
                                                          width: 2,
                                                        ),
                                                        color: Color.fromRGBO(234, 34, 56, 1),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context){
                                                                return AlertDialog(
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () async {
                                                                        await allNoticeProvider.deleteNotice(
                                                                            id: snapsort.data!.data!.notices![index].id!,
                                                                            onSuccess: (e){
                                                                              setState((){
                                                                                customWidget.showCustomSnackbar(context, "${e}");
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=> NoticeScreen()));
                                                                              });
                                                                            },
                                                                            onFail: (e){
                                                                              setState((){
                                                                                customWidget.showCustomSnackbar(context, "${e}");
                                                                                Navigator.pop(context);
                                                                              });
                                                                            }
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        height: 6.h,
                                                                        width: 20.w,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.redAccent,
                                                                          borderRadius: BorderRadius.circular(13),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "Yes",
                                                                            style: TextStyle(
                                                                              fontFamily: 'latoRagular',
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 20.sp,
                                                                              color: kBlackColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: TextButton(
                                                                        onPressed: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Container(
                                                                          height: 6.h,
                                                                          width: 20.w,
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.greenAccent,
                                                                            borderRadius: BorderRadius.circular(13),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              "No",
                                                                              style: TextStyle(
                                                                                fontFamily: 'latoRagular',
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 20.sp,
                                                                                color: kBlackColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  content: Text(
                                                                    "Do you want to delete the notice",
                                                                    style:  TextStyle(
                                                                      fontFamily: 'latoRagular',
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 20.sp,
                                                                      color: kBlackColor,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                          );
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(6),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 12,
                                                            color: Color.fromRGBO(245, 245, 245, 1),
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            );
                                          },
                                        childCount: snapsort.data!.data!.notices!.length
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
        )
      ),
    );

  }


  //Add Notice Alert Dialog
  Widget addNoticeDialog(){

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
                        height: 3.h,
                        width: 6.w,
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
                        "From Date",
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
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
                        "To",
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
              //For
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: DropdownButtonFormField<String>(
                    hint: Text(
                      "Team, Organization",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFC4C4C4),
                        fontSize: 14.5.sp,
                      ),
                    ),
                    // value: dropdownValue,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(10.0),
                      label: const Text(
                        "For",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF102048),
                        ),
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
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                    items: <String>[
                      "Team",
                      "Organization",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
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
                        "Notice",
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
                          // if(noticeToDate.text.isNotEmpty && noticeFromDate.text.isNotEmpty && dropDownValue.toString().isNotEmpty && notice.text.isNotEmpty){
                          //   _createNotice(allNoticeProvider);
                          //   Navigator.pop(context);
                          // }
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
  //Edit Notice Dialog
  Widget editNoticeDialog({required Notices notices}){
    noticeFromDate.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(notices.fromDate!));
    noticeToDate.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(notices.toDate!));
    notice.text = notices.notice!;
    dropDownnoticeType = noticeTypeList.where((element) => element.id == notices.noticeType!.id).first;
    subDepartmentList.isEmpty == true ? submitSubDepartment = [] : submitSubDepartment.add(subDepartmentList.where((element) => element.id == notices.departments!.id).first);
    dropDowndivisions = departmentList.where((element) => element.id == notices.officeDivisions!.id).first;
    return  Consumer<AllNoticeProvider>(
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
                                  "Edit Notice",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                  width: 10.w,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
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
                                value: dropDownnoticeType,
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

                          SizedBox(height: 5,),
                          // Container(
                          //   height: 2.h,
                          //   width: 100.w,
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       "Department",
                          //       style: TextStyle(
                          //         fontFamily: 'latoRagular',
                          //         fontWeight: FontWeight.w400,
                          //         color: Color.fromRGBO(12, 12, 12, 1),
                          //         fontSize: 14.5.sp,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          //
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 15),
                          //   child: Container(
                          //     height: 6.h,
                          //     width: 100.w,
                          //     padding: EdgeInsets.only(left: 14),
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Color.fromRGBO(12, 12, 12, .1),width: 1,),
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     child: Align(
                          //       alignment: Alignment.centerLeft,
                          //       child: Text(
                          //         "${dropDowndivisions!.name}",
                          //         style: TextStyle(
                          //           fontFamily: 'latoRagular',
                          //           fontWeight: FontWeight.w400,
                          //           color: Color.fromRGBO(12, 12, 12, 1),
                          //           fontSize: 14.5.sp,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

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
                                value: dropDowndivisions,
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

                          SizedBox(height: 1.h,),
                          // submitSubDepartment.isEmpty == true ? SizedBox.shrink() : Container(
                          //   height: 2.h,
                          //   width: 100.w,
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       "Sub Department",
                          //       style: TextStyle(
                          //         fontFamily: 'latoRagular',
                          //         fontWeight: FontWeight.w400,
                          //         color: Color.fromRGBO(12, 12, 12, 1),
                          //         fontSize: 14.5.sp,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                                            print(notices.id);
                                            Map<String,dynamic> data = {
                                              "office_division_id": dropDowndivisions!.id,
                                              "department_id": subDepartmentId.isEmpty == true ? null : subDepartmentId,
                                              "from_date": noticeFromDate.text,
                                              "to_date": noticeToDate.text,
                                              "notice_type_id": dropDownnoticeType!.id,
                                              "notice": notice.text,
                                              "status": true
                                            };
                                            print(jsonEncode(data));
                                            allNoticeProvider.updateNotice(
                                                id: notices.id!,
                                                data: data,
                                                onSuccess: (e){
                                                  setState((){
                                                    customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> NoticeScreen()));
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
                                        "Edit Notice",
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


  //Formated Time
  String _formatMillisecondsToDateString(String millisecondsString) {
    int milliseconds = int.tryParse(millisecondsString) ?? 0;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    String formattedDate = "${dateTime.day}${_getDaySuffix(dateTime.day)} ${_getMonthName(dateTime.month)} ${dateTime.year}";

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

  String _getMonthName(int month) {
    const List<String> monthNames = [
      "", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month];
  }

}
