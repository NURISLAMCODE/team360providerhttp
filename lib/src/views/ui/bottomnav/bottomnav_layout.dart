import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/views/ui/bottomnav/bottom_utils.dart';
import 'package:team360/src/views/utils/colors.dart';

class BottomNavScreenLayout2 extends StatefulWidget {
  const BottomNavScreenLayout2({Key? key}) : super(key: key);

  @override
  State<BottomNavScreenLayout2> createState() => _BottomNavScreenLayout2State();
}

class _BottomNavScreenLayout2State extends State<BottomNavScreenLayout2> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems2,
      ),
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
