import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/expenses_provider.dart';
import 'package:team360/src/views/ui/add_expense.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_switch.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';

import '../../../business_logics/models/expence_mdel/expence_perpose_model.dart';
import '../expense_screen.dart';

class TransportExpense extends StatefulWidget {
  const TransportExpense({Key? key, required this.type,required this.purposeTypes}) : super(key: key);
  final String type;
  final List<PurposeTypes>? purposeTypes;
  @override
  State<TransportExpense> createState() => TransportExpenseState();
}

class TransportExpenseState extends State<TransportExpense> {
  static TextEditingController date = TextEditingController();
  static TextEditingController description = TextEditingController();
  String dropdownValue = "";
  PurposeTypes? purposeTypes;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  GlobalKey<FormState> personalForm = GlobalKey<FormState>();
  GlobalKey<FormState> mainForm = GlobalKey<FormState>();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController kmController = TextEditingController();
  TextEditingController tollNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController perKmAmountController = TextEditingController();
  String purpose_type_id = "";
  bool state = false;
  bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context,expenceProvider,child){
        return isLoading == true ?
        Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width/1,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Form(
          key: mainForm,
          child: Column(
            children: [
              //Expense Date
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2040),
                    );
                    if (pickeddate != null) {
                      setState(() {
                          date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
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
                          expenceProvider.pickDate = value!;
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
                            fontFamily: 'latoRagular',
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFC4C4C4),
                            fontSize: 16.sp,
                            overflow: TextOverflow.visible),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
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
                ),
              ),

              //Purpose
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 10.h,
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

              //Travel Type
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Container(
                  // height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                    color: kWhiteColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [

                        //Model Of Transport Text
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Mode of Transport",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 15.sp,
                                color: kThemeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        //Personal Transport Select Button
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              CustomSwitch(
                                value: state,
                                onChanged: (value) {
                                  setState((){
                                    state = value;
                                    if(value == false){
                                      perKmAmountController.clear();
                                      kmController.clear();
                                      tollNoController.clear();
                                      amountController.clear();
                                      expenceProvider.fileName = "";
                                      expenceProvider.documentFile = null;
                                      expenceProvider.pKmExpense = "0";
                                      expenceProvider.amount = "";
                                      expenceProvider.toll_amount = "0";
                                      expenceProvider.KM = "";
                                    }else{
                                      expenceProvider.transport_type = "";
                                      perKmAmountController.clear();
                                      kmController.clear();
                                      tollNoController.clear();
                                      sourceController.clear();
                                      destinationController.clear();
                                      amountController.clear();
                                      expenceProvider.source = "";
                                      expenceProvider.destination = "";
                                      expenceProvider.amount = "";
                                      expenceProvider.pKmExpense = "0";
                                      expenceProvider.toll_amount = "0";
                                      expenceProvider.fileName = "";
                                      expenceProvider.documentFile = null;
                                    }
                                    },
                                  );
                                },
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "Personal Transport",
                                style: TextStyle(
                                  fontFamily: 'latoRagular',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kThemeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        state == false
                            ? transport(context)
                            : personalTransport(context)
                      ],
                    ),
                  ),
                ),
              ),

              allExpenseListShow(context),


              //Description
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      expenceProvider.despriction = value!;
                    });
                  },
                  controller: description,
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: const Text(
                      "Description *",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF102048),
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

              //Submit Button
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20),
                child: SizedBox(
                  height: 6.h,
                  width: 91.w,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        mainForm.currentState!.save();
                        if(expenceProvider.pickDate == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense date");
                        }else if(dropdownValue == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense purpose");
                        }else if(expenceProvider.despriction == ""){
                          customWidget.showCustomSnackbar(context, "Please fill the expense description");
                        }else if(state == false && expenceProvider.allTransportsList.isEmpty == true){
                          if(expenceProvider.transport_type == ""){
                            customWidget.showCustomSnackbar(context, "Please select a transport type");
                          }else if (expenceProvider.source.isEmpty == true){
                            customWidget.showCustomSnackbar(context, "Please fill the source of destination");
                          }else if (expenceProvider.destination.isEmpty == true){
                            customWidget.showCustomSnackbar(context, "Please fill the destination");
                          }else if (expenceProvider.amount.isEmpty == true){
                            customWidget.showCustomSnackbar(context, "Please fill the amount");
                          }else if (expenceProvider.documentFile == null){
                            isLoading = true;
                            var data = {
                              "mode_of_transport": "public",
                              "transport_type": expenceProvider.transport_type,
                              "source": expenceProvider.source,
                              "destination": expenceProvider.destination,
                              "toll_no": "",
                              "km": 0,
                              "amount": expenceProvider.amount,
                              "transport_attachment": "",
                            };
                            expenceProvider.transports.add(data);
                            sourceController.clear();
                            destinationController.clear();
                            amountController.clear();
                            expenceProvider.documentFile = null;
                            expenceProvider.fileName = "";
                            expenceProvider.transport_type = "";

                            Map<String,dynamic> sendData = {
                              "type": widget.type,
                              "expense_date": expenceProvider.pickDate,
                              "total_person": "1",
                              "amount": expenceProvider.amount,
                              "purpose_type_id": purpose_type_id,
                              "purpose": expenceProvider.perpous,
                              "description": expenceProvider.despriction,
                              "file": "",
                              "transports": expenceProvider.transports,
                            };

                            print(sendData);
                            expenceProvider.expensePost(
                              sendData,
                                  (e){
                                customWidget.showCustomSuccessSnackbar(context, "${e}");
                                isLoading = false;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                date.clear();
                                description.clear();
                                expenceProvider.publicTransport.clear();
                                expenceProvider.personalTransport.clear();
                                expenceProvider.transports.clear();
                                expenceProvider.allTransportsList.clear();
                                expenceProvider.fileName = "";
                                expenceProvider.documentFile = null;
                                expenceProvider.totalAmount = 0;
                                expenceProvider.amount = "";
                                expenceProvider.KM = "";
                              },
                                  (e){
                                    customWidget.showCustomSnackbar(context, "${e}");
                                    isLoading = false;
                              },
                            );
                          }else{
                            isLoading = true;
                            expenceProvider.uploadImageFile(
                                expenceProvider.documentFile,
                                    (e){
                                      var data = {
                                        "mode_of_transport": "public",
                                        "transport_type": expenceProvider.transport_type,
                                        "source": expenceProvider.source,
                                        "destination": expenceProvider.destination,
                                        "toll_no": "",
                                        "km": 0,
                                        "amount": expenceProvider.amount,
                                        "transport_attachment": e,
                                      };
                                      expenceProvider.transports.add(data);
                                      sourceController.clear();
                                      destinationController.clear();
                                      amountController.clear();
                                      expenceProvider.documentFile = null;
                                      expenceProvider.fileName = "";
                                      expenceProvider.transport_type = "";

                                      Map<String,dynamic> sendData = {
                                        "type": widget.type,
                                        "expense_date": expenceProvider.pickDate,
                                        "total_person": "1",
                                        "amount": expenceProvider.amount,
                                        "purpose_type_id": purpose_type_id,
                                        "purpose": expenceProvider.perpous,
                                        "description": expenceProvider.despriction,
                                        "file": "",
                                        "transports": expenceProvider.transports,
                                      };

                                      print(sendData);
                                      expenceProvider.expensePost(
                                        sendData,
                                            (e){
                                              customWidget.showCustomSuccessSnackbar(context, "${e}");
                                          isLoading = false;
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                          date.clear();
                                          description.clear();
                                          expenceProvider.publicTransport.clear();
                                          expenceProvider.personalTransport.clear();
                                          expenceProvider.transports.clear();
                                          expenceProvider.allTransportsList.clear();
                                          expenceProvider.fileName = "";
                                          expenceProvider.documentFile = null;
                                          expenceProvider.totalAmount = 0;
                                          expenceProvider.amount = "";
                                          expenceProvider.KM = "";
                                        },
                                            (e){
                                              isLoading = false;
                                              customWidget.showCustomSnackbar(context, "${e}");
                                        },
                                      );
                                    },
                                    (e){
                                      isLoading = false;
                                      customWidget.showCustomSnackbar(context, "${e}");
                                });
                          }
                        }else if(state == true && expenceProvider.allTransportsList.isEmpty == true){
                          if(expenceProvider.KM.isEmpty == true){
                            customWidget.showCustomSnackbar(context, "Please enter the kilo-meter");
                          }else if (expenceProvider.amount.isEmpty == true){
                            customWidget.showCustomSnackbar(context, "Please fill the amount");
                          }else if (expenceProvider.documentFile == null){
                            isLoading = true;
                            var data = {
                              "mode_of_transport": "personal",
                              "transport_type": "Personal Transport",
                              "source": "",
                              "destination": "",
                              "toll_no": "",
                              "km": expenceProvider.KM,
                              "amount": expenceProvider.amount,
                              "transport_attachment": "",
                            };
                            expenceProvider.transports.add(data);
                            sourceController.clear();
                            destinationController.clear();
                            amountController.clear();
                            expenceProvider.documentFile = null;
                            expenceProvider.fileName = "";
                            expenceProvider.transport_type = "";

                            Map<String,dynamic> sendData = {
                              "type": widget.type,
                              "expense_date": expenceProvider.pickDate,
                              "total_person": "1",
                              "amount": expenceProvider.amount,
                              "purpose_type_id": purpose_type_id,
                              "purpose": expenceProvider.perpous,
                              "description": expenceProvider.despriction,
                              "file": "",
                              "transports": expenceProvider.transports,
                            };

                            print(sendData);
                            expenceProvider.expensePost(
                              sendData,
                                  (e){
                                customWidget.showCustomSuccessSnackbar(context, "${e}");
                                isLoading = false;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                date.clear();
                                description.clear();
                                expenceProvider.publicTransport.clear();
                                expenceProvider.personalTransport.clear();
                                expenceProvider.transports.clear();
                                expenceProvider.allTransportsList.clear();
                                expenceProvider.fileName = "";
                                expenceProvider.documentFile = null;
                                expenceProvider.totalAmount = 0;
                                expenceProvider.amount = "";
                                expenceProvider.KM = "";
                              },
                                  (e){
                                isLoading = false;
                                customWidget.showCustomSnackbar(context, "${e}");
                              },
                            );
                          }else{
                            isLoading = true;
                            expenceProvider.uploadImageFile(
                                expenceProvider.documentFile,
                                    (e){
                                      var data = {
                                        "mode_of_transport": "personal",
                                        "transport_type": "Personal Transport",
                                        "source": "",
                                        "destination": "",
                                        "toll_no": "",
                                        "km": expenceProvider.KM,
                                        "amount": expenceProvider.amount,
                                        "transport_attachment": e,
                                      };
                                      expenceProvider.transports.add(data);
                                      sourceController.clear();
                                      destinationController.clear();
                                      amountController.clear();
                                      expenceProvider.documentFile = null;
                                      expenceProvider.fileName = "";
                                      expenceProvider.transport_type = "";

                                      Map<String,dynamic> sendData = {
                                        "type": widget.type,
                                        "expense_date": expenceProvider.pickDate,
                                        "total_person": "1",
                                        "amount": expenceProvider.amount,
                                        "purpose_type_id": purpose_type_id,
                                        "purpose": expenceProvider.perpous,
                                        "description": expenceProvider.despriction,
                                        "file": "",
                                        "transports": expenceProvider.transports,
                                      };

                                      print(sendData);
                                      expenceProvider.expensePost(
                                        sendData,
                                            (e){
                                          customWidget.showCustomSuccessSnackbar(context, "${e}");
                                          isLoading = false;
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                                          date.clear();
                                          description.clear();
                                          expenceProvider.publicTransport.clear();
                                          expenceProvider.personalTransport.clear();
                                          expenceProvider.transports.clear();
                                          expenceProvider.allTransportsList.clear();
                                          expenceProvider.fileName = "";
                                          expenceProvider.documentFile = null;
                                          expenceProvider.totalAmount = 0;
                                          expenceProvider.amount = "";
                                          expenceProvider.KM = "";
                                        },
                                            (e){
                                          isLoading = false;
                                          customWidget.showCustomSnackbar(context, "${e}");
                                        },
                                      );
                                    },
                                    (e){
                                  isLoading = false;
                                  customWidget.showCustomSnackbar(context, "${e}");
                                });
                          }
                        }else{
                          isLoading = true;
                          expenceProvider.transports.addAll(expenceProvider.personalTransport);
                          expenceProvider.transports.addAll(expenceProvider.publicTransport);

                          for(var i =0 ; i<expenceProvider.transports.length; i++){
                            expenceProvider.totalAmount = expenceProvider.totalAmount + int.parse(expenceProvider.transports[i]["amount"]);
                          }

                          Map<String,dynamic> data = {
                            "type": widget.type,
                            "expense_date": expenceProvider.pickDate,
                            "total_person": "1",
                            "amount": expenceProvider.totalAmount.toString(),
                            "purpose_type_id": purpose_type_id,
                            "purpose": expenceProvider.perpous,
                            "description": expenceProvider.despriction,
                            "file": "",
                            "transports": expenceProvider.transports,
                          };

                          print(data);
                          expenceProvider.expensePost(
                            data,
                                (e){
                              customWidget.showCustomSuccessSnackbar(context, "${e}");
                              isLoading = false;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                              date.clear();
                              description.clear();
                              expenceProvider.publicTransport.clear();
                              expenceProvider.personalTransport.clear();
                              expenceProvider.transports.clear();
                              expenceProvider.allTransportsList.clear();
                              expenceProvider.fileName = "";
                              expenceProvider.documentFile = null;
                              expenceProvider.totalAmount = 0;
                              expenceProvider.amount = "";
                              expenceProvider.KM = "";
                            },
                                (e){
                              isLoading = false;
                              customWidget.showCustomSnackbar(context, "${e}");
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

  //Public Transport
  Widget transport(BuildContext context){
    return Consumer<ExpensesProvider>(
      builder: (context,expenceProvider,child){
        return Form(
          key: form,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [

                //Transport Logo
                SizedBox(
                  height: 4.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Rickshaw";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child:  Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Rickshaw" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Rectangle 88.png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "CNG";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "CNG" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/rickshaw 1.png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Bus";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Bus" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Rectangle 88 (1).png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Train";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Train" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Rectangle 88 (2).png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Car";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Car" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Rectangle 88 (3).png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Motorcycle";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Motorcycle" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Rectangle 88 (4).png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "UBER";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "UBER" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Rectangle 88 (5).png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Pathao";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Pathao" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Pathao_Logo- 1.png"),
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          setState((){
                            expenceProvider.transport_type = "Airplane";
                            print(expenceProvider.transport_type);
                          });
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: expenceProvider.transport_type == "Airplane" ? kDarkGreyColor : kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Image(
                            image: AssetImage("assets/images/Icon 3.png"),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                //Destination
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Destination",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontSize: 15.sp,
                        color: kThemeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                //From To
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    //Source

                    Container(
                      width: 40.5.w,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: sourceController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(10.0),
                          label: const Text(
                            "From *",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF102048),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,

                          // Icon(Icons.calendar_month_outlined),
                          hintText: "From *",
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
                        onChanged: (value){
                          setState(() {
                            expenceProvider.source = value!;
                          });
                        },
                        onSaved: (value){
                          setState((){
                            expenceProvider.source = value!;
                          });
                        },
                      ),
                    ),

                    //Destination
                    Container(
                      width: 40.5.w,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: destinationController,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,

                          // Icon(Icons.calendar_month_outlined),
                          hintText: "To",
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
                        onChanged: (value){
                          setState((){
                            expenceProvider.destination = value!;
                          });
                        },
                        onSaved: (value){
                          setState((){
                            expenceProvider.destination = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                //Amount & Upload Documents & Add
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32.w,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(10.0),
                          label: const Text(
                            "Amonut *",
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
                        onChanged: (value){
                          setState((){
                            expenceProvider.amount = value!;
                          });
                        },
                        onSaved: (value){
                          setState((){
                            expenceProvider.amount = value!;
                          });
                        },
                      ),
                    ),
                    publicDottedBorder(
                      child: Container(
                        height: 5.h,
                        width: 32.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
                                  expenceProvider.documentFile = File(result.files.first.path!);
                                  expenceProvider.fileName = upload.name ?? '';// Store the selected file name
                                });
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 2.6.h,
                                width: 2.6.w,
                                child: Image.asset("assets/images/upload_plus.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  expenceProvider.fileName == ""?"Upload Documents": expenceProvider.fileName.substring(0,12),
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontSize: 13.sp,
                                    color: const Color(0xFF6A8495),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 12.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                          color: kBlueColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: (){
                            setState((){
                              form.currentState!.save();
                              if(expenceProvider.documentFile == null){
                                var data = {
                                  "mode_of_transport": "public",
                                  "transport_type": expenceProvider.transport_type,
                                  "source": expenceProvider.source,
                                  "destination": expenceProvider.destination,
                                  "toll_no": "",
                                  "km": 0,
                                  "amount": expenceProvider.amount,
                                  "transport_attachment": "",
                                };
                                expenceProvider.publicTransport.add(data);
                                print(jsonEncode(expenceProvider.publicTransport));
                                expenceProvider.allTransportsList.add(data);
                                print(jsonEncode(expenceProvider.allTransportsList));
                                sourceController.clear();
                                destinationController.clear();
                                amountController.clear();
                                expenceProvider.fileName = "";
                                expenceProvider.transport_type = "";
                                expenceProvider.documentFile = null;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense(selectedExpenseType: "Transport Expense",purposeTypes: widget.purposeTypes,)));
                              }else{
                                expenceProvider.uploadImageFile(
                                    expenceProvider.documentFile,
                                        (e){
                                          var data = {
                                            "mode_of_transport": "public",
                                            "transport_type": expenceProvider.transport_type,
                                            "source": expenceProvider.source,
                                            "destination": expenceProvider.destination,
                                            "toll_no": "",
                                            "km": 0,
                                            "amount": expenceProvider.amount,
                                            "transport_attachment": e,
                                          };
                                          expenceProvider.publicTransport.add(data);
                                          print(jsonEncode(expenceProvider.publicTransport));
                                          expenceProvider.allTransportsList.add(data);
                                          print(jsonEncode(expenceProvider.allTransportsList));
                                          sourceController.clear();
                                          destinationController.clear();
                                          amountController.clear();
                                          expenceProvider.fileName = "";
                                          expenceProvider.transport_type = "";
                                          expenceProvider.documentFile = null;
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense(selectedExpenseType: "Transport Expense",purposeTypes: widget.purposeTypes,)));
                                        },
                                        (e){
                                          customWidget.showCustomSnackbar(context, "${e}");
                                    });
                              }
                            });
                          },
                          child: Icon(Icons.add,color: kWhiteColor,size: 23.sp,)
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  //Personal Transport
  Widget personalTransport(BuildContext context){
    return Consumer<ExpensesProvider>(
        builder: (context,expenseProvider,child){
          return StatefulBuilder(
              builder: (context, satState){
                return Form(
                  key: personalForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Distance",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              fontSize: 15.sp,
                              color: kThemeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      //KM & Toll No & Amount
                      SizedBox(height: 1.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 26.5.w,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              onSaved: (value){
                                setState(() {
                                  expenseProvider.KM = value!;
                                });
                              },
                              onChanged: (value) async {
                                await expenseProvider.perKmExpense(
                                    km: value,
                                    onFail: (e){
                                      setState(() {
                                        if(e != ""){
                                          customWidget.showCustomSnackbar(context, "${e}");
                                        }
                                        expenseProvider.pKmExpense = "0";
                                        perKmAmountController.text = expenseProvider.pKmExpense;
                                        expenseProvider.amount = (int.parse(expenseProvider.pKmExpense) + int.parse(expenseProvider.toll_amount)).toString();
                                        amountController.text = expenseProvider.amount;
                                        expenseProvider.KM = "";
                                      });
                                    },
                                    onSuccess: (e){
                                      print(e);
                                      setState(() {
                                        expenseProvider.pKmExpense = (e).toString();
                                        perKmAmountController.text = expenseProvider.pKmExpense;
                                        expenseProvider.amount = (int.parse(expenseProvider.pKmExpense) + int.parse(expenseProvider.toll_amount)).toString();
                                        amountController.text = expenseProvider.amount;
                                        expenseProvider.KM = value;
                                      });
                                    }
                                );
                              },
                              controller: kmController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "KM *",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w600,
                                    color: kThemeColor,
                                  ),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,

                                // Icon(Icons.calendar_month_outlined),
                                hintText: "0.00 km",
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
                          Container(
                            width: 26.5.w,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              onSaved: (value){
                                setState(() {
                                  expenseProvider.pKmExpense = value!;
                                });
                              },
                              controller: perKmAmountController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "Per Km Amount *",
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
                          Container(
                            width: 26.5.w,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              onSaved: (value){
                                setState(() {
                                  expenseProvider.toll_amount = value!;
                                });
                              },
                              onChanged: (value) {
                                if(value == ""){
                                  setState(() {
                                    expenseProvider.toll_amount = "0";
                                    expenseProvider.amount = (int.parse(expenseProvider.pKmExpense) + int.parse(expenseProvider.toll_amount)).toString();
                                    amountController.text = expenseProvider.amount;
                                  });
                                }else{
                                  setState(() {
                                    expenseProvider.toll_amount = value;
                                    expenseProvider.amount = (int.parse(expenseProvider.pKmExpense) + int.parse(expenseProvider.toll_amount)).toString();
                                    amountController.text = expenseProvider.amount;
                                  });
                                }
                              },
                              controller: tollNoController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "Toll Amount",
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
                        ],
                      ),
                      //
                      SizedBox(height: 1.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 26.5.w,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: amountController,
                              onSaved: (value){
                                setState(() {
                                  expenseProvider.amount = value!;
                                });
                              },
                              keyboardType: TextInputType.number,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "Amount*",
                                  style: TextStyle(
                                    fontFamily: 'latoRagular',
                                    fontWeight: FontWeight.w600,
                                    color: kThemeColor,
                                  ),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: "0.00",
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
                          personalDottedBorder(
                            child: Container(
                              height: 5.h,
                              width: 32.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
                                        expenseProvider.documentFile = File(result.files.first.path!);
                                        expenseProvider.fileName = upload.name ?? '';// Store the selected file name
                                      });
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 2.6.h,
                                      width: 2.6.w,
                                      child: Image.asset("assets/images/upload_plus.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        expenseProvider.fileName == ""?"Upload Documents": expenseProvider.fileName.substring(0,12),
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 13.sp,
                                          color: const Color(0xFF6A8495),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 14.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                                color: kBlueColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextButton(
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                onPressed: (){
                                  setState((){
                                    personalForm.currentState!.save();
                                    if(expenseProvider.fileName == ""){
                                      var data = {
                                        "mode_of_transport": "personal",
                                        "transport_type": "Personal Transport",
                                        "source": "",
                                        "destination": "",
                                        "toll_no": "",
                                        "km": expenseProvider.KM,
                                        "amount": expenseProvider.amount,
                                        "transport_attachment": "",
                                      };
                                      expenseProvider.personalTransport.add(data);
                                      print(jsonEncode(expenseProvider.personalTransport));
                                      expenseProvider.allTransportsList.add(data);
                                      print(jsonEncode(expenseProvider.allTransportsList));
                                      sourceController.clear();
                                      destinationController.clear();
                                      amountController.clear();
                                      expenseProvider.fileName = "";
                                      expenseProvider.documentFile = null;
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense(selectedExpenseType: "Transport Expense",purposeTypes: widget.purposeTypes,)));
                                    }else{
                                      expenseProvider.uploadImageFile(
                                          expenseProvider.documentFile,
                                              (e){
                                            var data = {
                                              "mode_of_transport": "personal",
                                              "transport_type": "Personal Transport",
                                              "source": "",
                                              "destination": "",
                                              "toll_no": "",
                                              "km": expenseProvider.KM,
                                              "amount": expenseProvider.amount,
                                              "transport_attachment": e,
                                            };
                                            expenseProvider.personalTransport.add(data);
                                            print(jsonEncode(expenseProvider.personalTransport));
                                            expenseProvider.allTransportsList.add(data);
                                            print(jsonEncode(expenseProvider.allTransportsList));
                                            sourceController.clear();
                                            destinationController.clear();
                                            amountController.clear();
                                            expenseProvider.fileName = "";
                                            expenseProvider.documentFile = null;
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense(selectedExpenseType: "Transport Expense",purposeTypes: widget.purposeTypes,)));
                                          },
                                              (e){
                                                customWidget.showCustomSnackbar(context, "${e}");
                                          });
                                    }
                                  });
                                },
                                child: Icon(Icons.add,color: kWhiteColor,size: 23.sp,)
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                );
              }
          );
        }
    );
  }

  Widget allExpenseListShow(BuildContext context){
    return Consumer<ExpensesProvider>(
      builder: (context,expenseProvider,child){
        if(expenseProvider.allTransportsList.isEmpty){
          return SizedBox.shrink();
        }else{
          return Container(
            height: (expenseProvider.allTransportsList.length*11.7).h,
            width: 90.w,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: ListView.builder(
                itemCount: expenseProvider.allTransportsList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index){
                  if(expenseProvider.allTransportsList[index]["mode_of_transport"] == "personal"){
                     return Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 5),
                       child: Container(
                        height: 10.h,
                        width: 90.w,
                        margin: EdgeInsets.only(bottom: 12),
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
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Image
                              Container(
                                height: 5.h,
                                width: 15.w,
                                child: const Image(
                                  image: AssetImage("assets/images/personal.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const VerticalDivider(
                                color: Color(0xFFD9D9D9),
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              //
                              Container(
                                height: 10.h,
                                width: 40.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${expenseProvider.allTransportsList[index]["km"]} KM",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kThemeColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    personalTransportData(label: "Transport", value: ": ${expenseProvider.allTransportsList[index]["transport_type"]}"),
                                    personalTransportData(label: "Amount", value: ": ${expenseProvider.allTransportsList[index]["amount"]} /="),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Container(
                                height: 4.h,
                                width: 8.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: kWhiteColor,
                                    width: 2,
                                  ),
                                  color: const Color(0xFFE5252A),
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    setState((){
                                      print("Hello");
                                      expenseProvider.allTransportsList.removeAt(index);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense(selectedExpenseType: "Transport Expense",purposeTypes: widget.purposeTypes,)));
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Image(
                                      image: AssetImage("assets/images/delete.png"),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                                           ),
                     );
                  }else{
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        height: 10.h,
                        width: 90.w,
                        margin: EdgeInsets.only(bottom: 12),
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
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Image
                              SizedBox(
                                height: 5.h,
                                width: 15.w,
                                child: expenseProvider.allTransportsList[index]["transport_type"] == "Rickshaw" ? Image(
                                  image: AssetImage("assets/images/Rectangle 88.png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "CNG" ?
                                Image(
                                  image: AssetImage("assets/images/rickshaw 1.png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "Bus" ?
                                Image(
                                  image: AssetImage("assets/images/Rectangle 88 (1).png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "Train" ?
                                Image(
                                  image: AssetImage("assets/images/Rectangle 88 (2).png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "Car" ?
                                Image(
                                  image: AssetImage("assets/images/Rectangle 88 (3).png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "Motorcycle" ?
                                Image(
                                  image: AssetImage("assets/images/Rectangle 88 (4).png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "UBER" ?
                                Image(
                                  image: AssetImage("assets/images/Rectangle 88 (5).png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "Pathao" ?
                                Image(
                                  image: AssetImage("assets/images/Pathao_Logo- 1.png"),
                                  fit: BoxFit.contain,
                                ) :
                                expenseProvider.allTransportsList[index]["transport_type"] == "Airplane" ?
                                Image(
                                  image: AssetImage("assets/images/Icon 3.png"),
                                  fit: BoxFit.contain,
                                ) : Text("No Image Uploaded"),
                              ),
                              const VerticalDivider(
                                color: Color(0xFFD9D9D9),
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              //
                              Container(
                                height: 10.h,
                                width: 40.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${expenseProvider.allTransportsList[index]["source"]} - ${expenseProvider.allTransportsList[index]["destination"]}",
                                      style: TextStyle(
                                        fontFamily: 'latoRagular',
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kThemeColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    publicTransportData(label: "Amount", value: ": ${expenseProvider.allTransportsList[index]["amount"]} /="),
                                    publicTransportData(label: "Transport", value: ": ${expenseProvider.allTransportsList[index]["transport_type"]}"),
                                    //publicTransportData(label: "Date", value: ": 10/08/2022"),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Container(
                                height: 4.h,
                                width: 8.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: kWhiteColor,
                                    width: 2,
                                  ),
                                  color: const Color(0xFFE5252A),
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    setState((){
                                      expenseProvider.allTransportsList.removeAt(index);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense(selectedExpenseType: "Transport Expense",purposeTypes: widget.purposeTypes,)));
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Image(
                                      image: AssetImage("assets/images/delete.png"),
                                    ),
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
            )
          );
        }
      },
    );
  }

  //For Public Section
  Widget publicTransportData({label, value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 1.5.h,
          width: 15.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'latoRagular',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF808080),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.5.h,
          width: 25.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'latoRagular',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF808080),
              ),
            ),
          ),
        )
      ],
    );
  }

  //For Personal Section
  Widget personalTransportData({label, value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 1.5.h,
          width: 15.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'latoRagular',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF808080),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.5.h,
          width: 25.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'latoRagular',
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF808080),
              ),
            ),
          ),
        )
      ],
    );
  }
}


Widget publicDottedBorder({required Widget child}) => DottedBorder(
  strokeWidth: 1,
  dashPattern: const [10, 5],
  color: const Color(0xFF6A8495),
  borderType: BorderType.RRect,
  radius: const Radius.circular(8),
  child: child,
);

Widget personalDottedBorder({required Widget child}) => DottedBorder(
  strokeWidth: 1,
  dashPattern: const [10, 5],
  color: const Color(0xFF6A8495),
  borderType: BorderType.RRect,
  radius: const Radius.circular(8),
  child: child,
);
