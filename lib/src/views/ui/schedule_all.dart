import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../business_logics/models/scadual_calender_class/per_date_data.dart';
import '../../business_logics/models/scadual_calender_class/scadual_calender_class.dart';
import '../../business_logics/providers/schadual_provider.dart';
import 'bottomnav/bottomnav_screen_layout.dart';

class AllSchedule extends StatefulWidget {
  const AllSchedule({Key? key,required this.isFirst}) : super(key: key);
  final bool isFirst;
  @override
  State<AllSchedule> createState() => _AllScheduleState();
}


class _AllScheduleState extends State<AllSchedule> {
  static int month = 0;
  static int year = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isFirst == true){
      setState(() {
        month = DateTime.now().month;
        year = DateTime.now().year;
        SchadualProvider schadualProvider = Provider.of<SchadualProvider>(context, listen: false);
        schadualProvider.perDateData.clear();
        schadualProvider.allDateData.clear();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      body: WillPopScope(
        onWillPop: () async {
          SchadualProvider schadualProvider = Provider.of<SchadualProvider>(context, listen: false);
          schadualProvider.perDateData.clear();
          schadualProvider.allDateData.clear();
          month = 0;
          year = 0;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
          return true;
        },
        child: RefreshIndicator(
          onRefresh: ()async {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AllSchedule(isFirst: false,)));
          },
          child: SafeArea(
            child: Consumer<SchadualProvider>(
              builder: (context,schudaleProvider,child){
                return FutureBuilder<PerWeekSchedualWork?>(
                    future: schudaleProvider.getPerWeekWorkSchadual(),
                    builder: (context,snapsort){
                      if(snapsort.hasData){
                        return CustomScrollView(
                          slivers: [

                            SliverToBoxAdapter(
                              child: FutureBuilder<List<PerDateData>?>(
                                future: schudaleProvider.getTheSchudleCalender(year: year, month: month),
                                builder: (context,snapsort){
                                  if(snapsort.hasData){
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                        color: const Color(0xFFEAF4F2),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 5,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      setState((){
                                                        month = month! - 1;
                                                        print(month);
                                                        if(month! <= 0){
                                                          month = 12;
                                                          year = year! - 1;
                                                        }
                                                        schudaleProvider.perDateData.clear();
                                                        schudaleProvider.allDateData.clear();
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AllSchedule(isFirst: false,)));
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: kThemeColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${DateFormat("MMMM").format(DateTime(year!,month!)).toString().toUpperCase()} ${DateFormat("yyyy").format(DateTime(year!)).toString().toUpperCase()}",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: kThemeColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        month = month! + 1;
                                                        print(month);
                                                        if(month! > 12){
                                                          month = 1;
                                                          year = year! + 1;
                                                        }
                                                        schudaleProvider.perDateData.clear();
                                                        schudaleProvider.allDateData.clear();
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AllSchedule(isFirst: false,)));
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_forward_ios_rounded,
                                                      color: kThemeColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 1,
                                              thickness: 1,
                                              color: kThemeColor,
                                            ),

                                            //Day Name
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: const [
                                                  Text("SUN"),
                                                  Text("MON"),
                                                  Text("TUE"),
                                                  Text("WED"),
                                                  Text("THU"),
                                                  Text("FRI"),
                                                  Text("SAT"),
                                                ],
                                              ),
                                            ),

                                            //Date
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapsort.data!.length,
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 7,
                                                  childAspectRatio: 1.0,
                                                  mainAxisSpacing: 10.0,
                                                  crossAxisSpacing: 10.0,
                                                ),
                                                itemBuilder: (_, index) {
                                                  if(snapsort.data![index].workingDay == true
                                                      && snapsort.data![index].holiday == false
                                                      && snapsort.data![index].leave == false
                                                      && snapsort.data![index].weekend == false ){
                                                    return InkWell(
                                                      onTap: (){
                                                        showDialog(
                                                            context: context,
                                                            builder: (_){
                                                              return AlertDialog(
                                                                contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                                                titlePadding: EdgeInsets.zero,
                                                                title: Container(
                                                                  height: 31.h,
                                                                  width: 45.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                          Icons.check_circle_outline,
                                                                                          color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Working Day",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Leave",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                          Icons.check_circle_outline,
                                                                                          color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Holiday",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                         color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Weekend",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
                                                                        child: SizedBox(
                                                                          height: 5.h,
                                                                          width: 20.w,
                                                                          child: Center(
                                                                            child: IconButton(
                                                                                onPressed: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.clear,color: Color.fromRGBO(12, 12, 12, 1),size: 18,)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 1.5.h,
                                                        width: 3.w,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color:  const Color(0xFF04BF00),
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Sunday" ? "${index + 1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Monday" ? "${index}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Tuesday" ? "${index-1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Wednesday" ? "${index-2}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Thursday" ? "${index-3}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Friday" ? "${index-4}" : "${index-5}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 17.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: kWhiteColor,
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }else if(snapsort.data![index].workingDay == false
                                                      && snapsort.data![index].holiday == false
                                                      && snapsort.data![index].leave == true
                                                      && snapsort.data![index].weekend == false){
                                                    return InkWell(
                                                      onTap: (){
                                                        showDialog(
                                                            context: context,
                                                            builder: (_){
                                                              return AlertDialog(
                                                                contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                                                titlePadding: EdgeInsets.zero,
                                                                title: Container(
                                                                  height: 31.h,
                                                                  width: 45.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Working Day",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Leave",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Holiday",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Weekend",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
                                                                        child: SizedBox(
                                                                          height: 5.h,
                                                                          width: 20.w,
                                                                          child: Center(
                                                                            child: IconButton(
                                                                                onPressed: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.clear,color: Color.fromRGBO(12, 12, 12, 1),size: 18,)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 1.5.h,
                                                        width: 3.w,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(0xFF7887C2),
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Sunday" ? "${index + 1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Monday" ? "${index}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Tuesday" ? "${index-1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Wednesday" ? "${index-2}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Thursday" ? "${index-3}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Friday" ? "${index-4}" : "${index-5}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 17.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: kWhiteColor,
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }else if(snapsort.data![index].workingDay == false
                                                      && snapsort.data![index].holiday == false
                                                      && snapsort.data![index].leave == false
                                                      && snapsort.data![index].weekend == true ){
                                                    return InkWell(
                                                      onTap: (){
                                                        showDialog(
                                                            context: context,
                                                            builder: (_){
                                                              return AlertDialog(
                                                                contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                                                titlePadding: EdgeInsets.zero,
                                                                title: Container(
                                                                  height: 31.h,
                                                                  width: 45.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Working Day",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Leave",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Holiday",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Weekend",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
                                                                        child: SizedBox(
                                                                          height: 5.h,
                                                                          width: 20.w,
                                                                          child: Center(
                                                                            child: IconButton(
                                                                                onPressed: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.clear,color: Color.fromRGBO(12, 12, 12, 1),size: 18,)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 1.5.h,
                                                        width: 3.w,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(0xFFFF6347),
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Sunday" ? "${index + 1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Monday" ? "${index}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Tuesday" ? "${index-1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Wednesday" ? "${index-2}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Thursday" ? "${index-3}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Friday" ? "${index-4}" : "${index-5}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 17.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: kWhiteColor,
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }else if(snapsort.data![index].workingDay == false
                                                      && snapsort.data![index].holiday == true
                                                      && snapsort.data![index].leave == false
                                                      && snapsort.data![index].weekend == false ){
                                                    return InkWell(
                                                      onTap: (){
                                                        showDialog(
                                                            context: context,
                                                            builder: (_){
                                                              return AlertDialog(
                                                                contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                                                titlePadding: EdgeInsets.zero,
                                                                title: Container(
                                                                  height: 36.h,
                                                                  width: 45.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Working Day",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Leave",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 8.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 8.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Holiday (${snapsort.data![index].holiday_title})",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Weekend",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
                                                                        child: SizedBox(
                                                                          height: 5.h,
                                                                          width: 20.w,
                                                                          child: Center(
                                                                            child: IconButton(
                                                                                onPressed: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.clear,color: Color.fromRGBO(12, 12, 12, 1),size: 18,)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 1.5.h,
                                                        width: 3.w,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(0xFF3E425D),
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Sunday" ? "${index + 1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Monday" ? "${index}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Tuesday" ? "${index-1}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Wednesday" ? "${index-2}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Thursday" ? "${index-3}" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Friday" ? "${index-4}" : "${index-5}",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 17.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: kWhiteColor,
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }else if(snapsort.data![index].workingDay == false
                                                      && snapsort.data![index].holiday == false
                                                      && snapsort.data![index].leave == false
                                                      && snapsort.data![index].weekend == false ){
                                                    return Container(
                                                      height: 1.5.h,
                                                      width: 3.w,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(0xFFEAF4F2),
                                                      ),
                                                    );
                                                  }else {
                                                    return InkWell(
                                                      onTap: (){
                                                        showDialog(
                                                            context: context,
                                                            builder: (_){
                                                              return AlertDialog(
                                                                contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                                                titlePadding: EdgeInsets.zero,
                                                                title: Container(
                                                                  height: 36.h,
                                                                  width: 45.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Working Day",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].workingDay == true ? Color(0xFF04BF00) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Leave",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].leave == true ? Color(0xFF7887C2) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 8.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 8.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Holiday (${snapsort.data![index].holiday_title})",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].holiday == true ? Color(0xFF3E425D) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                            Container(
                                                                              height: 5.h,
                                                                              width: 50.w,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromRGBO(245, 245, 245, 1),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 4.h,
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.check_circle_outline,
                                                                                        color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 2.h,),
                                                                                  Container(
                                                                                    height: 4.h,
                                                                                    width: 35.w,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        "Weekend",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'latoRagular',
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: snapsort.data![index].weekend == true ? Color(0xFFFF6347) : Color.fromRGBO(12, 12, 12, .2),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2.h,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
                                                                        child: SizedBox(
                                                                          height: 5.h,
                                                                          width: 20.w,
                                                                          child: Center(
                                                                            child: IconButton(
                                                                                onPressed: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.clear,color: Color.fromRGBO(12, 12, 12, 1),size: 18,)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 1.5.h,
                                                        width: 3.w,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color.fromRGBO(30, 80, 235, .8),
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Sunday" ? "${index + 1} *" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Monday" ? "${index} *" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Tuesday" ? "${index-1} *" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Wednesday" ? "${index-2} *" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Thursday" ? "${index-3} *" :
                                                              DateFormat("EEEE").format(DateTime(year,month,1)) == "Friday" ? "${index-4} *" : "${index-5} *",
                                                              style: TextStyle(
                                                                fontFamily: 'latoRagular',
                                                                fontSize: 17.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: kWhiteColor,
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            //
                                          ],
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                        color: const Color(0xFFEAF4F2),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 5,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                      child: const Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      ),
                                    );
                                  }
                                },
                              )
                            ),

                            SliverToBoxAdapter(
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 20,bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    colorIndigator(const Color(0xFF04BF00), "WORKING DAY"),
                                    const SizedBox(width: 10),
                                    colorIndigator(const Color(0xFF7887C2), "LEAVE"),
                                    const SizedBox(width: 10),
                                    colorIndigator(const Color(0xFFFF6347), "WEEKEND"),
                                    const SizedBox(width: 10),
                                    colorIndigator(const Color(0xFF3E425D), "HOLIDAY"),
                                  ],
                                ),
                              ),
                            ),

                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                      (context, int index){
                                    return taskList(perWeekSchedualWorkList: snapsort.data!.perWeekSchedualWorkList![index]);
                                  },
                                  childCount: snapsort.data!.perWeekSchedualWorkList!.length
                              ),
                            ),
                          ],
                        );
                      }else{
                        return Container(
                          height: MediaQuery.of(context).size.height/1,
                          width: MediaQuery.of(context).size.width/1,
                          child: Center(child: CircularProgressIndicator(),),
                        );
                      }
                    }
                );
              },
            ),
          ),
        ),
      )
    );
  }
}

Widget colorIndigator(color, titel) {
  return Row(
    children: [
      Container(
        height: 1.5.h,
        width: 3.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2, right: 3),
        child: Text(
          titel,
          style: TextStyle(
            fontFamily: 'latoRagular',
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF102048),
          ),
        ),
      ),
    ],
  );
}



Widget taskList({required PerWeekSchedualWorkList perWeekSchedualWorkList}){
  return Padding(
    padding: const EdgeInsets.only(top: 10,left: 12,right: 12),
    child: Container(
      height: 12.5.h,
      width: 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kWhiteColor,
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
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  perWeekSchedualWorkList.dayName!,
                  style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF04BF00)),
                ),
                Text(
                  "${perWeekSchedualWorkList.date!.split(" ")[0]} ${perWeekSchedualWorkList.date!.split(" ")[1]}",
                  style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF04BF00)),
                ),
                Text(
                  "${perWeekSchedualWorkList.date!.split(" ")[2]}",
                  style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF04BF00)),
                ),
              ],
            ),
            VerticalDivider(
              width: 7.5.w,
              thickness: 1,
              color: const Color(0xFF313133),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Duty Time",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    color: const Color(0xFF3B455A).withOpacity(0.65),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                Text("${perWeekSchedualWorkList.startTime} - ${perWeekSchedualWorkList.endTime}",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    color: const Color(0xFF3B455A),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text("Duty Area/ Location",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    color: const Color(0xFF3B455A).withOpacity(0.65),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                Text(perWeekSchedualWorkList.dutyArea == null ? "N/A" : "${perWeekSchedualWorkList.dutyArea}",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    color: const Color(0xFF3B455A),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Grace Time",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      color: const Color(0xFFFC694C).withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text("${perWeekSchedualWorkList.graceInTime}",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      color: const Color(0xFFFC694C),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
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
