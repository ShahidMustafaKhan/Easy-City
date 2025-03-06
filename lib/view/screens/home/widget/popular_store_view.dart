import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/base/title_widget.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/wishlist_controller.dart';
import '../../../base/custom_snackbar.dart';

class PopularStoreView extends StatelessWidget {
  final bool isPopular;
  final bool isFeatured;
  PopularStoreView({@required this.isPopular, @required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store> _storeList = isFeatured
          ? storeController.featuredStoreList
          : isPopular
              ? storeController.popularStoreList
              : storeController.latestStoreList;

      return (_storeList != null && _storeList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, isPopular ? 2 : 22, 10, 10),
                  child: TitleWidget(
                    title: isFeatured
                        ? 'featured_stores'.tr
                        : isPopular
                            ? Get.find<SplashController>()
                                    .configModel
                                    .moduleConfig
                                    .module
                                    .showRestaurantText
                                ? 'popular_restaurants'.tr
                                : 'popular_stores'.tr
                            : '${'new_on'.tr} ${AppConstants.APP_NAME}',
                    onTap: () =>
                        Get.toNamed(RouteHelper.getAllStoreRoute(isFeatured
                            ? 'featured'
                            : isPopular
                                ? 'popular'
                                : 'latest')),
                  ),
                ),
                SizedBox(
                  height: 135,
                  child: _storeList != null
                      ? ListView.separated(
                          controller: ScrollController(),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount:
                              _storeList.length > 10 ? 10 : _storeList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 195,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFD0DAE5).withOpacity(
                                        0.7), // Adjust opacity for softness
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            bottom: Radius.circular(
                                                Dimensions.RADIUS_SMALL)),
                                        child: Image(
                                          image: NetworkImage(
                                              '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}'
                                              '/${_storeList[index].coverPhoto}'),
                                          height: 78,
                                          width: 195,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      GetBuilder<WishListController>(
                                          builder: (wishController) {
                                        bool _isWished = wishController
                                            .wishStoreIdList
                                            .contains(_storeList[index].id);
                                        return InkWell(
                                          onTap: () {
                                            if (Get.find<AuthController>()
                                                .isLoggedIn()) {
                                              _isWished
                                                  ? wishController
                                                      .removeFromWishList(
                                                          _storeList[index].id,
                                                          true)
                                                  : wishController
                                                      .addToWishList(
                                                          null,
                                                          _storeList[index],
                                                          true);
                                            } else {
                                              showCustomSnackBar(
                                                  'you_are_not_logged_in'.tr);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                            margin: EdgeInsets.all(Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                            ),
                                            child: Icon(
                                              _isWished
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: 13,
                                              color: _isWished
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .disabledColor,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(
                                                  Dimensions.RADIUS_SMALL)),
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _storeList[index].name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        _storeList[index]
                                                            .address,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 8,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          RatingBar(
                                                              rating: _storeList[
                                                                      index]
                                                                  .avgRating,
                                                              size: 10,
                                                              ratingCount:
                                                                  _storeList[
                                                                          index]
                                                                      .ratingCount),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            '(${_storeList[index].ratingCount ?? 0})',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize: 6,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 1.5,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 12);
                          },
                        )
                      : PopularStoreShimmer(storeController: storeController),
                ),
              ],
            );
    });
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final StoreController storeController;
  PopularStoreShimmer({@required this.storeController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          width: 200,
          margin:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 10, width: 100, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        Container(
                            height: 10, width: 130, color: Colors.grey[300]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
