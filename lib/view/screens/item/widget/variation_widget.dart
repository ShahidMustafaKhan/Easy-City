import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/util/colors.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class VariationWidget extends StatefulWidget {
  final ItemController itemController;
  const VariationWidget({Key key, this.itemController}) : super(key: key);

  @override
  State<VariationWidget> createState() => _VariationWidgetState();
}

class _VariationWidgetState extends State<VariationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: widget.itemController.item.choiceOptions.isEmpty ? 0 : 45.0),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.itemController.item.choiceOptions.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.itemController.item.choiceOptions[index].title,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall)),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: GetBuilder<ItemController>(builder: (controller) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.itemController.item
                            .choiceOptions[index].options.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                              onTap: () {
                                widget.itemController.setCartVariationIndex(
                                    index, i, widget.itemController.item);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.itemController.item
                                        .choiceOptions[index].options[i]
                                        .trim(),
                                    style: robotoMedium,
                                  ),
                                  Radio(
                                    activeColor: ColorResources.blue1,
                                    value: i,
                                    groupValue: widget
                                        .itemController.variationIndex[index],
                                    onChanged: (value) {
                                      print(widget.itemController
                                          .variationIndex[index]);
                                      print(i);

                                      widget.itemController
                                          .setCartVariationIndex(index, value,
                                              widget.itemController.item);
                                    },
                                  ),
                                ],
                              ));
                        },
                      );
                    }),
                  ),
                  SizedBox(
                      height: index !=
                              widget.itemController.item.choiceOptions.length -
                                  1
                          ? Dimensions.PADDING_SIZE_LARGE
                          : 0),
                ]);
          },
        ),
      ),
    );
  }
}
