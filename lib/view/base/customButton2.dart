import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sixam_mart/theme/light_theme.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';

import '../../controller/user_controller.dart';
import '../../util/colors.dart';

class CustomButton2 extends StatefulWidget {
  final Function onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets margin;
  final double height;
  final double width;
  final double fontSize;
  final double radius;
  final IconData icon;
  CustomButton2(
      {this.onPressed,
        @required this.buttonText,
        this.transparent = false,
        this.margin,
        this.width,
        this.height,
        this.fontSize,
        this.radius = 5,
        this.icon});

  @override
  State<CustomButton2> createState() => _CustomButton2State();
}

class _CustomButton2State extends State<CustomButton2> {
  int rating = 0;

  final userController = Get.find<UserController>();

  Future<double> getReview(String modelId) async {
    print(modelId);
    // final reviewDoc = await FirebaseFirestore.instance.collection('reviews').doc(modelId).get();
    // final reviewData = reviewDoc.data();
    final reviewDocs = await FirebaseFirestore.instance.collection('reviews')
        .get();
    final reviewsData = reviewDocs.docs.map((doc) => doc.data()['reviews'])
        .toList();
    final sum = reviewsData.fold<double>(0, (prev, curr) => prev + curr);

    // final total = reviewsData.fold<double>(0, (sum, item) => sum + item['value']);
    print('totalAaas:' + sum.toString());
    print('totalAaas:' + rating.toString());
    if (sum > 0.0) {
      rating = (sum / reviewsData.length).truncate();
    }
    return rating.toDouble();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReview(userController.userInfoModel.id.toString());
  }
  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      // backgroundColor: onPressed == null
      //     ? Theme.of(context).disabledColor
      //     : transparent
      //         ? Colors.transparent
      //         : Theme.of(context).primaryColor,
      minimumSize: Size(widget.width != null ? widget.width : Dimensions.WEB_MAX_WIDTH,
          widget.height != null ? widget.height : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );

    return Column(
      children: [
        Center(
            child: SizedBox(
                width: widget.width != null ? widget.width : Dimensions.WEB_MAX_WIDTH,
                child: Padding(
                  padding: widget.margin == null ? EdgeInsets.all(0) : widget.margin,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      gradient: widget.onPressed == null
                          ? LinearGradient(colors: [
                        Theme.of(context).disabledColor,
                        Theme.of(context).disabledColor,
                      ])
                          : widget.transparent
                          ? LinearGradient(colors: [
                        Colors.transparent,
                        Colors.transparent,
                      ])
                          : LinearGradient(colors: [
                        ColorResources.blue1,
                        ColorResources.blue1,
                        // Color(0xff374ABE),
                        // Color.fromARGB(255, 198, 10, 219)
                      ]),
                    ),
                    child: TextButton(
                      onPressed: widget.onPressed,
                      style: _flatButtonStyle,
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.icon != null
                                    ? Padding(
                                  padding: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Icon(widget.icon,
                                      color: widget.transparent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor),
                                )
                                    : SizedBox(),
                                Text(widget.buttonText ?? '',
                                    textAlign: TextAlign.center,
                                    style: robotoBold.copyWith(
                                      color: widget.transparent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor,
                                      fontSize: widget.fontSize != null
                                          ? widget.fontSize
                                          : Dimensions.fontSizeLarge,
                                    )),
                              ]),
                          FutureBuilder<double>(
                            future:    getReview(userController.userInfoModel.id.toString()),
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Return a loading indicator while waiting for the data to arrive.
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // Handle any errors that occur while fetching the data.
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // The data has arrived, so update the UI with the rating value.
                                final rating = snapshot.data;
                                return RatingBar(
                                  rating: rating,
                                  size:  10
                                  ,

                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ))),

      ],
    );
  }
}


