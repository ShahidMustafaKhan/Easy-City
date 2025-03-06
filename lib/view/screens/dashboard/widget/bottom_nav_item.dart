import 'package:flutter/material.dart';
import 'package:sixam_mart/util/colors.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class BottomNavItem extends StatelessWidget {
  final String image;
  final Function onTap;
  final bool isSelected;
  final double height;
  final double width;
  final String title;

  BottomNavItem(
      {@required this.image,
      this.onTap,
      this.isSelected = false,
      this.height = 25,
      this.width = 25,
      this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: height,
              width: width,
              child: Image.asset(
                image,
                fit: BoxFit.fill,
                color: isSelected ? ColorResources.blue1 : Colors.black,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(
            title,
            style: robotoMedium.copyWith(
              color: isSelected ? ColorResources.blue1 : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
