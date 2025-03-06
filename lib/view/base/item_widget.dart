import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
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
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';

import '../../util/colors.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final Store store;
  final bool isStore;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  ItemWidget(
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

    print(
        '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeImageUrl : _baseUrls.itemImageUrl}'
        '/${isStore ? store.coverPhoto : item.image}');

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
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_SMALL,
            vertical: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: CustomImage(
                      image:
                          '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeCoverPhotoUrl : _baseUrls.itemImageUrl}'
                          '/${isStore ? store.coverPhoto : item.image}',
                      height: context.width * 0.2,
                      width: Dimensions.WEB_MAX_WIDTH,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: wishList(_desktop, context)),
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
              // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 80),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: context.width * 0.24,
                                  child: Text(
                                    isStore ? store.name : item.name,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                    maxLines: _desktop ? 2 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 4),
                                (isStore
                                        ? store.address != null
                                        : item.storeName != null)
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Color(0xff6d7efe),
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          SizedBox(
                                            width: 30,
                                            child: Text(
                                              isStore
                                                  ? store.address ?? ''
                                                  : item.storeName ?? '',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: ((_desktop || isStore) &&
                                      (isStore
                                          ? store.address != null
                                          : item.storeName != null))
                                  ? 2
                                  : 0),
                          SizedBox(
                              height: (!isStore && _desktop)
                                  ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                  : 0),
                          isStore
                              ? SizedBox()
                              : Row(children: [
                                  Text(
                                    PriceConverter.convertPrice(item.price,
                                        discount: _discount,
                                        discountType: _discountType),
                                    style: robotoMedium.copyWith(
                                        color: ColorResources.blue1,
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  SizedBox(
                                      width: _discount > 0
                                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                          : 0),
                                  _discount > 0
                                      ? Text(
                                          PriceConverter.convertPrice(
                                              item.price),
                                          style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color:
                                                Theme.of(context).disabledColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        )
                                      : SizedBox(),
                                ]),
                        ]),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Column(
                        mainAxisAlignment: isStore
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          !isStore
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: _desktop
                                          ? Dimensions.PADDING_SIZE_SMALL
                                          : 0),
                                  child:
                                      Icon(Icons.add, size: _desktop ? 30 : 25),
                                )
                              : SizedBox(),
                        ]),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  children: [
                    locationWidget(),
                    Expanded(child: SizedBox()),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xff6d7efe),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Visit',
                        style: robotoMedium.copyWith(
                          fontSize: 10.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
            Positioned(
              top: 60,
              left: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      height: 65,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimensions.RADIUS_SMALL)),
                          image: DecorationImage(
                            image: NetworkImage(
                                '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeImageUrl : _baseUrls.itemImageUrl}'
                                '/${isStore ? store.logo : item.image}'),
                            fit: BoxFit.contain,
                          ),
                          border: Border.all(
                              color: ColorResources.white, width: 2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "0.0",
                          style: robotoMedium.copyWith(
                              color: ColorResources.black, fontSize: 9.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.star,
                          size: 13,
                          color: Color(0xff6d7efe),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row locationWidget() {
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Color(0xffe2e7fb).withOpacity(0.8),
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
              child: Row(
                children: [
                  Icon(
                    Icons.my_location_sharp,
                    color: ColorResources.green1,
                    size: 10,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '100+ Km',
                    style: robotoMedium.copyWith(
                      fontSize: 8,
                      color: Color(0xff6d7efe),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'From You',
                    style: robotoRegular.copyWith(
                      fontSize: 8,
                      color: Color(0xff6d7efe).withOpacity(0.6),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  GetBuilder<WishListController> wishList(bool _desktop, BuildContext context) {
    return GetBuilder<WishListController>(builder: (wishController) {
      bool _isWished = isStore
          ? wishController.wishStoreIdList.contains(store.id)
          : wishController.wishItemIdList.contains(item.id);
      return InkWell(
        onTap: () {
          if (Get.find<AuthController>().isLoggedIn()) {
            _isWished
                ? wishController.removeFromWishList(
                    isStore ? store.id : item.id, isStore)
                : wishController.addToWishList(item, store, isStore);
          } else {
            showCustomSnackBar('you_are_not_logged_in'.tr);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _desktop ? 10 : 20, vertical: 15),
          child: Icon(
            _isWished ? Icons.favorite : Icons.favorite_border,
            size: _desktop ? 30 : 21,
            color: _isWished ? Colors.red : Color(0xff6d7efe),
          ),
        ),
      );
    });
  }
}
