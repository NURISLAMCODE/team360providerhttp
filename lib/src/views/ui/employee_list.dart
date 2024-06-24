import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/views/ui/drawer.dart';
import 'package:team360/src/views/ui/employee_details.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/widgets/custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../business_logics/models/contact_list_model/Contact_list_model.dart';
import '../../business_logics/models/notice_model/department_list_class.dart';
import '../../business_logics/providers/contact_list_provider.dart';
import 'bottomnav/bottomnav_screen_layout.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  String? type = "All";
  List<Divisions>? divisions = [];
  int department_id = 0;
  int office_division_id = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      ContactListProvider contactListProvider = Provider.of<ContactListProvider>(context, listen: false);
      contactListProvider.getAllDepartmentList().then((value){
        setState(() {
          divisions!.add(Divisions(id: 0,companyId: "0",name: "All",email: "",logo: "",status: true,createdAt: "",updatedAt: "",deletedAt: ""));
          value!.data!.divisions!.forEach((element) {
            divisions!.add(element);
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=> EmployeeList()));
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
          body: Consumer<ContactListProvider>(
            builder: (context,contactListProvider,child){
              return FutureBuilder<EmployeeListClass?>(
                  future: contactListProvider.getAllEmployeeList(department_id: department_id, office_division_id: office_division_id),
                  builder: (context, snapsort){
                    if(snapsort.hasData){
                      return CustomScrollView(
                        slivers: [

                          //App bar
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            pinned: true,
                            floating: false,
                            backgroundColor: const Color(0xFFEAF4F2),
                            expandedHeight: 5.h,
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
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
                                            height: 5.h,
                                            width: 10.w,
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
                                            "Contact List",
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
                          ),

                          SliverFillRemaining(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverToBoxAdapter(
                                        child: SizedBox(height: 3.h,),
                                      ),
                                      SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: 5.h,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: divisions!.length,
                                            itemBuilder: (context,int index){
                                              return TextButton(
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                                      const EdgeInsets.all(1)),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    office_division_id = divisions![index].id!;
                                                  });
                                                },
                                                child: Container(
                                                  height: 5.8.h,
                                                  width:  divisions![index].name!.length <= 4 ? (divisions![index].name!.length) * 4.w :  (divisions![index].name!.length) * 2.5.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    color: office_division_id == divisions![index].id
                                                        ? const Color(0xFF19888E)
                                                        : kWhiteColor,
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      divisions![index].name!,
                                                      style: TextStyle(
                                                        fontFamily: 'latoRagular',
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: office_division_id == divisions![index].id
                                                            ? kWhiteColor
                                                            : kBlackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                        child: SizedBox(height: 3.h,),
                                      ),
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (context,int index){
                                                return  Padding(
                                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EmployeeDetails(contacts: snapsort.data!.data!.contacts![index],)),
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 12.h,
                                                          width: 90.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: kWhiteColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset: const Offset(0, 1),
                                                                blurRadius: 3,
                                                                color: Colors.black.withOpacity(0.3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                height: 12.h,
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
                                                                      child: snapsort.data?.data?.contacts?[index].image == null ||
                                                                          snapsort.data?.data?.contacts?[index].image == "null" ||
                                                                          snapsort.data?.data?.contacts?[index].image == ""? const CircleAvatar(
                                                                        backgroundImage: AssetImage(
                                                                            "assets/images/user_avatar.png"),
                                                                      ) : CircleAvatar(
                                                                        backgroundImage: NetworkImage("${BASE_URL_IMAGE}/assets/${snapsort.data!.data!.contacts![index].image}"),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height: 4.h,
                                                                            width: 43.w,
                                                                            child: Text(
                                                                              snapsort.data?.data?.contacts?[index].users?.name == null ||
                                                                                  snapsort.data?.data?.contacts?[index].users?.name == "null" ||
                                                                                  snapsort.data?.data?.contacts?[index].users?.name == "" ?
                                                                              "N/A" : snapsort.data!.data!.contacts![index].users!.name!,
                                                                              style: TextStyle(
                                                                                  fontFamily: 'latoRagular',
                                                                                  fontSize: 18.sp,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: kBlackColor),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height: 2.h,
                                                                            width: 43.w,
                                                                            child: Text(
                                                                              snapsort.data?.data?.contacts?[index].officeDivisions == null ||
                                                                                  snapsort.data?.data?.contacts?[index].officeDivisions?.name == "null" ||
                                                                                  snapsort.data?.data?.contacts?[index].officeDivisions?.name == "" ?
                                                                              "N/A" :
                                                                              snapsort.data!.data!.contacts![index].officeDivisions!.name!,
                                                                              style: TextStyle(
                                                                                fontFamily: 'latoRagular',
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(
                                                                                  0xFFAEAEAE,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height: 4.h,
                                                                            width: 43.w,
                                                                            child: Text(
                                                                              snapsort.data?.data?.contacts?[index].users?.email == null ||
                                                                                  snapsort.data?.data?.contacts?[index].users?.email == "null" ||
                                                                                  snapsort.data?.data?.contacts?[index].users?.email == "" ?
                                                                              "Email : N/A" : "Email : ${snapsort.data!.data!.contacts![index].users!.email}",
                                                                              style: TextStyle(
                                                                                fontFamily: 'latoRagular',
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(
                                                                                  0xFFAEAEAE,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
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
                                                                    onPressed: snapsort.data?.data?.contacts?[index].users?.phone == null ||
                                                                        snapsort.data?.data?.contacts?[index].users?.phone == "null" ||
                                                                        snapsort.data?.data?.contacts?[index].users?.phone == "" ? (){
                                                                      customWidget.showCustomSnackbar(context, "User phone number is not set");
                                                                    } : () {
                                                                      launchUrl(
                                                                        Uri(scheme: 'tel', path: "${snapsort.data!.data!.contacts![index].users!.phone}"),
                                                                      );
                                                                    },
                                                                    icon: Icon(
                                                                      Icons.phone,
                                                                      color: const Color(0xFF263238),
                                                                      size: 3.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 60.w,
                                                          child: Container(
                                                            height: 3.h,
                                                            width: 30.w,
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
                                                                snapsort.data?.data?.contacts?[index].jobTypes == null ||
                                                                    snapsort.data?.data?.contacts?[index].jobTypes?.name == "null" ||
                                                                    snapsort.data?.data?.contacts?[index].jobTypes?.name == "" ?
                                                                "N/A" : snapsort.data!.data!.contacts![index].jobTypes!.name!,
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
                                                  ),
                                                );
                                              },
                                            childCount: snapsort.data!.data!.contacts!.length
                                          ),
                                      ),
                                      SliverToBoxAdapter(
                                        child: SizedBox(height: 3.h,),
                                      ),
                                    ],
                                  ),
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
                        child: Center(child: CircularProgressIndicator(),),
                      );
                    }
                  }
              );
            },
          )
        ),
      ),
    );
  }
}
