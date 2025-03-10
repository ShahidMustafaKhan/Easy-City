import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/response/module_model.dart';
import '../../../util/app_constants.dart';
import 'service_item_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _moduleName;
  void getModuleName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _moduleName = ModuleModel.fromJson(
            jsonDecode(sharedPreferences.getString(AppConstants.MODULE_ID)))
        .moduleName;
  }

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCategoryList(false);
    getModuleName();

    log('module name is : ${_moduleName}');
    return Scaffold(
      appBar: CustomAppBar(title: 'categories'.tr),
      endDrawer: MenuDrawer(),
      backgroundColor: ColorResources.blue3,
      body: SafeArea(
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: FooterView(
                      child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<CategoryController>(builder: (catController) {
          return catController.categoryList != null
              ? catController.categoryList.length > 0
                  ? Container(
                      height: Get.height,
                      width: Get.width,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.6,
                            mainAxisSpacing: 5),
                        itemCount: catController.categoryList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 3, right: 3, left: 3),
                            child: InkWell(
                              onTap: () {
                                print(_moduleName);
                                print(catController.categoryList[index].id);
                                print(catController.categoryList[index].name);
                                print(_moduleName);
                                print("hi");
                                if (_moduleName == 'Pharmacy' ||
                                    _moduleName == 'Services') {
                                  Get.to(() => ServiceItemScreen(
                                        categoryID: catController
                                            .categoryList[index].id
                                            .toString(),
                                        categoryName: catController
                                            .categoryList[index].name,
                                      ));
                                } else {
                                  Get.toNamed(
                                    RouteHelper.getCategoryItemRoute(
                                      catController.categoryList[index].id,
                                      catController.categoryList[index].name,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.categoryList[index].image}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    catController.categoryList[index].name,
                                    style: robotoBold.copyWith(
                                      color: Colors.white,
                                    ),
                                    // style: TextStyle(
                                    //   fontFamily: 'Roboto',
                                    //   fontSize: 14,
                                    //   color: Colors.white,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )

                  //  ListView.builder(
                  //     physics: NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  //     itemCount: catController.categoryList.length,
                  //     itemBuilder: (context, index) {
                  //       return InkWell(
                  //         onTap: () {
                  //           if (_moduleName == 'Pharmacy' ||
                  //               _moduleName == 'Services') {
                  //             Get.to(() => ServiceItemScreen(
                  //                   categoryID: catController
                  //                       .categoryList[index].id
                  //                       .toString(),
                  //                   categoryName:
                  //                       catController.categoryList[index].name,
                  //                 ));
                  //           } else {
                  //             Get.toNamed(
                  //               RouteHelper.getCategoryItemRoute(
                  //                 catController.categoryList[index].id,
                  //                 catController.categoryList[index].name,
                  //               ),
                  //             );
                  //           }
                  //         },
                  //         child: Container(
                  //           height: 70,
                  //           width: Get.width,
                  //           margin: EdgeInsets.symmetric(vertical: 5),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(7),
                  //             image: DecorationImage(
                  //               image: NetworkImage(
                  //                   '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.categoryList[index].image}'),
                  //               fit: BoxFit.fitWidth,
                  //             ),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               catController.categoryList[index].name,
                  //               style: TextStyle(
                  //                 fontSize: 14,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         // child: Container(
                  //         //   margin: const EdgeInsets.symmetric(
                  //         //     horizontal: Dimensions.PADDING_SIZE_SMALL,
                  //         //     vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  //         //   ),
                  //         //   decoration: BoxDecoration(
                  //         //     color: Theme.of(context).cardColor,
                  //         //     borderRadius: BorderRadius.circular(
                  //         //         Dimensions.RADIUS_SMALL),
                  //         //     boxShadow: [
                  //         //       BoxShadow(
                  //         //           color:
                  //         //               Colors.grey[Get.isDarkMode ? 800 : 200],
                  //         //           blurRadius: 5,
                  //         //           spreadRadius: 1)
                  //         //     ],
                  //         //   ),
                  //         //   alignment: Alignment.center,
                  //         //   child: ListTile(
                  //         //     leading: ClipRRect(
                  //         //       borderRadius: BorderRadius.circular(
                  //         //           Dimensions.RADIUS_SMALL),
                  //         //       child: CustomImage(
                  //         //         height: 50,
                  //         //         width: 50,
                  //         //         fit: BoxFit.cover,
                  //         //         image:
                  //         //             '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.categoryList[index].image}',
                  //         //       ),
                  //         //     ),
                  //         //     title: Text(
                  //         //       catController.categoryList[index].name,
                  //         //       textAlign: TextAlign.center,
                  //         //       style: robotoMedium.copyWith(
                  //         //           fontSize: Dimensions.fontSizeSmall),
                  //         //       maxLines: 2,
                  //         //       overflow: TextOverflow.ellipsis,
                  //         //     ),
                  //         //     trailing: Icon(Icons.arrow_forward_ios),
                  //         //   ),
                  //         // ),
                  //       );
                  //     },
                  //   )
                  : NoDataScreen(text: 'no_category_found'.tr)
              : Center(child: CircularProgressIndicator());
        }),
      ))))),
    );
  }
}
