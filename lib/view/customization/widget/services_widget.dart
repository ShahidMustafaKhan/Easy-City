import 'dart:convert';
import 'dart:developer';

import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/service_provider_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controller/user_controller.dart';
import '../../../util/app_constants.dart';
import '../services_provider/model/get_review_model.dart';
import '../services_provider/service_provider_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ServicesWidget extends StatefulWidget {
  final ServiceData service;
  final int index;
  final bool inStore;
  ServicesWidget(
      {@required this.service, @required this.index, this.inStore = false});

  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget> {
  List<ReviewData> reviewList = [];
  int allReviewsSum = 0;
  int rating = 0;
  bool loader = false;
  final userController = Get.find<UserController>();
  // void getReviews() async {
  //
  //   print(widget.service.serviceProviderId);
  //   String url = AppConstants.BASE_URL +
  //       '/admin/review/api/get?sp_id=${widget.service.serviceProviderId}';
  //   try {
  //     setState(() {
  //       loader = true;
  //     });
  //     http.Response _response = await http.get(Uri.parse(url));
  //
  //     log('service provider review body : ${_response.body}');
  //     GetReviewModel review =
  //         GetReviewModel.fromJson(jsonDecode(_response.body));
  //     reviewList = review.data;
  //     reviewList.forEach((e) {
  //       allReviewsSum += int.parse(e.reviews);
  //     });
  //     log('all reviews sum : $allReviewsSum');
  //     if (allReviewsSum > 0.0) {
  //       rating = (allReviewsSum / reviewList.length).truncate();
  //     }
  //     setState(() {
  //       loader = false;
  //     });
  //   } catch (e) {
  //     // log('error is : $e');
  //     // setState(() {
  //     loader = false;
  //     // });
  //   }
  // }
  Future<double> getReview(String modelId) async {
    print(modelId);
    // final reviewDoc = await FirebaseFirestore.instance.collection('reviews').doc(modelId).get();
    // final reviewData = reviewDoc.data();
    final reviewDocs = await FirebaseFirestore.instance.collection('reviews').get();
    final reviewsData = reviewDocs.docs.map((doc) => doc.data()['reviews']).toList();
    final sum = reviewsData.fold<double>(0, (prev, curr) => prev + curr);

    // final total = reviewsData.fold<double>(0, (sum, item) => sum + item['value']);
    print('total:'+ sum.toString());
    if (sum > 0.0) {
            rating = (sum / reviewsData.length).truncate();
          }



    // rating = reviewData['reviews'] ;
    print("ratingrating:"+rating.toString());
    return rating.toDouble();

  }


  @override
  void initState() {
    final model = userController.userInfoModel;
    getReview(model.id.toString());



    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    print("rating:"+rating.toString());
    log('service provider id : ${widget.service.serviceProviderId}');
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    return loader
        ? ServiceShimmer(isEnable: true)
        : InkWell(
            onTap: () {
              if (widget.service != null) {

                Get.to(() => ServiceProviderDetailsScreen(
                      widget.service,
                      reviewDataList: reviewList,
                    ));
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 800 : 300],
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Dimensions.RADIUS_SMALL)),
                      child: CustomImage(
                        image:
                            '${AppConstants.BASE_URL}/${widget.service.serviceProviderImage}',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      )),
                  // DiscountTag(
                  //   discount: Get.find<StoreController>().getDiscount(service),
                  //   discountType: Get.find<StoreController>().getDiscountType(service),
                  //   freeDelivery: service.freeDelivery,
                  // ),
                  // Get.find<StoreController>().isOpenNow(service) ? SizedBox() : NotAvailableWidget(isStore: true),
                ]),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.service.serviceProviderName,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                          maxLines: _desktop ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        // (widget.service.location != null)
                        //     ? Text(
                        //         widget.service.location ?? '',
                        //         style: robotoRegular.copyWith(
                        //           fontSize: Dimensions.fontSizeExtraSmall,
                        //           color: Theme.of(context).disabledColor,
                        //         ),
                        //         maxLines: 1,
                        //         overflow: TextOverflow.ellipsis,
                        //       )
                        //     : SizedBox(),
                        // SizedBox(
                        //     height: widget.service.location != null ? 2 : 0),
                            FutureBuilder<double>(
                            future:    getReview(userController.userInfoModel.id.toString()),
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                            // Return a loading indicator while waiting for the data to arrive.
                            return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                            // Handle any errors that occur while fetching the data.
                            return Text('Error: ${snapshot.error}');
                            } else {
                            // The data has arrived, so update the UI with the rating value.
                            final rating = snapshot.data;
                            return RatingBar(
                            rating: rating,
                            size: _desktop ? 15 : 12,
                            ratingCount: rating.toInt(),
                            );
                            }
                            },
                            ),
                      ]),
                )),
              ]),
            ),
          );
  }
}

class ServiceShimmer extends StatelessWidget {
  final bool isEnable;
  ServiceShimmer({@required this.isEnable});

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
            height: context.width * 0.06,
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
                      RatingBar(rating: 0, size: 12, ratingCount: 0),
                    ]),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Icon(Icons.star,
                  size: 25, color: Theme.of(context).disabledColor),
            ]),
          )),
        ]),
      ),
    );
  }
}
