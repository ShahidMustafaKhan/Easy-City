import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/screens/store/widget/store_rating_location.dart';
import 'package:sixam_mart/view/screens/store/widget/store_title_widget.dart';

import '../../../../util/colors.dart';

class StoreDescriptionView extends StatelessWidget {
  final Store store;
  StoreDescriptionView({@required this.store});

  @override
  Widget build(BuildContext context) {
    bool _isAvailable = Get.find<StoreController>()
        .isStoreOpenNow(store?.active ?? false, store?.schedules ?? []);
    Color _textColor =
        ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    return Container(
      color: Colors.white,
      child: Column(children: [
        StoreTitleWidget(
            store: store, isAvailable: _isAvailable, textColor: _textColor),
        SizedBox(
            height: ResponsiveHelper.isDesktop(context)
                ? 30
                : Dimensions.PADDING_SIZE_SMALL),
        Container(
          color: ColorResources.white4,
          height: 7,
        ),
        StoreRatingLocation(store: store, textColor: _textColor),
        Container(
          color: ColorResources.white4,
          height: 7,
        ),
      ]),
    );
  }
}
