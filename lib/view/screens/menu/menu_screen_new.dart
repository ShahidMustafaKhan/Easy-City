import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/data/model/response/menu_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/menu/widget/menu_app_bar.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuModel> _menuList;

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    _menuList = [
      MenuModel(
          icon: 'assets/image/menu/profile.png',
          title: 'profile'.tr,
          route: RouteHelper.getProfileRoute()),
      MenuModel(
          icon: 'assets/image/menu/orders.png',
          isSVG: false,
          title: 'Orders'.tr,
          route: RouteHelper.getCartRoute()),
      MenuModel(
          icon: 'assets/image/menu/address.png',
          title: 'my_address'.tr,
          route: RouteHelper.getAddressRoute()),
      MenuModel(
          icon: 'assets/image/menu/language.png',
          isSVG: false,
          title: 'language'.tr,
          route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(
          icon: 'assets/image/menu/coupon.png',
          title: 'coupon'.tr,
          route: RouteHelper.getCouponRoute()),
      MenuModel(
          icon: 'assets/image/menu/language.png',
          title: 'Loyalty Points',
          route: RouteHelper.getCouponRoute()),
      MenuModel(
          icon: 'assets/image/menu/wallet.png',
          isSVG: false,
          title: 'My Wallet'.tr,
          route: RouteHelper.getCartRoute()),
      MenuModel(
          icon: "assets/image/menu/refer.png",
          isSVG: false,
          title: 'Refer & Earn',
          route: RouteHelper.getFavouriteRoute()),
      MenuModel(
          icon: "assets/image/menu/deliveryman.png",
          title: 'Join as a Delivery Man',
          route: RouteHelper.getSupportRoute()),
      MenuModel(
          icon: "assets/image/menu/store.png",
          isSVG: true,
          title: 'Store',
          route: RouteHelper.getHtmlRoute('about-us')),
      MenuModel(
          icon: "assets/image/menu/chat.png",
          title: 'live_chat'.tr,
          route: RouteHelper.getConversationRoute()),
      MenuModel(
          icon: "assets/image/menu/support.png",
          title: 'Help & Support',
          route: RouteHelper.getConversationRoute()),
      MenuModel(
          icon: "assets/image/about_us.png",
          title: 'About Us'.tr,
          route: RouteHelper.getConversationRoute()),
      MenuModel(
          icon: "assets/image/menu/terms.png",
          title: 'Terms & Conditions'.tr,
          route: RouteHelper.getConversationRoute()),
      MenuModel(
          icon: "assets/image/menu/privacy.png",
          title: 'Privacy Policy'.tr,
          route: RouteHelper.getConversationRoute()),
      MenuModel(
          icon: "assets/image/menu/privacy.png",
          title: 'Refund Policy'.tr,
          route: RouteHelper.getConversationRoute()),
      MenuModel(
          icon: "assets/image/menu/shipping.png",
          title: 'Shipping Policy'.tr,
          route: RouteHelper.getConversationRoute()),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MenuAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMenuSection('General', [0, 1, 2, 3]),
              _buildMenuSection('Promotional Activity', [4, 5, 6]),
              _buildMenuSection('Earnings', [7, 8, 9]),
              _buildMenuSection('Help & Support', [10, 11, 12, 13, 14, 15, 16]),
              SizedBox(height: 18),
              _buildLogoutButton(),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 24,
            width: 24,
            padding: EdgeInsets.all(3),
            decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Image.asset("assets/image/menu/logout.png"),
          ),
          SizedBox(width: 6),
          Text('Logout', style: robotoMedium),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<int> indices) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: robotoMedium.copyWith(
                  color: ColorResources.blue1.withOpacity(0.5))),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: indices
                  .map((index) => reusableRow(context, index,
                      hideDivider: index == indices.last,
                      verticalPadding: index == indices.last ? 8 : 6))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget reusableRow(BuildContext context, int index,
      {bool hideDivider = false, double verticalPadding = 6}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 22,
                  width: 22,
                  child: Image.asset(_menuList[index].icon)),
              SizedBox(
                width: 10,
              ),
              Text(_menuList[index].title,
                  style: robotoRegular.copyWith(fontSize: 13))
            ],
          ),
          if (hideDivider == false)
            Divider(
              color: Theme.of(context).disabledColor.withOpacity(0.5),
            )
        ],
      ),
    );
  }
}
