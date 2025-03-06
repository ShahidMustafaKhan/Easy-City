import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_image.dart';
import '../../base/title_widget.dart';
import '../../screens/home/widget/module_view.dart';

class MarketWidget extends StatelessWidget {
  final SplashController splashController;
  MarketWidget({@required this.splashController});

  @override
  Widget build(BuildContext context) {
    return splashController.moduleList != null
        ? splashController.moduleList.length > 0
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 2),
                    child: TitleWidget(
                      title: 'Market',
                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 143,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      itemCount: splashController.moduleList.length,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () =>
                              splashController.switchModule(index, true),
                          child: Container(
                            width: 98,
                            margin: const EdgeInsets.only(right: 11),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff6776FE),
                              ),
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xffB0B8FF).withOpacity(0.12),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      child: CustomImage(
                                        image:
                                            '${splashController.configModel.baseUrls.moduleImageUrl}/${splashController.moduleList[index].icon}',
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    Center(
                                        child: Container(
                                      width: 60,
                                      child: Text(
                                        splashController
                                            .moduleList[index].moduleName,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall),
                                      ),
                                    )),
                                  ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Padding(
                    padding:
                        EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    child: Text('no_module_found'.tr)))
        : ModuleShimmer(isEnabled: splashController.moduleList == null);
  }
}
