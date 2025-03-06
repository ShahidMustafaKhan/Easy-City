import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/title_widget.dart';

import '../../../../helper/price_converter.dart';
import '../../../../util/colors.dart';

class PopularItemView extends StatelessWidget {
  final bool isPopular;
  PopularItemView({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item> _itemList = isPopular
          ? itemController.popularItemList
          : itemController.reviewedItemList;

      return Container(
        color: isPopular ? Color(0xffe2e7fb) : null,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 12),
              child: TitleWidget(
                title: isPopular
                    ? 'popular_items_nearby'.tr
                    : 'best_reviewed_item'.tr,
                onTap: () =>
                    Get.toNamed(RouteHelper.getPopularItemRoute(isPopular)),
              ),
            ),
            (_itemList == null || _itemList.length == 0)
                ? PopularItemShimmer(
                    enabled: true,
                  )
                : Container(
                    height: 232,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _itemList?.length ?? [],
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0
                                  ? Dimensions.PADDING_SIZE_SMALL
                                  : 0,
                              right: index == _itemList.length - 1
                                  ? Dimensions.PADDING_SIZE_SMALL
                                  : 0),
                          child: InkWell(
                            onTap: () => Get.find<ItemController>()
                                .navigateToItemPage(_itemList[index], context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Dimensions.RADIUS_LARGE),
                                    topRight: Radius.circular(
                                        Dimensions.RADIUS_LARGE),
                                  ),
                                  child: Container(
                                    color: Theme.of(context).disabledColor,
                                    child: Image.network(
                                      '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}'
                                      '/${_itemList[index].image}',
                                      height: 125,
                                      width: 175,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        Dimensions.RADIUS_LARGE),
                                    bottomRight: Radius.circular(
                                        Dimensions.RADIUS_LARGE),
                                  ),
                                  child: Container(
                                    width: 175,
                                    color: ColorResources.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(_itemList[index].storeName,
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor)),
                                        Text(
                                          '${_itemList[index].name}',
                                          style: robotoBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                size: 13,
                                                color: Color(0xff6d7efe)),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            Text(
                                              '${_itemList[index].avgRating}',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                              ),
                                              maxLines: 1,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '(${_itemList[index].ratingCount})',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          PriceConverter.convertPrice(
                                              itemController.getStartingPrice(
                                                  _itemList[index])),
                                          style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeXExtraSmall,
                                            color:
                                                Theme.of(context).disabledColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          PriceConverter.convertPrice(
                                            itemController.getStartingPrice(
                                                _itemList[index]),
                                            discount: _itemList[index].discount,
                                            discountType:
                                                _itemList[index].discountType,
                                          ),
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 15);
                      },
                    ),
                  ),
            SizedBox(height: 11),
          ],
        ),
      );
    });
  }
}

class PopularItemShimmer extends StatelessWidget {
  final bool enabled;
  PopularItemShimmer({@required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return Shimmer(
            enabled: true,
            duration: Duration(seconds: 2),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.RADIUS_LARGE),
                  )),
              child: Padding(
                padding: EdgeInsets.only(
                    right: index == 5 ? Dimensions.PADDING_SIZE_SMALL : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.RADIUS_LARGE),
                        topRight: Radius.circular(Dimensions.RADIUS_LARGE),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.all(Radius.circular(9))),
                        height: 135,
                        width: 180,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Dimensions.RADIUS_LARGE),
                        bottomRight: Radius.circular(Dimensions.RADIUS_LARGE),
                      ),
                      child: Container(
                        width: 180,
                        height: 95,
                        color: ColorResources.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 9),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              height: 17,
                              width: 90,
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              height: 17,
                              width: 150,
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              height: 17,
                              width: 90,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 15);
        },
      ),
    );
    ;
  }
}
