import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/app.dart';
import 'package:team360/src/business_logics/models/approveal_model/my_request_class.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';
import 'package:team360/src/business_logics/providers/approval_provider.dart';
import 'package:team360/src/views/ui/approval_screen.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../business_logics/utils/constants.dart';
import '../../services/shared_preference_services/shared_preference_services.dart';
import '../widgets/custom_widget.dart';

//Expense Details
class ExpenseDetailsDialog extends StatefulWidget {
  const ExpenseDetailsDialog({Key? key,required this.myRequest,required this.isApprovalSelected}) : super(key: key);
  final MyRequest myRequest;
  final bool isApprovalSelected;
  @override
  State<ExpenseDetailsDialog> createState() => _ExpenseDetailsDialogState();
}

class _ExpenseDetailsDialogState extends State<ExpenseDetailsDialog> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Column(
        children: [
          //Leave Application $ Exit
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.myRequest.expense!.type}",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                  width: 10.w,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 3.h,
                      width: 6.w,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Image(
                          image: AssetImage("assets/images/cancel.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: kBlackColor,
            thickness: 1,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              expenseDialogData("Submitted By", ": ${widget.myRequest.expense!.createdBy!.name}"),
              expenseDialogData("Expense Type", ": ${widget.myRequest.expense!.type}"),
              widget.myRequest.expense!.expenseCurrency == null ?
              expenseDialogData("Total Amount", ": ${widget.myRequest.expense!.amount}")
                  : expenseDialogData("Total Amount", ": ${widget.myRequest.expense!.amount} ${widget.myRequest.expense!.expenseCurrency!.code}"),
              widget.myRequest.status == "Approved" ?
              widget.myRequest.approver != null && widget.myRequest.reportingTo == null ?
              expenseDialogData("Approved By", ": ${widget.myRequest.approver!.name}") :
              (widget.myRequest.reportingTo != null && widget.myRequest.approver == null) ?
              expenseDialogData("Approved By", ": ${widget.myRequest!.reportingTo!.name}") :
              expenseDialogData("Approved By", ": ${widget.myRequest!.reportingTo!.name}, ${widget.myRequest!.approver!.name}") :
              widget.myRequest.status == "Rejected" ?
              expenseDialogData("Rejected By", ": ${widget.myRequest.expense!.approvedBy!.name}") : SizedBox.shrink(),
              expenseDialogData("Date", ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.myRequest.expense!.expenseDate!))}"),
              widget.myRequest.expense!.type == "Miscellaneous Expense" ? SizedBox.shrink() :widget.myRequest.expense!.purposeType == null ? expenseDialogData("Purpose", ":  N/A") : expenseDialogData("Purpose", ": ${widget.myRequest.expense!.purposeType!.name}"),
              widget.myRequest.expense!.type != "Food Expense" ? SizedBox.shrink() :expenseDialogData("Persons", ": ${widget.myRequest.expense!.totalPerson}"),
              expenseDialogData("Apply Date", ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.myRequest.expense!.createdAt!))}"),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      height: 5.h,
                      width: 20.w,
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF808080),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                      width: 40.w,
                      child: Text(
                        ": ${widget.myRequest.expense!.description}",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF151515),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),

              widget.myRequest.expense!.expenseDetails!.length > 0 ? Container(
                height: 20.h,
                width: 90.w,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      itemCount: widget.myRequest.expense!.expenseDetails!.length,
                      itemBuilder: (context, int index){
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return expenseTransportDialogDetails(context: context,approverExpenseDetails: widget.myRequest.expense!.expenseDetails![index],myRequest: widget.myRequest);
                                  },
                                );
                              },
                              child: expenseDialogTransport(context: context,approverExpenseDetails: widget.myRequest.expense!.expenseDetails![index],myRequest: widget.myRequest)),
                        );
                      }
                  ),
                ),
              ) : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.myRequest.expense!.file == "" ? null : () async {
                        final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${widget.myRequest.expense!.file}"));

                        if(response.statusCode == 200){
                          final bytes = response.bodyBytes;
                          final directory = await getTemporaryDirectory();
                          final filePath = '${directory.path}/${widget.myRequest.expense!.file}';
                          await File(filePath).writeAsBytes(bytes);
                          await OpenFile.open(filePath);
                        }else{
                          customWidget.showCustomSnackbar(context, "Uploaded file is not open");
                        }
                      },
                      child: Center(
                        child: dottedBorder(
                          child: Container(
                            height: 10.h,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                widget.myRequest.expense!.file == "" ||  widget.myRequest.expense!.file == "null" ||  widget.myRequest.expense!.file == null
                                    ? SizedBox.shrink() :
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
                                    height: MediaQuery.of(context).size.height/15,
                                    width: MediaQuery.of(context).size.width/3,
                                    child: Center(
                                      child: Text(
                                        widget.myRequest.expense!.file == "" ||  widget.myRequest.expense!.file == "null" ||  widget.myRequest.expense!.file == null ?
                                        "N/A" : "${widget.myRequest.expense!.file}",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 14.sp,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              widget.isApprovalSelected == true && (SharedPrefsServices.getBoolData("isLead") == true || SharedPrefsServices.getBoolData("isApprover") == true )
                  && (widget.myRequest.status == "New" || (widget.myRequest.status =="Partially Approved" && (widget.myRequest.reportingTo == null && widget.myRequest.approver != null && UserData.id != widget.myRequest.approver!.id))) ?
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 6.h,
                      width: 35.5.w,
                      child: TextButton(
                        onPressed: () async {
                          ApprovalProvider approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
                          await approvalProvider.approveRequest(
                              index: widget.myRequest.id!,
                              onSuccess: (e){
                                customWidget.showCustomSuccessSnackbar(context, "${e}");
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Approval()));
                              },
                              onFail: (e){
                                customWidget.showCustomSnackbar(context, "${e}");
                                Navigator.pop(context);
                              }
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(kBlueColor),
                        ),
                        child: Center(
                          child: Text(
                            "Approve",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                      width: 35.5.w,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return rejectionNoteDialog(context: context,index: widget.myRequest.id!);
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFE5252A)),
                        ),
                        child: Center(
                          child: Text(
                            "Reject",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : widget.isApprovalSelected == true && (SharedPrefsServices.getBoolData("isLead") == true || SharedPrefsServices.getBoolData("isApprover") == true )
                  && (widget.myRequest.status == "New" || (widget.myRequest.status =="Partially Approved" && (widget.myRequest.approver == null && widget.myRequest.reportingTo != null && UserData.id != widget.myRequest.reportingTo!.id))) ?
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 6.h,
                      width: 35.5.w,
                      child: TextButton(
                        onPressed: () async {
                          ApprovalProvider approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
                          await approvalProvider.approveRequest(
                              index: widget.myRequest.id!,
                              onSuccess: (e){
                                customWidget.showCustomSuccessSnackbar(context, "${e}");
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Approval()));
                              },
                              onFail: (e){
                                customWidget.showCustomSnackbar(context, "${e}");
                                Navigator.pop(context);
                              }
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(kBlueColor),
                        ),
                        child: Center(
                          child: Text(
                            "Approve",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                      width: 35.5.w,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return rejectionNoteDialog(context: context,index: widget.myRequest.id!);
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFE5252A)),
                        ),
                        child: Center(
                          child: Text(
                            "Reject",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 6.h,
                      width: 40.w,
                      child: TextButton(
                        onPressed: widget.myRequest.status == "New" ? null : widget.myRequest.status == "Approved" ? null : widget.myRequest.status =="Partially Approved" ? null : () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                  titlePadding: EdgeInsets.zero,
                                  title: Column(
                                    children: [
                                      Container(
                                          height: 10.h,
                                          width: 67.w,
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Color.fromRGBO(245, 45, 45, 1),width: 2))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Remarks",
                                                  style: TextStyle(
                                                    fontFamily: 'latoRagular',
                                                    color: Color.fromRGBO(245, 45, 45, 1),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                  width: 10.w,
                                                  child: IconButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(Icons.close,color: Color.fromRGBO(245, 45, 45, 1),size: 15,)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      Container(
                                        height: 10.h,
                                        width: 67.w,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.myRequest.leave!.remarks!,
                                              style: TextStyle(
                                                fontFamily: 'latoRagular',
                                                color: Color.fromRGBO(245, 45, 45, 1),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: widget.myRequest.status == "New" ?
                          MaterialStateProperty.all(kBlueColor) :
                          widget.myRequest.status == "Approved" ? MaterialStateProperty.all(kGreenColor) :
                          MaterialStateProperty.all(Colors.red),
                        ),
                        child: Text(
                          widget.myRequest.status == "Rejected" ? "<<${widget.myRequest.status}>>" :"${widget.myRequest.status}",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0)
            ],
          ),
        ),
      ),
    );
  }
}

Widget dottedBorder({required Widget child}) => DottedBorder(
  strokeWidth: 1,
  dashPattern: const [10, 5],
  color: const Color(0xFF6A8495),
  borderType: BorderType.RRect,
  radius: const Radius.circular(5),
  child: child,
);

Widget expenseDialogData(type, text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: [
        SizedBox(
          height: 2.h,
          width: 20.w,
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF808080),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF151515),
            ),
          ),
        )
      ],
    ),
  );
}

Widget expenseDialogTransport({required BuildContext context,required ApproverExpenseDetails approverExpenseDetails,required MyRequest myRequest}) {
  return Container(
    height: 10.h,
    width: 72.5.w,
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
            child: approverExpenseDetails.transportType == "Rickshaw" ? Image(
              image: AssetImage("assets/images/Rectangle 88.png"),
            ) :
            approverExpenseDetails.transportType == "CNG" ?
            Image(
              image: AssetImage("assets/images/rickshaw 1.png"),
            ) :
            approverExpenseDetails.transportType == "Bus" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (1).png"),
            ) :
            approverExpenseDetails.transportType == "Train" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (2).png"),
            ) :
            approverExpenseDetails.transportType == "Car" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (3).png"),
            ) :
            approverExpenseDetails.transportType == "Motorcycle" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (4).png"),
            ) :
            approverExpenseDetails.transportType == "UBER" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (5).png"),
            ) :
            approverExpenseDetails.transportType == "Pathao" ?
            Image(
              image: AssetImage("assets/images/Pathao_Logo- 1.png"),
            ) :
            approverExpenseDetails.transportType == "Airplane" ?
            Image(
              image: AssetImage("assets/images/Icon 3.png"),
            ) :
            approverExpenseDetails.transportType == "Personal Transport" ?
            Image(
              image: AssetImage("assets/images/personal.png"),
            ) : Text("No Image Uploaded"),
          ),
          const VerticalDivider(
            color: Color(0xFFD9D9D9),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          //
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                approverExpenseDetails.transportType == "Personal Transport" ? "${approverExpenseDetails.km} Km" : "${approverExpenseDetails.source} - ${approverExpenseDetails.destination}",
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: kThemeColor,
                ),
              ),
              const SizedBox(height: 10),
              myRequest.expense!.expenseCurrency == null ?
              expenseDialogTransportData(label: "Amount", value: ": ${approverExpenseDetails.amount}") :
              expenseDialogTransportData(label: "Amount", value: ": ${approverExpenseDetails.amount} ${myRequest.expense!.expenseCurrency!.code}"),
              approverExpenseDetails.transportType == "Personal Transport" ?
              expenseDialogTransportData(label: "Transport", value: ": Personal") :
              expenseDialogTransportData(label: "Transport", value: ": ${approverExpenseDetails.transportType}"),
              expenseDialogTransportData(label: "Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(approverExpenseDetails.createdAt!))}"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 25),
            child: SizedBox(
              height: 2.h,
              width: 4.w,
              child: Image.asset(
                "assets/images/pin.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.5.sp,
              color: const Color(0xFF102048),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget expenseDialogTransportData({label, value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: 1.5.h,
        width: 15.w,
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
      SizedBox(
        height: 1.5.h,
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
      )
    ],
  );
}

Widget expenseTransportDialogDetails({required BuildContext context,required ApproverExpenseDetails approverExpenseDetails,required MyRequest myRequest}) {
  return AlertDialog(
    contentPadding: const EdgeInsets.only(
      left: 5,
      right: 5,
    ),
    titlePadding: EdgeInsets.zero,
    title: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${approverExpenseDetails.transportType}",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: kThemeColor,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  width: 10.w,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 3.h,
                      width: 6.w,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Image(
                          image: AssetImage("assets/images/cancel.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: kBlackColor,
            thickness: 1,
          ),
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    content: SizedBox(
      height: 30.h,
      width: 80.w,
      child: Column(
        children: [
          approverExpenseDetails.transportType == "Personal Transport" ? expenseTransportDialogDetailData("KM", ": ${approverExpenseDetails.km} Km") :
          expenseTransportDialogDetailData("Destination", ": ${approverExpenseDetails.source} - ${approverExpenseDetails.destination}"),
          myRequest.expense!.expenseCurrency == null ?
          expenseTransportDialogDetailData("Amount", ": ${approverExpenseDetails.amount}") :
          expenseTransportDialogDetailData("Amount", ": ${approverExpenseDetails.amount} ${myRequest.expense!.expenseCurrency!.code}"),
          expenseTransportDialogDetailData("Transport", ": ${approverExpenseDetails.transportType}"),
          expenseTransportDialogDetailData("Date", ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(approverExpenseDetails.createdAt!))}"),
          expenseTransportDialogDetailData("Attachments :", ""),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: approverExpenseDetails.file == "" ? null : () async {
                    final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${approverExpenseDetails.file}"));

                    if(response.statusCode == 200){
                      final bytes = response.bodyBytes;
                      final directory = await getTemporaryDirectory();
                      final filePath = '${directory.path}/${approverExpenseDetails.file}';
                      await File(filePath).writeAsBytes(bytes);
                      await OpenFile.open(filePath);
                    }else{
                      customWidget.showCustomSnackbar(context, "Uploaded file is not open");
                    }
                  },
                  child: Center(
                    child: dottedBorder(
                      child: Container(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width / 1.8,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            approverExpenseDetails.file == "" || approverExpenseDetails.file == "null" || approverExpenseDetails.file == null ?
                            SizedBox.shrink()
                                : SizedBox(
                              height: 3.h,
                              width: 3.w,
                              child: Image.asset(
                                  "assets/images/upload_plus.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.height/15,
                                width: MediaQuery.of(context).size.width/3,
                                child: Center(
                                  child: Text(
                                    approverExpenseDetails.file == "" || approverExpenseDetails.file == "null" || approverExpenseDetails.file == null
                                        ? "N/A"
                                        : "${approverExpenseDetails.file}",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontSize: 14.sp,
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

Widget expenseTransportDialogDetailData(type, text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
    child: Row(
      children: [
        SizedBox(
          height: 2.5.h,
          width: 20.w,
          child: Text(
            type,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF808080),
            ),
          ),
        ),
        SizedBox(
          height: 2.5.h,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF151515),
            ),
          ),
        )
      ],
    ),
  );
}

//Leave  Details & Rejection Note
class LeaveDetailsDialog extends StatefulWidget {
  const LeaveDetailsDialog({Key? key,required this.myRequest,required this.isApprovalSelected}) : super(key: key);
  final MyRequest myRequest;
  final bool isApprovalSelected;

  @override
  State<LeaveDetailsDialog> createState() => _LeaveDetailsDialogState();
}

class _LeaveDetailsDialogState extends State<LeaveDetailsDialog> {
  String dropdownLeaveValue = "Team";
  final maxLines = 5;

  @override
  Widget build(BuildContext context) {
    print(jsonEncode(widget.myRequest));
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Column(
        children: [
          //Leave Application $ Exit
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Leave  Details",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: kThemeColor,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  width: 8.w,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 3.h,
                      width: 6.w,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Image(
                          image: AssetImage("assets/images/cancel.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: kBlackColor,
            thickness: 1,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SizedBox(
        height: 45.h,
        width: 85.w,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                leaveDialogData("Leave Type", ": ${widget.myRequest.leave!.leaveType!.name}"),
                leaveDialogData("Total Day", ": ${widget.myRequest.leave!.noOfDays} Days"),
                widget.myRequest.status == "Approved" ?
                widget.myRequest.approver != null && widget.myRequest.reportingTo == null ?
                expenseDialogData("Approved By", ": ${widget.myRequest.approver!.name}") :
                (widget.myRequest.reportingTo != null && widget.myRequest.approver == null) ?
                expenseDialogData("Approved By", ": ${widget.myRequest!.reportingTo!.name}") :
                expenseDialogData("Approved By", ": ${widget.myRequest!.reportingTo!.name}, ${widget.myRequest!.approver!.name}") :
                widget.myRequest.status == "Rejected" ?
                expenseDialogData("Rejected By", ": ${widget.myRequest.leave!.approvedBy!.name}") : SizedBox.shrink(),
                leaveDialogData("From Date", ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.myRequest.leave!.fromDate!))}"),
                leaveDialogData("To Date", ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.myRequest.leave!.toDate!))}"),
                leaveDialogData("Apply Date", ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.myRequest.leave!.createdAt!))}"),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                        width: 20.w,
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF808080),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          """: ${widget.myRequest.leave!.remarks}.""",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF151515),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.myRequest.leave!.files == "" ? null : () async {
                          final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${widget.myRequest.leave!.files}"));

                          if(response.statusCode == 200){
                            final bytes = response.bodyBytes;
                            final directory = await getTemporaryDirectory();
                            final filePath = '${directory.path}/${widget.myRequest.leave!.files}';
                            await File(filePath).writeAsBytes(bytes);
                            await OpenFile.open(filePath);
                          }else{
                            customWidget.showCustomSnackbar(context, "Uploaded file is not open");
                          }
                        },
                        child: Center(
                          child: dottedBorder(
                            child: Container(
                              height: 10.h,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  widget.myRequest.leave!.files == "" || widget.myRequest.leave!.files == "null" || widget.myRequest.leave!.files == null
                                      ? SizedBox.shrink() : SizedBox(
                                    height: 3.h,
                                    width: 3.w,
                                    child: Image.asset(
                                        "assets/images/upload_plus.png"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height/15,
                                      width: MediaQuery.of(context).size.width/3,
                                      child: Center(
                                        child: Text(
                                          widget.myRequest.leave!.files == "" || widget.myRequest.leave!.files == "null" || widget.myRequest.leave!.files == null ?
                                          "N/A" : "${widget.myRequest.leave!.files}",
                                          style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 14.sp,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                widget.isApprovalSelected == true && (SharedPrefsServices.getBoolData("isLead") == true || SharedPrefsServices.getBoolData("isApprover") == true )
                    && (widget.myRequest.status == "New" || (widget.myRequest.status =="Partially Approved" && (widget.myRequest.reportingTo == null && widget.myRequest.approver != null && UserData.id != widget.myRequest.approver!.id))) ?
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 6.h,
                        width: 35.5.w,
                        child: TextButton(
                          onPressed: () async {
                            ApprovalProvider approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
                            await approvalProvider.approveRequest(
                                index: widget.myRequest.id!,
                                onSuccess: (e){
                                  customWidget.showCustomSuccessSnackbar(context, "${e}");
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Approval()));
                                },
                                onFail: (e){
                                  customWidget.showCustomSnackbar(context, "${e}");
                                  Navigator.pop(context);
                                }
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(kBlueColor),
                          ),
                          child: Center(
                            child: Text(
                              "Approve",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                        width: 35.5.w,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return rejectionNoteDialog(context: context,index: widget.myRequest.id!);
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFE5252A)),
                          ),
                          child: Center(
                            child: Text(
                              "Reject",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : widget.isApprovalSelected == true && (SharedPrefsServices.getBoolData("isLead") == true || SharedPrefsServices.getBoolData("isApprover") == true )
                    && (widget.myRequest.status == "New" || (widget.myRequest.status =="Partially Approved" && (widget.myRequest.approver == null && widget.myRequest.reportingTo != null && UserData.id != widget.myRequest.reportingTo!.id))) ?
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 6.h,
                        width: 35.5.w,
                        child: TextButton(
                          onPressed: () async {
                            ApprovalProvider approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
                            await approvalProvider.approveRequest(
                                index: widget.myRequest.id!,
                                onSuccess: (e){
                                  customWidget.showCustomSuccessSnackbar(context, "${e}");
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Approval()));
                                },
                                onFail: (e){
                                  customWidget.showCustomSnackbar(context, "${e}");
                                  Navigator.pop(context);
                                }
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(kBlueColor),
                          ),
                          child: Center(
                            child: Text(
                              "Approve",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                        width: 35.5.w,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return rejectionNoteDialog(context: context,index: widget.myRequest.id!);
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFE5252A)),
                          ),
                          child: Center(
                            child: Text(
                              "Reject",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 6.h,
                        width: 40.w,
                        child: TextButton(
                          onPressed: widget.myRequest.status == "New" ? null : widget.myRequest.status == "Approved" ? null : widget.myRequest.status =="Partially Approved" ? null : () {
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                                    titlePadding: EdgeInsets.zero,
                                    title: Column(
                                      children: [
                                        Container(
                                            height: 10.h,
                                            width: 67.w,
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Color.fromRGBO(245, 45, 45, 1),width: 2))
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Remarks",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      color: Color.fromRGBO(245, 45, 45, 1),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                    width: 10.w,
                                                    child: IconButton(
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        },
                                                        icon: Icon(Icons.close,color: Color.fromRGBO(245, 45, 45, 1),size: 15,)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                        Container(
                                          height: 10.h,
                                          width: 67.w,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                widget.myRequest.leave!.remarks!,
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  color: Color.fromRGBO(245, 45, 45, 1),
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: widget.myRequest.status == "New" ?
                            MaterialStateProperty.all(kBlueColor) :
                            widget.myRequest.status == "Approved" ? MaterialStateProperty.all(kGreenColor) :
                            MaterialStateProperty.all(Colors.red),
                          ),
                          child: Text(
                            widget.myRequest.status == "Rejected" ? "<<${widget.myRequest.status}>>" :"${widget.myRequest.status}",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget leaveDialogData(type, text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: [
        SizedBox(
          height: 2.h,
          width: 20.w,
          child: Text(
            type,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF808080),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'latoRagular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF151515),
            ),
          ),
        )
      ],
    ),
  );
}

Widget rejectionNoteDialog({required BuildContext context,required int index}) {
  TextEditingController remarks = TextEditingController();
  return Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),

    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rejection Note",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE5252A),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  width: 10.w,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 3.h,
                      width: 6.w,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Image(
                          image: AssetImage("assets/images/cancel.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              width: 80.w,
              child: TextField(
                maxLines: 10,
                controller: remarks,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: "Describe your reason for reject this expense ...",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFC4C4C4),
                    fontSize: 15.sp,
                  ),
                  label: const Text(
                    "Remarks",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE5252A),
                      fontSize: 18,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5252A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE5252A)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 4.5.h,
              width: 80.w,
              child: TextButton(
                onPressed: () async {
                  print(remarks.text);
                  print(index);
                  ApprovalProvider approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
                  await approvalProvider.approveRejected(
                      index: index,
                      remarks: remarks.text,
                      onSuccess: (e){
                        customWidget.showCustomSuccessSnackbar(context, "${e}");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Approval()));
                      },
                      onFail: (e){
                        customWidget.showCustomSnackbar(context, "${e}");
                        Navigator.pop(context);
                      }
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFE5252A)),
                ),
                child: const Text(
                  "Reject",
                  style: TextStyle(
                    fontFamily: 'latoRagular',
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.5.h),
        ],
      ),
    ),
  );
}
