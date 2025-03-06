import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/screens/cart/cart_screen.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';

import '../../../util/colors.dart';
import '../favourite/favourite_screen.dart';
import '../menu/menu_screen_new.dart';
import '../social/social_screen.dart';
import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();

  bool _isLogin;
  AdaptiveThemeMode savedThemeMode;
  SharedPreferences prefs;

  void getPrefs() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    await SharedPreferences.getInstance().then(
      (pref) {
        prefs = pref;
        log('pref is : $pref');
        // setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    _isLogin = Get.find<AuthController>().isLoggedIn();

    if (_isLogin) {
      Get.find<OrderController>().getRunningOrders(1, fromDashBoard: true);
    }

    _pageController = PageController(initialPage: 0);

    _screens = [
      HomeScreen(),
      FavouriteScreen(),
      CartScreen(fromNav: true),
      SocialMediaScreen(),
      MenuScreen(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    getPrefs();
    return WillPopScope(
      onWillPop: () async {
        print(_pageIndex);
        if (_pageIndex == 0 || _pageIndex == 1) {
          finish(context);
          return true;
        } else {
          if (_pageIndex != 2) {
            _setPage(2);
            return false;
          } else {
            if (!ResponsiveHelper.isDesktop(context) &&
                Get.find<SplashController>().module != null &&
                Get.find<SplashController>().configModel.module == null) {
              Get.find<SplashController>().setModule(null);
              return false;
            } else {
              if (_canExit) {
                return true;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('back_press_again_to_exit'.tr,
                      style: TextStyle(color: Colors.white)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                ));
                _canExit = true;
                Timer(Duration(seconds: 2), () {
                  _canExit = false;
                });
                return false;
              }
            }
          }
        }
      },
      child: GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel> _runningOrder =
            orderController.runningOrderModel != null
                ? orderController.runningOrderModel.orders
                : [];

        List<OrderModel> _reversOrder = List.from(_runningOrder.reversed);

        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          floatingActionButton: ResponsiveHelper.isDesktop(context)
              ? null
              : (orderController.showBottomSheet &&
                      orderController.runningOrderModel != null &&
                      orderController.runningOrderModel.orders.isNotEmpty)
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: Transform.scale(
                        scale: 1.0, // Adjust scale factor
                        child: FloatingActionButton(
                          shape: CircleBorder(
                              side: BorderSide(
                                  color: ColorResources.white, width: 5)),
                          elevation: 0,
                          backgroundColor: ColorResources.blue1,
                          // backgroundColor: _pageIndex == 2
                          //     ? ColorResources.white
                          //     : ColorResources.white,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(fromNav: true),
                              )),
                          child: Center(
                            child: SizedBox(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  "assets/image/bottom_nav/cart.png",
                                  color: ColorResources.white1,
                                )),
                          ),
                        ),
                      ),
                    ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: ResponsiveHelper.isDesktop(context)
              ? SizedBox()
              : (orderController.showBottomSheet &&
                      orderController.runningOrderModel != null &&
                      orderController.runningOrderModel.orders.isNotEmpty)
                  ? SizedBox()
                  : Container(
                      height: 61,
                      child: BottomAppBar(
                        notchMargin: 4,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BottomNavItem(
                                  image: "assets/image/bottom_nav/home.png",
                                  isSelected: _pageIndex == 0,
                                  onTap: () => _setPage(0),
                                  title: 'Home',
                                ),
                                BottomNavItem(
                                  image: "assets/image/bottom_nav/heart.png",
                                  isSelected: _pageIndex == 1,
                                  onTap: () => _setPage(1),
                                  title: 'Favourite',
                                ),
                                SizedBox(
                                  width: 22,
                                ),
                                BottomNavItem(
                                  image: "assets/image/bottom_nav/social.png",
                                  isSelected: _pageIndex == 3,
                                  onTap: () => _setPage(3),
                                  title: 'Social',
                                ),
                                BottomNavItem(
                                  image: "assets/image/bottom_nav/menu.png",
                                  isSelected: _pageIndex == 4,
                                  onTap: () => _setPage(4),
                                  title: 'Menu',
                                )
                              ]),
                        ),
                      ),
                    ),
          body: ExpandableBottomSheet(
            background: PageView.builder(
              controller: _pageController,
              itemCount: _screens.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens[index];
              },
            ),
            persistentContentHeight: 100,
            onIsContractedCallback: () {
              if (!orderController.showOneOrder) {
                orderController.showOrders();
              }
            },
            onIsExtendedCallback: () {
              if (orderController.showOneOrder) {
                orderController.showOrders();
              }
            },
            enableToggle: true,
            expandableContent: (ResponsiveHelper.isDesktop(context) ||
                    !_isLogin ||
                    orderController.runningOrderModel == null ||
                    orderController.runningOrderModel.orders.isEmpty ||
                    !orderController.showBottomSheet)
                ? null
                : Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (orderController.showBottomSheet) {
                        orderController.showRunningOrders();
                      }
                    },
                    child: RunningOrderViewWidget(reversOrder: _reversOrder),
                  ),
          ),
        );
      }),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {@required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)));
  }
}
