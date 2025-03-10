import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/veg_filter_widget.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/customization/widget/item_services_view.dart';

import '../../../controller/location_controller.dart';
import '../../../data/model/response/service_provider_model.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors.dart';
import '../../base/store_item_view.dart';
import '../../base/store_view.dart';

class CategoryItemScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  CategoryItemScreen({@required this.categoryID, @required this.categoryName});

  @override
  _CategoryItemScreenState createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  TabController _tabController;
  List<ServiceData> servicesList = [];

  int zoneid = Get.find<LocationController>().getUserAddress().zoneId;
  final moduleId = Get.find<SplashController>().module.id.toString();
  void getServices() async {
    String url = AppConstants.BASE_URL +
        // '/admin/service-provider/api/get?module_id=$moduleId&category_id=${widget.categoryID}&zone_id=9';
        '/admin/service-provider/api/get?module_id=$moduleId&category_id=${widget.categoryID}&zone_id=$zoneid';
    try {
      http.Response _response = await http.get(Uri.parse(url));

      log('service provider body in category item screen : ${_response.body}');
      ServiceProviderModel service =
          ServiceProviderModel.fromJson(jsonDecode(_response.body));
      servicesList = service.data;
    } catch (e) {
      log('error is : $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryItemList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    getServices();
    storeScrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryStoreList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('module_id=$moduleId&category_id=${widget.categoryID}&zone_id=$zoneid');
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item> _item;
      List<Store> _stores;
      if (catController.categoryItemList != null &&
          catController.searchItemList != null) {
        _item = [];
        if (catController.isSearching) {
          _item.addAll(catController.searchItemList);
        } else {
          _item.addAll(catController.categoryItemList);
        }
      }
      if (catController.categoryStoreList != null &&
          catController.searchStoreList != null) {
        _stores = [];
        if (catController.isSearching) {
          _stores.addAll(catController.searchStoreList);
        } else {
          _stores.addAll(catController.categoryStoreList);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: ColorResources.white12,
          appBar: ResponsiveHelper.isDesktop(context)
              ? WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) =>
                              catController.searchData(
                            query,
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            catController.type,
                          ),
                        )
                      : Text(widget.categoryName,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyText1.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: ColorResources.white12,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    )
                  ],
                ),
          endDrawer: MenuDrawer(),
          body: Center(
              child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Column(children: [
              (catController.subCategoryList != null &&
                      !catController.isSearching)
                  ? Center(
                      child: Container(
                      height: 38,
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: catController.subCategoryList.length,
                        padding: EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_SMALL),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => catController.setSubCategoryIndex(
                                index, widget.categoryID),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              decoration: BoxDecoration(
                                color: index == catController.subCategoryIndex
                                    ? Color(0xffe2e7fb).withOpacity(0.8)
                                    : null,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                              ),
                              child: Center(
                                child: Expanded(
                                  child: Text(
                                    catController.subCategoryList[index].name,
                                    style: index ==
                                            catController.subCategoryIndex
                                        ? robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources.blue1)
                                        : robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources.black,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ))
                  : SizedBox(),
              Center(
                  child: TabBar(
                controller: _tabController,
                indicatorColor: ColorResources.blue1,
                indicatorWeight: 2,
                labelColor: ColorResources.blue1,
                unselectedLabelColor: Theme.of(context).disabledColor,
                unselectedLabelStyle: robotoRegular.copyWith(
                    color: ColorResources.white, fontSize: 12),
                labelStyle: robotoMedium.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'item'.tr,
                  ),
                  Tab(
                      text: Get.find<SplashController>()
                              .configModel
                              .moduleConfig
                              .module
                              .showRestaurantText
                          ? 'restaurants'.tr
                          : 'stores'.tr),
                ],
              )),
              VegFilterWidget(
                  type: catController.type,
                  onSelected: (String type) {
                    if (catController.isSearching) {
                      catController.searchData(
                        catController.subCategoryIndex == 0
                            ? widget.categoryID
                            : catController
                                .subCategoryList[catController.subCategoryIndex]
                                .id
                                .toString(),
                        '1',
                        type,
                      );
                    } else {
                      if (catController.isStore) {
                        catController.getCategoryStoreList(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          type,
                          true,
                        );
                      } else {
                        catController.getCategoryItemList(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          type,
                          true,
                        );
                      }
                    }
                  }),
              Expanded(
                  child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if ((_tabController.index == 1 && !catController.isStore) ||
                        _tabController.index == 0 && catController.isStore) {
                      catController.setRestaurant(_tabController.index == 1);
                      if (catController.isSearching) {
                        catController.searchData(
                          catController.searchText,
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          catController.type,
                        );
                      } else {
                        if (_tabController.index == 1) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        } else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: StoreItemsView(
                        isStore: false,
                        items: _item,
                        stores: null,
                        noDataText: 'no_category_item_found'.tr,
                      ),
                    ),
                    SingleChildScrollView(
                      controller: storeScrollController,
                      child: StoreView(
                        isStore: true,
                        items: null,
                        stores: _stores,
                        noDataText: Get.find<SplashController>()
                                .configModel
                                .moduleConfig
                                .module
                                .showRestaurantText
                            ? 'no_category_restaurant_found'.tr
                            : 'no_category_store_found'.tr,
                      ),
                    ),
                    SingleChildScrollView(
                      child: ItemsSerivcesView(
                        isStore: true,
                        services: servicesList,
                        items: null,
                        noDataText: 'No Services found',
                      ),
                    ),
                  ],
                ),
              )),
              catController.isLoading
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : SizedBox(),
            ]),
          )),
        ),
      );
    });
  }
}
