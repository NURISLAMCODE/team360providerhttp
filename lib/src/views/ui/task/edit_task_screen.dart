import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/task/task_details.dart';
import 'package:team360/src/views/ui/task/task_screen.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';
import '../../../business_logics/models/task_model/company_user.dart';
import '../../../business_logics/models/task_model/single_task_details_model.dart';
import '../../../business_logics/providers/task_provider.dart';
import '../../../business_logics/utils/constants.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key,required this.index,required this.isFirst,required this.isAssignedByMeTask}) : super(key: key);
  final int index;
  final bool isFirst;
  final bool isAssignedByMeTask;
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  FocusNode taskTitleETFocusNode = FocusNode();
  FocusNode taskDetailETFocusNode = FocusNode();
  static TextEditingController addTaskDate = TextEditingController();
  static TextEditingController taskTitle = TextEditingController();
  static TextEditingController taskDescription = TextEditingController();
  bool isLoading = false;
  bool state = false;
  static int ungent = 0;
  //TaskUsers dropDownUsers = TaskUsers(assignTo: null);
  static List<dynamic> taskUsers = [];
  static List<CompanyUsers> companyusers = [];
  CompanyUsers dropDownUsers = CompanyUsers(companyUser: null,status: null,id: 0);
  List<int> id = [];
  bool isExist = false;
  bool isButtonLoading = false;
  static File? file;
  static String selectedFileName = "";


  void isUserExistFilter(CompanyUsers companyUsers){
    int count = 0;
    print(taskUsers.length);
    for(var i =0 ;i< taskUsers.length;i++){
      if(taskUsers[i]["id"] == companyUsers.companyUser!.id){
        print(taskUsers[i]["id"]);
        print(companyUsers.companyUser!.id);
        setState(() {
          isExist = true;
        });
        break;
      }else{
        count++;
      }
    }
    print("count : ${count}");
    if(taskUsers.length == count){
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 1),() async{
      if(widget.isFirst == true){
        taskDescription.clear();
        taskTitle.clear();
        addTaskDate.clear();
        ungent = 0;
        taskUsers.clear();
        file = null;
        selectedFileName = "";
        companyusers.clear();
        TaskProvider taskProvider = Provider.of<TaskProvider>(context,listen: false);
        await taskProvider.getAllCompanyUser().then((value) {
          value!.data!.companyUser!.forEach((element) {
            setState(() {
              companyusers.add(element);
            });
          });
        });
        await taskProvider.singleTaskDetails(widget.index).then((value){
          if(value!.data!.urgent == true){
            ungent = 1;
            state = value.data!.urgent!;
          }else{
            ungent = 0;
            state = value.data!.urgent!;
          }
          taskTitle.text = value.data!.title!;
          taskDescription.text = value.data!.description!;
          addTaskDate.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(value.data!.dueDate!));
          selectedFileName = value.data!.file!;
          value.data!.taskUsers!.forEach((element) {
            taskUsers.add({
              "id": element.assignTo?.id == null ? 0 : element.assignTo!.id,
              "image": element.assignTo?.employee?.image == null ? "" : element.assignTo!.employee!.image,
              "name": element.assignTo?.name == null ? "" : element.assignTo!.name,
              "designation": element.assignTo?.employee?.designations?.name == null ? "" : element.assignTo!.employee!.designations!.name,
            });
          });
          setState(() {
            isLoading = false;
          });
        });
      }else{
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        taskDescription.clear();
        taskTitle.clear();
        addTaskDate.clear();
        ungent = 0;
        taskUsers.clear();
        file = null;
        selectedFileName = "";
        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask)));
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTaskScreen(isFirst: true,index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask)));
          taskDescription.clear();
          taskTitle.clear();
          addTaskDate.clear();
          ungent = 0;
          taskUsers.clear();
          file = null;
          selectedFileName = "";
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
            width: MediaQuery.of(context).size.width /1,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ) :
          Consumer<TaskProvider>(
              builder: (context,taskProvider,child){
                return  isButtonLoading == true ?
                Container(
                  height: MediaQuery.of(context).size.height/1,
                  width: MediaQuery.of(context).size.width /1,
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
                                        taskDescription.clear();
                                        taskTitle.clear();
                                        addTaskDate.clear();
                                        ungent = 0;
                                        taskUsers.clear();
                                        file = null;
                                        selectedFileName = "";
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask)));
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
                                        "Edit Task",
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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: CustomScrollView(
                              slivers: [

                                //Task title
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      width: 90.w,
                                      child: WidgetFactory.buildTextField(
                                        focusNode: taskTitleETFocusNode,
                                        controller: taskTitle,
                                        context: context,
                                        label: "Task Title",
                                        hint: "Enter your task",
                                      ),
                                    ),
                                  ),
                                ),

                                //Task Date
                                SliverToBoxAdapter(
                                  child:  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: InkWell(
                                      onTap: () async {
                                        DateTime? pickeddate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2040),
                                        );
                                        if (pickeddate != null) {
                                          setState(() {
                                              addTaskDate.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 90.w,
                                        child: TextField(
                                          enabled: false,
                                          controller: addTaskDate,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding: const EdgeInsets.all(10.0),
                                            label: const Text(
                                              "Due Date",
                                              style: TextStyle(
                                                fontFamily: 'latoRagular',
                                                fontWeight: FontWeight.w600,
                                                color: kThemeColor,
                                              ),
                                            ),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            suffixIcon: Icon(
                                              Icons.calendar_month_outlined,
                                              size: 18.sp,
                                            ),
                                            // Icon(Icons.calendar_month_outlined),
                                            hintText: "dd/mm/yyyy",
                                            hintStyle: TextStyle(
                                                fontFamily: 'latoRagular',
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xFFC4C4C4),
                                                fontSize: 16.sp,
                                                overflow: TextOverflow.visible),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: kBlackColor,
                                                )
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: kBlackColor,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: kBlueColor),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //Task Details
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: TextField(
                                      focusNode: taskDetailETFocusNode,
                                      maxLines: 5,
                                      controller: taskDescription,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        label: Text(
                                          "Task Details",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontWeight: FontWeight.w600,
                                            color: taskDetailETFocusNode.hasFocus ? kBlueColor : kBlackColor,
                                          ),
                                        ),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        contentPadding: const EdgeInsets.all(10.0),
                                        hintText: "Enter you task details",
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
                                            color: kBlackColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: kBlueColor),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //Assign To & Add Button
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        addTaskDopWidget(
                                            "Select Person",
                                            "Assign To",
                                            companyusers
                                        ),

                                        taskUsers.isNotEmpty ? Container(
                                          width: 14.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                              color: kBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: TextButton(
                                              onPressed: (){
                                                setState(() {
                                                  print("sdsd : ${dropDownUsers.companyUser!.id}");
                                                  isUserExistFilter(dropDownUsers);
                                                  if(dropDownUsers.companyUser == null){
                                                    customWidget.showCustomSnackbar(context, "Please select an employee first");
                                                  }else if (isExist == true){
                                                    customWidget.showCustomSnackbar(context, "The employee is already exist");
                                                  }else{
                                                    taskUsers.add({
                                                      "id": dropDownUsers.companyUser!.id,
                                                      "image": dropDownUsers.image,
                                                      "name": dropDownUsers.companyUser!.name,
                                                      "designation": dropDownUsers.designations == null ? "" : dropDownUsers.designations,
                                                    });
                                                    print(taskUsers.length);
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTaskScreen(index: widget.index,isFirst: false,isAssignedByMeTask: widget.isAssignedByMeTask,)));
                                                  }
                                                });
                                              },
                                              child: Icon(Icons.add,color: kWhiteColor,size: 23.sp,)
                                          ),
                                        ) : SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ),

                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (context,int index){
                                          return personProfile(index: index);
                                        },
                                        childCount: taskUsers.length
                                    )
                                ),

                                //File Uploader
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: addTaskDottedBorder(
                                      child: TextButton(
                                        onPressed: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            allowMultiple: false, // Set to true if you want to allow multiple files.
                                            type: FileType.custom, // You can specify the file types you want to allow.
                                            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'xlsx', 'csv'],
                                          );
                                          setState(() {
                                            if (result != null && result.files.isNotEmpty) {
                                              setState(() {
                                                var upload = result.files.first;
                                                file = File(result.files.first.path!);
                                                selectedFileName = upload.name ?? '';// Store the selected file name
                                              });
                                            }
                                          });
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
                                              SizedBox(
                                                height: 3.h,
                                                width: 3.w,
                                                child: Image.asset(
                                                    "assets/images/upload_plus.png"),
                                              ),
                                              Container(
                                                height: 5.h,
                                                width: 55.w,
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    selectedFileName != ""? selectedFileName :"Upload Your Documents",
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
                                  ),
                                ),


                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: [
                                        UrgentCustomSwitch(
                                          value: state,
                                          onChanged: (value) {
                                            setState(() {
                                              state = value;
                                              if(state == false){
                                                ungent = 0;
                                              }else{
                                                ungent = 1;
                                              }
                                            },
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),


                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20,bottom: 100),
                                    child: SizedBox(
                                      height: 6.h,
                                      width: 91.w,
                                      child: TextButton(
                                        onPressed: () {
                                          if(taskTitle.text.isEmpty){
                                            customWidget.showCustomSnackbar(context, "Please fill the task title");
                                          }else if(taskDescription.text.isEmpty){
                                            customWidget.showCustomSnackbar(context, "Please fill the task details");
                                          }else if(addTaskDate.text.isEmpty){
                                            customWidget.showCustomSnackbar(context, "Please fill the task date");
                                          }else if(taskUsers.isEmpty){
                                            customWidget.showCustomSnackbar(context, "Please add employees for this task");
                                          }else{
                                            setState(() {
                                              isButtonLoading = true;
                                              List<int> filterId = [];
                                              taskUsers.forEach((element) {
                                                id.add(element["id"]);
                                              });

                                              id.forEach((element) {
                                                if(filterId.contains(element) == false){
                                                  filterId.add(element);
                                                }
                                              });
                                              print(filterId);

                                              if(file == null){
                                                Map<String,dynamic> data = {
                                                  "title": taskTitle.text,
                                                  "description": taskDescription.text,
                                                  "due_date": addTaskDate.text,
                                                  "file": selectedFileName,
                                                  "assigned_to": filterId,
                                                  "urgent": ungent,
                                                };
                                                print(jsonEncode(data));
                                                print(widget.index);
                                                taskProvider.updatedTask(
                                                    index: widget.index,
                                                    data: data,
                                                    onSuccess: (e){
                                                      taskDescription.clear();
                                                      taskTitle.clear();
                                                      addTaskDate.clear();
                                                      ungent = 0;
                                                      filterId.clear();
                                                      taskUsers.clear();
                                                      file = null;
                                                      selectedFileName = "";
                                                      isButtonLoading = false;
                                                      customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
                                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask)));
                                                    },
                                                    onFail: (e){
                                                      isButtonLoading = false;
                                                      customWidget.showCustomSnackbar(context, "${e}");
                                                    }
                                                );
                                              }else{
                                                taskProvider.uploadImageFile(
                                                    filePath: file,
                                                    onSuccess: (e){
                                                      Map<String,dynamic> data = {
                                                        "title": taskTitle.text,
                                                        "description": taskDescription.text,
                                                        "due_date": addTaskDate.text,
                                                        "file": "${e}",
                                                        "assigned_to": filterId,
                                                        "urgent": ungent,
                                                      };
                                                      print(jsonEncode(data));
                                                      taskProvider.updatedTask(
                                                          index: widget.index,
                                                          data: data,
                                                          onSuccess: (e){
                                                            taskDescription.clear();
                                                            taskTitle.clear();
                                                            addTaskDate.clear();
                                                            ungent = 0;
                                                            filterId.clear();
                                                            taskUsers.clear();
                                                            file = null;
                                                            selectedFileName = "";
                                                            isButtonLoading = false;
                                                            customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen()));
                                                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(index: widget.index, isAssignedByMeTask: widget.isAssignedByMeTask)));
                                                          },
                                                          onFail: (e){
                                                            isButtonLoading = false;
                                                            customWidget.showCustomSnackbar(context, "${e}");
                                                          }
                                                      );
                                                    },
                                                    onFail: (e){
                                                      isButtonLoading = false;
                                                      customWidget.showCustomSnackbar(context, "${e}");
                                                    });
                                              }
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all(
                                            const Color(0xFF1294F2),
                                          ),
                                        ),
                                        child: Text(
                                          "Update Task",
                                          style: TextStyle(
                                              fontFamily: 'latoRagular',
                                              color: kWhiteColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          )
        ),
      ),
    );
  }

  Widget addTaskDopWidget(hint, label, List<CompanyUsers> companyUsers) {
    return SizedBox(
      height: 6.h,
      width: taskUsers.isNotEmpty ? 78.5.w : 94.w,
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
              color: kBlackColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kBlackColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (CompanyUsers? newValue) {
          setState((){
            dropDownUsers = newValue!;
            if(taskUsers.length < 1){
              taskUsers.add({
                "id": dropDownUsers.companyUser!.id,
                "image": dropDownUsers.image,
                "name": dropDownUsers.companyUser!.name,
                "designation": dropDownUsers.designations == null ? "" : dropDownUsers.designations,
              });
              print(taskUsers.length);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTaskScreen(index: widget.index,isFirst: false,isAssignedByMeTask: widget.isAssignedByMeTask,)));
            }
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
    );
  }


  Widget personProfile ({required int index}){
    return Padding(
      padding: const EdgeInsets.only(top: 20,right: 4,left: 4),
      child: Container(
        height: 10.h,
        width: 90.w,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 3,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 8.h,
              width: 60.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 6.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color(0xFFC6EAE9),
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${BASE_URL_IMAGE}/assets/${taskUsers[index]["image"]}"),
                    ),
                  ),
                  Container(
                    height: 6.h,
                    width: 48.w,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            taskUsers[index]["name"] != null ?
                            "${taskUsers[index]["name"]}" : "N/A",
                            style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: kBlackColor),
                          ),
                          Text(
                            taskUsers[index]["designation"] != null ?
                            "${taskUsers[index]["designation"]}" : "N/A",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(
                                0xFFAEAEAE,
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
            Padding(
              padding:
              const EdgeInsets.only(right: 10, top: 5),
              child: SizedBox(
                height: 8.h,
                width: 10.w,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      taskUsers.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: const Color(0xFFE5252A),
                    size: 3.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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



class UrgentCustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const UrgentCustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _UrgentCustomSwitchState createState() => _UrgentCustomSwitchState();
}

class _UrgentCustomSwitchState extends State<UrgentCustomSwitch>
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
              },
              child: Container(
                width: 12.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: widget.value ? const Color(0xFFFC694C) : kWhiteColor,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: widget.value ? kWhiteColor : kThemeColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, right: 0.5, left: 0.5),
                  child: Container(
                    alignment:
                    widget.value ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 2.5.h,
                      height: 4.5.w,
                      decoration: BoxDecoration(
                        color: widget.value ? kWhiteColor : const Color(0xFFFC694C),
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
          "Urgent",
          style: TextStyle(
            fontFamily: 'latoRagular',
            fontSize: 18.sp,

            color: widget.value ? const Color(0xFFFC694C) : kThemeColor,
          ),
        ),
      ],
    );
  }
}



