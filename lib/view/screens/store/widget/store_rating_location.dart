import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class StoreRatingLocation extends StatelessWidget {
  const StoreRatingLocation({
    Key key,
    @required this.store,
    @required Color textColor,
  })  : _textColor = textColor,
        super(key: key);

  final Store store;
  final Color _textColor;

  @override
  Widget build(BuildContext context) {
    return store == null
        ? StoreRatingLocationShimmer()
        : Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_LARGE),
            child: Row(children: [
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () =>
                    Get.toNamed(RouteHelper.getStoreReviewRoute(store.id)),
                child: Column(children: [
                  Row(children: [
                    Icon(Icons.star, color: ColorResources.blue1, size: 20),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      store.avgRating.toStringAsFixed(1),
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: _textColor),
                    ),
                  ]),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    '${store.ratingCount ?? 0} + ${'ratings'.tr}',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: _textColor),
                  ),
                ]),
              ),
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                  AddressModel(
                    id: store.id,
                    address: store.address,
                    latitude: store.latitude,
                    longitude: store.longitude,
                    contactPersonNumber: '',
                    contactPersonName: '',
                    addressType: '',
                  ),
                  'store',
                )),
                child: Column(children: [
                  Icon(Icons.location_on,
                      color: ColorResources.blue1, size: 20),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text('location'.tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: _textColor)),
                ]),
              ),
              Expanded(child: SizedBox()),
              Column(children: [
                Row(children: [
                  Icon(Icons.timer, color: ColorResources.blue1, size: 20),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    store.deliveryTime,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: _textColor),
                  ),
                ]),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text('delivery_time'.tr,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: _textColor)),
              ]),
              (store.delivery && store.freeDelivery)
                  ? Expanded(child: SizedBox())
                  : SizedBox(),
              (store.delivery && store.freeDelivery)
                  ? Column(children: [
                      Icon(Icons.money_off,
                          color: Theme.of(context).primaryColor, size: 20),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text('free_delivery'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: _textColor)),
                    ])
                  : SizedBox(),
              Expanded(child: SizedBox()),
            ]),
          );
  }
}

class StoreRatingLocationShimmer extends StatelessWidget {
  const StoreRatingLocationShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      period: Duration(seconds: 2),
      gradient: LinearGradient(
        colors: [Colors.grey[300], Colors.grey[100], Colors.grey[300]],
        stops: [0.4, 0.5, 0.6],
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            shimmerColumn(),
            shimmerColumn(),
            shimmerColumn(),
          ],
        ),
      ),
    );
  }

  Widget shimmerColumn() {
    return Column(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 15,
          width: 60,
          color: Colors.white,
        ),
      ],
    );
  }
}
