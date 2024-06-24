import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/profile_screen.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';

import '../../business_logics/providers/user_provider.dart';
import '../../business_logics/utils/constants.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? mobileNumber;
  final String? email;
  final String? joinDate;
  final String? image;
  final String? employeeId;
  final String? gender;
  final String? emergencyContact;
  final String? bloodGroup;
  final String? designation;
  EditProfile({Key? key,this.joinDate,this.image,this.employeeId,this.name,this.gender,this.emergencyContact,this.bloodGroup,this.designation, this.mobileNumber, this.email}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String dropdownGenderValue = "Male";
  String dropdownAddReferenceValue = "Add Reference";
  String dropdownBloodValue = "A+";
  String designation = "N/A";
  File? imageFile;
  String? imageFilePath;
  PickedFile? pickedFile;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();



  FocusNode employeeETFocusNode = FocusNode();
  FocusNode mobileETFocusNode = FocusNode();
  FocusNode emailETFocusNode = FocusNode();
  FocusNode contactETFocusNode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    Future.delayed(Duration(seconds: 1),(){
      setState(() {
        nameController.text = widget.name == "null" || widget.name ==  null || widget.name ==  ""? "N/A" : widget.name!;
        mobileNoController.text = widget.mobileNumber == "null" || widget.mobileNumber == null || widget.mobileNumber == "" ? "N/A" : widget.mobileNumber! ;
        emailController.text = widget.email == "null" || widget.email == null || widget.email == "" ? "N/A" : widget.email!;
        emergencyContactController.text = widget.emergencyContact == "null" || widget.emergencyContact == null || widget.emergencyContact == "" ? "N/A" : widget.emergencyContact!;
        dropdownGenderValue = (widget.gender == "N/A" || widget.gender == null || widget.gender == ""? "Select gender" : widget.gender)!;
        dropdownBloodValue = (widget.bloodGroup == "N/A" || widget.bloodGroup == null || widget.bloodGroup == ""? "Blood Group" : widget.bloodGroup)!;
        designation = widget.designation == "null" || widget.designation == null || widget.designation == "" ? "N/A" : widget.designation!;
        isLoading = false;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
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
        body: isLoading == true ? Container(
          height: MediaQuery.of(context).size.height/1,
          width: MediaQuery.of(context).size.width/1,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : SingleChildScrollView(
          child: Column(
            children: [

              //Add Employee

              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Container(
                      height: 4.5.h,
                      width: 9.w,
                      decoration: const BoxDecoration(),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
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
                        "Edit Profile",
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

              //Other

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  height: MediaQuery.of(context).size.height,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Profile & Joining Date & Employee Id
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            //Profile Pic Selection
                            GestureDetector(
                              onTap:() async {
                                pickedFile = await ImagePicker().getImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    imageFile = File(pickedFile!.path);
                                  });
                                }

                              },
                              child: SizedBox(
                                height: 15.h,
                                width: 30.w,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  fit: StackFit.expand,
                                  children: [
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundColor: const Color(0xFFEAF4F2),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.transparent,
                                        child: imageFile != null ? Image.file(
                                          imageFile!,
                                        ) : widget.image == null || widget.image == "null" || widget.image == "" ? Image.asset(
                                          "assets/images/user_avatar.png",
                                        ) : Image.network(
                                          "${BASE_URL_IMAGE}/assets/${widget.image}",
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: kWhiteColor,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Color(0xFFEAF4F2),
                                          child: CircleAvatar(
                                            radius: 6,
                                            backgroundColor: Colors.transparent,
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/add_image.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Joining Date & Employee Id
                            Column(
                              children: [
                                customContainer(
                                  label: "Join Date",
                                  hintText: widget.joinDate == null  || widget.joinDate == "null" || widget.joinDate ==""? "N/A" : DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.joinDate!)),
                                  kIcon: Image.asset("assets/images/calender.png"),
                                  height: 6.h,
                                  width: 50.w,
                                ),
                                const SizedBox(height: 15),
                                customContainer(
                                  label: "Employee ID",
                                  hintText: widget.employeeId != "null" || widget.employeeId != null || widget.employeeId != "" ? "N/A" : widget.employeeId,
                                  height: 6.h,
                                  width: 50.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Employee Name
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: WidgetFactory.buildTextField(
                          focusNode: employeeETFocusNode,
                          controller: nameController,
                          context: context,
                          label: "Employee Name",
                          hint: "Enter your name",
                            hintColor: const Color(0xFFC4C4C4),
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next
                        ),
                      ),

                      //Mobile No
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: WidgetFactory.buildTextField(
                          controller: mobileNoController,
                          focusNode: mobileETFocusNode,
                          enabled: false,
                          context: context,
                          label: "Mobile No",
                          hint: "Enter your mobile no",
                            hintColor: const Color(0xFFC4C4C4),
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next
                        ),
                      ),

                      //Email
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: WidgetFactory.buildTextField(
                          controller: emailController,
                          enabled: false,
                          focusNode: emailETFocusNode,
                          context: context,
                          label: "Email",
                          hint: "Enter your email",
                          hintColor: const Color(0xFFC4C4C4),
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next
                        ),
                      ),

                      //Gender
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: DropdownButtonFormField<String>(
                          hint: const Text(
                            "Gender",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              fontSize: 14,
                              color: Color(0xFFC4C4C4),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: dropdownGenderValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.all(10.0),
                            // label: const Text(
                            //   "Purpose",
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     color: Color(0xFF102048),
                            //   ),
                            // ),
                            border: const OutlineInputBorder(),
                            enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF808080),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF808080)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            if(newValue == "Select gender"){
                              customWidget.showCustomSnackbar(context, "Please select a gender");
                            }else{
                              setState(() {
                                dropdownGenderValue = newValue!;
                              });
                            }
                          },
                          items: <String>[
                            "Select gender",
                            "Male",
                            "Female",
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),

                      //Emergency Contact
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: WidgetFactory.buildTextField(
                          controller: emergencyContactController,
                          focusNode: contactETFocusNode,
                          context: context,
                          label: "Emergency Contact",
                          hint: "Enter emergency contact number",
                          hintColor: const Color(0xFFC4C4C4),
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next
                        ),
                      ),

                      //Blood Group
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: DropdownButtonFormField<String>(
                          hint: const Text(
                            "Blood Group",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              fontSize: 14,
                              color: Color(0xFFC4C4C4),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: dropdownBloodValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.all(10.0),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF808080),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF808080)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            if(newValue == "Blood Group"){
                              customWidget.showCustomSnackbar(context, "Please select a blood group");
                            }else{
                              setState(() {
                                dropdownBloodValue = newValue!;
                              });
                            }
                          },
                          items: <String>[
                            "Blood Group",
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'O+',
                            'O-',
                            'AB+',
                            'AB-',
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

                      //Designation
                      customContainer(
                        label: "Designation",
                        hintText: designation,
                        height: 6.h,
                        width: 90.w,
                      ),

                      //Save Button
                      Consumer<UserProfileProvider>(
                          builder: (context, userProfileProvider, child)  {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              height: 6.h,
                              width: 90.w,
                              child: TextButton(

                                onPressed: () {
                                  setState(() {
                                    UserData.name = nameController.text;
                                    if(pickedFile != null){
                                      userProfileProvider.uploadImageFileForUser(
                                          filePath: imageFile,
                                          onSuccess: (e){
                                            userProfileProvider.profileUpdate(
                                                name: nameController.text,
                                                phone: mobileNoController.text,
                                                email: emailController.text,
                                                gender: dropdownGenderValue == "Select gender" ? null : dropdownGenderValue,
                                                image: "${e}",
                                                emergencyContact: emergencyContactController.text == "N/A" ? null : emergencyContactController.text,
                                                bloodGroup: dropdownBloodValue == "Blood Group" ? null : dropdownBloodValue,
                                                onSuccess: (e){
                                                  customWidget.showCustomSuccessSnackbar(context, "${e}");
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                                                },
                                                onFail: (e){
                                                  customWidget.showCustomSnackbar(context, "${e}");
                                                }
                                            );
                                          },
                                          onFail: (e){

                                          }
                                      );
                                      // UserProfileProvider().uploadImageFile(
                                      //   pickedFile!,
                                      //       (e){
                                      //     setState(() {
                                      //       imageFilePath = e;
                                      //       print(imageFilePath);
                                      //       UserData.photo= imageFilePath;
                                      //       _updateProfile(userProfileProvider);
                                      //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                                      //     });
                                      //   },
                                      //       (e){
                                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e}")));
                                      //   },);
                                    }else{
                                      userProfileProvider.profileUpdate(
                                          name: nameController.text,
                                          phone: mobileNoController.text,
                                          email: emailController.text,
                                          gender: dropdownGenderValue == "Select gender" ? null : dropdownGenderValue,
                                          image: widget.image,
                                          emergencyContact: emergencyContactController.text == "N/A" ? null : emergencyContactController.text,
                                          bloodGroup: dropdownBloodValue == "Blood Group" ? null : dropdownBloodValue,
                                          onSuccess: (e){
                                            customWidget.showCustomSuccessSnackbar(context, "${e}");
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                                          },
                                          onFail: (e){
                                            customWidget.showCustomSnackbar(context, "${e}");
                                          }
                                      );
                                    }
                                  });
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
                                  "Save",
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




Widget customContainer({label, hintText, required height, required width, kIcon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontFamily: 'latoRagular',
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: kThemeColor,
        ),
      ),
      const SizedBox(height: 5),
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFEAF4F2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hintText,
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w400,
                    color: kThemeColor,
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                  width: 5.w,
                  child: kIcon,
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
