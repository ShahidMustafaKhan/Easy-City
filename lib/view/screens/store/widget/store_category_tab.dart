import 'package:flutter/material.dart';
import 'package:sixam_mart/controller/store_controller.dart';

import '../../../../util/colors.dart';
import '../../../../util/styles.dart';

class StoreCategoryTab extends StatelessWidget {
  final StoreController storeController;
  const StoreCategoryTab({
    Key key,
    @required bool ltr,
    this.storeController,
  })  : _ltr = ltr,
        super(key: key);

  final bool _ltr;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
          child: Container(
        height: 83,
        width: MediaQuery.of(context).size.width,
        color: ColorResources.white,
        margin: EdgeInsets.only(top: 30, left: 9, right: 9),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            child: Row(
              children: [
                Text(
                  'All Products',
                  style: robotoMedium.copyWith(fontSize: 13),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Color(0xffe2e7fb).withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Icon(
                    Icons.search_sharp,
                    color: ColorResources.blue1,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: storeController.categoryList.length,
              padding: EdgeInsets.only(left: 0),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 13, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => storeController.setCategoryIndex(index),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                          decoration: BoxDecoration(
                              color: index == storeController.categoryIndex
                                  ? Color(0xffe2e7fb).withOpacity(0.6)
                                  : null,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                            child: Text(
                              storeController.categoryList[index].name,
                              style: index == storeController.categoryIndex
                                  ? robotoMedium.copyWith(
                                      fontSize: 10.5,
                                      color: ColorResources.blue1)
                                  : robotoMedium.copyWith(
                                      fontSize: 10.5,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 9,
                );
              },
            ),
          ),
        ]),
      )),
    );
  }
}
