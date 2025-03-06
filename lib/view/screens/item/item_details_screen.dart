import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/base/cart_snackbar.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:sixam_mart/view/screens/item/widget/details_app_bar.dart';
import 'package:sixam_mart/view/screens/item/widget/details_web_view.dart';
import 'package:sixam_mart/view/screens/item/widget/item_detail_widget.dart';
import 'package:sixam_mart/view/screens/item/widget/item_image_view.dart';
import 'package:sixam_mart/view/screens/item/widget/item_title_view.dart';
import 'package:sixam_mart/view/screens/item/widget/variation_widget.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;
  final bool inStorePage;
  ItemDetailsScreen({@required this.item, @required this.inStorePage});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
    with SingleTickerProviderStateMixin {
  final Size size = Get.size;
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  final GlobalKey<DetailsAppBarState> _key = GlobalKey();
  AnimationController controller;
  @override
  void initState() {
    super.initState();

    Get.find<ItemController>().getProductDetails(widget.item);
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    return GetBuilder<ItemController>(
      builder: (itemController) {
        int _stock = 0;
        CartModel _cartModel;
        double _priceWithAddons = 0;
        if (itemController.item != null &&
            itemController.variationIndex != null) {
          List<String> _variationList = [];
          for (int index = 0;
              index < itemController.item.choiceOptions.length;
              index++) {
            _variationList.add(itemController.item.choiceOptions[index]
                .options[itemController.variationIndex[index]]
                .replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          _variationList.forEach((variation) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          });

          double price = itemController.item.price;
          Variation _variation;
          _stock = itemController.item.stock;
          for (Variation variation in itemController.item.variations) {
            if (variation.type == variationType) {
              price = variation.price;
              _variation = variation;
              _stock = variation.stock;
              break;
            }
          }

          double _discount = (itemController.item.availableDateStarts != null ||
                  itemController.item.storeDiscount == 0)
              ? itemController.item.discount
              : itemController.item.storeDiscount;
          String _discountType =
              (itemController.item.availableDateStarts != null ||
                      itemController.item.storeDiscount == 0)
                  ? itemController.item.discountType
                  : 'percent';
          double priceWithDiscount = PriceConverter.convertWithDiscount(
              price, _discount, _discountType);
          double priceWithQuantity =
              priceWithDiscount * itemController.quantity;
          double addonsCost = 0;
          List<AddOn> _addOnIdList = [];
          List<AddOns> _addOnsList = [];
          for (int index = 0;
              index < itemController.item.addOns.length;
              index++) {
            if (itemController.addOnActiveList[index]) {
              addonsCost = addonsCost +
                  (itemController.item.addOns[index].price *
                      itemController.addOnQtyList[index]);
              _addOnIdList.add(AddOn(
                  id: itemController.item.addOns[index].id,
                  quantity: itemController.addOnQtyList[index]));
              _addOnsList.add(itemController.item.addOns[index]);
            }
          }

          _cartModel = CartModel(
            price,
            priceWithDiscount,
            _variation != null ? [_variation] : [],
            (price -
                PriceConverter.convertWithDiscount(
                    price, _discount, _discountType)),
            itemController.quantity,
            _addOnIdList,
            _addOnsList,
            itemController.item.availableDateStarts != null,
            _stock,
            itemController.item,
          );
          _priceWithAddons = priceWithQuantity +
              (Get.find<SplashController>()
                      .configModel
                      .moduleConfig
                      .module
                      .addOn
                  ? addonsCost
                  : 0);
        }

        return Scaffold(
          key: _globalKey,
          backgroundColor: ColorResources.white,
          appBar: ResponsiveHelper.isDesktop(context)
              ? CustomAppBar(title: '')
              : DetailsAppBar(key: _key),
          body: (itemController.item != null)
              ? ResponsiveHelper.isDesktop(context)
                  ? DetailsWebView(
                      cartModel: _cartModel,
                      stock: _stock,
                      priceWithAddOns: _priceWithAddons,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: ColorResources.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 34,
                            color: ColorResources.black.withOpacity(0.04),
                            spreadRadius: 0,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(children: [
                        Expanded(
                            child: Scrollbar(
                          child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              physics: BouncingScrollPhysics(),
                              child: Center(
                                  child: Container(
                                      color: ColorResources.white,
                                      width: Dimensions.WEB_MAX_WIDTH,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ItemImageView(
                                              item: itemController.item),
                                          // SizedBox(height: 10),
                                          ItemTitleView(
                                              item: itemController.item,
                                              inStorePage: widget.inStorePage),
                                          Container(
                                            child: Divider(
                                              thickness: 0.9,
                                              color: ColorResources.grey8,
                                            ),
                                          ),

                                          VariationWidget(
                                              itemController: itemController),

                                          ItemDetailsWidget(
                                              itemController: itemController,
                                              stock: _stock,
                                              priceWithAddons:
                                                  _priceWithAddons),
                                        ],
                                      )))),
                        )),
                        Container(
                          width: 1170,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: ColorResources.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 34,
                                color: ColorResources.black.withOpacity(0.04),
                                spreadRadius: 0,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: CustomButton(
                              radius: 10,
                              fontSize: 14,
                              buttonText: (Get.find<SplashController>()
                                          .configModel
                                          .moduleConfig
                                          .module
                                          .stock &&
                                      _stock <= 0)
                                  ? 'out_of_stock'.tr
                                  : itemController.item.availableDateStarts !=
                                          null
                                      ? 'order_now'.tr
                                      : itemController.cartIndex != -1
                                          ? 'update_in_cart'.tr
                                          : 'add_to_cart'.tr,
                              onPressed: (!Get.find<SplashController>()
                                          .configModel
                                          .moduleConfig
                                          .module
                                          .stock ||
                                      _stock > 0)
                                  ? () {
                                      if (!Get.find<SplashController>()
                                              .configModel
                                              .moduleConfig
                                              .module
                                              .stock ||
                                          _stock > 0) {
                                        if (itemController
                                                .item.availableDateStarts !=
                                            null) {
                                          Get.toNamed(
                                              RouteHelper.getCheckoutRoute(
                                                  'campaign'),
                                              arguments: CheckoutScreen(
                                                fromCart: false,
                                                cartList: [_cartModel],
                                              ));
                                        } else {
                                          if (Get.find<CartController>()
                                              .existAnotherStoreItem(
                                                  _cartModel.item.storeId)) {
                                            Get.dialog(
                                                ConfirmationDialog(
                                                  icon: Images.warning,
                                                  title: 'are_you_sure_to_reset'
                                                      .tr,
                                                  description: Get.find<
                                                              SplashController>()
                                                          .configModel
                                                          .moduleConfig
                                                          .module
                                                          .showRestaurantText
                                                      ? 'if_you_continue'.tr
                                                      : 'if_you_continue_without_another_store'
                                                          .tr,
                                                  onYesPressed: () {
                                                    Get.back();
                                                    Get.find<CartController>()
                                                        .removeAllAndAddToCart(
                                                            _cartModel);
                                                    showCartSnackBar(context);
                                                  },
                                                ),
                                                barrierDismissible: false);
                                          } else {
                                            if (itemController.cartIndex ==
                                                -1) {
                                              Get.find<CartController>()
                                                  .addToCart(_cartModel,
                                                      itemController.cartIndex);
                                            }
                                            _key.currentState.shake();
                                            showCartSnackBar(context);
                                          }
                                        }
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ]),
                    )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;
  final bool isExistInCart;
  final int cartIndex;
  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    @required this.isExistInCart,
    @required this.cartIndex,
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isExistInCart) {
          if (!isIncrement && quantity > 1) {
            Get.find<CartController>().setQuantity(false, cartIndex, stock);
          } else if (isIncrement) {
            if (quantity < stock ||
                !Get.find<SplashController>()
                    .configModel
                    .moduleConfig
                    .module
                    .stock) {
              Get.find<CartController>().setQuantity(true, cartIndex, stock);
            } else {
              showCustomSnackBar('out_of_stock'.tr);
            }
          }
        } else {
          if (!isIncrement && quantity > 1) {
            Get.find<ItemController>().setQuantity(false, stock);
          } else if (isIncrement) {
            if (quantity < stock ||
                !Get.find<SplashController>()
                    .configModel
                    .moduleConfig
                    .module
                    .stock) {
              Get.find<ItemController>().setQuantity(true, stock);
            } else {
              showCustomSnackBar('out_of_stock'.tr);
            }
          }
        }
      },
      child: Container(
        // padding: EdgeInsets.all(3),
        height: 50, width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor),
        child: Center(
          child: Icon(
            isIncrement ? Icons.add : Icons.remove,
            color: isIncrement
                ? Colors.white
                : quantity > 1
                    ? Colors.white
                    : Colors.white,
            size: isCartWidget ? 26 : 20,
          ),
        ),
      ),
    );
  }
}
