import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../controller/wishlist_controller.dart';
import '../../../../data/model/response/store_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/colors.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_image.dart';
import '../../../base/custom_snackbar.dart';

class StoreTitleWidget extends StatelessWidget {
  const StoreTitleWidget({
    Key key,
    @required this.store,
    @required bool isAvailable,
    @required Color textColor,
  })  : _isAvailable = isAvailable,
        _textColor = textColor,
        super(key: key);

  final Store store;
  final bool _isAvailable;
  final Color _textColor;

  @override
  Widget build(BuildContext context) {
    return store == null
        ? StoreTitleShimmer()
        : Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10, top: 14, bottom: 7),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                child: Stack(children: [
                  CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${store.logo}',
                    height: ResponsiveHelper.isDesktop(context) ? 80 : 60,
                    width: ResponsiveHelper.isDesktop(context) ? 100 : 70,
                    fit: BoxFit.cover,
                  ),
                  _isAvailable
                      ? SizedBox()
                      : Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  bottom:
                                      Radius.circular(Dimensions.RADIUS_SMALL)),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Text(
                              'closed_now'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ),
                ]),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        store.name,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: _textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      ResponsiveHelper.isDesktop(context)
                          ? InkWell(
                              onTap: () => Get.toNamed(
                                  RouteHelper.getSearchStoreItemRoute(
                                      store.id)),
                              child: ResponsiveHelper.isDesktop(context)
                                  ? Container(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_DEFAULT),
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: Center(
                                          child: Icon(Icons.search,
                                              color: Colors.white)),
                                    )
                                  : Icon(Icons.search,
                                      color: Theme.of(context).primaryColor),
                            )
                          : SizedBox(),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      store.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor),
                    ),
                    SizedBox(
                        height: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                            : 0),
                    Row(children: [
                      Text('minimum_order'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor,
                          )),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        PriceConverter.convertPrice(store.minimumOrder),
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: ColorResources.blue1),
                      ),
                    ]),
                  ])),
              Row(
                children: [
                  wishlist(context),
                  SizedBox(
                    width: 12,
                  ),
                  shareButton()
                ],
              )
            ]),
          );
  }

  GetBuilder<WishListController> wishlist(BuildContext context) {
    return GetBuilder<WishListController>(builder: (wishController) {
      bool _isWished = wishController.wishStoreIdList.contains(store.id);
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
        child: ResponsiveHelper.isDesktop(context)
            ? Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                    color: Theme.of(context).primaryColor),
                child: Center(
                    child: Icon(
                        _isWished ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white)),
              )
            : Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                    color: ColorResources.white4),
                child: Center(
                    child: Icon(
                        _isWished ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                        color: _isWished
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor)),
              ),
      );
    });
  }

  Widget shareButton() {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
          color: ColorResources.white4),
      child: Center(child: Icon(Icons.share, size: 24, color: Colors.black)),
    );
  }
}

class StoreTitleShimmer extends StatelessWidget {
  const StoreTitleShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 10, top: 14, bottom: 7),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 60,
                width: 70,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 200,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 15,
                    width: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 15,
                    width: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
