import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/views/ui/add_expense.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_screen_layout.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:team360/src/views/widgets/widget_factory.dart';
import 'package:http/http.dart' as http;

import '../../business_logics/models/all_expenses_response_model.dart';
import '../../business_logics/models/expence_mdel/expence_perpose_model.dart';
import '../../business_logics/providers/expenses_provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  FocusNode serchETFocusNode = FocusNode();
  String? selectedType = "All";
  var tfVisibility = false;
  bool loading = true;
  String selectedExpenseType = "";
  List<PurposeTypes> purposeTypes = [];

  @override
  void initState() {
    super.initState();
    loading = true;
    Future.delayed(Duration(seconds: 1), () async {
      ExpensesProvider expensesProvider = Provider.of<ExpensesProvider>(context, listen: false);
      await expensesProvider.getAllExpencePerpose().then((value) {
        if(value?.data?.purposeTypes?.isNotEmpty == true){
          value!.data!.purposeTypes!.forEach((element) {
            purposeTypes.add(element);
          });
        }
      });
      await loadingStop();
    });
  }

  Future<void> loadingStop() async {
    Future.delayed(Duration(seconds: 1),() {
      setState((){
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        fromDateController.clear();
        toDateController.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreenLayout(page: 0,)));
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpenseScreen()));
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

          body: loading ==true ? Container(
            height: MediaQuery.of(context).size.height/ 1,
            width: MediaQuery.of(context).size.width/ 1,
            child : Center(child: CircularProgressIndicator()),
          ): Consumer<ExpensesProvider>(
            builder: (context,allExpensesProvider,child){
              return FutureBuilder<AllExpensesResponseModel?>(
                  future: allExpensesProvider.getAllExpence(start_date: fromDateController.text, end_date: toDateController.text, type: selectedExpenseType,),
                  builder: (context,snapsort){
                    if(snapsort.hasData){
                      return CustomScrollView(
                        slivers: [

                          SliverAppBar(
                            backgroundColor: const Color(0xFFEAF4F2),
                            automaticallyImplyLeading: false,
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                height: 5.h,
                                width: 90.w,
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
                                              fromDateController.clear();
                                              toDateController.clear();
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
                                              "Expenses",
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
                                    Container(
                                      height: 4.h,
                                      width: 8.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: kBlueColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          if(tfVisibility == true) {
                                            setState(() {
                                              tfVisibility = false;
                                            });
                                          } else {
                                            setState(() {
                                              tfVisibility = true;
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.search,
                                          size: 17.sp,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SliverFillRemaining(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomScrollView(
                                slivers: [

                                  SliverToBoxAdapter(
                                    child: Container(
                                      height: 6.h,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        borderRadius: BorderRadius.circular(32),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
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
                                              onTap:(){
                                                setState(() {
                                                  selectedType = "All";
                                                });
                                              },
                                              child: Text(
                                                "ALL",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.sp,
                                                  color: selectedType == "All" ? const Color(0xFF1294F2) : kBlackColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  selectedType = "Pending";
                                                });
                                              },
                                              child: Text(
                                                "Pending",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.sp,
                                                  color: selectedType == "Pending" ? const Color(0xFF1294F2) : kBlackColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  selectedType = "Approved";
                                                });
                                              },
                                              child: Text(
                                                "Approved",
                                                style: TextStyle(
                                                  fontFamily: 'latoRagular',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.sp,
                                                  color: selectedType == "Approved" ? const Color(0xFF1294F2) : kBlackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SliverToBoxAdapter(
                                    child: Visibility(
                                      visible: tfVisibility,
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 20,right: 20,top: 15,),
                                        child: SizedBox(
                                          height: 6.h,
                                          width: 90.w,
                                          child: DropdownButtonFormField<String>(
                                            hint: Text(
                                              "Select Expense Type",
                                              style: TextStyle(
                                                fontFamily: 'latoRagular',
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w400,
                                                color: kThemeColor,
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              contentPadding: const EdgeInsets.all(10.0),
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
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedExpenseType = newValue!;
                                              });
                                            },
                                            items: <String>[
                                              "Food Expense",
                                              "Transport Expense",
                                              "Miscellaneous Expense",
                                            ].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,style: const TextStyle(
                                                  color: kThemeColor,
                                                  fontFamily: 'latoRagular',
                                                ),),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20,top: 15),
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
                                                  fromDateController.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickedDate);
                                                });
                                              }
                                            },
                                            child: SizedBox(
                                              width: 40.w,
                                              child: TextField(
                                                enabled: false,
                                                controller: fromDateController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  contentPadding:
                                                  const EdgeInsets.all(10.0),
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
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                    borderSide: const BorderSide(
                                                      color: kLightGreyColor,
                                                    ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: kLightGreyColor),
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.parse(fromDateController.text),
                                                firstDate: DateTime.parse(fromDateController.text),
                                                lastDate: DateTime(2040),
                                              );
                                              if (pickedDate != null) {
                                                setState(() {
                                                  toDateController.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickedDate);
                                                });
                                              }
                                            },
                                            child: SizedBox(
                                              width: 40.w,
                                              child: TextField(
                                                enabled: false,
                                                controller: toDateController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  contentPadding:
                                                  const EdgeInsets.all(10.0),
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
                                                      borderRadius:
                                                      BorderRadius.circular(8)),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                    borderSide: const BorderSide(
                                                      color: kLightGreyColor,
                                                    ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: kLightGreyColor),
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  ),
                                                ),
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
                                            if(selectedType == "All"){
                                              return allType(expenses: snapsort.data!.data!.expenses![index],context: context);
                                            }else if(snapsort.data!.data!.expenses![index].status == selectedType){
                                              return allType(expenses: snapsort.data!.data!.expenses![index],context: context);
                                            }
                                          },
                                        childCount: snapsort.data!.data!.expenses!.length
                                      ),
                                  ),

                                  SliverToBoxAdapter(
                                    child: SizedBox(height: 2.h,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }else{
                      return Container(
                        height: MediaQuery.of(context).size.height/ 1,
                        width: MediaQuery.of(context).size.width/ 1,
                        child : Center(child: CircularProgressIndicator()),
                      );
                    }
                  }
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddExpense(selectedExpenseType: "Food Expense",purposeTypes: purposeTypes,),
                ),
              );
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
}


Widget allType({required Expenses expenses,required BuildContext context}){
  if(expenses.type == "Transport Expense"){
    return Container(
      width: 90.h,
      margin: EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return transportDetails(context: context,expenses: expenses);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              IntrinsicHeight(
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
                        //
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "Transport Bill",
                              //"${allExpenses?.type == "Food Expense" ? allExpenses?.type: "N/A"}",
                              expenses!.type ?? "N/A",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF252930),
                              ),
                            ),
                            const SizedBox(height: 8),
                            expenseData(
                                label: "Submitted by", value: ": ${expenses.createdBy!.name}"),
                            expenses.expenseCurrency == null ?   expenseData(label: "Amount", value: ": ${expenses.amount} ") : expenseData(label: "Amount", value: ": ${expenses.amount} ${expenses.expenseCurrency!.code}"),
                            expenseData(label: "Date", value: ": ${DateFormat('yyyy-MM-dd').format(DateTime.parse(expenses!.expenseDate ?? "N/A"))}"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 60,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              height: 2.5.h,
                              width: 5.w,
                              child: Image.asset(
                                "assets/images/pin.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
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
                  height: 5.h,
                  width: 20.w,
                  padding: EdgeInsets.only(left: 5,right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: expenses.status == "Pending" ? Color(0xFFEBA900) : expenses.status== "Approved" ? kGreenColor : Color.fromRGBO(245, 45, 45, 1) ,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${expenses.status}",
                      //"Approved",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }else if(expenses.type == "Food Expense"){
    return Container(
      height: 18.h,
      width: 90.w,
      margin: EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return foodDetails(context: context,expenses: expenses);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              IntrinsicHeight(
                child: Container(
                  height: 18.h,
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
                            image: AssetImage("assets/images/Rectangle 90 (1).png"),
                          ),
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

                              //"Food Bill"
                              // "${ allExpenses?.type == "food" ? allExpenses?.type: "N/A"}",
                              expenses.type ?? "N/A",
                              //  allExpenses?.type ? "Food Bill" : "N/A",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF252930),
                              ),
                            ),
                            const SizedBox(height: 8),
                            expenses.expenseCurrency == null ?   expenseData(label: "Amount", value: ": ${expenses.amount} ") : expenseData(label: "Amount", value: ": ${expenses.amount} ${expenses.expenseCurrency!.code}"),
                            expenseData(label: "Person", value: ": ${expenses.totalPerson ?? "N/A"} Person"),
                            expenseData(label: "Date", value: ": ${DateFormat('yyyy-MM-dd').format(DateTime.parse(expenses.expenseDate!))}"),
                            expenseData(label: "Submitted By", value: ": ${expenses.createdBy!.name} "),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 60,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              height: 2.5.h,
                              width: 5.w,
                              child: Image.asset(
                                "assets/images/pin.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
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
                  height: 5.h,
                  width: 20.w,
                  padding: EdgeInsets.only(left: 5,right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    color: expenses.status == "Pending" ? Color(0xFFEBA900) : expenses.status== "Approved" ? kGreenColor : Color.fromRGBO(245, 45, 45, 1) ,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${expenses.status}",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: kWhiteColor,
                      ),
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
    return Container(
      height: 17.h,
      width: 90.w,
      margin: EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return miscellaneousDetails(context: context,expenses: expenses);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              IntrinsicHeight(
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
                            image: AssetImage("assets/images/miscellaneous.png"),
                          ),
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
                            const SizedBox(height: 8),
                            expenseData(label: "", value: ""),
                            Text(
                              expenses.type ?? "N/A",
                              // "Miscellaneous Bill ",
                              style: TextStyle(
                                fontFamily: 'latoRagular',
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF252930),
                              ),
                            ),
                            const SizedBox(height: 8),
                            expenses.expenseCurrency == null ?   expenseData(label: "Amount", value: ": ${expenses.amount} ") : expenseData(label: "Amount", value: ": ${expenses.amount} ${expenses.expenseCurrency!.code}"),
                            expenseData(label: "Date", value: ": ${DateFormat('yyyy-MM-dd').format(DateTime.parse(expenses.expenseDate!))}"),
                            expenseData(label: "Submitted By", value: ": ${expenses.createdBy!.name} "),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 60,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              height: 2.5.h,
                              width: 5.w,
                              child: Image.asset(
                                "assets/images/pin.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
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
                  height: 5.h,
                  width: 20.w,
                  padding: EdgeInsets.only(left: 5,right: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    color: expenses.status == "Pending" ? Color(0xFFEBA900) : expenses.status== "Approved" ? kGreenColor : Color.fromRGBO(245, 45, 45, 1) ,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${expenses.status}",
                      style: TextStyle(
                        fontFamily: 'latoRagular',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: kWhiteColor,
                      ),
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

Widget transportExpenseItem() {
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
                  //
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
                      expenseData(label: "Billing by", value: ": Sahidul Islam"),
                      expenseData(label: "Amount", value: ": 5475.00 Tk"),
                      expenseData(label: "Transport", value: ": Bus"),
                      expenseData(label: "Date", value: ": 10/08/2022"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: 2.5.h,
                        width: 5.w,
                        child: Image.asset(
                          "assets/images/pin.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
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
        ),
      ],
    ),
  );
}

Widget foodExpenseItem() {
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
                      image: AssetImage("assets/images/Rectangle 90 (1).png"),
                    ),
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
                        "Food Bill",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF252930),
                        ),
                      ),
                      const SizedBox(height: 8),
                      expenseData(label: "Amount", value: ": 5475.00 Tk"),
                      expenseData(label: "Person", value: ": 3 Person"),
                      expenseData(label: "Date", value: ": 10/08/2022"),
                      expenseData(
                          label: "Sumitted By", value: ": Sahidul Islam"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: 2.5.h,
                        width: 5.w,
                        child: Image.asset(
                          "assets/images/pin.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
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
                  topLeft: Radius.circular(10)),
              color: Color(0xFFEBA900),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Pending",
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget miscellaneousExpenseItem() {
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
                      image: AssetImage("assets/images/miscellaneous.png"),
                    ),
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
                      const SizedBox(height: 8),
                      expenseData(label: "", value: ""),
                      Text(
                        "Miscellaneous Bill ",
                        style: TextStyle(
                          fontFamily: 'latoRagular',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF252930),
                        ),
                      ),
                      expenseData(label: "Amount", value: ": 5475.00 Tk"),
                      expenseData(label: "", value: ""),
                      expenseData(label: "", value: ""),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: 2.5.h,
                        width: 5.w,
                        child: Image.asset(
                          "assets/images/pin.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
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
                  topLeft: Radius.circular(10)),
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
        ),
      ],
    ),
  );
}

Widget expenseData({String? label, String? value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: 1.5.h,
        width: 15.w,
        child: Text(
          label ?? "",
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
          value ?? "",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF808080),
          ),
        ),
      )
    ],
  );
}

Widget transportDetails({required BuildContext context,required Expenses expenses}) {
  return AlertDialog(
    contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
    titlePadding: EdgeInsets.zero,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 5.h,
          width: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            color: expenses.status == "Pending" ? Color(0xFFEBA900) : expenses.status== "Approved" ? kGreenColor : Color.fromRGBO(245, 45, 45, 1) ,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${expenses.status}",
              style: TextStyle(
                fontFamily: 'latoRagular',
                color: kWhiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 1.5.h,
              width: 3.w,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Image(
                  image: AssetImage("./assets/images/cancel.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    content: SingleChildScrollView(
      child: Column(
        children: [
          transportDetailsData("Expense Type", ": ${expenses.type}"),
          expenses.expenseCurrency == null ? transportDetailsData("Total Amount", ": ${expenses.amount}") : transportDetailsData("Total Amount", ": ${expenses.amount} ${expenses.expenseCurrency!.code}") ,
          transportDetailsData("Date", ": ${DateFormat("dd-MMMM-yyyy").format(DateTime.parse(expenses.createdAt!))}"),
          expenses.purposeType == null ? transportDetailsData("Purpose", ": N/A"):transportDetailsData("Purpose", ": ${expenses.purposeType!.name}"),
          transportDetailsData("Apply Date", ": ${DateFormat("dd-MMMM-yyyy").format(DateTime.parse(expenses.updatedAt!))}"),
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
                    ": ${expenses.description}",
                    style: TextStyle(
                      fontFamily: 'latoRagular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF151515),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10.h,
            width: 72.5.w,
            child: ListView.builder(
                itemCount: expenses.expenseDetails!.length,
                itemBuilder: (context,int index){
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return transportItemDetails(context: context,expenseDetails: expenses.expenseDetails![index],expenses: expenses);
                            },
                          );
                        },
                        child: transportItem(context: context,expenseDetails: expenses.expenseDetails![index],expenses: expenses),
                    ),
                  );
                }
                ),
          ),
          const SizedBox(height: 24.0)
        ],
      ),
    ),
  );
}

Widget transportDetailsData(type, text) {
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

Widget transportItem({required BuildContext context,required ExpenseDetails expenseDetails,required Expenses expenses}) {
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
            child: expenseDetails.transportType == "Rickshaw" ? Image(
              image: AssetImage("assets/images/Rectangle 88.png"),
            ) :
            expenseDetails.transportType == "CNG" ?
            Image(
              image: AssetImage("assets/images/rickshaw 1.png"),
            ) :
            expenseDetails.transportType == "Bus" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (1).png"),
            ) :
            expenseDetails.transportType == "Train" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (2).png"),
            ) :
            expenseDetails.transportType == "Car" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (3).png"),
            ) :
            expenseDetails.transportType == "Motorcycle" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (4).png"),
            ) :
            expenseDetails.transportType == "UBER" ?
            Image(
              image: AssetImage("assets/images/Rectangle 88 (5).png"),
            ) :
            expenseDetails.transportType == "Pathao" ?
            Image(
              image: AssetImage("assets/images/Pathao_Logo- 1.png"),
            ) :
            expenseDetails.transportType == "Airplane" ?
            Image(
              image: AssetImage("assets/images/Icon 3.png"),
            ) : expenseDetails.transportType == "Personal Transport" ?
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
                expenseDetails.transportType == "Personal Transport" ? "${expenseDetails.km} KM" :"${expenseDetails.source} - ${expenseDetails.destination}",
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: kThemeColor,
                ),
              ),
              const SizedBox(height: 10),
              expenses.expenseCurrency == null ?  transportItemData(label: "Amount", kData: ": ${expenseDetails.amount}") : transportItemData(label: "Amount", kData: ": ${expenseDetails.amount} ${expenses.expenseCurrency!.code}"),
              transportItemData(label: "Transport", kData: expenseDetails.transportType == "Personal Transport"? ": Personal":": ${expenseDetails.transportType}"),
              //transportItemData(label: "Date", kData: ": 10/08/2022"),
            ],
          ),
          SizedBox(width: 4.w),
          SizedBox(
            height: 2.h,
            width: 4.w,
            child: Image.asset(
              "assets/images/pin.png",
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 3.w),
          Icon(
            Icons.arrow_forward_ios,
            size: 20.sp,
            color: kThemeColor,
          )
        ],
      ),
    ),
  );
}

Widget transportItemData({label, kData}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: 1.5.h,
        width: 14.w,
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
          kData,
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

Widget transportItemDetails({required BuildContext context,required ExpenseDetails expenseDetails,required Expenses expenses}) {
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
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 20),
        child: SizedBox(
          height: 1.5.h,
          width: 3.w,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Image(
              image: AssetImage("./assets/images/cancel.png"),
            ),
          ),
        ),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    content: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 10.h,
                width: 20.w,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  border: Border.all(color: const Color(0xFF4DAFF5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: expenseDetails.transportType == "Rickshaw" ? Image(
                  image: AssetImage("assets/images/Rectangle 88.png"),
                ) :
                expenseDetails.transportType == "CNG" ?
                Image(
                  image: AssetImage("assets/images/rickshaw 1.png"),
                ) :
                expenseDetails.transportType == "Bus" ?
                Image(
                  image: AssetImage("assets/images/Rectangle 88 (1).png"),
                ) :
                expenseDetails.transportType == "Train" ?
                Image(
                  image: AssetImage("assets/images/Rectangle 88 (2).png"),
                ) :
                expenseDetails.transportType == "Car" ?
                Image(
                  image: AssetImage("assets/images/Rectangle 88 (3).png"),
                ) :
                expenseDetails.transportType == "Motorcycle" ?
                Image(
                  image: AssetImage("assets/images/Rectangle 88 (4).png"),
                ) :
                expenseDetails.transportType == "UBER" ?
                Image(
                  image: AssetImage("assets/images/Rectangle 88 (5).png"),
                ) :
                expenseDetails.transportType == "Pathao" ?
                Image(
                  image: AssetImage("assets/images/Pathao_Logo- 1.png"),
                ) :
                expenseDetails.transportType == "Airplane" ?
                Image(
                  image: AssetImage("assets/images/Icon 3.png"),
                ) :
                expenseDetails.transportType == "Personal Transport" ?
                Image(
                  image: AssetImage("assets/images/personal.png"),
                ) : Text("No Image Uploaded"),
              ),
            ),
          ),
          transportItemDetailsData("Travel Type", ": ${expenseDetails.modeOfTransport}"),
          expenseDetails.transportType != "Personal Transport" ? transportItemDetailsData(
              "Destination", ": ${expenseDetails.source} - ${expenseDetails.destination}") :
          transportItemDetailsData(
              "KM", ": ${expenseDetails.km}"),
          expenses.expenseCurrency == null ?  transportItemDetailsData("Amount", ": ${expenseDetails.amount}") : transportItemDetailsData("Amount", ": ${expenseDetails.amount} ${expenses.expenseCurrency!.code}"),
          transportItemDetailsData("Transport", ": ${expenseDetails.transportType}"),
          //transportItemDetailsData("Date", ": 10-08-2022"),
          transportItemDetailsData("Attachments :", ""),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: expenseDetails.file == "" ? null : () async {
                    final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${expenseDetails.file}"));

                    if(response.statusCode == 200){
                      final bytes = response.bodyBytes;
                      final directory = await getTemporaryDirectory();
                      final filePath = '${directory.path}/${expenseDetails.file}';
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
                            expenseDetails.file == "" ? SizedBox.shrink() : SizedBox(
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
                                    expenseDetails.file == "" ? "N/A" :"${expenseDetails.file}",
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
          const SizedBox(height: 24.0)
        ],
      ),
    ),
  );
}

Widget transportItemDetailsData(type, text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
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

Widget foodDetails({required BuildContext context,required Expenses expenses}) {
  return AlertDialog(
    contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
    titlePadding: EdgeInsets.zero,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 4.h,
          width: 20.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            color: expenses.status == "Pending" ? Color(0xFFEBA900) : expenses.status== "Approved" ? kGreenColor : Color.fromRGBO(245, 45, 45, 1) ,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${expenses.status}",
              style: TextStyle(
                fontFamily: 'latoRagular',
                color: kWhiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 1.5.h,
              width: 3.w,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Image(
                  image: AssetImage("./assets/images/cancel.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    content: SingleChildScrollView(
      child: Column(
        children: [
          foodDetailsData("Expense Type", ": ${expenses.type}"),
          foodDetailsData("Person", ": ${expenses.totalPerson}"),
          expenses.expenseCurrency == null ? foodDetailsData("Amount", ": ${expenses.amount}") : foodDetailsData("Amount", ": ${expenses.amount} ${expenses.expenseCurrency!.code}"),
          foodDetailsData("Date", ": ${DateFormat("dd-MMMM-yyyy").format(DateTime.parse(expenses.createdAt!))}"),
          expenses.purposeType == null ? foodDetailsData("Purpose", ": N/A") : foodDetailsData("Purpose", ": ${expenses.purposeType!.name}"),
          foodDetailsData("Apply Date", ": ${DateFormat("dd-MMMM-yyyy").format(DateTime.parse(expenses.updatedAt!))}"),
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
                  width: 45.w,
                  child: Text(
                    """: ${expenses.description}""",
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
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Attachments",
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontWeight: FontWeight.w600,
                  color: kThemeColor,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: expenses.file == "" ? null :() async {
                    final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${expenses.file}"));

                    if(response.statusCode == 200){
                      final bytes = response.bodyBytes;
                      final directory = await getTemporaryDirectory();
                      final filePath = '${directory.path}/${expenses.file}';
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
                        width:
                        MediaQuery.of(context).size.width /
                            1.8,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            expenses.file == "" ? SizedBox.shrink() : SizedBox(
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
                                    expenses.file == "" ? "N/A" :"${expenses.file}",
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
          const SizedBox(height: 24.0)
        ],
      ),
    ),
  );
}

Widget dottedBorder({required Widget child}) => DottedBorder(
  strokeWidth: 1,
  dashPattern: const [10, 5],
  color: const Color(0xFF6A8495),
  borderType: BorderType.RRect,
  radius: const Radius.circular(5),
  child: child,
);

Widget foodDetailsData(type, text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
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

Widget miscellaneousDetails({required BuildContext context,required Expenses expenses}) {
  return AlertDialog(
    contentPadding: const EdgeInsets.only(left: 5, right: 5, top: 20),
    titlePadding: EdgeInsets.zero,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 5.h,
          width: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            color: expenses.status == "Pending" ? Color(0xFFEBA900) : expenses.status== "Approved" ? kGreenColor : Color.fromRGBO(245, 45, 45, 1) ,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${expenses.status}",
              style: TextStyle(
                fontFamily: 'latoRagular',
                color: kWhiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 1.5.h,
              width: 3.w,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Image(
                  image: AssetImage("./assets/images/cancel.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    content: SingleChildScrollView(
      // height: 35.h,
      // width: 80.w,
      child: Column(
        children: [
          foodDetailsData("Expense Type", ": ${expenses.type}"),
          expenses.expenseCurrency == null ? foodDetailsData("Amount", ": ${expenses.amount}") : foodDetailsData("Amount", ": ${expenses.amount} ${expenses.expenseCurrency!.code}"),
          foodDetailsData("Date", ": ${DateFormat("dd-MMMM-yyyy").format(DateTime.parse(expenses.createdAt!))}"),
          foodDetailsData("Apply Date", ": ${DateFormat("dd-MMMM-yyyy").format(DateTime.parse(expenses.updatedAt!))}"),
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
                  width: 45.w,
                  child: Text(
                    """: ${expenses.description}""",
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
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Attachments",
                style: TextStyle(
                  fontFamily: 'latoRagular',
                  fontWeight: FontWeight.w600,
                  color: kThemeColor,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: expenses.file == "" ? null : () async {
                    final response = await http.get(Uri.parse("${BASE_URL_IMAGE}/assets/${expenses.file}"));

                    if(response.statusCode == 200){
                      final bytes = response.bodyBytes;
                      final directory = await getTemporaryDirectory();
                      final filePath = '${directory.path}/${expenses.file}';
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
                        width:
                        MediaQuery.of(context).size.width /
                            1.8,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            expenses.file == "" ? SizedBox.shrink() : SizedBox(
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
                                    expenses.file == ""? "N/A" : "${expenses.file}",
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
          const SizedBox(height: 24.0)
        ],
      ),
    ),
  );
}

Widget miscellaneousDetailsData(type, text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: [
        SizedBox(
          height: 3.h,
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
          height: 3.h,
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


