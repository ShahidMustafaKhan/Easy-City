import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/item_controller.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../helper/price_converter.dart';
import '../../../../util/colors.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class ItemDetailsWidget extends StatelessWidget {
  final ItemController itemController;
  const ItemDetailsWidget({
    Key key,
    @required int stock,
    @required double priceWithAddons,
    this.itemController,
  })  : _stock = stock,
        _priceWithAddons = priceWithAddons,
        super(key: key);

  final int _stock;
  final double _priceWithAddons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ColorResources.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          quantityRow(context),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          totalAmountRow(),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          (itemController.item.description != null &&
                  itemController.item.description.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr,
                        style: robotoMedium.copyWith(fontSize: 13)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                    Text(itemController.item.description,
                        style: robotoRegular.copyWith(fontSize: 12.5)),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Row totalAmountRow() {
    return Row(children: [
      Container(
        margin: const EdgeInsets.only(right: 5),
        child: Text('${'total_amount'.tr}:',
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )),
      ),
      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      Text(PriceConverter.convertPrice(_priceWithAddons ?? 0.0),
          style: robotoBold.copyWith(
            color: ColorResources.blue1,
            fontSize: Dimensions.fontSizeLarge,
          )),
    ]);
  }

  Row quantityRow(BuildContext context) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.only(right: 20),
        child: Text('quantity'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
      ),
      Expanded(child: SizedBox()),
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(5)),
        child: Row(children: [
          InkWell(
            onTap: () {
              if (itemController.cartIndex != -1) {
                if (Get.find<CartController>()
                        .cartList[itemController.cartIndex]
                        .quantity >
                    1) {
                  Get.find<CartController>()
                      .setQuantity(false, itemController.cartIndex, _stock);
                }
              } else {
                if (itemController.quantity > 1) {
                  itemController.setQuantity(false, _stock);
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Icon(Icons.remove, size: 18),
            ),
          ),
          GetBuilder<CartController>(builder: (cartController) {
            return Text(
              itemController.cartIndex != -1
                  ? cartController.cartList[itemController.cartIndex].quantity
                      .toString()
                  : itemController.quantity.toString(),
              style:
                  robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
            );
          }),
          InkWell(
            onTap: () => itemController.cartIndex != -1
                ? Get.find<CartController>()
                    .setQuantity(true, itemController.cartIndex, _stock)
                : itemController.setQuantity(true, _stock),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Icon(Icons.add, size: 18),
            ),
          ),
        ]),
      ),
    ]);
  }
}
