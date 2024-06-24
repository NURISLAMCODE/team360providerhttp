import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/ui/bottomnav/bottomnav_utils.dart';
import 'package:team360/src/views/utils/colors.dart';

class BottomNavScreenLayout extends StatefulWidget {
  const BottomNavScreenLayout({Key? key,this.page}) : super(key: key);
  final int? page;
  @override
  State<BottomNavScreenLayout> createState() => _BottomNavScreenLayoutState();
}

class _BottomNavScreenLayoutState extends State<BottomNavScreenLayout> {
  int _page = 0;

  @override
  void initState() {
    super.initState();
    if(widget.page == null){
      _page = 0;
    }else{
      _page = widget.page!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigationTap(int page) {
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: homeScreenItems[_page],
        bottomNavigationBar: SizedBox(
          height: 7.h,
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFFECECEC),
            currentIndex: _page,
            items: [
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20.sp,
                  child: const ImageIcon(
                    AssetImage("assets/images/home_bottomnav.png"),
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20.sp,
                  child: const ImageIcon(
                    AssetImage("assets/images/attendence.png"),
                  ),
                ),
                label: 'Attendance',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20.sp,
                  child: const ImageIcon(
                    AssetImage("assets/images/approval.png"),
                  ),
                ),
                label: 'Approval',
              ),
            ],
            onTap: navigationTap,
            selectedLabelStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),
            selectedItemColor:  const Color(0xFF19888E),
            unselectedLabelStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),
            unselectedItemColor: kBlackColor,
          ),
        ),
    );
  }
}
