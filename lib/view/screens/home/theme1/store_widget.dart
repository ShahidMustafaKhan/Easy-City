import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';

import '../../../../util/colors.dart';

class StoreWidget extends StatelessWidget {
  final Store store;
  final int index;
  final bool inStore;
  StoreWidget(
      {@required this.store, @required this.index, this.inStore = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    return InkWell(
      onTap: () {
        if (store != null) {
          Get.toNamed(
            RouteHelper.getStoreRoute(store.id, 'item'),
            arguments: StoreScreen(store: store, fromModule: false),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: ColorResources.blue1.withOpacity(0.05),
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorResources.white6,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImage(
                    image:
                        '${_baseUrls.storeCoverPhotoUrl}/${store.coverPhoto}',
                    height: context.width * 0.3,
                    width: Dimensions.WEB_MAX_WIDTH,
                    fit: BoxFit.cover,
                  )),
              DiscountTag(
                discount: Get.find<StoreController>().getDiscount(store),
                discountType:
                    Get.find<StoreController>().getDiscountType(store),
                freeDelivery: store.freeDelivery,
              ),
              Get.find<StoreController>().isOpenNow(store)
                  ? SizedBox()
                  : NotAvailableWidget(isStore: true),
            ]),
          ),
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        store.name,
                        style: robotoMedium.copyWith(fontSize: 15),
                        maxLines: _desktop ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      (store.address != null)
                          ? Text(
                              store.address ?? '',
                              style: robotoRegular.copyWith(
                                fontSize: 15,
                                color: ColorResources.blue1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(),
                      SizedBox(height: store.address != null ? 2 : 0),
                      RatingBar(
                        rating: store.avgRating,
                        size: _desktop ? 15 : 12,
                        ratingCount: store.ratingCount,
                      ),
                    ]),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              GetBuilder<WishListController>(builder: (wishController) {
                bool _isWished =
                    wishController.wishStoreIdList.contains(store.id);
                return InkWell(
                  onTap: () {
                    if (Get.find<AuthController>().isLoggedIn()) {
                      _isWished
                          ? wishController.removeFromWishList(store.id, true)
                          : wishController.addToWishList(null, store, true);
                    } else {
                      showCustomSnackBar('you_are_not_logged_in'.tr);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                    child: Icon(
                      _isWished ? Icons.favorite : Icons.favorite_border,
                      size: _desktop ? 30 : 25,
                      color: _isWished
                          ? Colors.red
                          : Theme.of(context).disabledColor,
                    ),
                  ),
                );
              }),
            ]),
          )),
        ]),
      ),
    );
  }
}

class StoreShimmer extends StatelessWidget {
  final bool isEnable;
  StoreShimmer({@required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 800 : 300],
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: isEnable,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: context.width * 0.3,
            width: Dimensions.WEB_MAX_WIDTH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.RADIUS_SMALL)),
              color: Colors.grey[300],
            ),
          ),
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 15, width: 150, color: Colors.grey[300]),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Container(height: 10, width: 50, color: Colors.grey[300]),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    ]),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Icon(Icons.favorite_border,
                  size: 25, color: Theme.of(context).disabledColor),
            ]),
          )),
        ]),
      ),
    );
  }
}
