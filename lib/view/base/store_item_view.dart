import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/item_shimmer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/base/veg_filter_widget.dart';
import 'package:sixam_mart/view/screens/home/theme1/store_widget.dart';

import 'store_item_widget.dart';

class StoreItemsView extends StatelessWidget {
  final List<Item> items;
  final List<Store> stores;
  final bool isStore;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inStorePage;
  final String type;
  final bool isFeatured;
  final bool showTheme1Store;
  final Function(String type) onVegFilterTap;
  StoreItemsView(
      {@required this.stores,
      @required this.items,
      @required this.isStore,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      this.noDataText,
      this.isCampaign = false,
      this.inStorePage = false,
      this.type,
      this.onVegFilterTap,
      this.isFeatured = false,
      this.showTheme1Store = false});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if (isStore) {
      _isNull = stores == null;
      if (!_isNull) {
        _length = stores.length;
      }
    } else {
      _isNull = items == null;
      if (!_isNull) {
        _length = items.length;
      }
    }

    return Column(children: [
      type != null
          ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
          : SizedBox(),
      !_isNull
          ? _length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4.6,
                    crossAxisCount: 1,
                  ),
                  physics: isScrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  shrinkWrap: isScrollable ? false : true,
                  itemCount: _length,
                  padding: padding,
                  itemBuilder: (context, index) {
                    return showTheme1Store
                        ? StoreWidget(
                            store: stores[index],
                            index: index,
                            inStore: inStorePage)
                        : StoreItemWidget(
                            isStore: isStore,
                            item: isStore ? null : items[index],
                            isFeatured: isFeatured,
                            store: isStore ? stores[index] : null,
                            index: index,
                            length: _length,
                            isCampaign: isCampaign,
                            inStore: inStorePage,
                          );
                  },
                )
              : NoDataScreen(
                  text: noDataText != null
                      ? noDataText
                      : isStore
                          ? Get.find<SplashController>()
                                  .configModel
                                  .moduleConfig
                                  .module
                                  .showRestaurantText
                              ? 'no_restaurant_available'.tr
                              : 'no_store_available'.tr
                          : 'no_item_available'.tr,
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                mainAxisSpacing: 12,
                childAspectRatio: 4.6,
                crossAxisCount: 1,
              ),
              physics: isScrollable
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: 10,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Store
                    ? StoreShimmer(isEnable: _isNull)
                    : ItemShimmer(
                        isEnabled: _isNull,
                        hasDivider: index != shimmerLength - 1);
              },
            ),
    ]);
  }
}
