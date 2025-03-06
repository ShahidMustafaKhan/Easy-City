import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/data/model/response/category_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/store/widget/store_category_tab.dart';
import 'package:sixam_mart/view/screens/store/widget/store_description_view.dart';

import '../../base/store_item_view.dart';

class StoreScreen extends StatefulWidget {
  final Store store;
  final bool fromModule;
  StoreScreen({@required this.store, @required this.fromModule});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>()
        .getStoreDetails(Store(id: widget.store.id), widget.fromModule);
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<StoreController>()
        .getStoreItemList(widget.store.id, 1, 'all', false);
  }

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      endDrawer: MenuDrawer(),
      backgroundColor: ColorResources.white,
      body: GetBuilder<StoreController>(builder: (storeController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          Store _store;
          if (storeController.store != null &&
              storeController.store.name != null &&
              categoryController.categoryList != null) {
            _store = storeController.store;
          }
          storeController.setCategoryList();

          return CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                toolbarHeight: 50,
                pinned: true,
                floating: false,
                backgroundColor: ColorResources.white,
                leading: IconButton(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ColorResources.blue1),
                    alignment: Alignment.center,
                    child: Icon(Icons.chevron_left,
                        color: Theme.of(context).cardColor),
                  ),
                  onPressed: () => Get.back(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _store?.coverPhoto != null
                      ? CustomImage(
                          fit: BoxFit.cover,
                          image:
                              '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}/${_store.coverPhoto}',
                        )
                      : Shimmer(
                          duration: Duration(seconds: 2),
                          enabled: true,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Dimensions.WEB_MAX_WIDTH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                            Dimensions.RADIUS_SMALL)),
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ]),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Center(
                      child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                child: Column(children: [
                  ResponsiveHelper.isDesktop(context)
                      ? SizedBox()
                      : StoreDescriptionView(store: _store),
                  _store?.discount != null
                      ? Container(
                          width: context.width,
                          margin: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              color: ColorResources.blue1),
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _store.discount.discountType == 'percent'
                                      ? '${_store.discount.discount}% OFF'
                                      : '${PriceConverter.convertPrice(_store.discount.discount)} OFF',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      color: Theme.of(context).cardColor),
                                ),
                                Text(
                                  _store.discount.discountType == 'percent'
                                      ? '${'enjoy'.tr} ${_store.discount.discount}% ${'off_on_all_categories'.tr}'
                                      : '${'enjoy'.tr} ${PriceConverter.convertPrice(_store.discount.discount)}'
                                          ' ${'off_on_all_categories'.tr}',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).cardColor),
                                ),
                                SizedBox(
                                    height: (_store.discount.minPurchase != 0 ||
                                            _store.discount.maxDiscount != 0)
                                        ? 5
                                        : 0),
                                _store.discount.minPurchase != 0
                                    ? Text(
                                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_store.discount.minPurchase)} ]',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).cardColor),
                                      )
                                    : SizedBox(),
                                _store.discount.maxDiscount != 0
                                    ? Text(
                                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_store.discount.maxDiscount)} ]',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).cardColor),
                                      )
                                    : SizedBox(),
                                Text(
                                  '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_store.discount.startTime)} '
                                  '- ${DateConverter.convertTimeToTime(_store.discount.endTime)} ]',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).cardColor),
                                ),
                              ]),
                        )
                      : SizedBox(),
                ]),
              ))),
              ((storeController.categoryList?.length ?? 0) > 0)
                  ? StoreCategoryTab(
                      storeController: storeController, ltr: _ltr)
                  : SliverToBoxAdapter(child: SizedBox()),
              SliverToBoxAdapter(
                  child: FooterView(
                      child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: PaginatedListView(
                  scrollController: scrollController,
                  onPaginate: (int offset) => storeController.getStoreItemList(
                      widget.store.id, offset, storeController.type, false),
                  totalSize: storeController.storeItemModel != null
                      ? storeController.storeItemModel.totalSize
                      : null,
                  offset: storeController.storeItemModel != null
                      ? storeController.storeItemModel.offset
                      : null,
                  itemView: StoreItemsView(
                    isStore: false,
                    stores: null,
                    items: (storeController.categoryList.length > 0 &&
                            storeController.storeItemModel != null)
                        ? storeController.storeItemModel.items
                        : null,
                    inStorePage: true,
                    type: storeController.type,
                    onVegFilterTap: (String type) {
                      storeController.getStoreItemList(
                          storeController.store.id, 1, type, true);
                    },
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                      vertical: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.PADDING_SIZE_SMALL
                          : 10,
                    ),
                  ),
                ),
              ))),
            ],
          );
        });
      }),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Item> products;
  CategoryProduct(this.category, this.products);
}
