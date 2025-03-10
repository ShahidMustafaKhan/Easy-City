import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/banner_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/screens/home/widget/banner_view.dart';
import 'package:sixam_mart/view/screens/home/widget/popular_store_view.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/location_controller.dart';
import '../../../../data/model/response/address_model.dart';
import '../../../base/custom_loader.dart';
import '../../../base/title_widget.dart';
import '../../../customization/blogs/blog_widget.dart';
import '../../../customization/market/market_wIdget.dart';
import '../../../customization/market/services_widget.dart';
import '../../../customization/videos/video_widget.dart';
import '../../address/widget/address_widget.dart';

class ModuleView extends StatelessWidget {
  final SplashController splashController;
  ModuleView({@required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<BannerController>(builder: (bannerController) {
        return BannerView(isFeatured: true);
      }),
      MarketWidget(
        splashController: splashController,
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
      ServiceWidget(splashController: splashController),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        child: TitleWidget(title: 'deliver_to'.tr),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      GetBuilder<LocationController>(builder: (locationController) {
        List<AddressModel> _addressList = [];
        if (Get.find<AuthController>().isLoggedIn() &&
            locationController.addressList != null) {
          _addressList = [];
          bool _contain = false;
          if (locationController.getUserAddress().id != null) {
            for (int index = 0;
                index < locationController.addressList.length;
                index++) {
              if (locationController.addressList[index].id ==
                  locationController.getUserAddress().id) {
                _contain = true;
                break;
              }
            }
          }
          if (!_contain) {
            _addressList.add(Get.find<LocationController>().getUserAddress());
          }
          _addressList.addAll(locationController.addressList);
        } else {
          _addressList.add(Get.find<LocationController>().getUserAddress());
        }
        return (!Get.find<AuthController>().isLoggedIn() ||
                locationController.addressList != null)
            ? SizedBox(
                height: 70,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _addressList.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      padding:
                          EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      child: AddressWidget(
                        address: _addressList[index],
                        fromAddress: false,
                        onTap: () {
                          if (locationController.getUserAddress().id !=
                              _addressList[index].id) {
                            Get.dialog(CustomLoader(),
                                barrierDismissible: false);
                            locationController.saveAddressAndNavigate(
                              _addressList[index],
                              false,
                              null,
                              false,
                              ResponsiveHelper.isDesktop(context),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              )
            : AddressShimmer(
                isEnabled: Get.find<AuthController>().isLoggedIn() &&
                    locationController.addressList == null);
      }),
      BlogWidget(
        splashController.module != null
            ? splashController.module.id.toString() ??
                    splashController.moduleList != null &&
                        splashController.moduleList.isNotEmpty
                ? splashController.moduleList[1].id.toString()
                : '1'
            : splashController.moduleList != null &&
                    splashController.moduleList.isNotEmpty
                ? splashController.moduleList[1].id.toString()
                : '1',
        isAllBlogs: true,
      ),
      VideoWidget(
        splashController.module != null
            ? splashController.module.id.toString() ??
                    splashController.moduleList != null &&
                        splashController.moduleList.isNotEmpty
                ? splashController.moduleList[1].id.toString()
                : '1'
            : splashController.moduleList != null &&
                    splashController.moduleList.isNotEmpty
                ? splashController.moduleList[1].id.toString()
                : '1',
        isAllVideos: true,
      ),
      PopularStoreView(isPopular: false, isFeatured: true),
      SizedBox(height: 90),
    ]);
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  ModuleShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
        crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
        childAspectRatio: (1 / 1),
      ),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      itemCount: 6,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 200],
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.grey[300]),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  AddressShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                  ? Dimensions.PADDING_SIZE_DEFAULT
                  : Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[Get.isDarkMode ? 800 : 200],
                      blurRadius: 5,
                      spreadRadius: 1)
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  Icons.location_on,
                  size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Shimmer(
                    duration: Duration(seconds: 2),
                    enabled: isEnabled,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 15, width: 100, color: Colors.grey[300]),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                              height: 10, width: 150, color: Colors.grey[300]),
                        ]),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
