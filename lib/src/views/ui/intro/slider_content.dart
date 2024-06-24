import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:team360/src/business_logics/utils/constants.dart';
import 'package:team360/src/views/utils/colors.dart';
import 'package:team360/src/views/utils/custom_text_style.dart';

class SliderContent extends StatelessWidget {

  final int id;
  final String title;
  final String description;
  final String image;
  // List<OnboardingContent> contents = [
  //   OnboardingContent(
  //       color: const Color(0xFFEAF4F2),
  //       image: "assets/images/slider_1.png",
  //       title: """Manage all of your expenses and costs""",
  //       description:
  //       """Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley."""),
  //   OnboardingContent(
  //       color: const Color(0xFFEAF4F2),
  //       image: "assets/images/slider_2.png",
  //       title: """Maintain healthy work-life balance""",
  //       description:
  //       """Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley."""),
  //   OnboardingContent(
  //       color: const Color(0xFFEAF4F2),
  //       image: "assets/images/slider_3.png",
  //       title: """Track your work and get result """,
  //       description:
  //       """Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley."""),
  // ];

  SliderContent({required this.id,required this.title,required this.image,required this.description,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 55.h,
            decoration: BoxDecoration(
                color: const Color(0xFFEAF4F2),
                image: DecorationImage(
                    image: Image.network("${BASE_URL_IMAGE}/assets/${image}").image
                )
            )
        ),
        Positioned(
          top: 50.h,
          child: Container(
            height: 50.h,
            width: 100.w,
            decoration: const BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 66.w,
                  padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      title,
                      style: kLargeTitleTextStyle,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: HtmlWidget('''${description}''',textStyle: TextStyle(fontFamily: 'latoRagular', fontWeight: FontWeight.w400, color: Color(0xFF808080),),)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContent {
  dynamic image;
  dynamic title;
  dynamic description;
  dynamic color;

  OnboardingContent({this.image, this.title, this.description, this.color});
}