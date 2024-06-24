import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/expenses_provider.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../expense_screen.dart';



class MiscellaneousExpense extends StatefulWidget {
  const MiscellaneousExpense({Key? key,required this.type}) : super(key: key);
  final String type;

  @override
  State<MiscellaneousExpense> createState() => _MiscellaneousExpenseState();
}

class _MiscellaneousExpenseState extends State<MiscellaneousExpense> {
  TextEditingController date = TextEditingController();
  String datePick = "";
  String amount = "";
  String dropdownValue = "";
  String selectedFileName = "";
  String persion = "";
  String uploadedImageName = "";
  String discription = "";
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  File? file;
  bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context,expenseProvider,child){
        return isLoading == true ?
        Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width/1,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Form(
          key: _key,
          child: Column(
            children: [

              //Expense Date
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2040),
                    );
                    if (pickedDate != null) {
                      setState(
                            () {
                          date.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 90.w,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      onSaved: (value){
                        setState(() {
                          datePick = value!;
                        });
                      },
                      enabled: false,
                      controller: date,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.all(10.0),
                        label: const Text(
                          "Expense Date *",
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
                        hintText: "yyyy-MM-dd",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFC4C4C4),
                            fontSize: 16.sp,
                            overflow: TextOverflow.visible),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder:  OutlineInputBorder(
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
                    ),
                  ),
                ),
              ),


              //Amount
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: SizedBox(
                  width: 90.w,
                  child: TextFormField(
                    onSaved: (value){
                      setState(() {
                        amount = value!;
                      });
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(10.0),
                      label: const Text(
                        "Amount *",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontWeight: FontWeight.w600,
                          color: kThemeColor,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter Amount",
                      hintStyle: TextStyle(
                          fontFamily: 'latoRagular',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFC4C4C4),
                          fontSize: 16.sp,
                          overflow: TextOverflow.visible),
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
                        borderSide: const BorderSide(color: kLightGreyColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              //Description
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      discription = value!;
                    });
                  },
                  maxLines: 5,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: const Text(
                      "Description *",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w600,
                        color: kThemeColor,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(10.0),
                    hintText: "Enter the expense description",
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
                      borderSide: const BorderSide(color: kLightGreyColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              //Attachment
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5,left: 15),
                    child: Text(
                      "Attachment",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: kThemeColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        allowMultiple: false, // Set to true if you want to allow multiple files.
                        type: FileType.custom, // You can specify the file types you want to allow.
                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
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
                    child: dottedBorder(
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
                              child: Image.asset("assets/images/upload_plus.png"),
                            ),
                            Container(
                              height: 5.h,
                              width: 75.w,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    selectedFileName == "" ? "Upload Your Documents" : selectedFileName,
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
                ],
              ),

              //Submit Button
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SizedBox(
                  height: 6.h,
                  width: 95.w,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _key.currentState!.save();
                        if(datePick == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense date");
                        }else if(amount == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense amount");
                        }else if(discription == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense description");
                        }else if(selectedFileName == ""){
                          isLoading = true;
                          Map<String,dynamic> data = {
                            "type": widget.type,
                            "expense_date": datePick,
                            "total_person": "1",
                            "amount": amount,
                            "purpose": dropdownValue,
                            "description": discription,
                            "file": "",
                            "transports": [],
                          };

                          expenseProvider.expensePost(
                            data,
                                (e){
                                  customWidget.showCustomSuccessSnackbar(context, "${e}");
                              isLoading = false;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                            },
                                (e){
                                  customWidget.showCustomSnackbar(context, "${e}");
                              isLoading = false;
                            },
                          );
                        }else{
                          isLoading = true;
                          expenseProvider.uploadImageFile(
                            file,
                                (e){
                                  Map<String,dynamic> data = {
                                    "type": widget.type,
                                    "expense_date": datePick,
                                    "total_person": "1",
                                    "amount": amount,
                                    "purpose": dropdownValue,
                                    "description": discription,
                                    "file": e,
                                    "transports": [],
                                  };

                              expenseProvider.expensePost(
                                data,
                                    (e){
                                      customWidget.showCustomSuccessSnackbar(context, "${e}");
                                  isLoading = false;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                },
                                    (e){
                                      customWidget.showCustomSnackbar(context, "${e}");
                                  isLoading = false;
                                },
                              );
                            },
                                (e){
                                  customWidget.showCustomSnackbar(context, "${e}");
                              isLoading = false;
                            },
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
                      "Submit",
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
        );
      },
    );
  }
}


Widget dottedBorder({required Widget child}) => DottedBorder(
  strokeWidth: 1,
  dashPattern: const [10, 5],
  color: const Color(0xFF6A8495),
  borderType: BorderType.RRect,
  radius: const Radius.circular(8),
  child: child,
);