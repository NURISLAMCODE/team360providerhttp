import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team360/src/business_logics/providers/attendance_provider.dart';
import 'package:team360/src/business_logics/providers/attendance_report_provider.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/tooltip.dart';
import 'package:intl/intl.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../business_logics/models/attendence_task_report.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/utils/log_debugger.dart';
import '../../services/shared_preference_services/shared_preference_services.dart';
import 'bottomnav/bottomnav_screen_layout.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String formatDate(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(1693205186049);
    final DateFormat formatter = DateFormat('EEEE, MMMM d y');
    return formatter.format(dateTime);
  }

  String dropdownLeaveValue = "ANNUAL LEAVE";
  final maxLines = 5;
  int selectedIndex = 0;
  String lat = "";
  String long = "";
  bool hasCheckedIn = false;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  bool isLongPressed = false;
  List<Result> results = [];
  int resultLenght = 0;
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      await _updateCurrentLocation();
      AttendanceReportProvider attendanceReportProvider = Provider.of<AttendanceReportProvider>(context, listen: false);
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
      // _loadCheckedInStatus();
      await checkLocationStatus();
    });
  }

  Future<void> checkLocationStatus() async {
    var status = await Permission.location.status;
    print(status.name.toString());
    if(status.isPermanentlyDenied || status.isDenied){
      var request = await Permission.location.request();
      if(request.isPermanentlyDenied || request.isDenied){
        setState(() {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_){
              return AlertDialog(
                content: const Text(
                  "Your location Service is not open. Please go to application setting",
                  style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontWeight: FontWeight.w600,
                      color: kBlackColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 1,)));
                    },
                    child: Text(
                      "Refresh",
                      style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontWeight: FontWeight.w600,
                          color: kBlackColor),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: Text(
                        "Go to app setting",
                        style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w600,
                            color: kBlackColor),
                      ),
                  ),
                ],
              );
            }
        );
        });
      }
    }
  }




  // void _loadCheckedInStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     hasCheckedIn = prefs.getBool('hasCheckedIn')!;
  //   });
  // }

  _attendanceInRequest(AttendaceProvider attendaceProvider) {
    if(long == "" && lat == ""){
      customWidget.showCustomSnackbar(context, "No Location Found!");
    }else{
      attendaceProvider.attendanceInRequestProvider(
        time: (DateTime.now().millisecondsSinceEpoch).toString(),
        location: "$lat,$long",
        remarks: "",
      ).then((value) async {
        if(value == true) {
          hasCheckedIn = true;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          SharedPrefsServices.setStringData("checkIn", (checkInTime?.millisecondsSinceEpoch).toString());
          prefs.setBool('hasCheckedIn', true);
          UserData.checkIn = (checkInTime?.millisecondsSinceEpoch).toString();
          customWidget.showCustomSuccessSnackbar(context, "${attendaceProvider.attandanceCheckInRespnseModel!.message}");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavScreenLayout(page: 1,),
              ));
          showDialog(
            context: context,
            builder: (context) {
              return successDialog(
                  context, "Checked In");
            },
          );
        } else {
          customWidget.showCustomSnackbar(context, "${attendaceProvider.errorResponse!.message}");
        }
      });
      // if (attendaceProvider.attandanceCheckInRespnseModel?.success == true) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("Successful"),
      //     ),
      //   );
      // }
    }
  }


  _attendanceOutRequest(AttendaceProvider attendaceProvider) {
    if(long == "" && lat == ""){
      customWidget.showCustomSnackbar(context, "No Location Found!");
    }else{
      attendaceProvider.attendanceOutRequestProvider(
        time: (DateTime.now().millisecondsSinceEpoch).toString(),
        location: "$lat,$long",
        remarks: "",
      ).then((value) async {
        if(value == true) {
          hasCheckedIn = false;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          SharedPrefsServices.setStringData("checkOut", (checkOutTime?.millisecondsSinceEpoch).toString());
          UserData.checkOut = (checkOutTime?.millisecondsSinceEpoch).toString();
          prefs.setBool('hasCheckedIn', false);
          customWidget.showCustomSuccessSnackbar(context, "${attendaceProvider.attendanceRequstModel!.message}");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavScreenLayout(page: 1,),
              ));
          showDialog(
            context: context,
            builder: (context) {
              return successDialog(context, "Checked Out");
            },
          );
        } else {
          customWidget.showCustomSnackbar(context, "${attendaceProvider.errorResponse!.message}");
        }
      });
    }
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

    Size size = MediaQuery.of(context).size;
    final mHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=> BottomNavScreenLayout(page: 0,),
          ),
        );
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AttendanceScreen()));
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFEAF4F2),
          drawer: const DrawerScreen(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: mHeight / 2.2,
                      width: size.width,
                      child: ClipRRect(
                        child: GoogleMap(
                          initialCameraPosition: initialCameraPosition,
                          markers: markers,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 6.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: kWhiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5.h,
                                width: 38.w,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedIndex = 0;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedIndex == 0
                                            ? const Color(0xFF1294F2)
                                            : kLightGreyColor),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Attendance",
                                    style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontWeight: FontWeight.w600,
                                        color: selectedIndex == 0
                                            ? kWhiteColor
                                            : kBlackColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Consumer<AttendanceReportProvider>(
                                  builder: (context, attendanceReportProvider, child) {
                                  return SizedBox(
                                    height: 5.h,
                                    width: 38.w,
                                    child: TextButton(
                                      onPressed: () {
                                        reportBottomSheets(context);
                                        setState(() {
                                          selectedIndex = 1;
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            selectedIndex == 0
                                                ? kLightGreyColor
                                                : const Color(0xFF1294F2)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                      child: Text("Report",
                                          style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontWeight: FontWeight.w600,
                                              color: selectedIndex == 1
                                                  ? kWhiteColor
                                                  : kBlackColor)),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: _updateCurrentLocation,
                    child: Container(
                      height: 6.h,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: kWhiteColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 4.h,
                              width: 6.w,
                              child: Image.asset(
                                  "assets/images/akar-icons_location.png"),
                            ),

                            SizedBox(
                              height: 4.h,
                              width: 60.w,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // "House-17, Road-17/A, Block-E, Banani Dhaka-1213 Bangladesh",
                                  "${lat},${long}",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    color: const Color(0xFF102048),
                                    fontSize: 15.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),


                            TextButton(
                              onPressed: (){
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context)=> BottomNavScreenLayout(page: 1,),
                                      ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 4.h,
                                    width: 4.5.w,
                                    child: Image.asset("assets/images/refresh.png"),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                    width: 10.w,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Refresh",
                                        style: (TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1294F2),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                results.isNotEmpty == true ?
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    results[resultLenght - 1].attendance!.isEmpty == true  ?
                    "$greeting, Entering Office ? Please Check IN" :
                    (DateTime.parse(results[resultLenght - 1].attendance![0].checkIn!).day) != (DateTime.now().day) ? "$greeting, Entering Office ? Please Check IN" :
                    results[resultLenght - 1].attendance![0].checkIn == null ? "$greeting, Entering Office ? Please Check IN" :
                    results[resultLenght - 1].attendance![0].checkOut == null ? "$greeting, Leaving Office ? Please Check Out" :
                    "$greeting, Entering Office ? Please Check IN",
                    style: const TextStyle(
                      fontFamily: 'latoRagular',
                      color: Color(0xFF465174),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ) : Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "$greeting, Entering Office ? Please Check IN",
                    style: const TextStyle(
                      fontFamily: 'latoRagular',
                      color: Color(0xFF465174),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),


                const Divider(
                  color: kBlackColor,
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                  height: 50,
                ),
                Text(
                  "${DateFormat("dd MMM . yyyy | hh:mm a").format(DateTime.now())}",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF465174),
                  ),
                ),

                Consumer<AttendaceProvider>(
                    builder: (context, attendaceProvider,child) {
                      if(results.isEmpty == true){
                        return GestureDetector(
                          onTap: () async {
                            if(results.isEmpty == true){
                              setState(() {
                                checkInTime = DateTime.now();
                                _attendanceInRequest(attendaceProvider);
                              });
                            }
                          },
                          child: checkInButton()
                        );
                      }else{
                        return GestureDetector(
                          onTap: () async {
                            if(results[resultLenght - 1].attendance!.isEmpty == true){
                              setState(() {
                                checkInTime = DateTime.now();
                                _attendanceInRequest(attendaceProvider);

                              });
                            } else if(results[resultLenght - 1].attendance![0].checkIn == null) {
                              setState(() {
                                // hasCheckedIn = false;
                                checkOutTime = DateTime.now();
                                _attendanceOutRequest(attendaceProvider);
                              });
                            }else if ((DateTime.parse(results[resultLenght - 1].attendance![0].checkIn!).day) != (DateTime.now().day)) {
                              setState(() {
                                checkInTime = DateTime.now();
                                _attendanceInRequest(attendaceProvider);

                              });
                            } else if(results[resultLenght - 1].attendance![0].checkOut == "null" || results[resultLenght - 1].attendance![0].checkOut == null) {
                              setState(() {
                                // hasCheckedIn = false;
                                checkOutTime = DateTime.now();
                                _attendanceOutRequest(attendaceProvider);
                              });
                            }else{
                              setState(() {
                                checkInTime = DateTime.now();
                                _attendanceInRequest(attendaceProvider);
                              });

                            }
                          },
                          child: results.isEmpty == true  ? checkInButton() :
                          results[resultLenght - 1].attendance!.isEmpty == true ? checkInButton() :
                          results[resultLenght - 1].attendance![0].checkIn == null || results[resultLenght - 1].attendance![0].checkIn == "null" ? checkInButton():
                          (DateTime.parse(results[resultLenght - 1].attendance![0].checkIn!).day) != (DateTime.now().day) ? checkInButton() :
                          results[resultLenght - 1].attendance![0].checkOut == "null" || results[resultLenght - 1].attendance![0].checkOut == null ? checkOutButton() : checkInButton(),
                        );
                      }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
      ));

      setState(() {
        lat = position.latitude.toString();
        long = position.longitude.toString();
        LogDebugger.instance.i(position.longitude);
        LogDebugger.instance.i(position.latitude);
      });
    } catch (e) {
      // Handle exceptions
      LogDebugger.instance.e("Error updating location: $e");
    }
  }
}

//Check In Button
Widget checkInButton() {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Stack(
      children: [
        Container(
          height: 18.5.h,
          width: 39.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF04BF00), width: 1.5.w),
            color: kWhiteColor,
          ),
        ),
        //Check in & Check Out Button
        Positioned(
          top: 2.h,
          left: 4.w,
          bottom: 2.h,
          right: 4.w,
          child: Container(
            // height: 14.h,
            width: 30.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF04BF00),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7.h,
                  width: 7.w,
                  child: Image.asset("assets/images/touch1.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 25),
                  child: Text(
                    "Check In",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

//Check Out Button
Widget checkOutButton() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Stack(
      children: [
        Container(
          height: 18.h,
          width: 39.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFC694C), width: 1.5.w),
            color: kWhiteColor,
          ),
        ),
        //Check in & Check Out Button
        Positioned(
          top: 2.h,
          left: 4.w,
          bottom: 2.h,
          right: 4.w,
          child: Container(
            height: 14.h,
            width: 30.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFC694C),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7.h,
                  width: 7.w,
                  child: Image.asset("assets/images/touch1.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 25),
                  child: Text(
                    "Check Out",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

//Repost
void reportBottomSheets(context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      return StatefulBuilder(
          builder: (context, setState){
            return Container(
              height: 80.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: kWhiteColor,
              ),
              child: Column(
                children: [
                  //Year
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState((){
                              month = month - 1;
                              print(month);
                              if(month <= 0){
                                month = 12;
                                year = year - 1;
                              }
                            });
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 18.sp,
                            color: kThemeColor,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "${DateFormat("MMMM").format(DateTime(year,month)).toString().toUpperCase()} ${DateFormat("yyyy").format(DateTime(year)).toString().toUpperCase()}",
                          // "${attendanceReportProvider.attendanceReportResponseModel!.data?[index].checkIn!.substring(0, 10).toString() ?? "N/A"}",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontSize: 18.sp,
                            color: kThemeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        TextButton(
                          onPressed: () {
                            month = month + 1;
                            print(month);
                            setState((){
                              if(month > 12){
                                month = 1;
                                year = year + 1;
                              }
                            });
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 18.sp,
                            color: kThemeColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        statusBlock(const Color(0xFF04BF00), "P", "Present"),
                        SizedBox(width: 1.w),
                        statusBlock(const Color(0xFFAA6755), "D", "Delay"),
                        SizedBox(width: 1.w),
                        statusBlock(const Color(0xFF640917), "EL", "Early Leave"),
                        SizedBox(width: 1.w),
                        statusBlock(const Color(0xFFFC694C), "A", "Absent"),
                        SizedBox(width: 1.w),
                        statusBlock(const Color(0xFF455A64), "L", "Leave"),
                        SizedBox(width: 1.w),
                        statusBlock(const Color(0xFF00B9B5), "H", "Holiday"),
                      ],
                    ),
                  ),
                  //
                  Consumer<AttendanceReportProvider>(
                      builder: (context, attendanceReportProvider, child) {
                        return FutureBuilder<AttendenceReportClass?>(
                            future: attendanceReportProvider.attendenceReport(month: month, year: year),
                            builder: (context,snapshort){
                              if(snapshort.hasData){
                                if(snapshort.data!.data!.result!.isEmpty == true){
                                  return const Center(
                                    child: Text(
                                      "No data found",
                                      style: TextStyle(
                                        color: Color.fromRGBO(12, 12, 12, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  );
                                }else{
                                  return  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshort.data!.data!.result!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: 9.5.h,
                                            decoration: const BoxDecoration(
                                              color: kWhiteColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SizedBox(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 17.5.w,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            // "Saturday",
                                                            snapshort.data?.data?.result?[index].attendance!.isEmpty == true ? "${snapshort.data?.data?.result?[index].day}" :
                                                            formatDay(snapshort.data?.data?.result?[index].attendance?[0].checkInTime),
                                                            // "${attendanceReportProvider.attendanceReportResponseModel!.data?.attendances![index].checkInTime ?? "N/A"}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0x465174A8),
                                                            ),
                                                          ),
                                                          Text(
                                                            // "14 July",
                                                            snapshort.data?.data?.result?[index].attendance?.isEmpty == true ? "${DateFormat("dd MMM").format(DateTime.parse(snapshort.data!.data!.result![index].date!))}" :
                                                            formatDate(snapshort.data?.data?.result?[index].attendance?[0].checkInTime),
                                                            // "${attendanceReportProvider.attendanceReportResponseModel!.data?.attendances![index].checkOutTime ?? "N/A"}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 18.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0x465174A8)
                                                                  .withOpacity(0.66),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              height: 3.h,
                                                              width: 47.w,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(3),
                                                                color: const Color(0xFF7CC3BB)
                                                                    .withOpacity(0.22),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.symmetric(
                                                                    horizontal: 5),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 10.w,
                                                                      child: Text(
                                                                        "IN",
                                                                        style: TextStyle(
                                                                          fontFamily:
                                                                          'latoRagular',
                                                                          fontSize: 15.sp,
                                                                          fontWeight:
                                                                          FontWeight.w600,
                                                                          color: kBlackColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 22.5.w,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            height: 2.4.h,
                                                                            width: 15.w,
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  2),
                                                                              color: const Color(
                                                                                  0xFF617B78),
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            top: 2,
                                                                            left: 2,
                                                                            child: Container(
                                                                              height: 2.h,
                                                                              width: 14.w,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    1),
                                                                                color: const Color(
                                                                                    0xFF617B78),
                                                                                border:
                                                                                Border.all(
                                                                                  color:
                                                                                  kWhiteColor,
                                                                                ),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  // "10:00 AM",
                                                                                  snapshort.data?.data?.result?[index].attendance?.isEmpty == true ? "N/A" :
                                                                                  formatTime(snapshort.data?.data?.result?[index].attendance?[0].checkInTime),
                                                                                  // "${attendanceReportProvider.attendanceReportResponseModel!.data?.attendances![index].checkIn ?? "N/A"}",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontFamily: 'latoRagular',
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: kWhiteColor,
                                                                                    fontSize: 12.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    snapshort.data?.data?.result?[index].isPresent == true && snapshort.data?.data?.result?[index].isDalay == true ?
                                                                    Container(
                                                                      height: 2.4.h,
                                                                      width: 4.8.w,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(2),
                                                                          color: Color(0xFFAA6755)
                                                                      ),
                                                                      child: Align(
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                            "D",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontWeight: FontWeight.w600,
                                                                            color: kWhiteColor,
                                                                            fontSize: 13.5.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ) :
                                                                    Container(
                                                                      height: 2.4.h,
                                                                      width: 4.8.w,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(2),
                                                                        color: snapshort.data?.data?.result?[index].isPresent == true ?  Color(0xFF04BF00) :
                                                                        snapshort.data?.data?.result?[index].isDalay == true ? Color(0xFFAA6755) :
                                                                        snapshort.data?.data?.result?[index].isEarlyLeave == true ? Color(0xFF640917) :
                                                                        snapshort.data?.data?.result?[index].isAbsent == true ? Color(0xFFFC694C) :
                                                                        snapshort.data?.data?.result?[index].isLeave == true ? Color(0xFF455A64) : Color(0xFF00B9B5),
                                                                      ),
                                                                      child: Align(
                                                                        alignment:
                                                                        Alignment.center,
                                                                        child: Text(
                                                                          snapshort.data?.data?.result?[index].isPresent == true ? "P" :
                                                                          snapshort.data?.data?.result?[index].isDalay == true ? "D" :
                                                                          snapshort.data?.data?.result?[index].isEarlyLeave == true ? "EL" :
                                                                          snapshort.data?.data?.result?[index].isAbsent == true ? "A" :
                                                                          snapshort.data?.data?.result?[index].isLeave == true ? "L" :
                                                                          "H",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontWeight: FontWeight.w600,
                                                                            color: kWhiteColor,
                                                                            fontSize: 13.5.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 1.w,
                                                                    ),
                                                                    // Tooltip(
                                                                    //   message:
                                                                    //   'Delayed for some\npersonal work.',
                                                                    //   textAlign:
                                                                    //   TextAlign.center,
                                                                    //   padding:
                                                                    //   const EdgeInsets.all(5),
                                                                    //   showDuration:
                                                                    //   const Duration(seconds: 5),
                                                                    //   decoration: ShapeDecoration(
                                                                    //     color: Colors.blue,
                                                                    //     shape: ToolTipCustomShape(),
                                                                    //   ),
                                                                    //   textStyle: const TextStyle(
                                                                    //       color: Colors.white
                                                                    //   ),
                                                                    //   preferBelow: false,
                                                                    //   // verticalOffset: 10,
                                                                    //   child: Container(
                                                                    //     height: 2.4.h,
                                                                    //     width: 4.8.w,
                                                                    //     decoration:
                                                                    //     BoxDecoration(
                                                                    //       borderRadius:
                                                                    //       BorderRadius
                                                                    //           .circular(2),
                                                                    //       color: const Color(
                                                                    //           0xFF1294F2),
                                                                    //     ),
                                                                    //     child: Align(
                                                                    //         alignment: Alignment
                                                                    //             .center,
                                                                    //         child: Padding(
                                                                    //           padding:
                                                                    //           const EdgeInsets
                                                                    //               .all(1),
                                                                    //           child: Image.asset(
                                                                    //               "assets/images/arcticons_note-it.png"),
                                                                    //         )),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            SizedBox(
                                                                width: 24.w,
                                                                child: Text(
                                                                  // "Location: House-17, Road-17/A, Block-E, Banani Dhaka-1213",
                                                                  snapshort.data?.data?.result?[index].attendance?.isEmpty == true ? "N/A":
                                                                  "${snapshort.data?.data?.result?[index].attendance?[0].checkInLocation}",
                                                                  //  "${attendanceReportProvider.attendanceReportResponseModel!.data?.attendances![index].checkInLocation ?? "N/A"}",
                                                                  style: TextStyle(
                                                                    fontFamily: 'latoRagular',
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 12.sp,
                                                                    color:
                                                                    const Color(0xFF808080),
                                                                  ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                ))
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              height: 3.h,
                                                              width: 47.w,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(3),
                                                                color: const Color(0xFFFF0000)
                                                                    .withOpacity(0.15),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.symmetric(
                                                                    horizontal: 5),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 10.w,
                                                                      child: Text(
                                                                        "OUT",
                                                                        style: TextStyle(
                                                                          fontFamily:
                                                                          'latoRagular',
                                                                          fontSize: 15.sp,
                                                                          fontWeight:
                                                                          FontWeight.w600,
                                                                          color: kBlackColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 22.5.w,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            height: 2.4.h,
                                                                            width: 15.w,
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  2),
                                                                              color: const Color(
                                                                                  0xFF617B78),
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            top: 2,
                                                                            left: 2,
                                                                            child: Container(
                                                                              height: 2.h,
                                                                              width: 14.w,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    1),
                                                                                color: const Color(
                                                                                    0xFF617B78),
                                                                                border:
                                                                                Border.all(
                                                                                  color:
                                                                                  kWhiteColor,
                                                                                ),
                                                                              ),
                                                                              child: Align(
                                                                                alignment:
                                                                                Alignment
                                                                                    .center,
                                                                                child: Text(
                                                                                  // "10:00 AM",
                                                                                  snapshort.data?.data?.result?[index].attendance?.isEmpty == true ? "N/A" :
                                                                                  formatTime(snapshort.data?.data?.result?[index].attendance?[0].checkOutTime),
                                                                                  // "${attendanceReportProvider.attendanceReportResponseModel!.data?.attendances![index].checkOut ?? "N/A"}",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontFamily:
                                                                                    'latoRagular',
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w600,
                                                                                    color:
                                                                                    kWhiteColor,
                                                                                    fontSize:
                                                                                    12.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    snapshort.data?.data?.result?[index].isPresent == true && snapshort.data?.data?.result?[index].isEarlyLeave == true ?
                                                                        Container(
                                                                          height: 2.4.h,
                                                                          width: 4.8.w,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(2),
                                                                            color: Color(0xFF640917)
                                                                          ),
                                                                          child: Align(
                                                                            alignment: Alignment.center,
                                                                            child: Text(
                                                                                "EL",
                                                                              style: TextStyle(
                                                                                fontFamily: 'latoRagular',
                                                                                fontWeight: FontWeight.w600,
                                                                                color: kWhiteColor,
                                                                                fontSize: 13.5.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ) :
                                                                    Container(
                                                                      height: 2.4.h,
                                                                      width: 4.8.w,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(2),
                                                                        color: snapshort.data?.data?.result?[index].isPresent == true ?  Color(0xFF04BF00) :
                                                                        snapshort.data?.data?.result?[index].isDalay == true ? Color(0xFFAA6755) :
                                                                        snapshort.data?.data?.result?[index].isEarlyLeave == true ? Color(0xFF640917) :
                                                                        snapshort.data?.data?.result?[index].isAbsent == true ? Color(0xFFFC694C) :
                                                                        snapshort.data?.data?.result?[index].isLeave == true ? Color(0xFF455A64) : Color(0xFF00B9B5),
                                                                      ),
                                                                      child: Align(
                                                                        alignment:
                                                                        Alignment.center,
                                                                        child: Text(
                                                                          snapshort.data?.data?.result?[index].isPresent == true ? "P" :
                                                                          snapshort.data?.data?.result?[index].isDalay == true ? "D" :
                                                                          snapshort.data?.data?.result?[index].isEarlyLeave == true ? "EL" :
                                                                          snapshort.data?.data?.result?[index].isAbsent == true ? "A" :
                                                                          snapshort.data?.data?.result?[index].isLeave == true ? "L" :
                                                                          "H",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontWeight: FontWeight.w600,
                                                                            color: kWhiteColor,
                                                                            fontSize: 13.5.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 1.w,
                                                                    ),
                                                                    // Container(
                                                                    //   height: 2.4.h,
                                                                    //   width: 4.8.w,
                                                                    //   decoration: BoxDecoration(
                                                                    //     borderRadius:
                                                                    //     BorderRadius
                                                                    //         .circular(2),
                                                                    //     color: const Color(
                                                                    //         0xFF1294F2),
                                                                    //   ),
                                                                    //   child: Align(
                                                                    //       alignment:
                                                                    //       Alignment.center,
                                                                    //       child: Padding(
                                                                    //         padding:
                                                                    //         const EdgeInsets
                                                                    //             .all(1),
                                                                    //         child: Image.asset(
                                                                    //             "assets/images/arcticons_note-it.png"),
                                                                    //       )),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            SizedBox(
                                                              width: 24.w,
                                                              child: Text(
                                                                //"Location: House-17, Road-17/A, Block-E, Banani Dhaka-1213",
                                                                snapshort.data?.data?.result?[index].attendance?.isEmpty == true ? "N/A" :
                                                                "${snapshort.data?.data?.result?[index].attendance?[0].checkOutLocation} ",
                                                                // "${attendanceReportProvider.attendanceReportResponseModel!.data?.attendances![index].checkOutLocation ?? "N/A"}",
                                                                style: TextStyle(
                                                                  fontFamily: 'latoRagular',
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 12.sp,
                                                                  color:
                                                                  const Color(0xFF808080),
                                                                ),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 1.w),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                }
                              }else{
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                        );
                      }),
                ],
              ),
            );
          }
      );
    }
  );
}

Widget statusBlock(color, text, label) {
  return Row(
    children: [
      Container(
        height: 1.5.h,
        width: 3.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: color,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'latoRagular',
              color: kWhiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ),
      ),
      SizedBox(width: 1.w),
      Text(
        label,
        style: TextStyle(
          fontFamily: 'latoRagular',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: kBlackColor,
        ),
      ),
    ],
  );
}

Widget successDialog(context, String action) {
  return Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: SizedBox(
      height: 40.h,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 15),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 2.h,
                  width: 4.w,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Image(
                      image: AssetImage("./assets/images/cancel.png"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.h,
            width: 90.w,
            child: const Image(
              image: AssetImage(
                "assets/images/happy_jumping.png",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Congratulation",
              style: TextStyle(
                fontFamily: 'FBBold',
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: kBlackColor,
              ),
            ),
          ),
          Text(
            "Successfully $action",
            style: TextStyle(
                fontFamily: 'FBBold',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: action == "Check In"
                    ? Color(0xFF04BF00)
                    : Color(0xFFFC694C)),
          ),
        ],
      ),
    ),
  );
}

//Late Dialog
Widget lateReasonDialog(context) {
  return SingleChildScrollView(
    child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 160),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 15),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 2.h,
                  width: 4.w,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Image(
                      image: AssetImage("./assets/images/cancel.png"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                  child: const Image(
                    image: AssetImage(
                      "assets/images/late.png",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Opps!",
                    style: TextStyle(
                      fontFamily: 'FBBold',
                      fontSize: 17.5.sp,
                      fontWeight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                  ),
                ),
                Text(
                  "You are Late",
                  style: TextStyle(
                    fontFamily: 'FBBold',
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF04BF00),
                  ),
                ),
                Text(
                  "Give Reason",
                  style: TextStyle(
                    fontFamily: 'FBBold',
                    shadows: const [
                      Shadow(color: Color(0xFFFF350D), offset: Offset(0, -0))
                    ],
                    decoration: TextDecoration.underline,
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFF350D),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: "Reason For Leave ",
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kLightGreyColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kLightGreyColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: SizedBox(
                    height: 6.h,
                    width: 90.w,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF1294F2),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontFamily: 'latoRagular',
                            color: kWhiteColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

//
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition();

  return position;
}

String formatDay(String? timestamp) {
  if (timestamp == null) {
    return 'N/A'; // Handle null timestamp gracefully if needed
  }
  int parsedTimestamp;
  try {
    parsedTimestamp = int.parse(timestamp);
  } catch (e) {
    print('Error parsing timestamp: $e');
    return ''; // Handle parsing error gracefully if needed
  }

  final DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(parsedTimestamp);
  final DateFormat formatter = DateFormat('EEEE');
  return formatter.format(dateTime);
}

String formatDate(String? timestamp) {
  if (timestamp == null) {
    return 'N/A'; // Handle null timestamp
  }
  int parsedTimestamp;
  try {
    parsedTimestamp = int.parse(timestamp);
  } catch (e) {
    print('Error parsing timestamp: $e');
    return ''; // Handle parsing error
  }
  final DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(parsedTimestamp);
  final DateFormat formatter = DateFormat('d MMM');
  return formatter.format(dateTime);
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

class TimeNotifier {
  ValueNotifier<String> currentTime = ValueNotifier<String>('');

  late Timer _timer;

  TimeNotifier() {
    currentTime.value = getCurrentFormattedTime();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime.value = getCurrentFormattedTime();
    });
  }

  String getCurrentFormattedTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM. yyyy | hh:mm a');
    return formatter.format(now);
  }

  void dispose() {
    _timer.cancel();
    currentTime.dispose();
  }
}
