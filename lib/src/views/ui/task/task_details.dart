import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/providers/task_provider.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/task/edit_task_screen.dart';
import 'package:team360/src/views/ui/task/task_screen.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../../business_logics/utils/constants.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key,required this.index,required this.isAssignedByMeTask}) : super(key: key);
  final int index;
  final bool isAssignedByMeTask;
  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  FocusNode taskTitleETFocusNode = FocusNode();
  TextEditingController addTaskDate = TextEditingController();
  bool state = false;
  bool isLoading = false;
  final int som = 0;
  String title = "";
  String details = "";
  int employeeID = 0;
  String assignedByName = "";
  String assignedByDesignation = "";
  List<dynamic> taskUser = [];
  String dueDate = "";
  String fileName = "";
  String status = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 1),() async{
      TaskProvider taskProvider = Provider.of<TaskProvider>(context,listen: false);
      await taskProvider.singleTaskDetails(widget.index).then((value){
        title = value!.data!.title!;
        details = value.data!.description!;
        assignedByName = value.data!.CreatedBy!.name!;
        employeeID = value.data!.CreatedBy!.employee!.id!;
        dueDate = dateFormation(date: DateFormat("d MMM y").format(DateTime.parse(value.data!.dueDate!)));
        fileName = value.data!.file!;
        value.data!.CreatedBy?.employee?.designations?.name != null ? assignedByDesignation = value.data!.CreatedBy!.employee!.designations!.name! : assignedByDesignation == "";
        value.data!.taskUsers!.forEach((element) {
          if(element.assignTo?.id == UserData.id) {
            status = element.status!;
          }
          taskUser.add(
            {
              "name": element.assignTo?.name,
              "status": element.status,
              "designation": element.assignTo?.employee!.designations?.name! == null ? "" : element.assignTo!.employee!.designations!.name!
            }
          );
        });
        setState(() {
          isLoading = false;
        });
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask,)));
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
                padding: const EdgeInsets.symmetric(vertical: 10),
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
          body: isLoading == true ?
             Container(
               height: MediaQuery.of(context).size.height/1,
               width: MediaQuery.of(context).size.width/1,
               child: const Center(
                 child: CircularProgressIndicator(),
               ),
             )
              : SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 5.h,
                          width: 80.w,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
                                },
                                child: Container(
                                  height: 4.5.h,
                                  width: 9.w,
                                  decoration: const BoxDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child:
                                        Image.asset("assets/images/arrow_left.png"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Task Details",
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
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              //Titel & Edit Task
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${title}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF102048),
                                      ),
                                    ),
                                    widget.isAssignedByMeTask == false  && UserData.id != employeeID?
                                    SizedBox.shrink() : SizedBox(
                                      height: 6.h,
                                      width: 12.w,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskScreen(index: widget.index,isFirst: true,isAssignedByMeTask: widget.isAssignedByMeTask,)));
                                        },
                                        icon: ImageIcon(
                                          const AssetImage(
                                              "assets/images/edittask.png"),
                                          size: 20.sp,
                                          color: kBlueColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                height: 3.h,
                              ),
                              //Details
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Details",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: kThemeColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 90.w,
                                        child: Text(
                                          "${details}",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF808080),
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: const Color(0xFFA0BBB6),
                                height: 3.h,
                              ),
                              //Assigned By
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Assigned By",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: kThemeColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${assignedByName}\n",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF808080),
                                                ),
                                              ),
                                              TextSpan(
                                                text: "${assignedByDesignation}",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xFF808080),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                        // Text(
                                        //   "Suzzad Hossain Shuvo",
                                        //   style: TextStyle(
                                        //     fontFamily: 'latoRagular',
                                        //     fontSize: 16.sp,
                                        //     fontWeight: FontWeight.w600,
                                        //     color: const Color(0xFF808080),
                                        //   ),
                                        // ),
                                        ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: const Color(0xFFA0BBB6),
                                height: 3.h,
                              ),
                              //Assigned To
                              Container(
                                height: 10.h,
                                width: 90.h,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Assigned To",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: kThemeColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Expanded(
                                        child: SizedBox(
                                          width: 90.h,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: taskUser.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context,int index){
                                                return Row(
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${taskUser[index]["name"]} ",
                                                            style: TextStyle(
                                                              decoration: TextDecoration.underline,
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: kBlueColor,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "(${taskUser[index]["status"]})\n",
                                                            style: TextStyle(
                                                              decoration: TextDecoration.underline,
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: kGreenColor,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${taskUser[index]["designation"]}",
                                                            style: TextStyle(
                                                              fontFamily: 'latoRagular',
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w400,
                                                              color: kBlueColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 5.w,)
                                                  ],
                                                );
                                              }
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: const Color(0xFFA0BBB6),
                                height: 3.h,
                              ),
                              //Due Date
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Due Date",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: const Color(0xFFE5252A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${dueDate}",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFFE5252A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: const Color(0xFFA0BBB6),
                                height: 3.h,
                              ),

                              // //PDF , Image ,XLS File Attach
                              fileName != "" ?
                              Padding(
                                padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
                                child: addTaskDottedBorder(
                                  child: TextButton(
                                    onPressed: () async {
                                      final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${fileName}"));

                                      if(response.statusCode == 200){
                                        final bytes = response.bodyBytes;
                                        final directory = await getTemporaryDirectory();
                                        final filePath = '${directory.path}/${fileName}';
                                        await File(filePath).writeAsBytes(bytes);
                                        await OpenFile.open(filePath);
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uploaded file is not open")));
                                      }
                                    },
                                    child: Container(
                                      height: 5.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.download_for_offline_outlined,size: 20,color: Color.fromRGBO(12, 12, 12, 1),),
                                          Container(
                                            height: 5.h,
                                            width: 55.w,
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text(
                                                fileName,
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontSize: 14.sp,
                                                  color: const Color(0xFF6A8495),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  : SizedBox.shrink(),


                              //Status
                              widget.isAssignedByMeTask == false ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: addTaskDopWidget(
                                  "Select Status",
                                  // "Status",
                                  <String>[
                                    "New",
                                    "In Progress",
                                    "Completed",
                                  ],
                                ),
                              ) : SizedBox.shrink(),

                              SizedBox(height: 20,),

                              //Reschedule
                              status != "Completed" ? Padding(
                                padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                                child: ReScheduleCustomSwitch(
                                  index: widget.index,
                                  isAssignedByMeTask: widget.isAssignedByMeTask,
                                  value: state,
                                  onChanged: (value) {
                                      setState(() {
                                          state = value;
                                        },
                                      );
                                  },
                                ),
                              ) : SizedBox.shrink(),
                            ],
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
    );
  }

  Widget addTaskDopWidget(label, item) {
    return Consumer<TaskProvider>(
        builder: (context,taskProvider,child){
          return SizedBox(
            height: 6.h,
            width: 90.w,
            child: DropdownButtonFormField<String>(
              value: status,
              // hint: Text(
              //   hint,
              //   style: const TextStyle(
              //     fontFamily: 'latoRagular',
              //     fontSize: 14,
              //     color: Color(0xFFC4C4C4),
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              // value: dropdownValue,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(10.0),
                label: Text(
                  label,
                  style: const TextStyle(
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
                    color: Color(0xFFA7A7A7),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA7A7A7)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  taskProvider.updateTaskStatus(
                      id: widget.index,
                      status: newValue!,
                      onSuccess: (e){
                        customWidget.showCustomSuccessSnackbar(context, "${e}");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
                      },
                      onFail: (e){
                        customWidget.showCustomSnackbar(context, "${e}");
                      });
                });
              },
              items: item.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'latoRagular',
                      color: kThemeColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  }


  Widget addTaskDottedBorder({required Widget child}) => DottedBorder(
    strokeWidth: 1,
    dashPattern: const [10, 5],
    color: const Color(0xFF6A8495),
    borderType: BorderType.RRect,
    radius: const Radius.circular(8),
    child: child,
  );
}



class ReScheduleCustomSwitch extends StatefulWidget {
  bool value= false;
  final ValueChanged<bool> onChanged;
  final int index;
  final bool isAssignedByMeTask;
   ReScheduleCustomSwitch(
      {Key? key, required this.value, required this.onChanged, required this.index, required this.isAssignedByMeTask})
      : super(key: key);

  @override
  _ReScheduleCustomSwitchState createState() => _ReScheduleCustomSwitchState();
}

class _ReScheduleCustomSwitchState extends State<ReScheduleCustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _animationController!,
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                if (_animationController!.isCompleted) {
                  _animationController!.reverse();
                } else {
                  _animationController!.forward();
                }
                widget.value == false
                    ? widget.onChanged(true)
                    : widget.onChanged(false);
                if (widget.value == false) {
                  reScheduleDialog(context);
                }
                else {}
              },
              child: Container(
                width: 11.5.w,
                height: 2.5.h,
                decoration: BoxDecoration(
                  color: widget.value ? const Color(0xFF263238) : kWhiteColor,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                      color: widget.value ? kWhiteColor : const Color(0xFF263238),
                      width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, right: 0.5, left: 0.5),
                  child: Container(
                    alignment: widget.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 2.h,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: widget.value ? kWhiteColor : const Color(0xFF263238),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 2.w),
        Text(
          "Reschedule",
          style: TextStyle(
            fontFamily: 'latoRagular',
            fontSize: 16.sp,
            color: const Color(0xFF263238),
          ),
        ),
      ],
    );
  }

  Future reScheduleDialog (context){
    TextEditingController rescheduleDate = TextEditingController();
    TextEditingController reasoneController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<TaskProvider>(
            builder: (context,teskProvider,child){
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  insetPadding: const EdgeInsets.only(left: 15,right: 15,top: 150),
                  child: Column(
                    children: [
                      Container(
                        height: 10.h,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const rescheduleEditCustomSwitch(),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.value = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: 1.4.h,
                                  width: 2.8.w,
                                  child: const Image(
                                    image: AssetImage("assets/images/cancel.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Date
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: SizedBox(
                          width: 100.w,
                          child: InkWell(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2040),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  rescheduleDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                            child: TextField(
                              enabled: false,
                              controller: rescheduleDate,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "Reschedule Date",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w600,
                                    color: kThemeColor,
                                  ),
                                ),
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                suffixIcon: Icon(
                                  Icons.calendar_month_outlined,
                                  size: 18.sp,
                                ),
                                // Icon(Icons.calendar_month_outlined),
                                hintText: "yyyy-MM-dd",
                                hintStyle: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC4C4C4),
                                    fontSize: 16.sp,
                                    overflow: TextOverflow.visible),
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
                                  borderSide:
                                  const BorderSide(color: kLightGreyColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Reason
                      Padding(
                        padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                        child: SizedBox(
                          child: TextField(
                            maxLines: 5,
                            controller: reasoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: "Enter Complete Note ....",
                              hintStyle: TextStyle(
                                fontFamily: 'latoRagular',
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFC4C4C4),
                                fontSize: 15.sp,
                              ),
                              label: const Text(
                                "Reason",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF102048),
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      //
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                        child: SizedBox(
                          height: 6.h,
                          width: 100.w,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if(reasoneController.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Please fill the reason field");
                                }else if(rescheduleDate.text.isEmpty){
                                  customWidget.showCustomSnackbar(context, "Please fill the date field");
                                }else {
                                  Map<String,dynamic> data = {
                                    "due_date": rescheduleDate.text,
                                    "reson": reasoneController.text
                                  };
                                  print(jsonEncode(data));
                                  print(widget.index);
                                  teskProvider.reshudleTaskDate(
                                      data: data,
                                      id: widget.index,
                                      onSuccess: (e){
                                        customWidget.showCustomSuccessSnackbar(context, "${e}");
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask,)));
                                      },
                                      onFail: (e){
                                        customWidget.showCustomSnackbar(context, "${e}");
                                      }
                                  );
                                }
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF1294F2),
                              ),
                            ),
                            child: Text(
                              "Request Reschedule",
                              style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  color: kWhiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }
}



class rescheduleEditCustomSwitch extends StatefulWidget {


  const rescheduleEditCustomSwitch({Key? key})
      : super(key: key);

  @override
  _rescheduleEditCustomSwitchState createState() => _rescheduleEditCustomSwitchState();
}

class _rescheduleEditCustomSwitchState extends State<rescheduleEditCustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Container(
          width: 11.w,
          height: 2.5.h,
          decoration: BoxDecoration(
            color: const Color(0xFFAECCDB),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color:const Color(0xFFAECCDB), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 2.0, right: 0.5, left: 0.5),
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                width: 2.h,
                height: 4.w,
                decoration: const BoxDecoration(
                  color:Color(0xFF455A64),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

