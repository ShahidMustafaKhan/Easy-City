import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';

import '../../util/colors.dart';

class StoreItemWidget extends StatelessWidget {
  final Item item;
  final Store store;
  final bool isStore;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  StoreItemWidget(
      {@required this.item,
      @required this.isStore,
      @required this.store,
      @required this.index,
      @required this.length,
      this.inStore = false,
      this.isCampaign = false,
      this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    if (isStore) {
      _discount = store.discount != null ? store.discount.discount : 0;
      _discountType =
          store.discount != null ? store.discount.discountType : 'percent';
      // bool _isClosedToday = Get.find<StoreController>().isRestaurantClosed(true, store.active, store.offDay);
      // _isAvailable = DateConverter.isAvailable(store.openingTime, store.closeingTime) && store.active && !_isClosedToday;
      _isAvailable = store.open == 1 && store.active;
    } else {
      _discount = (item.storeDiscount == 0 || isCampaign)
          ? item.discount
          : item.storeDiscount;
      _discountType = (item.storeDiscount == 0 || isCampaign)
          ? item.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
          item.availableTimeStarts, item.availableTimeEnds);
    }

    return InkWell(
      onTap: () {
        if (isStore) {
          if (store != null) {
            if (isFeatured && Get.find<SplashController>().moduleList != null) {
              for (ModuleModel module
                  in Get.find<SplashController>().moduleList) {
                if (module.id == store.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.toNamed(
              RouteHelper.getStoreRoute(
                  store.id, isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: store, fromModule: isFeatured),
            );
          }
        } else {
          Get.find<ItemController>().navigateToItemPage(item, context,
              inStore: inStore, isCampaign: isCampaign);
        }
      },
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // Soft shadow
                    offset: Offset(0, 0), // Shadow position
                    blurRadius: 2, // Softness of shadow
                    spreadRadius: 0, // No extra spread
                  ),
                ],
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 70,
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: CustomImage(
                          image:
                              '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeImageUrl : _baseUrls.itemImageUrl}'
                              '/${isStore ? store.logo : item.image}',
                          height: 120,
                          width: 200,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    DiscountTag(
                      discount: _discount,
                      discountType: _discountType,
                      freeDelivery: isStore ? store.freeDelivery : false,
                    ),
                    _isAvailable
                        ? SizedBox()
                        : NotAvailableWidget(isStore: isStore),
                  ]),
                ),
                SizedBox(
                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                Container(
                  color: ColorResources.white,
                  width: 170,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.storeName,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeXExtraSmall,
                                color: Theme.of(context).disabledColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          RatingBar(
                            rating: isStore ? store.avgRating : item.avgRating,
                            size: _desktop ? 15 : 10,
                            ratingCount:
                                isStore ? store.ratingCount : item.ratingCount,
                          ),
                          Row(children: [
                            Expanded(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      PriceConverter.convertPrice(item.price,
                                          discount: _discount,
                                          discountType: _discountType),
                                      style: robotoMedium.copyWith(
                                          color: ColorResources.black,
                                          fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                            ),
                          ]),
                        ]),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.favorite_border_outlined,
                color: Theme.of(context).disabledColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
