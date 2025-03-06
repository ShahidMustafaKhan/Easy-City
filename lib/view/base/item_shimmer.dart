import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';

import '../../util/colors.dart';
import '../../util/dimensions.dart';
import 'custom_image.dart';

class ItemShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isStore;
  final bool hasDivider;
  ItemShimmer(
      {@required this.isEnabled,
      @required this.hasDivider,
      this.isStore = false});

  @override
  Widget build(BuildContext context) {
    bool _desktop = ResponsiveHelper.isDesktop(context);

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Soft shadow
                  offset: Offset(0, 0), // Shadow position
                  blurRadius: 2, // Softness of shadow
                  spreadRadius: 0, // No extra spread
                ),
              ],
            ),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                width: 70,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: CustomImage(
                          image: '',
                          height: 120,
                          width: 200,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              ),
              Container(
                color: ColorResources.white,
                width: 170,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 7,
                            width: 145,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 7,
                            width: 135,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          child: RatingBar(
                            rating: 5,
                            size: _desktop ? 15 : 11.5,
                            ratingCount: 5,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 9,
                            width: 75,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Icon(
                Icons.favorite_border_outlined,
                color: Theme.of(context).disabledColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
