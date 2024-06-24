import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/providers/expenses_provider.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_list.dart';
import 'package:team360/src/views/ui/expense_screen.dart';
import 'package:team360/src/views/ui/expense_type/food_expense.dart';
import 'package:team360/src/views/ui/expense_type/miscellaneous_expense.dart';
import 'package:team360/src/views/ui/expense_type/transport_expense.dart';
import 'package:team360/src/views/utils/colors.dart';

import '../../business_logics/models/expence_mdel/expence_perpose_model.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key,required this.selectedExpenseType,required this.purposeTypes}) : super(key: key);
  final String selectedExpenseType;
  final List<PurposeTypes>? purposeTypes;
  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String selectedExpenseType = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedExpenseType = widget.selectedExpenseType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      drawer: const DrawerScreen(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF4F2),
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 5.h,
                    width: 45.w,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              ExpensesProvider expensesProvider = Provider.of<ExpensesProvider>(context, listen: false);
                              TransportExpenseState.description.clear();
                              TransportExpenseState.date.clear();
                              expensesProvider.publicTransport.clear();
                              expensesProvider.personalTransport.clear();
                              expensesProvider.transports.clear();
                              expensesProvider.allTransportsList.clear();
                              expensesProvider.fileName = "";
                              expensesProvider.documentFile = null;
                              expensesProvider.transport_type = "";
                              expensesProvider.totalAmount = 0;
                              expensesProvider.amount = "";
                              expensesProvider.KM = "";
                              expensesProvider.toll_amount = "";
                              expensesProvider.pKmExpense = "";
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpenseScreen()));
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
                            "Add Expense",
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 24),
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
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select Expense Type",
                            style: TextStyle(
                              fontFamily: 'latoRagular',
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: kThemeColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 6.h,
                        width: 90.w,
                        child: DropdownButtonFormField<String>(
                          value: selectedExpenseType,
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
                      selectedExpenseType == "Transport Expense"
                          ? TransportExpense(type: selectedExpenseType,purposeTypes: widget.purposeTypes,)
                          : selectedExpenseType == "Miscellaneous Expense"
                          ? MiscellaneousExpense(type: selectedExpenseType,)
                          : FoodExpense(type: selectedExpenseType,purposeTypes: widget.purposeTypes,),
                      const SizedBox(height: 24.0)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





