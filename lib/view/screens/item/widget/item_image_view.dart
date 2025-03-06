import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';

import '../../../../util/colors.dart';

class ItemImageView extends StatelessWidget {
  final Item item;
  ItemImageView({@required this.item});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    List<String> _imageList = [];
    _imageList.add(item.image);
    _imageList.addAll(item.images);

    return GetBuilder<ItemController>(
      builder: (itemController) {
        String _baseUrl = item.availableDateStarts == null
            ? Get.find<SplashController>().configModel.baseUrls.itemImageUrl
            : Get.find<SplashController>()
                .configModel
                .baseUrls
                .campaignImageUrl;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                RouteHelper.getItemImagesRoute(item),
                arguments: ItemImageView(item: item),
              ),
              child: Stack(children: [
                SizedBox(
                  height: ResponsiveHelper.isDesktop(context)
                      ? 350
                      : MediaQuery.of(context).size.height * 0.45,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _imageList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 240,
                        width: Get.width,
                        color: ColorResources.white6,
                        child: Image.network(
                          '$_baseUrl/${_imageList[index]}',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      itemController.setImageSliderIndex(index);
                    },
                  ),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              color: ColorResources.white,
              height: 65,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageList.length,
                itemBuilder: (context, index) {
                  int currentPage = _controller.hasClients
                      ? _controller.page?.round() ?? 0
                      : 0;

                  return InkWell(
                    onTap: () {
                      _controller.animateToPage(index,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.ease);
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: currentPage == index
                                  ? ColorResources.bluePrimaryColor
                                  : Colors.transparent,
                              width: 1.8),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              '$_baseUrl/${_imageList[index]}',
                            ),
                          )),
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }

  List<Widget> _indicators(BuildContext context, ItemController itemController,
      List<String> _imageList) {
    List<Widget> indicators = [];
    for (int index = 0; index < _imageList.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == itemController.imageSliderIndex
            ? Theme.of(context).primaryColor
            : Colors.white,
        borderColor: Colors.white,
        size: 10,
      ));
    }
    return indicators;
  }
}
