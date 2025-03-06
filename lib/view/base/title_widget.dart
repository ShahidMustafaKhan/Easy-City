import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600)),
      (onTap != null && !ResponsiveHelper.isDesktop(context))
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  'See All'.tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.blue1),
                ),
              ),
            )
          : SizedBox(),
    ]);
  }
}
