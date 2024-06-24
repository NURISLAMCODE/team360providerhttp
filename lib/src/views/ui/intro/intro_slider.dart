import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:team360/src/business_logics/providers/splash_screen_provider.dart';
import 'package:team360/src/views/ui/intro/slider_content.dart';
import 'package:team360/src/views/ui/login/login.dart';

import '../../../business_logics/models/splash_screen_content_model.dart';

class IntroSliderScreen extends StatefulWidget {

  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroSliderScreenState createState() => IntroSliderScreenState();
}

class IntroSliderScreenState extends State<IntroSliderScreen> {

  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<SplashScreenProvider>(
        builder: (context,splashScreenProvider,child){
          return FutureBuilder<SplashScreenContentModel?>(
              future: splashScreenProvider.getSplashScreenData(),
              builder: (context,snapsort){
                if(snapsort.hasData){
                  return Stack(
                    children: [
                      PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _controller,
                        itemCount: snapsort.data!.data!.contents!.length,
                        onPageChanged: (int index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (_, i) {
                          return SliderContent(
                            id: i,
                            image:  snapsort.data!.data!.contents![i].image!,
                            description: snapsort.data!.data!.contents![i].description!,
                            title: snapsort.data!.data!.contents![i].title!,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 50,
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SmoothPageIndicator(
                                controller: _controller,
                                onDotClicked: (index) => _controller.jumpToPage(index),
                                count: snapsort.data!.data!.contents!.length,
                                effect: const ExpandingDotsEffect(),
                              ),
                              InkWell(
                                onTap: () {
                                  if(currentIndex >= snapsort.data!.data!.contents!.length-1) {
                                    print(snapsort.data!.data!.contents!.length-1);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                                            (Route<dynamic> route) => false
                                    );
                                  } else {
                                    _controller.nextPage(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeIn
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF1F3C88), width: 4)
                                  ),
                                  child: const Icon(Icons.arrow_forward_ios_rounded,color: Color(0xFF1F3C88),),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }else{
                  return Container(
                    height: MediaQuery.of(context).size.height/1,
                    width: MediaQuery.of(context).size.width/1,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }
          );
        },
      )
    );
  }
}
