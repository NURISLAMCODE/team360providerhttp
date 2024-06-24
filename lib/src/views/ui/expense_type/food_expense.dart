import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/expenses_provider.dart';
import 'package:team360/src/views/ui/expense_screen.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../../business_logics/models/expence_mdel/expence_perpose_model.dart';

class FoodExpense extends StatefulWidget {
  const FoodExpense({Key? key, required this.type, required this.purposeTypes}) : super(key: key);
  final String type;
  final List<PurposeTypes>? purposeTypes;
  @override
  State<FoodExpense> createState() => _FoodExpenseState();
}

class _FoodExpenseState extends State<FoodExpense> {
  TextEditingController date = TextEditingController();
  String datePick = "";
  String amount = "";
  String persion = "";
  TextEditingController _controller = TextEditingController();
  String dropdownValue = "";
  PurposeTypes? purposeTypes;
  String selectedFileName = "";
  String uploadedImageName = "";
  String discription = "";
  String purpose_type_id = "";
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  File? file;
  bool? isLoading;
  @override
  void initState() {
    super.initState();
    _controller.text = "0";
    // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expenceProvider, child){
        return isLoading == true ?
        Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width/1,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) :
        Form(
          key: _key,
          child: Column(
            children: [

              //Expense Date
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: SizedBox(
                  width: 90.w,
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2040),
                      );
                      if (pickeddate != null) {
                        setState(
                              () {
                            date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                          },
                        );
                      }
                    },
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
                          "Expense Date * ",
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
                          borderSide: const BorderSide(color: kLightGreyColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //Person & Amount
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    //Person
                    Stack(
                      children: [
                        SizedBox(
                          width: 42.5.w,
                          // height: 6.h,
                          child: TextFormField(
                            onSaved: (value){
                              setState(() {
                                persion = value!;
                              });
                            },
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding:
                              const EdgeInsets.only(left: 10, right: 10,),
                              label: const Text(
                                "Person *",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontWeight: FontWeight.w600,
                                  color: kThemeColor,
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              // Icon(Icons.calendar_month_outlined),
                              hintText: "Person",
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
                                borderSide: const BorderSide(color: kLightGreyColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 35.w,
                          child: Column(
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.arrow_drop_up,

                                ),
                                onTap: () {
                                  int currentValue = int.parse(_controller.text);
                                  setState(() {
                                    currentValue++;
                                    _controller.text = (currentValue)
                                        .toString(); // incrementing value
                                  });
                                },
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  // size: 2.h,
                                ),
                                onTap: () {
                                  int currentValue = int.parse(_controller.text);
                                  setState(() {
                                    if(currentValue !=0){
                                      currentValue--;
                                      _controller.text =
                                          (currentValue > 0 ? currentValue : 0)
                                              .toString();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //Amount
                    SizedBox(
                      width: 42.5.w,
                      child: TextFormField(
                        onSaved: (value){
                          setState(() {
                            amount = value!;
                          });
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
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

                          // Icon(Icons.calendar_month_outlined),
                          hintText: "0.00",
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
                            borderSide: const BorderSide(color: kLightGreyColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Purpose
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 6.h,
                  width: 90.w,
                  child: DropdownButtonFormField<PurposeTypes>(
                    hint: const Text(
                      "Enter Purpose",
                      style: TextStyle(
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
                      label: const Text(
                        "Purpose *",
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
                    onChanged: (PurposeTypes? newValue) {
                      setState(() {
                        purposeTypes = newValue;
                        dropdownValue = newValue!.name!;
                        purpose_type_id = newValue!.id.toString();
                      });
                    },
                    items: widget.purposeTypes!.map<DropdownMenuItem<PurposeTypes>>((PurposeTypes purposetype) {
                      return DropdownMenuItem<PurposeTypes>(
                        value: purposetype,
                        child: Text(
                          purposetype.name!,
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            color: kThemeColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              //Description
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  maxLines: 5,
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
                  onSaved: (value){
                    setState(() {
                      discription = value!;
                    });
                  },
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
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 6.h,
                  width: 91.w,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _key.currentState!.save();
                        if(datePick == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense date");
                        }else if(persion == "0"){
                          customWidget.showCustomSnackbar(context, "The person count must getter than 0");
                        }else if(amount == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense amount");
                        }else if(dropdownValue == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense purpose");
                        }else if(discription == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense description");
                        }else if(selectedFileName == ""){
                          isLoading = true;
                          Map<String,dynamic> data = {
                            "type": widget.type,
                            "expense_date": datePick,
                            "total_person": persion,
                            "amount": amount,
                            "purpose": dropdownValue,
                            "purpose_type_id": purpose_type_id,
                            "description": discription,
                            "file": "",
                            "transports": [],
                          };

                          expenceProvider.expensePost(
                                data,
                                (e){
                                  customWidget.showCustomSuccessSnackbar(context, "$e");
                                  isLoading = false;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                },
                                (e){
                                  customWidget.showCustomSnackbar(context, "$e");
                                  isLoading = false;
                                },
                          );
                        }else{
                          isLoading = true;
                          expenceProvider.uploadImageFile(
                            file,
                            (e){
                              Map<String,dynamic> data = {
                                "type": widget.type,
                                "expense_date": datePick,
                                "total_person": persion,
                                "amount": amount,
                                "purpose_type_id": purpose_type_id,
                                "purpose": dropdownValue,
                                "description": discription,
                                "file": e,
                                "transports": [],
                              };

                              expenceProvider.expensePost(
                                data,
                                    (e){
                                      customWidget.showCustomSuccessSnackbar(context, "$e");
                                      isLoading = false;
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                    },
                                    (e){
                                      isLoading = false;
                                      customWidget.showCustomSnackbar(context, "$e");
                                    },
                              );
                            },
                            (e){
                              isLoading = false;
                              customWidget.showCustomSnackbar(context, "$e");
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
