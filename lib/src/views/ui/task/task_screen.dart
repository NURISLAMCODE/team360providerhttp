import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/models/task_model/assigned_by_me_model.dart';
import 'package:team360/src/business_logics/models/task_model/assigned_to_me_model.dart';
import 'package:team360/src/business_logics/providers/task_provider.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/task/add_task_screen.dart';
import 'package:team360/src/views/ui/task/task_details.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

import '../../../business_logics/models/task_model/company_user.dart';
import '../bottomnav/bottomnav_screen_layout.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String? type = "assigned_to_me";
  String? all = "All";
  FocusNode serchETFocusNode = FocusNode();
  var tfVisibility = false;
  String employeeId = "";
  String filter_status = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController assignfromDateController = TextEditingController();
  TextEditingController assigntoDateController = TextEditingController();
  TextEditingController duefromDateController = TextEditingController();
  TextEditingController duetoDateController = TextEditingController();
  List<CompanyUsers> companyusers = [];
  CompanyUsers dropDownUsers = CompanyUsers(companyUser: null,status: null,id: 0);
  static List<CompanyUsers> addAllUser = [];
  bool isLoading = false;
  String title = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 1),() async {
      TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.getAllCompanyUser().then((value) {
        value!.data!.companyUser!.forEach((element) {
          setState(() {
            companyusers.add(element);
            isLoading = false;
          });
        });
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
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
          duefromDateController.clear();
          duetoDateController.clear();
          titleController.clear();
          title = "";
          employeeId = "";
          filter_status = "";
          assignfromDateController.clear();
          assigntoDateController.clear();
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
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : Consumer<TaskProvider>(
            builder: (context,taskProvider,child){
              if(type == "assigned_to_me"){
                return FutureBuilder<AssignedToMeModel?>(
                    future: taskProvider.getAssignedToMeTask(
                        status: all!,
                        filter_status: filter_status,
                        assigned_to: employeeId.toString(),
                        due_date_from: duefromDateController.text,
                        due_date_to: duetoDateController.text,
                        assigned_date_from: assignfromDateController.text,
                        assigned_date_to: assigntoDateController.text,
                        title: title,
                        type: type!,
                    ),
                    builder: (context,snapsort){
                      if(snapsort.hasData){
                        return CustomScrollView(
                          slivers: [

                            //Main App Bar
                            SliverAppBar(
                              pinned: true,
                              floating: false,
                              expandedHeight: 10.h,
                              automaticallyImplyLeading: false,
                              backgroundColor: const Color(0xFFEAF4F2),
                              flexibleSpace: Container(
                                height: 9.h,
                                width: 48.w,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                                  child:
                                                  Image.asset("assets/images/arrow_left.png"),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Task",
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
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 6.h,
                                            width: 12.w,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  duefromDateController.clear();
                                                  duetoDateController.clear();
                                                  titleController.clear();
                                                  title = "";
                                                  employeeId = "";
                                                  filter_status = "";
                                                  assignfromDateController.clear();
                                                  assigntoDateController.clear();
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return TaskFilterDialog();
                                                  },
                                                );
                                              },
                                              icon: ImageIcon(
                                                const AssetImage(
                                                    "assets/images/task_screen_icon.png"),
                                                size: 17.sp,
                                                color: kBlueColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SliverFillRemaining(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                ),
                                margin: const EdgeInsets.only(top: 16),
                                child: CustomScrollView(
                                  slivers: [

                                    //Remaining App bar
                                    SliverAppBar(
                                      pinned: true,
                                      floating: true,
                                      expandedHeight: 16.h,
                                      collapsedHeight: 17.h,
                                      automaticallyImplyLeading: false,
                                      flexibleSpace: Container(
                                        height: 16.h,
                                        decoration: BoxDecoration(
                                            color: kWhiteColor
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                                        const EdgeInsets.all(1)),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      type = "assigned_to_me";
                                                      duefromDateController.clear();
                                                      duetoDateController.clear();
                                                      titleController.clear();
                                                      title = "";
                                                      employeeId = "";
                                                      filter_status = "";
                                                      assignfromDateController.clear();
                                                      assigntoDateController.clear();
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 5.8.h,
                                                    width: 48.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(32),
                                                      color: type == "assigned_to_me"
                                                          ? const Color(0xFF1294F2)
                                                          : kWhiteColor,
                                                    ),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "ASSIGN TO ME",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: type == "ASSIGN TO ME"
                                                              ? kWhiteColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                                        const EdgeInsets.all(1)),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      type = "assigned_by_me";
                                                      duefromDateController.clear();
                                                      duetoDateController.clear();
                                                      titleController.clear();
                                                      title = "";
                                                      employeeId = "";
                                                      filter_status = "";
                                                      assignfromDateController.clear();
                                                      assigntoDateController.clear();
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 5.8.h,
                                                    width: 48.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(32),
                                                      color: type == "assigned_by_me"
                                                          ? const Color(0xFF1294F2)
                                                          : kWhiteColor,
                                                    ),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "ASSIGN BY ME",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: type == "ASSIGN BY ME"
                                                              ? kWhiteColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            //All,New,Due & outher
                                            Container(
                                              height: 6.h,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                color: kWhiteColor,
                                                borderRadius: BorderRadius.circular(32),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 5,
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "All";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                          title = "";
                                                        });
                                                      },
                                                      child: Text(
                                                        "All",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color:
                                                          all == "All" ? kBlueColor : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "New";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          title = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "New",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color:
                                                          all == "New" ? kBlueColor : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "In Progress";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          title = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "In Progress",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color:
                                                          all == "In Progress" ? kBlueColor : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "Completed";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          title = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "Completed",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color: all == "Completed"
                                                              ? kBlueColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            //Search Task
                                            Visibility(
                                              visible: tfVisibility,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 10),
                                                child: WidgetFactory.buildTextField(
                                                  textInputType: TextInputType.emailAddress,
                                                  textInputAction: TextInputAction.next,
                                                  context: context,
                                                  label: "Search Task",
                                                  hint: "Enter Task Name/ Date/ Assigned by",
                                                  focusNode: serchETFocusNode,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                                (context,int index){
                                              if(snapsort.data!.data!.tasks![index].urgent == true){
                                                return TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero
                                                  ),
                                                  onPressed: (){
                                                    setState(() {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: snapsort.data!.data!.tasks![index].id!,isAssignedByMeTask: false)));
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    child: Container(
                                                      width: 95.w,
                                                      decoration: BoxDecoration(
                                                          color: kWhiteColor,
                                                          borderRadius: BorderRadius.circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: const Offset(0, 1),
                                                              blurRadius: 5,
                                                              color: Colors.grey.withOpacity(0.3),
                                                            ),
                                                          ]),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          urgentTask(
                                                            title: snapsort.data!.data!.tasks![index].title!,
                                                            details: snapsort.data!.data!.tasks![index].description!,
                                                            id: snapsort.data!.data!.tasks![index].id!,
                                                            dueDate: DateFormat("d MMM y").format(DateTime.parse(snapsort.data!.data!.tasks![index].dueDate!)),
                                                            AssignByMe: snapsort.data!.data!.tasks![index].assignedTo!.name!,
                                                            isAssignedByMeTask: false,
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                  ),
                                                );
                                              }else{
                                                return TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero
                                                  ),
                                                  onPressed: (){
                                                    setState(() {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: snapsort.data!.data!.tasks![index].id!,isAssignedByMeTask: false)));
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    child: Container(
                                                      width: 95.w,
                                                      decoration: BoxDecoration(
                                                          color: kWhiteColor,
                                                          borderRadius: BorderRadius.circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: const Offset(0, 1),
                                                              blurRadius: 5,
                                                              color: Colors.grey.withOpacity(0.3),
                                                            ),
                                                          ]),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          onlyTask(
                                                            title: snapsort.data!.data!.tasks![index].title!,
                                                            details: snapsort.data!.data!.tasks![index].description!,
                                                            id: snapsort.data!.data!.tasks![index].id!,
                                                            dueDate: DateFormat("d MMM y").format(DateTime.parse(snapsort.data!.data!.tasks![index].dueDate!)),
                                                            AssignByMe: snapsort.data!.data!.tasks![index].assignedTo!.name!,
                                                            isAssignedByMeTask: false,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },

                                            childCount: snapsort.data!.data!.tasks!.length
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      else{
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
              }else{
                return FutureBuilder<AssignedByMeModel?>(
                    future: taskProvider.getAssignedByMeTask(
                      status: all!,
                      filter_status: filter_status,
                      assigned_to: employeeId.toString(),
                      due_date_from: duefromDateController.text,
                      due_date_to: duetoDateController.text,
                      assigned_date_from: assignfromDateController.text,
                      assigned_date_to: assigntoDateController.text,
                      title: title,
                      type: type!,
                    ),
                    builder: (context,snapsort){
                      if(snapsort.hasData){
                        return CustomScrollView(
                          slivers: [

                            //Main App Bar
                            SliverAppBar(
                              pinned: true,
                              floating: false,
                              expandedHeight: 10.h,
                              automaticallyImplyLeading: false,
                              backgroundColor: const Color(0xFFEAF4F2),
                              flexibleSpace: Container(
                                height: 9.h,
                                width: 48.w,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                                Navigator.pop(context);
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
                                                "Task",
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
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 6.h,
                                            width: 12.w,
                                            child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return TaskFilterDialog();
                                                  },
                                                );
                                              },
                                              icon: ImageIcon(
                                                const AssetImage(
                                                    "assets/images/task_screen_icon.png"),
                                                size: 17.sp,
                                                color: kBlueColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SliverFillRemaining(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                ),
                                margin: const EdgeInsets.only(top: 16),
                                child: CustomScrollView(
                                  slivers: [

                                    SliverAppBar(
                                      pinned: true,
                                      floating: true,
                                      expandedHeight: 16.h,
                                      collapsedHeight: 17.h,
                                      automaticallyImplyLeading: false,
                                      flexibleSpace: Container(
                                        height: 16.h,
                                        decoration: BoxDecoration(
                                            color: kWhiteColor
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                                        const EdgeInsets.all(1)),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      type = "assigned_to_me";
                                                      duefromDateController.clear();
                                                      duetoDateController.clear();
                                                      titleController.clear();
                                                      title = "";
                                                      employeeId = "";
                                                      filter_status = "";
                                                      assignfromDateController.clear();
                                                      assigntoDateController.clear();
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 5.8.h,
                                                    width: 48.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(32),
                                                      color: type == "assigned_to_me"
                                                          ? const Color(0xFF1294F2)
                                                          : kWhiteColor,
                                                    ),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "ASSIGN TO ME",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: type == "ASSIGN TO ME"
                                                              ? kWhiteColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                                        const EdgeInsets.all(1)),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      type = "assigned_by_me";
                                                      duefromDateController.clear();
                                                      duetoDateController.clear();
                                                      titleController.clear();
                                                      title = "";
                                                      employeeId = "";
                                                      filter_status = "";
                                                      assignfromDateController.clear();
                                                      assigntoDateController.clear();
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 5.8.h,
                                                    width: 48.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(32),
                                                      color: type == "assigned_by_me"
                                                          ? const Color(0xFF1294F2)
                                                          : kWhiteColor,
                                                    ),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "ASSIGN BY ME",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: type == "ASSIGN BY ME"
                                                              ? kWhiteColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            //All,New,Due & outher
                                            Container(
                                              height: 6.h,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                color: kWhiteColor,
                                                borderRadius: BorderRadius.circular(32),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 5,
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "All";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          title = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "All",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color:
                                                          all == "All" ? kBlueColor : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "New";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          title = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "New",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color:
                                                          all == "New" ? kBlueColor : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "In Progress";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          title = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "In Progress",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color:
                                                          all == "In Progress" ? kBlueColor : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          all = "Completed";
                                                          titleController.clear();
                                                          employeeId = "";
                                                          title = "";
                                                          duetoDateController.clear();
                                                          duefromDateController.clear();
                                                          filter_status = "";
                                                          assigntoDateController.clear();
                                                          assignfromDateController.clear();
                                                        });
                                                      },
                                                      child: Text(
                                                        "Completed",
                                                        style: TextStyle(
                                                          fontFamily: 'latoRagular',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 17.sp,
                                                          color: all == "Completed"
                                                              ? kBlueColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            //Search Task
                                            Visibility(
                                              visible: tfVisibility,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 10),
                                                child: WidgetFactory.buildTextField(
                                                  textInputType: TextInputType.emailAddress,
                                                  textInputAction: TextInputAction.next,
                                                  context: context,
                                                  label: "Search Task",
                                                  hint: "Enter Task Name/ Date/ Assigned by",
                                                  focusNode: serchETFocusNode,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                                (context,int index){
                                              if(snapsort.data!.data!.tasks![index].urgent == true){
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding: EdgeInsets.zero
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: snapsort.data!.data!.tasks![index].id!,isAssignedByMeTask: true)));
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: Container(
                                                          width: 95.w,
                                                          decoration: BoxDecoration(
                                                              color: kWhiteColor,
                                                              borderRadius: BorderRadius.circular(10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset: const Offset(0, 1),
                                                                  blurRadius: 5,
                                                                  color: Colors.grey.withOpacity(0.3),
                                                                ),
                                                              ]),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              urgentTask(
                                                                title: snapsort.data!.data!.tasks![index].title!,
                                                                details: snapsort.data!.data!.tasks![index].description!,
                                                                id: snapsort.data!.data!.tasks![index].id!,
                                                                dueDate: DateFormat("d MMM y").format(DateTime.parse(snapsort.data!.data!.tasks![index].dueDate!)),
                                                                AssignByMe: snapsort.data!.data!.tasks![index].assignedTo!.name!,
                                                                isAssignedByMeTask: true,
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }else{
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding: EdgeInsets.zero
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: snapsort.data!.data!.tasks![index].id!,isAssignedByMeTask: true)));
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: Container(
                                                          width: 95.w,
                                                          decoration: BoxDecoration(
                                                              color: kWhiteColor,
                                                              borderRadius: BorderRadius.circular(10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset: const Offset(0, 1),
                                                                  blurRadius: 5,
                                                                  color: Colors.grey.withOpacity(0.3),
                                                                ),
                                                              ]),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              onlyTask(
                                                                title: snapsort.data!.data!.tasks![index].title!,
                                                                details: snapsort.data!.data!.tasks![index].description!,
                                                                id: snapsort.data!.data!.tasks![index].id!,
                                                                dueDate: DateFormat("d MMM y").format(DateTime.parse(snapsort.data!.data!.tasks![index].dueDate!)),
                                                                AssignByMe: snapsort.data!.data!.tasks![index].assignedTo!.name!,
                                                                isAssignedByMeTask: true,
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },

                                            childCount: snapsort.data!.data!.tasks!.length
                                        )
                                    ),

                                  ],
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
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddTaskScreen(isFirst: true,)));
            },
            backgroundColor: kBlueColor,
            child: const Icon(
              Icons.add,
              color: kWhiteColor,
            ),
          ),
        ),
      ),
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


  Widget urgentTask({
    required int id,
    required bool isAssignedByMeTask,
    required String title,
    required String details,
    required String dueDate,
    required String AssignByMe,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF252930),
                    ),
                  ),
                  const SizedBox(height: 10),
                  taskContainer(label: "Details", kData: ": ${details}."),
                  taskContainer(label: "Due Date", kData: ": ${dateFormation(date: dueDate)}"),
                  taskContainer(label: "Assigned By", kData: ": ${AssignByMe}"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.sp,
                  color: const Color(0xFF102048),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 75.w,
          child: Container(
            height: 3.h,
            width: 20.w,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Color(0xFFFC694C),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Urgent",
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
    );
  }

  Widget onlyTask({
    required int id,
    required String title,
    required String details,
    required bool isAssignedByMeTask,
    required String dueDate,
    required String AssignByMe,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF252930),
                ),
              ),
              const SizedBox(height: 10),
              taskContainer(label: "Details", kData: ": ${details}"),
              taskContainer(label: "Due Date", kData: ": ${dateFormation(date: dueDate)}"),
              taskContainer(label: "Assigned By", kData: ": ${AssignByMe}"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20.sp,
              color: const Color(0xFF102048),
            ),
          ),
        ],
      ),
    );
  }

  Widget taskContainer({required label, required kData}) {
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

  Widget TaskFilterDialog(){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 120),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Task",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                          });
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
                Divider(
                  thickness: 1,
                  color: const Color(0xFFA7A7A7),
                  height: 1.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  width: 87.w,
                  height: 6.h,
                  child: TextField(
                    enabled: true,
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(10.0),
                      label: const Text(
                        "Title",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontWeight: FontWeight.w600,
                          color: kThemeColor,
                        ),
                      ),
                      floatingLabelBehavior:
                      FloatingLabelBehavior.always,
                      // Icon(Icons.calendar_month_outlined),
                      hintText: "Enter a task title",
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
                    onChanged: (value){
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                ),

                employeeDropdown(
                  hint: "Select Person",
                  label: "By Person",
                  companyUsers: companyusers,
                ),

                // dopWidget(
                //   hint : "Select Status",
                //   label: "By Status",
                //   items: <String>[
                //     "All",
                //     "New",
                //     "In Progress",
                //     "Complete"
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 5, top: 10),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "By Assign Date",
                //       style: TextStyle(
                //         fontSize: 14.sp,
                //         fontWeight: FontWeight.w600,
                //         fontFamily: 'latoRagular',
                //         color: kThemeColor,
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       InkWell(
                //         onTap: () async {
                //           DateTime? pickedDate = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate: DateTime(2022),
                //             lastDate: DateTime(2040),
                //           );
                //           if (pickedDate != null) {
                //             setState(() {
                //               duefromDateController.text =
                //                   DateFormat('yyyy-MM-dd').format(pickedDate);
                //             });
                //           }
                //         },
                //         child: SizedBox(
                //           width: 43.5.w,
                //           child: TextField(
                //             enabled: false,
                //             controller: duefromDateController,
                //             decoration: InputDecoration(
                //               filled: true,
                //               fillColor: Colors.transparent,
                //               contentPadding: const EdgeInsets.all(10.0),
                //               label: const Text(
                //                 "From Date",
                //                 style: TextStyle(
                //                   fontFamily: 'latoRagular',
                //                   fontWeight: FontWeight.w600,
                //                   color: kThemeColor,
                //                 ),
                //               ),
                //               floatingLabelBehavior:
                //               FloatingLabelBehavior.always,
                //               suffixIcon: Icon(
                //                 Icons.calendar_month_outlined,
                //                 size: 18.sp,
                //               ),
                //               // Icon(Icons.calendar_month_outlined),
                //               hintText: "yyyy-MM-dd",
                //               hintStyle: TextStyle(
                //                   fontFamily: 'latoRagular',
                //                   fontWeight: FontWeight.w400,
                //                   color: const Color(0xFFC4C4C4),
                //                   fontSize: 16.sp,
                //                   overflow: TextOverflow.visible),
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //               enabledBorder: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(8),
                //                 borderSide: const BorderSide(
                //                   color: kLightGreyColor,
                //                 ),
                //               ),
                //               focusedBorder: OutlineInputBorder(
                //                 borderSide:
                //                 const BorderSide(color: kLightGreyColor),
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 5),
                //       InkWell(
                //         onTap: () async {
                //           DateTime? pickedDate = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate: DateTime(2022),
                //             lastDate: DateTime(2040),
                //           );
                //           if (pickedDate != null) {
                //             setState(() {
                //               duetoDateController.text =
                //                   DateFormat('yyyy-MM-dd').format(pickedDate);
                //             });
                //           }
                //         },
                //         child: SizedBox(
                //           width: 43.5.w,
                //           child: TextField(
                //             enabled: false,
                //             controller: duetoDateController,
                //             decoration: InputDecoration(
                //               filled: true,
                //               fillColor: Colors.transparent,
                //               contentPadding: const EdgeInsets.all(10.0),
                //               label: const Text(
                //                 "To Date",
                //                 style: TextStyle(
                //                   fontFamily: 'latoRagular',
                //                   fontWeight: FontWeight.w600,
                //                   color: kThemeColor,
                //                 ),
                //               ),
                //               floatingLabelBehavior:
                //               FloatingLabelBehavior.always,
                //               suffixIcon: Icon(
                //                 Icons.calendar_month_outlined,
                //                 size: 18.sp,
                //               ),
                //               hintText: "yyyy-MM-dd",
                //               hintStyle: TextStyle(
                //                   fontFamily: 'latoRagular',
                //                   fontWeight: FontWeight.w400,
                //                   color: const Color(0xFFC4C4C4),
                //                   fontSize: 16.sp,
                //                   overflow: TextOverflow.visible),
                //               border: OutlineInputBorder(
                //                   borderRadius: BorderRadius.circular(8)),
                //               enabledBorder: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(8),
                //                 borderSide: const BorderSide(
                //                   color: kLightGreyColor,
                //                 ),
                //               ),
                //               focusedBorder: OutlineInputBorder(
                //                 borderSide:
                //                 const BorderSide(color: kLightGreyColor),
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: Container(
                    width: 87.w,
                    height: 5.h,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "By Due Date",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'latoRagular',
                          color: kThemeColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2040),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              assignfromDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        child: SizedBox(
                          width: 43.5.w,
                          child: TextField(
                            enabled: false,
                            controller: assignfromDateController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.all(10.0),
                              label: const Text(
                                "From Date",
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
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(assignfromDateController.text),
                            firstDate: DateTime.parse(assignfromDateController.text),
                            lastDate: DateTime(2040),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              assigntoDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        child: SizedBox(
                          width: 43.5.w,
                          child: TextField(
                            enabled: false,
                            controller: assigntoDateController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.all(10.0),
                              label: const Text(
                                "To Date",
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
                              hintText: "yyyy-MM-dd",
                              hintStyle: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFC4C4C4),
                                  fontSize: 16.sp,
                                  overflow: TextOverflow.visible),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: 90.w,
                  height: 5.h,
                  child: WidgetFactory.buildButton(
                    backgroundColor: kBlueColor,
                    borderColor: Colors.transparent,
                    context: context,
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    text: "Filter",
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget dopWidget({required String hint,required String label,required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 6.h,
        width: 90.w,
        child: DropdownButtonFormField<String>(
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 14,
              color: Color(0xFFC4C4C4),
              fontWeight: FontWeight.w400,
            ),
          ),
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
              filter_status = newValue!;
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
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
      ),
    );
  }

  Widget employeeDropdown({required String hint,required String label,required List<CompanyUsers> companyUsers}){
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 6.h,
        width: 87.w,
        child: DropdownButtonFormField<CompanyUsers>(
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 14,
              color: Color(0xFFC4C4C4),
              fontWeight: FontWeight.w400,
            ),
          ),
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
                color: kLightGreyColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kLightGreyColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (CompanyUsers? newValue) {
            setState(() {
              employeeId = newValue!.companyUser!.id!.toString();
              print(newValue!.companyUser!.id!.toString());
            });
          },
          items: companyUsers.map<DropdownMenuItem<CompanyUsers>>((CompanyUsers companyUsers) {
            return DropdownMenuItem<CompanyUsers>(
              value: companyUsers,
              child: Text(
                companyUsers.companyUser!.name!,
                style: const TextStyle(
                  fontFamily: 'latoRagular',
                  color: kThemeColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

