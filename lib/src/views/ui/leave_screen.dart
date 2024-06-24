import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../business_logics/models/all_leave_response_model.com.dart';
import '../../business_logics/models/half_leave_model.dart';
import '../../business_logics/models/leve_type_response_model.dart';
import '../../business_logics/models/user_data_model.dart';
import '../../business_logics/providers/leave_provider.dart';
import '../../business_logics/utils/constants.dart';
import '../widgets/custom_switch.dart';
import '../widgets/device_image_picker.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  String? dropdownLeaveValue;
  String? dropdownHalfLeaveValue;
  final maxLines = 5;
  String? selectedType = "All";
  String? selectedDropdownID;
  String? selectedHalfDropdownID;
  bool halfDay = false;
  String? fileUpName;
  File? selectedFile;
  bool loading = true;
  File? file;
  String selectedLeaveType = "";
  String selectedHalfLeaveType = "";
  List<dynamic> leaveReport = [];
  TextEditingController halfDate = TextEditingController();
  TextEditingController halfDayRemark = TextEditingController();
  List<HalfDay> halfDays = [];
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController dayCount = TextEditingController();
  TextEditingController remark = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? selectedFileName;
  String? selectedFileNameHalfDay;
  bool state = false;

  _leaveRequest(LeaveProvider leaveProvider) {
    setState(() {
      leaveProvider.leaveRequestProvider(
        id: UserData.id ?? 0,
        leaveTypeId: selectedDropdownID.toString(),
        fromDate: fromDate.text,
        toDate: toDate.text,
        noOfDays: dayCount.text,
        remarks: remark.text,
        files: fileUpName.toString(),
      );
    });
  }

  void _uploadFile(LeaveProvider leaveProvider, PlatformFile file) {
    if (file != null) {
      final File imageFile = File(file.path!);
      leaveProvider
          .uploadDocument(
            image: imageFile,
          )
          .then((value) => {
                fileUpName = leaveProvider.uploadFile.data,
                const SnackBar(
                  content: Text("File has been uploaded please continue"),
                ),
              });
    } else {}
  }

  String? fileName;

  Future<void> filePicked() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      if (result != null && result.files.single.path != null) {
        PlatformFile file = result.files.first;
        print(file.name);
        print(file.bytes);
        print(file.size);

        File _file = File(result.files.single.path! ?? " ");
        setState(() {
          fileName = _file.path;
        });
      } else {
        print("file not found");
      }
    } catch (e) {
      print(e);
    }
  }

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  void initState() {
    // requestPermission();
    //  filePicked();
    loading = true;
    Future.delayed(Duration(seconds: 1), () async {
      LeaveProvider leaveProvider =
          Provider.of<LeaveProvider>(context, listen: false);
      await leaveProvider.getLeveType();
      await leaveProvider.leaveReport().then((value) {
        if (value?.data?.isNotEmpty == true) {
          value!.data!.forEach((element) {
            leaveReport.add({
              "title": element.title,
              "available": element.available,
              "total": element.total
            });
          });
        }
      });
      await leaveProvider.halfDayGet().then((value) {
        setState(() {
          halfDay = value!.data!.allowHalfDay!;
          state = halfDay;
          print(halfDay);
          if(value.data!.days!.isNotEmpty == true){
            value.data!.days!.forEach((element) {
              halfDays.add(element);
            });
          }
        });
      });
      await loadingStop();
    });
    super.initState();
  }

  Future<void> loadingStop() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavScreenLayout(
                      page: 0,
                    )));
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LeaveScreen()));
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
                  icon: Image.asset('./assets/images/notification.png'),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: IconButton(
                  icon: Image.asset('./assets/images/appbar_contact.png'),
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
          body: loading == true
              ? Container(
                  height: MediaQuery.of(context).size.height / 1,
                  width: MediaQuery.of(context).size.width / 1,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Consumer<LeaveProvider>(
                  builder: (context, allLeaveProvider, child) {
                    return FutureBuilder<AllLeaveResponseModel?>(
                        future: allLeaveProvider.leaveFilter(status: selectedType!),
                        builder: (context, snapsort) {
                          if (snapsort.hasData) {
                            return CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  pinned: true,
                                  floating: false,
                                  expandedHeight: 6.h,
                                  automaticallyImplyLeading: false,
                                  backgroundColor: const Color(0xFFEAF4F2),
                                  flexibleSpace: Container(
                                    height: 5.h,
                                    width: 90.h,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                            width: 40.w,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BottomNavScreenLayout(
                                                                  page: 0,
                                                                )));
                                                  },
                                                  child: Container(
                                                    height: 4.5.h,
                                                    width: 9.w,
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Image.asset(
                                                          "./assets/images/arrow_left.png"),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      filePicked();
                                                    },
                                                    child: Text(
                                                      "Leave",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'latoRagular',
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kBlackColor,
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
                                  ),
                                ),

                                SliverFillRemaining(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      height: 100.h,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.grey.shade400,
                                          ),
                                        ],
                                        color: kWhiteColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                      ),
                                      child: CustomScrollView(
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: SizedBox(
                                              height: 2.h,
                                            ),
                                          ),
                                          leaveReport.isEmpty == true
                                              ? SliverToBoxAdapter(
                                                  child: Container(
                                                    height: 10.h,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Center(
                                                      child: Text(
                                                        "This user has no leave allocated.",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SliverGrid(
                                                  delegate: SliverChildBuilderDelegate((context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                                      child: customLeaveContainer(
                                                        label: leaveReport[index]["title"].toString(),
                                                        totalleave: leaveReport[index]["total"].toString(),
                                                        availableleave: leaveReport[index]["available"].toString(),
                                                        psize: const EdgeInsets.only(left: 15),
                                                        kicon: Image.asset("./assets/images/annual_calendar.png"),
                                                      ),
                                                    );
                                                  },
                                                      childCount: leaveReport.length),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 2,
                                                  ),
                                                ),
                                          SliverToBoxAdapter(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Container(
                                                height: .2.h,
                                                width: 90.w,
                                                margin:
                                                    EdgeInsets.only(top: 2.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xFF19888E),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SliverToBoxAdapter(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Container(
                                                height: 4.h,
                                                width: 90.w,
                                                margin:
                                                    EdgeInsets.only(top: 1.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xFF19888E),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _buildStatusButton(
                                                        "All", "All"),
                                                    _buildStatusButton(
                                                        "Pending", "Pending"),
                                                    _buildStatusButton(
                                                        "Approved", "Approved"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          snapsort.data!.data!.leaves!
                                                      .isEmpty ==
                                                  true
                                              ? SliverToBoxAdapter(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: Container(
                                                      height: 4.h,
                                                      width: 90.w,
                                                      child: Center(
                                                        child: Text(
                                                          "No data found",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Color.fromRGBO(
                                                                    12,
                                                                    12,
                                                                    12,
                                                                    1),
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SliverList(
                                              delegate: SliverChildBuilderDelegate(
                                                          (context, int index) {
                                                            return Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                              child: _buildAllList(snapsort.data!.data!.leaves![index]),
                                                            );
                                                            },
                                                          childCount: snapsort.data!.data!.leaves!.length))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            );
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height / 1,
                              width: MediaQuery.of(context).size.width / 1,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        });
                  },
                ),
          floatingActionButton:
              Consumer<LeaveProvider>(builder: (context, leaveProvider, child) {
            return FloatingActionButton(
              onPressed: () {
                if (leaveReport.isEmpty) {
                  customWidget.showCustomSnackbar(
                      context, "Sorry! You have no leave allocated.");
                } else {
                  fromDate.clear();
                  toDate.clear();
                  remark.clear();
                  file = null;
                  halfDate.clear();
                  halfDayRemark.clear();
                  selectedFileNameHalfDay = null;
                  selectedHalfDropdownID = null;
                  selectedFileName = null;
                  selectedDropdownID = null;
                  dayCount.clear();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            insetPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 120),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    //Leave Application $ Exit
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Leave Application",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kBlackColor,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: SizedBox(
                                              height: 2.h,
                                              width: 2.8.w,
                                              child: const Image(
                                                image: AssetImage(
                                                    "assets/images/cancel.png"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: const Color(0xFFA7A7A7),
                                      height: 1.h,
                                    ),
                                  ],
                                ),
                                halfDay == false
                                    ? SizedBox.shrink()
                                    : Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            CustomSwitch(
                                              value: state,
                                              onChanged: (value) {
                                                setState(() {
                                                    state = value;
                                                  },
                                                );
                                              },
                                            ),
                                            SizedBox(width: 2.w),
                                            state == false
                                                ? Text(
                                                    "Full Day Leave",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kThemeColor,
                                                    ),
                                                  )
                                                : Text(
                                                    "Half Day Leave",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kThemeColor,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                state == false
                                    ? Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: SizedBox(
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField<String>(
                                                hint: const Text(
                                                  "Select Leave Type",
                                                  style: TextStyle(
                                                    fontFamily: 'latoRagular',
                                                    fontSize: 14,
                                                    color: Color(0xFFC4C4C4),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  contentPadding:
                                                      const EdgeInsets.all(
                                                          10.0),
                                                  label: const Text(
                                                    "Leave Type *",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF102048),
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: kLightGreyColor,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: kLightGreyColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownLeaveValue =
                                                        newValue;

                                                    // Find the corresponding ID based on the selected name
                                                    final selectedLeaveType =
                                                        leaveProvider
                                                            .leaveTypeResponseModel
                                                            ?.data
                                                            ?.leaveTypes
                                                            ?.firstWhere(
                                                      (leaveType) =>
                                                          leaveType.name ==
                                                          newValue,
                                                      orElse: () =>
                                                          LeaveTypes(), // Provide a default empty LeaveTypes object
                                                    );

                                                    // Check if selectedLeaveType is not null before accessing its ID
                                                    selectedDropdownID =
                                                        selectedLeaveType?.id
                                                            ?.toString();
                                                  });
                                                },
                                                items: leaveProvider
                                                        .leaveTypeResponseModel
                                                        ?.data
                                                        ?.leaveTypes
                                                        ?.map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (LeaveTypes
                                                                leaveType) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: leaveType.name ??
                                                            "",
                                                        child: Text(
                                                          leaveType.name ?? "",
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'latoRagular',
                                                            color: kThemeColor,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList() ??
                                                    [],
                                              ),
                                              //Form Date
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    DateTime? pickeddate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2022),
                                                      lastDate: DateTime(2040),
                                                    );
                                                    if (pickeddate != null) {
                                                      setState(
                                                        () {
                                                          fromDate
                                                              .text = DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  pickeddate);
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: TextField(
                                                    enabled: false,
                                                    controller: fromDate,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      label: const Text(
                                                        "From Date *",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kThemeColor,
                                                        ),
                                                      ),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      suffixIcon: Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        size: 18.sp,
                                                      ),
                                                      // Icon(Icons.calendar_month_outlined),
                                                      hintText: "yyyy-MM-dd",
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: const Color(
                                                              0xFFC4C4C4),
                                                          fontSize: 16.sp,
                                                          overflow: TextOverflow
                                                              .visible),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              kLightGreyColor,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    kLightGreyColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //To Date
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (fromDate.text.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Please select from date first")));
                                                    } else {
                                                      DateTime? toPickedDate =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.parse(fromDate.text),
                                                        firstDate: DateTime.parse(fromDate.text),
                                                        lastDate: DateTime(2040),
                                                      );
                                                      if (toPickedDate !=
                                                          null) {
                                                        setState(
                                                          () {
                                                            toDate.text = DateFormat('yyyy-MM-dd')
                                                                .format(
                                                                    toPickedDate);
                                                            DateTime
                                                                fromDateValue =
                                                                DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .parse(fromDate
                                                                        .text);
                                                            DateTime
                                                                toDateValue =
                                                                toPickedDate;
                                                            int difference = toDateValue
                                                                    .difference(
                                                                        fromDateValue)
                                                                    .inDays +
                                                                1;
                                                            dayCount.text =
                                                                difference
                                                                    .toString();
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: TextField(
                                                    enabled: false,
                                                    controller: toDate,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      label: const Text(
                                                        "To Date *",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xFF102048),
                                                        ),
                                                      ),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      suffixIcon: Icon(
                                                          Icons
                                                              .calendar_month_outlined,
                                                          size: 18.sp),
                                                      // Icon(Icons.calendar_month_outlined),
                                                      hintText: "yyyy-MM-dd",
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            'latoRagular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xFFC4C4C4),
                                                        fontSize: 14.5.sp,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              kLightGreyColor,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    kLightGreyColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              //Day Count
                                              TextField(
                                                enabled: false,
                                                controller: dayCount,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  contentPadding:
                                                      const EdgeInsets.all(
                                                          10.0),
                                                  suffixIcon: Icon(
                                                      Icons.timer_outlined,
                                                      size: 18.sp),
                                                  // Icon(Icons.calendar_month_outlined),
                                                  hintText: "Day Count",
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'latoRagular',
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xFFC4C4C4),
                                                    fontSize: 14.5.sp,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: kLightGreyColor,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: kLightGreyColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                              //Attachment
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, bottom: 5),
                                                    child: Text(
                                                      "Attachment",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'latoRagular',
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kThemeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  dottedBorder(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        final result =
                                                            await FilePicker.platform.pickFiles(
                                                              allowMultiple: false,
                                                              type: FileType.custom,
                                                            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'xlsx', 'csv'],
                                                        );
                                                        setState(() {
                                                          if (result != null &&
                                                              result.files.isNotEmpty) {
                                                            setState(() {
                                                              final upload = result.files.first;
                                                              file = File(result.files.first.path!);
                                                              selectedFileName = upload.name ?? ''; // Store the selected file name
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 5.h,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  height: 3.h,
                                                                  width: 3.w,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/images/upload_plus.png"),
                                                                ),
                                                                Container(
                                                                  height: 5.h,
                                                                  width: 55.w,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        selectedFileName ==
                                                                                null
                                                                            ? "Upload Your Documents"
                                                                            : selectedFileName!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'latoRagular',
                                                                          fontSize:
                                                                              14.sp,
                                                                          color:
                                                                              const Color(0xFF6A8495),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          // FutureBuilder<String?>(
                                                          //   future: Future.value(selectedFileName),
                                                          //   builder: (context, snapshot) {
                                                          //     if (snapshot.hasData) {
                                                          //       return Text(
                                                          //         snapshot.data!,
                                                          //         style: TextStyle(
                                                          //             fontFamily: 'latoRagular',
                                                          //             fontSize: 14.sp,
                                                          //             color: const Color(0xFF6A8495),
                                                          //             fontWeight: FontWeight.w600
                                                          //         ),
                                                          //       );
                                                          //     } else {
                                                          //       return Container();
                                                          //     }
                                                          //   },
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              //Reason for Leave
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: TextField(
                                                  maxLines: maxLines,
                                                  controller: remark,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.transparent,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    hintText:
                                                        "Reason For Leave *",
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xFFC4C4C4),
                                                      fontSize: 14.5.sp,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: kLightGreyColor,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color:
                                                              kLightGreyColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Submit Button
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: SizedBox(
                                                  height: 5.h,
                                                  width: 90.w,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (selectedDropdownID ==
                                                            null) {
                                                          customWidget
                                                              .showCustomSnackbar(
                                                                  context,
                                                                  "Please select a leave type");
                                                        } else if (fromDate
                                                                .text.isEmpty ==
                                                            true) {
                                                          customWidget
                                                              .showCustomSnackbar(
                                                                  context,
                                                                  "Please fill up the from date");
                                                        } else if (toDate
                                                                .text.isEmpty ==
                                                            true) {
                                                          customWidget
                                                              .showCustomSnackbar(
                                                                  context,
                                                                  "Please fill up the to date");
                                                        } else if (remark
                                                                .text.isEmpty ==
                                                            true) {
                                                          customWidget
                                                              .showCustomSnackbar(
                                                                  context,
                                                                  "Please fill up the reason");
                                                        } else {
                                                          if(file == null){
                                                            loading = true;
                                                            leaveProvider.leavePost(
                                                                leaveSlot: "0",
                                                                id: UserData.id ?? 0,
                                                                mode: "full-day",
                                                                leaveDate: "",
                                                                leaveTypeId: selectedDropdownID.toString(),
                                                                fromDate: fromDate.text,
                                                                toDate: toDate.text,
                                                                noOfDays: dayCount.text,
                                                                remarks: remark.text,
                                                                files: "",
                                                                onSuccess: (e) {
                                                                  customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                                  loading = false;
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveScreen()));
                                                                },
                                                                onFail: (e) {
                                                                  customWidget.showCustomSnackbar(context, "${e}");
                                                                  loading = false;
                                                                  Navigator.pop(context);
                                                                });
                                                          }else{
                                                            leaveProvider.uploadImageFileForLeave(
                                                                filePath: file,
                                                                onSuccess: (e){
                                                                  loading = true;
                                                                  leaveProvider.leavePost(
                                                                      leaveSlot: "0",
                                                                      id: UserData.id ?? 0,
                                                                      mode: "full-day",
                                                                      leaveDate: "",
                                                                      leaveTypeId: selectedDropdownID.toString(),
                                                                      fromDate: fromDate.text,
                                                                      toDate: toDate.text,
                                                                      noOfDays: dayCount.text,
                                                                      remarks: remark.text,
                                                                      files: "${e}",
                                                                      onSuccess: (e) {
                                                                        customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                                        loading = false;
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveScreen()));
                                                                      },
                                                                      onFail: (e) {
                                                                        customWidget.showCustomSnackbar(context, "${e}");
                                                                        loading = false;
                                                                        Navigator.pop(context);
                                                                      });
                                                                },
                                                                onFail: (e){
                                                                  customWidget.showCustomSnackbar(context, "${e}");
                                                                  loading = false;
                                                                  Navigator.pop(context);
                                                                }
                                                            );
                                                          }
                                                        }
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        const Color(0xFF1294F2),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          color: kWhiteColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ) :
                                    halfDay == false && state == false ?
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SizedBox(
                                        child: Column(
                                          children: [
                                            DropdownButtonFormField<String>(
                                              hint: const Text(
                                                "Select Leave Type",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontSize: 14,
                                                  color: Color(0xFFC4C4C4),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                const EdgeInsets.all(
                                                    10.0),
                                                label: const Text(
                                                  "Leave Type *",
                                                  style: TextStyle(
                                                    fontFamily: 'latoRagular',
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Color(0xFF102048),
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                  borderSide:
                                                  const BorderSide(
                                                    color: kLightGreyColor,
                                                  ),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: kLightGreyColor),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                ),
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownLeaveValue =
                                                      newValue;

                                                  // Find the corresponding ID based on the selected name
                                                  final selectedLeaveType =
                                                  leaveProvider
                                                      .leaveTypeResponseModel
                                                      ?.data
                                                      ?.leaveTypes
                                                      ?.firstWhere(
                                                        (leaveType) =>
                                                    leaveType.name ==
                                                        newValue,
                                                    orElse: () =>
                                                        LeaveTypes(), // Provide a default empty LeaveTypes object
                                                  );

                                                  // Check if selectedLeaveType is not null before accessing its ID
                                                  selectedDropdownID =
                                                      selectedLeaveType?.id
                                                          ?.toString();
                                                });
                                              },
                                              items: leaveProvider
                                                  .leaveTypeResponseModel
                                                  ?.data
                                                  ?.leaveTypes
                                                  ?.map<
                                                  DropdownMenuItem<
                                                      String>>(
                                                      (LeaveTypes
                                                  leaveType) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: leaveType.name ??
                                                          "",
                                                      child: Text(
                                                        leaveType.name ?? "",
                                                        style:
                                                        const TextStyle(
                                                          fontFamily:
                                                          'latoRagular',
                                                          color: kThemeColor,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList() ??
                                                  [],
                                            ),
                                            //Form Date
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: InkWell(
                                                onTap: () async {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                      FocusNode());
                                                  DateTime? pickeddate =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                    DateTime.now(),
                                                    firstDate: DateTime(2022),
                                                    lastDate: DateTime(2040),
                                                  );
                                                  if (pickeddate != null) {
                                                    setState(
                                                          () {
                                                        fromDate
                                                            .text = DateFormat(
                                                            'yyyy-MM-dd')
                                                            .format(
                                                            pickeddate);
                                                      },
                                                    );
                                                  }
                                                },
                                                child: TextField(
                                                  enabled: false,
                                                  controller: fromDate,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                    Colors.transparent,
                                                    contentPadding:
                                                    const EdgeInsets.all(
                                                        10.0),
                                                    label: const Text(
                                                      "From Date *",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'latoRagular',
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: kThemeColor,
                                                      ),
                                                    ),
                                                    floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                    suffixIcon: Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      size: 18.sp,
                                                    ),
                                                    // Icon(Icons.calendar_month_outlined),
                                                    hintText: "yyyy-MM-dd",
                                                    hintStyle: TextStyle(
                                                        fontFamily:
                                                        'latoRagular',
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: const Color(
                                                            0xFFC4C4C4),
                                                        fontSize: 16.sp,
                                                        overflow: TextOverflow
                                                            .visible),
                                                    border:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            8)),
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                      borderSide:
                                                      const BorderSide(
                                                        color:
                                                        kLightGreyColor,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide:
                                                      const BorderSide(
                                                          color:
                                                          kLightGreyColor),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //To Date
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: InkWell(
                                                onTap: () async {
                                                  if (fromDate.text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "Please select from date first")));
                                                  } else {
                                                    DateTime? toPickedDate =
                                                    await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.parse(fromDate.text),
                                                      firstDate: DateTime.parse(fromDate.text),
                                                      lastDate: DateTime(2040),
                                                    );
                                                    if (toPickedDate !=
                                                        null) {
                                                      setState(() {
                                                          toDate.text = DateFormat('yyyy-MM-dd').format(toPickedDate);
                                                          DateTime
                                                          fromDateValue =
                                                          DateFormat(
                                                              'yyyy-MM-dd')
                                                              .parse(fromDate
                                                              .text);
                                                          DateTime
                                                          toDateValue =
                                                              toPickedDate;
                                                          int difference = toDateValue
                                                              .difference(
                                                              fromDateValue)
                                                              .inDays +
                                                              1;
                                                          dayCount.text =
                                                              difference
                                                                  .toString();
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                                child: TextField(
                                                  enabled: false,
                                                  controller: toDate,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                    Colors.transparent,
                                                    contentPadding:
                                                    const EdgeInsets.all(
                                                        10.0),
                                                    label: const Text(
                                                      "To Date *",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'latoRagular',
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color:
                                                        Color(0xFF102048),
                                                      ),
                                                    ),
                                                    floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                    suffixIcon: Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        size: 18.sp),
                                                    // Icon(Icons.calendar_month_outlined),
                                                    hintText: "yyyy-MM-dd",
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                      'latoRagular',
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: const Color(
                                                          0xFFC4C4C4),
                                                      fontSize: 14.5.sp,
                                                    ),
                                                    border:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                    ),
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                      borderSide:
                                                      const BorderSide(
                                                        color:
                                                        kLightGreyColor,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide:
                                                      const BorderSide(
                                                          color:
                                                          kLightGreyColor),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //Day Count
                                            TextField(
                                              enabled: false,
                                              controller: dayCount,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                const EdgeInsets.all(
                                                    10.0),
                                                suffixIcon: Icon(
                                                    Icons.timer_outlined,
                                                    size: 18.sp),
                                                // Icon(Icons.calendar_month_outlined),
                                                hintText: "Day Count",
                                                hintStyle: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                  const Color(0xFFC4C4C4),
                                                  fontSize: 14.5.sp,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                  borderSide:
                                                  const BorderSide(
                                                    color: kLightGreyColor,
                                                  ),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: kLightGreyColor),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8),
                                                ),
                                              ),
                                            ),
                                            //Attachment
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 10, bottom: 5),
                                                  child: Text(
                                                    "Attachment",
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'latoRagular',
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: kThemeColor,
                                                    ),
                                                  ),
                                                ),
                                                dottedBorder(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final result =
                                                      await FilePicker.platform.pickFiles(
                                                        allowMultiple: false,
                                                        type: FileType.custom,
                                                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'xlsx', 'csv'],
                                                      );
                                                      setState(() {
                                                        if (result != null &&
                                                            result.files.isNotEmpty) {
                                                          setState(() {
                                                            final upload = result.files.first;
                                                            file = File(result.files.first.path!);
                                                            selectedFileName = upload.name ?? ''; // Store the selected file name
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 5.h,
                                                          width:
                                                          MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              SizedBox(
                                                                height: 3.h,
                                                                width: 3.w,
                                                                child: Image
                                                                    .asset(
                                                                    "assets/images/upload_plus.png"),
                                                              ),
                                                              Container(
                                                                height: 5.h,
                                                                width: 55.w,
                                                                child:
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                      10),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    Text(
                                                                      selectedFileName ==
                                                                          null
                                                                          ? "Upload Your Documents"
                                                                          : selectedFileName!,
                                                                      style:
                                                                      TextStyle(
                                                                        fontFamily:
                                                                        'latoRagular',
                                                                        fontSize:
                                                                        14.sp,
                                                                        color:
                                                                        const Color(0xFF6A8495),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // FutureBuilder<String?>(
                                                        //   future: Future.value(selectedFileName),
                                                        //   builder: (context, snapshot) {
                                                        //     if (snapshot.hasData) {
                                                        //       return Text(
                                                        //         snapshot.data!,
                                                        //         style: TextStyle(
                                                        //             fontFamily: 'latoRagular',
                                                        //             fontSize: 14.sp,
                                                        //             color: const Color(0xFF6A8495),
                                                        //             fontWeight: FontWeight.w600
                                                        //         ),
                                                        //       );
                                                        //     } else {
                                                        //       return Container();
                                                        //     }
                                                        //   },
                                                        // )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //Reason for Leave
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextField(
                                                maxLines: maxLines,
                                                controller: remark,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor:
                                                  Colors.transparent,
                                                  contentPadding:
                                                  const EdgeInsets.all(
                                                      10.0),
                                                  hintText:
                                                  "Reason For Leave *",
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'latoRagular',
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: const Color(
                                                        0xFFC4C4C4),
                                                    fontSize: 14.5.sp,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                    borderSide:
                                                    const BorderSide(
                                                      color: kLightGreyColor,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color:
                                                        kLightGreyColor),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //Submit Button
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: SizedBox(
                                                height: 5.h,
                                                width: 90.w,
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (selectedDropdownID ==
                                                          null) {
                                                        customWidget
                                                            .showCustomSnackbar(
                                                            context,
                                                            "Please select a leave type");
                                                      } else if (fromDate
                                                          .text.isEmpty ==
                                                          true) {
                                                        customWidget
                                                            .showCustomSnackbar(
                                                            context,
                                                            "Please fill up the from date");
                                                      } else if (toDate
                                                          .text.isEmpty ==
                                                          true) {
                                                        customWidget
                                                            .showCustomSnackbar(
                                                            context,
                                                            "Please fill up the to date");
                                                      } else if (remark
                                                          .text.isEmpty ==
                                                          true) {
                                                        customWidget
                                                            .showCustomSnackbar(
                                                            context,
                                                            "Please fill up the reason");
                                                      } else {
                                                        if(file == null){
                                                          loading = true;
                                                          leaveProvider.leavePost(
                                                              leaveSlot: "0",
                                                              id: UserData.id ?? 0,
                                                              mode: "full-day",
                                                              leaveDate: "",
                                                              leaveTypeId: selectedDropdownID.toString(),
                                                              fromDate: fromDate.text,
                                                              toDate: toDate.text,
                                                              noOfDays: dayCount.text,
                                                              remarks: remark.text,
                                                              files: "",
                                                              onSuccess: (e) {
                                                                customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                                loading = false;
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveScreen()));
                                                              },
                                                              onFail: (e) {
                                                                customWidget.showCustomSnackbar(context, "${e}");
                                                                loading = false;
                                                                Navigator.pop(context);
                                                              });
                                                        }else{
                                                          leaveProvider.uploadImageFileForLeave(
                                                              filePath: file,
                                                              onSuccess: (e){
                                                                loading = true;
                                                                leaveProvider.leavePost(
                                                                    leaveSlot: "0",
                                                                    id: UserData.id ?? 0,
                                                                    mode: "full-day",
                                                                    leaveDate: "",
                                                                    leaveTypeId: selectedDropdownID.toString(),
                                                                    fromDate: fromDate.text,
                                                                    toDate: toDate.text,
                                                                    noOfDays: dayCount.text,
                                                                    remarks: remark.text,
                                                                    files: "${e}",
                                                                    onSuccess: (e) {
                                                                      customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                                      loading = false;
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveScreen()));
                                                                    },
                                                                    onFail: (e) {
                                                                      customWidget.showCustomSnackbar(context, "${e}");
                                                                      loading = false;
                                                                      Navigator.pop(context);
                                                                    });
                                                              },
                                                              onFail: (e){
                                                                customWidget.showCustomSnackbar(context, "${e}");
                                                                loading = false;
                                                                Navigator.pop(context);
                                                              }
                                                          );
                                                        }
                                                      }
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all(
                                                      const Color(0xFF1294F2),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'latoRagular',
                                                        color: kWhiteColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SizedBox(
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField<String>(
                                                hint: const Text(
                                                  "Select Leave Type",
                                                  style: TextStyle(
                                                    fontFamily: 'latoRagular',
                                                    fontSize: 14,
                                                    color: Color(0xFFC4C4C4),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  contentPadding:
                                                  const EdgeInsets.all(
                                                      10.0),
                                                  label: const Text(
                                                    "Leave Type *",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: Color(0xFF102048),
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                    borderSide:
                                                    const BorderSide(
                                                      color: kLightGreyColor,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: kLightGreyColor),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownLeaveValue =
                                                        newValue;

                                                    // Find the corresponding ID based on the selected name
                                                    final selectedLeaveType =
                                                    leaveProvider
                                                        .leaveTypeResponseModel
                                                        ?.data
                                                        ?.leaveTypes
                                                        ?.firstWhere(
                                                          (leaveType) =>
                                                      leaveType.name ==
                                                          newValue,
                                                      orElse: () =>
                                                          LeaveTypes(), // Provide a default empty LeaveTypes object
                                                    );

                                                    // Check if selectedLeaveType is not null before accessing its ID
                                                    selectedDropdownID =
                                                        selectedLeaveType?.id
                                                            ?.toString();
                                                  });
                                                },
                                                items: leaveProvider
                                                    .leaveTypeResponseModel
                                                    ?.data
                                                    ?.leaveTypes
                                                    ?.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (LeaveTypes
                                                    leaveType) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: leaveType.name ??
                                                            "",
                                                        child: Text(
                                                          leaveType.name ?? "",
                                                          style:
                                                          const TextStyle(
                                                            fontFamily:
                                                            'latoRagular',
                                                            color: kThemeColor,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList() ??
                                                    [],
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                child: Container(
                                                  child: DropdownButtonFormField<HalfDay>(
                                                    hint: const Text(
                                                      "Select Half Leave Type",
                                                      style: TextStyle(
                                                        fontFamily: 'latoRagular',
                                                        fontSize: 12,
                                                        color: Color(0xFFC4C4C4),
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.transparent,
                                                      contentPadding: const EdgeInsets.all(
                                                          10.0),
                                                      label: const Text(
                                                        "Half Day Leave Type *",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(0xFF102048),
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                                                        borderSide:
                                                        const BorderSide(
                                                          color: kLightGreyColor,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: const BorderSide(
                                                            color: kLightGreyColor),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                      ),
                                                    ),
                                                    onChanged: (HalfDay? newValue) {
                                                      setState(() {
                                                        selectedHalfDropdownID = newValue!.id.toString();
                                                      });
                                                    },
                                                    items: halfDays.map<DropdownMenuItem<HalfDay>>((HalfDay halfday) {
                                                          return DropdownMenuItem<HalfDay>(
                                                            value: halfday,
                                                            child: Text(
                                                              halfday.title!,
                                                              style: const TextStyle(
                                                                fontFamily:
                                                                'latoRagular',
                                                                color: kThemeColor,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()
                                                  ),
                                                ),
                                              ),

                                              //Date
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    DateTime? pickeddate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2022),
                                                      lastDate: DateTime(2040),
                                                    );
                                                    if (pickeddate != null) {
                                                      setState(
                                                        () {
                                                          halfDate.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: TextField(
                                                    enabled: false,
                                                    controller: halfDate,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      label: const Text(
                                                        "Date *",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kThemeColor,
                                                        ),
                                                      ),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      suffixIcon: Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        size: 18.sp,
                                                      ),
                                                      // Icon(Icons.calendar_month_outlined),
                                                      hintText: "yyyy-MM-dd",
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: const Color(
                                                              0xFFC4C4C4),
                                                          fontSize: 16.sp,
                                                          overflow: TextOverflow
                                                              .visible),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              kLightGreyColor,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    kLightGreyColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              //Attachment
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, bottom: 5),
                                                    child: Text(
                                                      "Attachment",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'latoRagular',
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kThemeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  dottedBorder(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        final result =
                                                            await FilePicker.platform.pickFiles(
                                                          allowMultiple: false, // Set to true if you want to allow multiple files.
                                                          type: FileType.custom, // You can specify the file types you want to allow.
                                                          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'xlsx', 'csv'],
                                                        );
                                                        setState(() {
                                                          if (result != null && result.files.isNotEmpty) {
                                                            setState(() {
                                                              final upload = result.files.first; // Pass the PlatformFile here
                                                              file = File(result.files.first.path!);
                                                              selectedFileNameHalfDay = upload.name ?? ''; // Store the selected file name
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 5.h,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  height: 3.h,
                                                                  width: 3.w,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/images/upload_plus.png"),
                                                                ),
                                                                Container(
                                                                  height: 5.h,
                                                                  width: 55.w,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        selectedFileNameHalfDay == null ? "Upload Your Documents" : selectedFileNameHalfDay!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'latoRagular',
                                                                          fontSize:
                                                                              14.sp,
                                                                          color:
                                                                              const Color(0xFF6A8495),
                                                                        ),
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
                                                  ),
                                                ],
                                              ),

                                              //Reason for Leave
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: TextField(
                                                  maxLines: maxLines,
                                                  controller: halfDayRemark,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.transparent,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    hintText:
                                                        "Reason For Leave *",
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xFFC4C4C4),
                                                      fontSize: 14.5.sp,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: kLightGreyColor,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color:
                                                              kLightGreyColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Submit Button
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: SizedBox(
                                                  height: 5.h,
                                                  width: 90.w,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (selectedDropdownID == null) {
                                                          customWidget.showCustomSnackbar(context, "Please select a leave type");
                                                        } else if (selectedHalfDropdownID == null) {
                                                          customWidget.showCustomSnackbar(context, "Please select a leave type");
                                                        } else if (halfDate.text.isEmpty == true) {
                                                          customWidget.showCustomSnackbar(context, "Please fill up the  date");
                                                        } else if (halfDayRemark.text.isEmpty == true) {
                                                          customWidget.showCustomSnackbar(context, "Please fill up the reason");
                                                        } else {
                                                          if(file == null){
                                                            loading = true;
                                                            leaveProvider.leavePost(
                                                                id: UserData.id ?? 0,
                                                                mode: "half-day",
                                                                leaveDate: halfDate.text,
                                                                leaveSlot: selectedHalfDropdownID.toString(),
                                                                leaveTypeId: selectedDropdownID!,
                                                                fromDate: "",
                                                                toDate: "",
                                                                noOfDays: "0.5",
                                                                remarks: halfDayRemark.text,
                                                                files: "",
                                                                onSuccess: (e) {
                                                                  customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                                  loading = false;
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              LeaveScreen()));
                                                                },
                                                                onFail: (e) {
                                                                  customWidget.showCustomSnackbar(
                                                                      context,
                                                                      "${e}");
                                                                  loading =
                                                                  false;
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                          }else{
                                                            loading = true;
                                                            leaveProvider.uploadImageFileForLeave(
                                                                filePath: file,
                                                                onSuccess: (e){
                                                                  leaveProvider.leavePost(
                                                                      id: UserData.id ?? 0,
                                                                      mode: "half-day",
                                                                      leaveDate: halfDate.text,
                                                                      leaveSlot: selectedHalfDropdownID.toString(),
                                                                      leaveTypeId: selectedDropdownID!,
                                                                      fromDate: "",
                                                                      toDate: "",
                                                                      noOfDays: "0.5",
                                                                      remarks: halfDayRemark.text,
                                                                      files: "${e}",
                                                                      onSuccess: (e) {
                                                                        customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                                        loading = false;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    LeaveScreen()));
                                                                      },
                                                                      onFail: (e) {
                                                                        customWidget.showCustomSnackbar(
                                                                            context,
                                                                            "${e}");
                                                                        loading =
                                                                        false;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                },
                                                                onFail: (e){
                                                                  customWidget.showCustomSnackbar(
                                                                      context,
                                                                      "${e}");
                                                                  loading =
                                                                  false;
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                            );
                                                          }
                                                        }
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        const Color(0xFF1294F2),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'latoRagular',
                                                          color: kWhiteColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                      });
                    },
                  );
                }
              },
              backgroundColor: kBlueColor,
              child: const Icon(
                Icons.add,
                color: kWhiteColor,
              ),
            );
          }),
        ),
      ),
    );
  }


  //filter leaves by status
  List<Leaves>? _filterLeavesByStatus(List<Leaves>? leaves, String status) {
    if (leaves == null) return null;
    return leaves.where((leave) => leave.status == status).toList();
  }

  //build status filter buttons
  Widget _buildStatusButton(String label, String status) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(2)),
      ),
      onPressed: () {
        setState(() {
          selectedType = status;
        });
      },
      child: Container(
        height: 5.h,
        width: 25.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: selectedType == status ? kWhiteColor : const Color(0xFF19888E),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: selectedType == status ? kBlackColor : kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllList(Leaves? leaves) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 90),
                  child: Container(
                    width: 90.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Leave Details",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor,
                                ),
                              ),
                              Container(
                                height: 4.h,
                                width: 10.w,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                    height: 2.h,
                                    width: 4.w,
                                    child: const Image(
                                      image: AssetImage(
                                          "assets/images/cancel.png"),
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: const Color(0xFFA7A7A7),
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: leaves?.files == ""
                              ? null
                              : () async {
                                  final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${leaves!.files}"));

                                  if (response.statusCode == 200) {
                                    final bytes = response.bodyBytes;
                                    final directory =
                                        await getTemporaryDirectory();
                                    final filePath =
                                        '${directory.path}/${leaves!.files}';
                                    await File(filePath).writeAsBytes(bytes);
                                    await OpenFile.open(filePath);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Uploaded file is not open")));
                                  }
                                },
                          child: Center(
                            child: dottedBorder(
                              child: Container(
                                height: 10.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 3.h,
                                      width: 3.w,
                                      child: leaves?.files != ""
                                          ? Image.asset(
                                              "assets/images/upload_plus.png")
                                          : SizedBox.shrink(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        height: 10.h,
                                        width: 55.w,
                                        child: Center(
                                          child: Text(
                                            leaves?.files != ""
                                                ? "${leaves!.files}"
                                                : "N/A",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 14.sp,
                                              color: const Color(0xFF6A8495),
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
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Days Of Leave :",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                              Text(
                                '${leaves?.noOfDays ?? "N/A "} Days',
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  color: const Color(0xFFEBA900),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Leave Type :",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                              Text(
                                leaves?.leaveType?.name ?? "N/A",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  color: const Color(0xFF252930),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "From Date :",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                              Text(
                                DateFormat('dd-MMM-yyyy').format(
                                    DateTime.parse(leaves?.fromDate ?? "N/A")),
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  color: const Color(0xFF252930),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "To Date :",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                              Text(
                                DateFormat('dd-MMM-yyyy').format(
                                    DateTime.parse(leaves?.toDate ?? "N/A")),
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  color: const Color(0xFF252930),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Applied Date :",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                              Text(
                                DateFormat('dd-MMM-yyyy').format(
                                    DateTime.parse(leaves?.createdAt ?? "N/A")),
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  color: const Color(0xFF252930),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reason :",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF808080),
                                ),
                              ),
                              Container(
                                width: 55.w,
                                height: 10.h,
                                child: Text(
                                  "${leaves?.remarks ?? "N/A"}",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp,
                                    color: const Color(0xFFEBA900),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Center(
                          child: Container(
                            height: 4.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              color: leaves?.status == "Pending"
                                  ? Color(0xFFEBA900)
                                  : leaves?.status == "Approved"
                                      ? kGreenColor
                                      : Color.fromRGBO(245, 45, 45, 1),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${leaves?.status ?? "N/A"}",
                                // "Pending",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp,
                                  color: kWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
      },
      child: Container(
        height: 17.h,
        width: 90.w,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 5,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //"21 Dec 2022 - 22 Dec 2022",
                        leaves?.fromDate != null
                            ? "${DateFormat('dd MMM yyyy').format(DateTime.parse(leaves?.fromDate ?? ""))}"
                                " -  "
                                "${DateFormat('dd MMM yyyy').format(DateTime.parse(leaves?.toDate ?? ""))}"
                            : "N/A",

                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF252930),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Leave Type : ',
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF808080),
                              ),
                            ),
                            TextSpan(
                              text: leaves?.leaveType?.name ?? "N/A",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: const Color(0xFF252930),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                        width: 60.w,
                        child: Text(
                          leaves?.remarks ?? "N/A",
                          // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF575757),
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Applied Date : ',
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1294F2),
                              ),
                            ),
                            TextSpan(
                              // text: "18 Dec-20212",
                              text: DateFormat('dd MMM-yyyy').format(
                                  DateTime.parse(leaves?.createdAt ?? "")),
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: kBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${leaves?.noOfDays ?? "N/A "} ',
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: leaves?.status == "Pending"
                                ? const Color(0xFFEBA900)
                                : const Color(0xFF06B402),
                          ),
                        ),
                        TextSpan(
                          text: "Days",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                            color: leaves?.status == "Pending"
                                ? const Color(0xFFEBA900)
                                : const Color(0xFF06B402),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 74.2.w,
              top: 12.h,
              child: Container(
                height: 5.h,
                width: 20.w,
                padding: EdgeInsets.only(left: 5,right: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: leaves?.status == "Pending"
                      ? Color(0xFFEBA900)
                      : leaves?.status == "Approved"
                          ? kGreenColor
                          : Color.fromRGBO(245, 45, 45, 1),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    leaves?.status ?? "N/A",
                    // "Pending",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveList(List<Leaves>? leaves) {
    return leaves?.isEmpty ?? true // Check if leaves is empty
        ? Center(
            child: Text(
              'No data available.',
              style: TextStyle(
                fontFamily: 'latoRagular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF252930),
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: leaves?.length ?? 0,
              itemBuilder: (context, index) {
                final allLeave = leaves?[index];

                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 120),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Leave Details",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kBlackColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: SizedBox(
                                            height: 2.h,
                                            width: 4.w,
                                            child: const Image(
                                              image: AssetImage(
                                                  "assets/images/cancel.png"),
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: const Color(0xFFA7A7A7),
                                    height: 1.h,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final response = await http.get(Uri.parse(
                                          "${BASE_URL_IMAGE}/assets/${allLeave!.files}"));

                                      if (response.statusCode == 200) {
                                        final bytes = response.bodyBytes;
                                        final directory =
                                            await getTemporaryDirectory();
                                        final filePath =
                                            '${directory.path}/${allLeave!.files}';
                                        await File(filePath)
                                            .writeAsBytes(bytes);
                                        await OpenFile.open(filePath);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Uploaded file is not open")));
                                      }
                                    },
                                    child: Center(
                                      child: dottedBorder(
                                        child: Container(
                                          height: 10.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 3.h,
                                                width: 3.w,
                                                child: Image.asset(
                                                    "assets/images/upload_plus.png"),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Center(
                                                    child: Text(
                                                      allLeave!.files != null
                                                          ? "${allLeave!.files}"
                                                          : "Show Your Documents",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'latoRagular',
                                                        fontSize: 14.sp,
                                                        color: const Color(
                                                            0xFF6A8495),
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
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Days Of Leave :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          '${allLeave?.noOfDays ?? "N/A "} Days',
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFFEBA900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Leave Type :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          allLeave?.leaveType?.name ?? "N/A",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "From Date :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  allLeave?.fromDate ?? "N/A")),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To Date :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  allLeave?.toDate ?? "N/A")),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Applied Date :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  allLeave?.createdAt ??
                                                      "N/A")),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 3.h,
                                      width: 20.w,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: Color(0xFFEBA900),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${allLeave?.status ?? "N/A"}",
                                          // "Pending",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.sp,
                                            color: kWhiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Container(
                      height: 15.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //"21 Dec 2022 - 22 Dec 2022",
                                      allLeave?.fromDate != null
                                          ? "${DateFormat('dd MMM yyyy').format(DateTime.parse(allLeave?.fromDate ?? ""))}"
                                              " -  "
                                              "${DateFormat('dd MMM yyyy').format(DateTime.parse(allLeave?.toDate ?? ""))}"
                                          : "N/A",

                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF252930),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Leave Type : ',
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF808080),
                                            ),
                                          ),
                                          TextSpan(
                                            text: allLeave?.leaveType?.name ??
                                                "N/A",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                              color: const Color(0xFF252930),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                      width: 60.w,
                                      child: Text(
                                        allLeave?.remarks ?? "N/A",
                                        // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF575757),
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Applied Date : ',
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF1294F2),
                                            ),
                                          ),
                                          TextSpan(
                                            // text: "18 Dec-20212",
                                            text: DateFormat('dd MMM-yyyy')
                                                .format(DateTime.parse(
                                                    allLeave?.createdAt ?? "")),
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${allLeave?.noOfDays ?? "N/A "} ',
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFEBA900),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Days",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.sp,
                                          color: const Color(0xFFEBA900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 70.w,
                            top: 12.h,
                            child: Container(
                              height: 3.h,
                              width: 20.w,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Color(0xFFEBA900),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${allLeave?.status ?? "N/A"}",
                                  // "Pending",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildApprovedList(List<Leaves>? leaves) {
    return leaves?.isEmpty ?? true
        ? Center(
            child: Text(
              'No data available.',
              style: TextStyle(
                fontFamily: 'latoRagular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF252930),
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: leaves?.length ?? 0,
              itemBuilder: (context, index) {
                final allLeave = leaves?[index];

                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 120),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Leave Details",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kBlackColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: SizedBox(
                                            height: 2.h,
                                            width: 4.w,
                                            child: const Image(
                                              image: AssetImage(
                                                  "assets/images/cancel.png"),
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: const Color(0xFFA7A7A7),
                                    height: 1.h,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final response = await http.get(Uri.parse(
                                          "${BASE_URL_IMAGE}/assets/${allLeave!.files}"));

                                      if (response.statusCode == 200) {
                                        final bytes = response.bodyBytes;
                                        final directory =
                                            await getTemporaryDirectory();
                                        final filePath =
                                            '${directory.path}/${allLeave!.files}';
                                        await File(filePath)
                                            .writeAsBytes(bytes);
                                        await OpenFile.open(filePath);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Uploaded file is not open")));
                                      }
                                    },
                                    child: Center(
                                      child: dottedBorder(
                                        child: Container(
                                          height: 10.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 3.h,
                                                width: 3.w,
                                                child: Image.asset(
                                                    "assets/images/upload_plus.png"),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Center(
                                                    child: Text(
                                                      allLeave!.files != null
                                                          ? "${allLeave!.files}"
                                                          : "Show Your Documents",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'latoRagular',
                                                        fontSize: 14.sp,
                                                        color: const Color(
                                                            0xFF6A8495),
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
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Days Of Leave :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          '${allLeave?.noOfDays ?? "N/A "} Days',
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFFEBA900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Leave Type :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          allLeave?.leaveType?.name ?? "N/A",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "From Date :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  allLeave?.fromDate ?? "N/A")),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To Date :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  allLeave?.toDate ?? "N/A")),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Applied Date :",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF808080),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  allLeave?.createdAt ??
                                                      "N/A")),
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.sp,
                                            color: const Color(0xFF252930),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 3.h,
                                      width: 20.w,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: Color(0xFFEBA900),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${allLeave?.status ?? "N/A"}",
                                          // "Pending",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.sp,
                                            color: kWhiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Container(
                      height: 15.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allLeave?.fromDate != null
                                          ? "${DateFormat('dd MMM yyyy').format(DateTime.parse(allLeave?.fromDate ?? ""))}"
                                              " -  "
                                              "${DateFormat('dd MMM yyyy').format(DateTime.parse(allLeave?.toDate ?? ""))}"
                                          : "N/A",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF252930),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Leave Type : ',
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF808080),
                                            ),
                                          ),
                                          TextSpan(
                                            text: allLeave?.leaveType?.name ??
                                                "N/A",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                              color: const Color(0xFF252930),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                      width: 60.w,
                                      child: Text(
                                        allLeave?.remarks ?? "N/A",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF575757),
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Applied Date : ',
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF1294F2),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "18 Dec-20212",
                                            style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${allLeave?.noOfDays ?? "N/A "} ',
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF06B402),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Days",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.sp,
                                          color: const Color(0xFF06B402),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 70.w,
                            top: 12.h,
                            child: Container(
                              height: 3.h,
                              width: 20.w,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Color(0xFF06B402),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  allLeave?.status ?? "N/A ",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

Widget customLeaveContainer({label, totalleave, availableleave, kicon, psize}) {
  return Container(
    height: 10.h,
    width: 55.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 2,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
      color: kWhiteColor,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: kBlueColor,
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Leaves : ',
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                    ),
                    TextSpan(
                      text: totalleave,
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: kBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Available Leaves : ',
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                    ),
                    TextSpan(
                      text: availableleave,
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: kBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: psize,
            child: SizedBox(
              height: 8.h,
              width: 14.w,
              child: kicon,
            ),
          ),
        ],
      ),
    ),
  );
}

//Formated Time
String _formatMillisecondsToDateString(String millisecondsString) {
  int milliseconds = int.tryParse(millisecondsString) ?? 0;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

  String formattedDate =
      "${dateTime.day}${_getDaySuffix(dateTime.day)} ${_getMonthName(dateTime.month)} ${dateTime.year}";

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
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return monthNames[month];
}

Widget dottedBorder({required Widget child}) => DottedBorder(
      strokeWidth: 1,
      dashPattern: const [10, 5],
      color: const Color(0xFF6A8495),
      borderType: BorderType.RRect,
      radius: const Radius.circular(5),
      child: child,
    );
