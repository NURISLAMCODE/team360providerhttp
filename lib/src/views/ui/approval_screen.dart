import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/approval_provider.dart';
import 'package:team360/src/views/ui/approval_screen_alert_dialog.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/expense_screen.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../business_logics/models/approveal_model/my_request_class.dart';
import '../../services/shared_preference_services/shared_preference_services.dart';
import 'bottomnav/bottomnav_screen_layout.dart';
import 'drawer.dart';

class Approval extends StatefulWidget {
  const Approval({Key? key}) : super(key: key);

  @override
  State<Approval> createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  bool isApprovalSelected = true;
  String? type = "All";
  bool isPendingSelected = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(SharedPrefsServices.getBoolData("isLead") == true || SharedPrefsServices.getBoolData("isApprover") == true){
      setState(() {
        isApprovalSelected = true;
      });
    }else{
      setState(() {
        isApprovalSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Consumer<ApprovalProvider>(
        builder: (context,approvalProvider,child){
          if(isApprovalSelected == true){
            return FutureBuilder<MyRequestClass?>(
                future: approvalProvider.getAllAprover(type: type!),
                builder: (context,snapsort){
                  if(snapsort.hasData){
                    return CustomScrollView(
                      slivers: [

                        SliverAppBar(
                          floating: false,
                          pinned: true,
                          expandedHeight: 6.h,
                          automaticallyImplyLeading: false,
                          backgroundColor: const Color(0xFFEAF4F2),
                          flexibleSpace: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                            child: SizedBox(
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
                                        child: Image.asset("assets/images/arrow_left.png"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Approval",
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
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: SharedPrefsServices.getBoolData("isApprover") == true || SharedPrefsServices.getBoolData("isLead") == true ? Container(
                            height: 7.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xFF19888E),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isApprovalSelected = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(3)),
                                  ),
                                  child: Container(
                                    height: 7.h,
                                    width: MediaQuery.of(context).size.width / 2.1,
                                    decoration: BoxDecoration(
                                      color: isApprovalSelected
                                          ? kWhiteColor
                                          : const Color(0xFF19888E),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Approval",
                                        style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isApprovalSelected
                                                ? kBlackColor
                                                : kWhiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isApprovalSelected = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(3)),
                                  ),
                                  child: Container(
                                    height: 7.h,
                                    width: MediaQuery.of(context).size.width / 2.1,
                                    decoration: BoxDecoration(
                                      color: isApprovalSelected
                                          ? const Color(0xFF19888E)
                                          : kWhiteColor,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "My Request",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          isApprovalSelected ? kWhiteColor : kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(
                            height: 7.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xFF19888E),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isApprovalSelected = false;
                                });
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(3)),
                              ),
                              child: Container(
                                height: 7.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: isApprovalSelected
                                      ? const Color(0xFF19888E)
                                      : kWhiteColor,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "My Request",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      isApprovalSelected ? kWhiteColor : kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SliverFillRemaining(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
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
                              child: CustomScrollView(
                                slivers: [

                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                      child: Container(
                                        height: 6.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: const Color(0xFF19888E),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                    const EdgeInsets.all(1)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  type = "All";
                                                });
                                              },
                                              child: Container(
                                                height: 5.8.h,
                                                width: 29.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: type == "All"
                                                      ? kWhiteColor
                                                      : const Color(0xFF19888E),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: type == "All"
                                                          ? kBlackColor
                                                          : kWhiteColor,
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
                                                  type = "expense";
                                                });
                                              },
                                              child: Container(
                                                height: 5.8.h,
                                                width: 29.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: type == "expense"
                                                      ? kWhiteColor
                                                      : const Color(0xFF19888E),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Expense",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: type == "expense"
                                                          ? kBlackColor
                                                          : kWhiteColor,
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
                                                  type = "leave";
                                                });
                                              },
                                              child: Container(
                                                height: 5.8.h,
                                                width: 29.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: type == "leave"
                                                      ? kWhiteColor
                                                      : const Color(0xFF19888E),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Leave",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: type == "leave"
                                                          ? kBlackColor
                                                          : kWhiteColor,
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

                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                              (context,int index){
                                            if(snapsort.data!.data![index].type == "leave"){
                                              return InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return LeaveDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                                  child: IntrinsicHeight(
                                                    child: Container(
                                                      // height: 10.h,
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
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              height: 5.h,
                                                              width: 15.w,
                                                              child: const Image(
                                                                image: AssetImage("assets/images/exit.png"),
                                                              ),
                                                            ),
                                                            const VerticalDivider(
                                                              color: Color(0xFFD9D9D9),
                                                              thickness: 1,
                                                              indent: 10,
                                                              endIndent: 10,
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Leave",
                                                                  style: TextStyle(
                                                                    fontFamily: 'latoRagular',
                                                                    fontSize: 13.5.sp,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: const Color(0xFF252930),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                customData(label: "Applied by", value: ": ${snapsort.data!.data![index].leave!.users!.name}"),
                                                                customData(label: "From Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].leave!.fromDate!))}"),
                                                                customData(label: "To Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].leave!.toDate!))}"),
                                                                customData(label: "Day Count", value: ": ${snapsort.data!.data![index].leave!.noOfDays}"),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 100),
                                                              child: Column(
                                                                children: [
                                                                  // SizedBox(
                                                                  //   height: 3.h,
                                                                  //   width: 7.5.w,
                                                                  //   child: const Image(
                                                                  //     image: AssetImage(
                                                                  //         "assets/images/clarity_new-line.png"),
                                                                  //   ),
                                                                  // ),
                                                                  SizedBox(
                                                                      height: 3.h,
                                                                      width: 12.w,
                                                                      child: Text(
                                                                        "${snapsort.data!.data![index].status}",
                                                                        style: TextStyle(
                                                                          fontFamily: 'latoRagular',
                                                                          fontSize: 13.sp,
                                                                          fontWeight: FontWeight.w700,
                                                                          color: snapsort.data!.data![index].status == "New" ?
                                                                          kBlueColor : snapsort.data!.data![index].status == "Approved" ?
                                                                          kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                                                                        ),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 5),
                                                                    child: Icon(
                                                                      Icons.arrow_forward_ios_rounded,
                                                                      size: 18.5.sp,
                                                                      color: const Color(0xFF102048),
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
                                              );
                                            }else{
                                              if(snapsort.data!.data![index].expense!.type == "Food Expense"){
                                                return  InkWell(
                                                  onTap: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return ExpenseDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        // height: 10.h,
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5.h,
                                                                width: 15.w,
                                                                child: const Image(
                                                                  image: AssetImage(
                                                                      "assets/images/Rectangle 90 (1).png"),
                                                                ),
                                                              ),
                                                              const VerticalDivider(
                                                                color: Color(0xFFD9D9D9),
                                                                thickness: 1,
                                                                indent: 10,
                                                                endIndent: 10,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "${snapsort.data!.data![index].expense!.type}",
                                                                    style: TextStyle(
                                                                      fontFamily: 'latoRagular',
                                                                      fontSize: 13.5.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: const Color(0xFF252930),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 8),
                                                                  customData(label: "Billing by", value: ": ${snapsort.data!.data![index].expense!.createdBy!.name}"),
                                                                  snapsort.data!.data![index].expense!.expenseCurrency == null ?
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount}") :
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount} ${snapsort.data!.data![index].expense!.expenseCurrency!.code}"),
                                                                  customData(label: "Person", value: ": ${snapsort.data!.data![index].expense!.totalPerson}"),
                                                                  customData(label: "Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].expense!.createdAt!))}"),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 100),
                                                                child: Column(
                                                                  children: [
                                                                    // SizedBox(
                                                                    //   height: 3.h,
                                                                    //   width: 7.5.w,
                                                                    //   child: const Image(
                                                                    //     image: AssetImage(
                                                                    //         "assets/images/clarity_new-line.png"),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                        height: 3.h,
                                                                        width: 12.w,
                                                                        child: Text(
                                                                          "${snapsort.data!.data![index].status}",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontSize: 13.sp,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: snapsort.data!.data![index].status == "New" ?
                                                                            kBlueColor : snapsort.data!.data![index].status == "Approved" ?
                                                                            kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5),
                                                                      child: Icon(
                                                                        Icons.arrow_forward_ios_rounded,
                                                                        size: 18.5.sp,
                                                                        color: const Color(0xFF102048),
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
                                                );
                                              }else if(snapsort.data!.data![index].expense!.type == "Transport Expense") {
                                                return InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return ExpenseDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                      },
                                                    );
                                                  },
                                                  child: customContainer(myRequest: snapsort.data!.data![index]),
                                                );
                                              }else {
                                                return InkWell(
                                                  onTap: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return ExpenseDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        // height: 10.h,
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5.h,
                                                                width: 15.w,
                                                                child: const Image(
                                                                  image: AssetImage(
                                                                      "assets/images/miscellaneous.png"),
                                                                ),
                                                              ),
                                                              const VerticalDivider(
                                                                color: Color(0xFFD9D9D9),
                                                                thickness: 1,
                                                                indent: 10,
                                                                endIndent: 10,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "${snapsort.data!.data![index].expense!.type}",
                                                                    style: TextStyle(
                                                                      fontFamily: 'latoRagular',
                                                                      fontSize: 13.5.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: const Color(0xFF252930),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 8),
                                                                  customData(label: "Billing by", value: ": ${snapsort.data!.data![index].expense!.createdBy!.name}"),
                                                                  snapsort.data!.data![index].expense!.expenseCurrency == null ?
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount}") :
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount} ${snapsort.data!.data![index].expense!.expenseCurrency!.code}"),
                                                                  customData(label: "Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].expense!.createdAt!))}"),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 100),
                                                                child: Column(
                                                                  children: [
                                                                    // SizedBox(
                                                                    //   height: 3.h,
                                                                    //   width: 7.5.w,
                                                                    //   child: const Image(
                                                                    //     image: AssetImage(
                                                                    //         "assets/images/clarity_new-line.png"),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                        height: 3.h,
                                                                        width: 12.w,
                                                                        child: Text(
                                                                          "${snapsort.data!.data![index].status}",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontSize: 13.sp,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: snapsort.data!.data![index].status == "New" ?
                                                                            kBlueColor : snapsort.data!.data![index].status == "Approved" ?
                                                                            kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5),
                                                                      child: Icon(
                                                                        Icons.arrow_forward_ios_rounded,
                                                                        size: 18.5.sp,
                                                                        color: const Color(0xFF102048),
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
                                                );
                                              }
                                            }
                                          },
                                          childCount: snapsort.data!.data!.length
                                      )
                                  ),

                                  SliverToBoxAdapter(
                                    child: SizedBox(height: 5.h,),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }else{
                    return Container(
                      height: MediaQuery.of(context).size.height / 1,
                      width: MediaQuery.of(context).size.width / 1,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }
            );
          }else{
            return FutureBuilder<MyRequestClass?>(
                future: approvalProvider.getAllMyRequest(type: type!),
                builder: (context,snapsort){
                  if(snapsort.hasData){
                    return CustomScrollView(
                      slivers: [

                        SliverAppBar(
                          floating: false,
                          pinned: true,
                          expandedHeight: 6.h,
                          automaticallyImplyLeading: false,
                          backgroundColor: const Color(0xFFEAF4F2),
                          flexibleSpace: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                            child: SizedBox(
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
                                        child: Image.asset("assets/images/arrow_left.png"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Approval",
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
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: SharedPrefsServices.getBoolData("isApprover") == true || SharedPrefsServices.getBoolData("isLead") == true ? Container(
                            height: 7.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xFF19888E),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isApprovalSelected = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(3)),
                                  ),
                                  child: Container(
                                    height: 7.h,
                                    width: MediaQuery.of(context).size.width / 2.1,
                                    decoration: BoxDecoration(
                                      color: isApprovalSelected
                                          ? kWhiteColor
                                          : const Color(0xFF19888E),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Approval",
                                        style: TextStyle(
                                            fontFamily: 'latoRagular',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isApprovalSelected
                                                ? kBlackColor
                                                : kWhiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isApprovalSelected = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(3)),
                                  ),
                                  child: Container(
                                    height: 7.h,
                                    width: MediaQuery.of(context).size.width / 2.1,
                                    decoration: BoxDecoration(
                                      color: isApprovalSelected
                                          ? const Color(0xFF19888E)
                                          : kWhiteColor,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "My Request",
                                        style: TextStyle(
                                          fontFamily: 'latoRagular',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          isApprovalSelected ? kWhiteColor : kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(
                            height: 7.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xFF19888E),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isApprovalSelected = false;
                                });
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(3)),
                              ),
                              child: Container(
                                height: 7.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: isApprovalSelected
                                      ? const Color(0xFF19888E)
                                      : kWhiteColor,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "My Request",
                                    style: TextStyle(
                                      fontFamily: 'latoRagular',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      isApprovalSelected ? kWhiteColor : kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SliverFillRemaining(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
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
                              child: CustomScrollView(
                                slivers: [

                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                      child: Container(
                                        height: 6.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: const Color(0xFF19888E),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                    const EdgeInsets.all(1)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  type = "All";
                                                });
                                              },
                                              child: Container(
                                                height: 5.8.h,
                                                width: 29.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: type == "All"
                                                      ? kWhiteColor
                                                      : const Color(0xFF19888E),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: type == "All"
                                                          ? kBlackColor
                                                          : kWhiteColor,
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
                                                  type = "expense";
                                                });
                                              },
                                              child: Container(
                                                height: 5.8.h,
                                                width: 29.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: type == "expense"
                                                      ? kWhiteColor
                                                      : const Color(0xFF19888E),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Expense",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: type == "expense"
                                                          ? kBlackColor
                                                          : kWhiteColor,
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
                                                  type = "leave";
                                                });
                                              },
                                              child: Container(
                                                height: 5.8.h,
                                                width: 29.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: type == "leave"
                                                      ? kWhiteColor
                                                      : const Color(0xFF19888E),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Leave",
                                                    style: TextStyle(
                                                      fontFamily: 'latoRagular',
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: type == "leave"
                                                          ? kBlackColor
                                                          : kWhiteColor,
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

                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                              (context,int index){
                                            if(snapsort.data!.data![index].type == "leave"){
                                              return InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return LeaveDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                                  child: IntrinsicHeight(
                                                    child: Container(
                                                      // height: 10.h,
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
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              height: 5.h,
                                                              width: 15.w,
                                                              child: const Image(
                                                                image: AssetImage("assets/images/exit.png"),
                                                              ),
                                                            ),
                                                            const VerticalDivider(
                                                              color: Color(0xFFD9D9D9),
                                                              thickness: 1,
                                                              indent: 10,
                                                              endIndent: 10,
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Leave",
                                                                  style: TextStyle(
                                                                    fontFamily: 'latoRagular',
                                                                    fontSize: 13.5.sp,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: const Color(0xFF252930),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                customData(label: "Applied by", value: ": ${snapsort.data!.data![index].leave!.users!.name}"),
                                                                customData(label: "From Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].leave!.fromDate!))}"),
                                                                customData(label: "To Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].leave!.toDate!))}"),
                                                                customData(label: "Day Count", value: ": ${snapsort.data!.data![index].leave!.noOfDays}"),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 100),
                                                              child: Column(
                                                                children: [
                                                                  // SizedBox(
                                                                  //   height: 3.h,
                                                                  //   width: 7.5.w,
                                                                  //   child: const Image(
                                                                  //     image: AssetImage(
                                                                  //         "assets/images/clarity_new-line.png"),
                                                                  //   ),
                                                                  // ),
                                                                  SizedBox(
                                                                      height: 3.h,
                                                                      width: 12.w,
                                                                      child: Text(
                                                                        "${snapsort.data!.data![index].status}",
                                                                        style: TextStyle(
                                                                          fontFamily: 'latoRagular',
                                                                          fontSize: 13.sp,
                                                                          fontWeight: FontWeight.w700,
                                                                          color: snapsort.data!.data![index].status == "New" ?
                                                                          kBlueColor : snapsort.data!.data![index].status == "Approved" ?
                                                                          kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                                                                        ),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 5),
                                                                    child: Icon(
                                                                      Icons.arrow_forward_ios_rounded,
                                                                      size: 18.5.sp,
                                                                      color: const Color(0xFF102048),
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
                                              );
                                            }else{
                                              if(snapsort.data!.data![index].expense!.type == "Food Expense"){
                                                return  InkWell(
                                                  onTap: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return ExpenseDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        // height: 10.h,
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5.h,
                                                                width: 15.w,
                                                                child: const Image(
                                                                  image: AssetImage(
                                                                      "assets/images/Rectangle 90 (1).png"),
                                                                ),
                                                              ),
                                                              const VerticalDivider(
                                                                color: Color(0xFFD9D9D9),
                                                                thickness: 1,
                                                                indent: 10,
                                                                endIndent: 10,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "${snapsort.data!.data![index].expense!.type}",
                                                                    style: TextStyle(
                                                                      fontFamily: 'latoRagular',
                                                                      fontSize: 13.5.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: const Color(0xFF252930),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 8),
                                                                  customData(label: "Billing by", value: ": ${snapsort.data!.data![index].expense!.createdBy!.name}"),
                                                                  snapsort.data!.data![index].expense!.expenseCurrency == null ?
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount}") :
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount} ${snapsort.data!.data![index].expense!.expenseCurrency!.code}"),
                                                                  customData(label: "Person", value: ": ${snapsort.data!.data![index].expense!.totalPerson}"),
                                                                  customData(label: "Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].expense!.createdAt!))}"),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 100),
                                                                child: Column(
                                                                  children: [
                                                                    // SizedBox(
                                                                    //   height: 3.h,
                                                                    //   width: 7.5.w,
                                                                    //   child: const Image(
                                                                    //     image: AssetImage(
                                                                    //         "assets/images/clarity_new-line.png"),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                        height: 3.h,
                                                                        width: 12.w,
                                                                        child: Text(
                                                                          "${snapsort.data!.data![index].status}",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontSize: 13.sp,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: snapsort.data!.data![index].status == "New" ?
                                                                            kBlueColor : snapsort.data!.data![index].status == "Approved" ?
                                                                            kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5),
                                                                      child: Icon(
                                                                        Icons.arrow_forward_ios_rounded,
                                                                        size: 18.5.sp,
                                                                        color: const Color(0xFF102048),
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
                                                );
                                              }else if(snapsort.data!.data![index].expense!.type == "Transport Expense") {
                                                return InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return ExpenseDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                      },
                                                    );
                                                  },
                                                  child: customContainer(myRequest: snapsort.data!.data![index]),
                                                );
                                              }else {
                                                return InkWell(
                                                  onTap: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return ExpenseDetailsDialog(myRequest: snapsort.data!.data![index],isApprovalSelected: isApprovalSelected,);
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        // height: 10.h,
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5.h,
                                                                width: 15.w,
                                                                child: const Image(
                                                                  image: AssetImage(
                                                                      "assets/images/miscellaneous.png"),
                                                                ),
                                                              ),
                                                              const VerticalDivider(
                                                                color: Color(0xFFD9D9D9),
                                                                thickness: 1,
                                                                indent: 10,
                                                                endIndent: 10,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "${snapsort.data!.data![index].expense!.type}",
                                                                    style: TextStyle(
                                                                      fontFamily: 'latoRagular',
                                                                      fontSize: 13.5.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: const Color(0xFF252930),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 8),
                                                                  customData(label: "Billing by", value: ": ${snapsort.data!.data![index].expense!.createdBy!.name}"),
                                                                  snapsort.data!.data![index].expense!.expenseCurrency == null ?
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount}") :
                                                                  customData(label: "Amount", value: ": ${snapsort.data!.data![index].expense!.amount} ${snapsort.data!.data![index].expense!.expenseCurrency!.code}"),
                                                                  customData(label: "Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapsort.data!.data![index].expense!.createdAt!))}"),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 100),
                                                                child: Column(
                                                                  children: [
                                                                    // SizedBox(
                                                                    //   height: 3.h,
                                                                    //   width: 7.5.w,
                                                                    //   child: const Image(
                                                                    //     image: AssetImage(
                                                                    //         "assets/images/clarity_new-line.png"),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                        height: 3.h,
                                                                        width: 12.w,
                                                                        child: Text(
                                                                          "${snapsort.data!.data![index].status}",
                                                                          style: TextStyle(
                                                                            fontFamily: 'latoRagular',
                                                                            fontSize: 13.sp,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: snapsort.data!.data![index].status == "New" ?
                                                                            kBlueColor : snapsort.data!.data![index].status == "Approved" ?
                                                                            kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5),
                                                                      child: Icon(
                                                                        Icons.arrow_forward_ios_rounded,
                                                                        size: 18.5.sp,
                                                                        color: const Color(0xFF102048),
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
                                                );
                                              }
                                            }
                                          },
                                          childCount: snapsort.data!.data!.length
                                      )
                                  ),

                                  SliverToBoxAdapter(
                                    child: SizedBox(height: 5.h,),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }else{
                    return Container(
                      height: MediaQuery.of(context).size.height / 1,
                      width: MediaQuery.of(context).size.width / 1,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }
            );
          }
        },
      )
    );
  }
}

Widget customContainer({required MyRequest myRequest}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
    child: IntrinsicHeight(
      child: Container(
        // height: 10.h,
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
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Image
              SizedBox(
                height: 5.h,
                width: 15.w,
                child: const Image(
                  image: AssetImage("assets/images/Rectangle 90.png"),
                ),
              ),
              const VerticalDivider(
                color: Color(0xFFD9D9D9),
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${myRequest.expense!.type}",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF252930),
                    ),
                  ),
                  const SizedBox(height: 8),
                  customData(label: "Billing by", value: ": ${myRequest.expense!.createdBy!.name}"),
                  myRequest.expense!.expenseCurrency == null ?
                  customData(label: "Amount", value: ": ${myRequest.expense!.amount}") :
                  customData(label: "Amount", value: ": ${myRequest.expense!.amount} ${myRequest.expense!.expenseCurrency!.code}"),
                  customData(label: "Date", value: ": ${DateFormat("yyyy-MM-dd").format(DateTime.parse(myRequest.expense!.createdAt!))}"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 3.h,
                    //   width: 7.5.w,
                    //   child: const Image(
                    //     image: AssetImage("assets/images/clarity_new-line.png"),
                    //   ),
                    // ),
                    SizedBox(
                        height: 3.h,
                        width: 12.w,
                        child: Text(
                          "${myRequest.status}",
                          style: TextStyle(
                            fontFamily: 'latoRagular',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: myRequest.status == "New" ?
                            kBlueColor : myRequest.status == "Approved" ?
                            kGreenColor : Color.fromRGBO(245, 45, 45, 1),
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18.5.sp,
                          color: const Color(0xFF102048),
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
  );
}

Widget customContainerAd() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Stack(
      children: [
        IntrinsicHeight(
          child: Container(
            // height: 10.h,
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
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Image
                  SizedBox(
                    height: 5.h,
                    width: 15.w,
                    child: const Image(
                      image: AssetImage("assets/images/Rectangle 90.png"),
                    ),
                  ),
                  const VerticalDivider(
                    color: Color(0xFFD9D9D9),
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transport Bill",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF252930),
                        ),
                      ),
                      const SizedBox(height: 8),
                      customData(label: "Billing by", value: ": Sahidul Islam"),
                      customData(label: "Amount", value: ": 5475.00 Tk"),
                      customData(label: "Transport", value: ": Bus"),
                      customData(label: "Date", value: ": 10/08/2022"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.5.sp,
                        color: const Color(0xFF102048),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 70.w,
          child: Container(
            height: 3.h,
            width: 20.w,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              color: Color(0xFF06B402),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Approved",
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
  );
}

Widget customData({label, value}) {
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
