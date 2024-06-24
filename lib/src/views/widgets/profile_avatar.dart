import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team360/src/business_logics/models/user_data_model.dart';

import '../utils/colors.dart';

enum ImageType { network, asset, file }

class ProfileAvatarWidget extends StatelessWidget {

  final String? url;
  final double? radius;
  final ImageType? imageType;

  const ProfileAvatarWidget({this.url, this.radius, this.imageType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getProfileImageWidget(imageType);
  }

  Widget getProfileImageWidget(ImageType? imageType) {
    if (imageType == ImageType.asset && (url ?? "").isEmpty) {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(url!), fit: BoxFit.cover),
        ),
      );
    } else if (imageType == ImageType.file && (url ?? "").isEmpty) {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: Image.file(File(url!)).image, fit: BoxFit.cover),
        ),
      );
    }
    else if (imageType == ImageType.network && (url ?? "").isEmpty) {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: Image.network(url!).image,
              fit: BoxFit.cover
          ),
        ),
      );
    } else {
      return Container(
        height: radius,
        width: radius,
        decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: Text(
          (UserData.name ?? "U").characters.first,
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
