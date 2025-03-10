import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/menu_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/screens/menu/widget/menu_button.dart';

class MenuOldScreen extends StatefulWidget {
  @override
  State<MenuOldScreen> createState() => _MenuOldScreenState();
}

class _MenuOldScreenState extends State<MenuOldScreen> {
  List<MenuModel> _menuList;
  double _ratio;

  @override
  Widget build(BuildContext context) {
    _ratio = ResponsiveHelper.isDesktop(context)
        ? 1.1
        : ResponsiveHelper.isTab(context)
            ? 1.1
            : 1.2;
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    _menuList = [
      MenuModel(
          icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(
          icon: 'assets/images/Bag1.png',
          isSVG: false,
          title: 'my_cart'.tr,
          route: RouteHelper.getCartRoute()),
      MenuModel(
          icon: Images.terms,
          isSVG: false,
          title: 'Booking'.tr,
          route: RouteHelper.getBookingRoute()),
      MenuModel(
          icon: "images/icons/ic_heart.png",
          isSVG: false,
          title: 'Favourite Services'.tr,
          route: RouteHelper.getFavouriteRoute()),
      // MenuModel(
      //     icon: Images.Profileicon,
      //     isSVG: true,
      //     title: 'profile'.tr,
      //     route: RouteHelper.getProfileRoute()),
      MenuModel(
          icon: Images.location,
          title: 'my_address'.tr,
          route: RouteHelper.getAddressRoute()),
      MenuModel(
          icon: 'assets/images/Twocolors1.png',
          isSVG: false,
          title: 'blogs'.tr,
          route: RouteHelper.getBlogsRoute('menu')),
      MenuModel(
          icon: 'assets/images/Play1.png',
          isSVG: false,
          title: 'videos'.tr,
          route: RouteHelper.getVideosRoute('menu')),
      MenuModel(
          icon: Images.languageicon,
          isSVG: true,
          title: 'language'.tr,
          route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(
          icon: Images.coupon,
          title: 'coupon'.tr,
          route: RouteHelper.getCouponRoute()),
      MenuModel(
          icon: Images.support,
          title: 'help_support'.tr,
          route: RouteHelper.getSupportRoute()),
      // MenuModel(
      //     icon: Images.policy,
      //     title: 'privacy_policy'.tr,
      //     route: RouteHelper.getHtmlRoute('privacy-policy')),
      MenuModel(
          icon: Images.aboutusicon,
          isSVG: true,
          title: 'about_us'.tr,
          route: RouteHelper.getHtmlRoute('about-us')),
      // MenuModel(
      //     icon: Images.terms,
      //     title: 'terms_conditions'.tr,
      //     route: RouteHelper.getHtmlRoute('terms-and-condition')),
      MenuModel(
          icon: Images.chat,
          title: 'live_chat'.tr,
          route: RouteHelper.getConversationRoute()),
    ];

    if (Get.find<SplashController>().configModel.refEarningStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.refer_code,
          title: 'refer_and_earn'.tr,
          route: RouteHelper.getReferAndEarnRoute()));
    }
    if (Get.find<SplashController>().configModel.customerWalletStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.wallet,
          title: 'wallet'.tr,
          route: RouteHelper.getWalletRoute(true)));
    }
    if (Get.find<SplashController>().configModel.loyaltyPointStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.loyal,
          title: 'loyalty_points'.tr,
          route: RouteHelper.getWalletRoute(false)));
    }
    if (Get.find<SplashController>().configModel.toggleDmRegistration &&
        !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.delivery_man_join,
        title: 'join_as_a_delivery_man'.tr,
        route: RouteHelper.getDeliverymanRegistrationRoute(),
      ));
    }
    if (Get.find<SplashController>().configModel.toggleStoreRegistration &&
        !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.restaurant_join,
        title: Get.find<SplashController>()
                .configModel
                .moduleConfig
                .module
                .showRestaurantText
            ? 'join_as_a_restaurant'.tr
            : 'join_as_a_store'.tr,
        route: RouteHelper.getRestaurantRegistrationRoute(),
      ));
    }
    _menuList.add(MenuModel(
        isSignIn: true,
        icon: Images.log_out,
        title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr,
        route: ''));

    return SingleChildScrollView(
      child: PointerInterceptor(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Color(0xffEFF4FA),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(
              onTap: () => Get.back(),
              child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _menuList.length,
              itemBuilder: (context, index) {
                return MenuButton(
                    menu: _menuList[index],
                    isProfile: index == 0,
                    isLogout: index == _menuList.length - 1);
              },
            ),
            SizedBox(
                height: ResponsiveHelper.isMobile(context)
                    ? Dimensions.PADDING_SIZE_SMALL
                    : 0),
          ]),
        ),
      ),
    );
  }
}
