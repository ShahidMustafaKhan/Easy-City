import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/view/customization/services_provider/model/post_review_model.dart';
import 'package:sixam_mart/view/customization/services_provider/services_map_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../../controller/auth_controller.dart';
import '../../../data/model/response/service_provider_model.dart';
import '../../../data/repository/location_repo.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/customButton2.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/my_text_field.dart';
import '../../base/not_logged_in_screen.dart';
import '../../base/rating_bar.dart';
import '../widget/back_widget.dart';
import '../widget/fluttertoast.dart';
import 'model/get_review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ServiceProviderDetailsScreen extends StatefulWidget {
  final ServiceData service;
  final List<ReviewData> reviewDataList;

  ServiceProviderDetailsScreen(this.service, {this.reviewDataList});

  @override
  State<ServiceProviderDetailsScreen> createState() =>
      _ServiceProviderDetailsScreenState();
}

class _ServiceProviderDetailsScreenState
    extends State<ServiceProviderDetailsScreen> {
  void launchCall(String url) {
    if (url.validate().isNotEmpty) {
      if (isIOS)
        commonLaunchUrl('tel://' + url,
            launchMode: LaunchMode.externalApplication);
      else
        commonLaunchUrl('tel:' + url,
            launchMode: LaunchMode.externalApplication);
    }
  }

  Future<void> commonLaunchUrl(String address,
      {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
    await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
      toast('Invalid URL: $address');
    });
  }

  int totalReviews = 0;
  int reviews = 0;
  bool isServiceReviewed = false;

  void checkReview() {
    widget.reviewDataList.forEach((e) {
      totalReviews += int.parse(e.reviews);
      if (e.uId == userController.userInfoModel.id.toString()) {
        isServiceReviewed = true;
      }
    });
    if (totalReviews > 0.0) {
      reviews = (totalReviews / widget.reviewDataList.length).truncate();
    }
  }

  Future<void> addReview() async {

  }

  bool loader = false;
  void postReview(Map<String, dynamic> body) async {
    String url = AppConstants.BASE_URL + '/admin/review/api';
    // https://manager.easycity.app/admin/review/api?user_id=104&user_name=kh&user_image&reviews=4&service_provider_id=47&comment=this
// "    /admin/review/api/get?sp_id=${widget.service.serviceProviderId}"
//     '/admin/review/api'
    try {
      setState(() {
        loader = true;
      });
      http.Response _response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (_response.statusCode == 200) {
 
        Get.snackbar('success', 'Review inserted',
            snackPosition: SnackPosition.BOTTOM);
      }
      log('post review response : ${_response.body}');

      setState(() {
        loader = false;
      });
    } catch (e) {
      log('error is is : ${e.toString()}');
      setState(() {
        loader = false;
      });
    }
  }

  int rating = 0;
  final commentController = TextEditingController();
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
  final userController = Get.find<UserController>();
  final locationController = Get.find<UserController>();

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    // print('lat lng is : ${latLng.toJson()}');
    Response response = await LocationRepo().getAddressFromGeocode(latLng);
    String _address = 'Unknown Location Found';
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return _address;
  }

  String address = '';
  // @override
  // void initState() {
  //   if (widget.service.latitude != null && widget.service.longitude != null) {
  //     getAddressFromGeocode(LatLng(double.parse(widget.service.latitude),
  //             double.parse(widget.service.longitude)))
  //         .then((addrs) {
  //       setState(() {
  //         address = addrs;
  //       });
  //     });
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    double screenWidth= MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.323,
                child: Stack(
                  children: [
                Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(MediaQuery.of(context).size.width*0.15020),
                    bottomRight: Radius.circular(MediaQuery.of(context).size.width*0.15020),
                  ),
                // borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.13020),
                  gradient:
                  LinearGradient(colors: [
                    ColorResources.blue1,
                    ColorResources.blue1,

                  ]),
                ),

                height: screenHeight*0.248345,
                width: Get.width,
                ),
                    // Container(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(60),
                    //       color: Colors.blue,
                    //     ),
                    //
                    //     child: CachedNetworkImage(
                    //       placeholder: (context, url) {
                    //         return AnimatedContainer(
                    //           height: 20,
                    //           duration: Duration(seconds: 1),
                    //           width: 20,
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //           ),
                    //           alignment: Alignment.center,
                    //         );
                    //       },
                    //       imageUrl:
                    //           '${AppConstants.BASE_URL}/${widget.service.serviceProviderImage}',
                    //
                    //       height: 250,
                    //       width: Get.width,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: screenHeight*0.009937,
                      child: Container(
                        alignment: Alignment.center,
                        margin:  EdgeInsets.symmetric(horizontal: screenWidth*0.0260416666666),
                        child:
                            Center(child: Padding(
                              padding: Get.locale?.languageCode=='en'? EdgeInsets.only(left: screenWidth*0.0234375): EdgeInsets.only(right: screenWidth*0.0274375),
                              child: BackWidget(iconColor: ColorResources.blue1),
                            )),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                    Positioned(
                        top: screenHeight*0.136589,
                        left: screenWidth*0.3125,
                        child: Container(
                          padding:  EdgeInsets.fromLTRB(0, screenHeight*0.012417217515, 0, screenHeight*0.012417217515),
                          // height: 200,
                          height: screenWidth*0.3645833,
                          width: screenWidth*0.3645833,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('${AppConstants.BASE_URL}/${widget.service.serviceProviderImage}'),

                              ),

                          border: Border(

                          ), shape: BoxShape.circle,

                          ),

                            // Column(
                          //   children: [
                          //     // item('${'name'.tr} :',
                          //     //     widget.service.serviceProviderName),
                          //     // SizedBox(height: 10),
                          //     // item('${'contact'.tr} :',
                          //     //     widget.service.serviceProviderContact),
                          //     // SizedBox(height: 10),
                          //     // item('${'location'.tr} :', address),
                          //     // SizedBox(height: 10),
                          //     Container(
                          //       margin: const EdgeInsets.symmetric(
                          //           horizontal: 25),
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //
                          //
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             '${'review'.tr} :',
                          //             style: boldTextStyle()
                          //                 .copyWith(color: Color(0xFF5F60B9)),
                          //             overflow: TextOverflow.ellipsis,
                          //           ),
                          //           // RatingBar(
                          //           //   rating: reviews.toDouble(),
                          //           //   size: _desktop ? 15 : 12,
                          //           //   ratingCount:
                          //           //       widget.reviewDataList.length,
                          //           // ),
                          //         ],
                          //       ),
                          //     ),
                          //     Spacer(),
                          //     Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceAround,
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       children: [
                          //         // Padding(
                          //         //   padding: const EdgeInsets.only(left: 15),
                          //         //   child: InkWell(
                          //         //     onTap: () {
                          //         //       launchCall(widget
                          //         //           .service.serviceProviderContact
                          //         //           .validate());
                          //         //     },
                          //         //     child: Container(
                          //         //       height: 50,
                          //         //       width: 50,
                          //         //       decoration: BoxDecoration(
                          //         //         color: Color(0xFF5F60B9),
                          //         //         borderRadius:
                          //         //             BorderRadius.circular(10),
                          //         //       ),
                          //         //       child: Icon(
                          //         //         Icons.phone,
                          //         //         color: Colors.white,
                          //         //       ),
                          //         //     ),
                          //         //   ),
                          //         // ),
                          //         // Padding(
                          //         //   padding: const EdgeInsets.only(left: 15),
                          //         //   child: InkWell(
                          //         //     onTap: () {
                          //         //       Get.to(
                          //         //         () => ServicesMapScreen(
                          //         //           address: AddressModel(
                          //         //             latitude:
                          //         //                 widget.service.latitude,
                          //         //             longitude:
                          //         //                 widget.service.longitude,
                          //         //           ),
                          //         //           fromStore: true,
                          //         //         ),
                          //         //       );
                          //         //     },
                          //         //     child: Container(
                          //         //       height: 50,
                          //         //       width: 50,
                          //         //       decoration: BoxDecoration(
                          //         //         color: Color(0xFF5F60B9),
                          //         //         borderRadius:
                          //         //             BorderRadius.circular(10),
                          //         //       ),
                          //         //       child: Icon(
                          //         //         Icons.location_on_outlined,
                          //         //         color: Colors.white,
                          //         //       ),
                          //         //     ),
                          //         //   ),
                          //         // ),
                          //         // Padding(
                          //         //   padding: const EdgeInsets.only(right: 15),
                          //         //   child: InkWell(
                          //         //     onTap: () {
                          //         //       launchUrl(
                          //         //           Uri.parse(
                          //         //               '${getSocialMediaLink(LinkProvider.WHATSAPP)}${widget.service.serviceProviderContact.validate()}'),
                          //         //           mode: LaunchMode
                          //         //               .externalApplication);
                          //         //     },
                          //         //     child: Container(
                          //         //       height: 50,
                          //         //       width: 50,
                          //         //       decoration: BoxDecoration(
                          //         //         color: Color(0xFF5F60B9),
                          //         //         borderRadius:
                          //         //             BorderRadius.circular(10),
                          //         //       ),
                          //         //       child: Icon(
                          //         //         FontAwesomeIcons.whatsapp,
                          //         //         color: Colors.white,
                          //         //       ),
                          //         //     ),
                          //         //   ),
                          //         // ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        )),
                    // Positioned(
                    //   top: 335,
                    //   left: Get.width * 0.1,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 15),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Description',
                    //             style: boldTextStyle(size: 18)
                    //                 .copyWith(color: Color(0xFF5F60B9))),
                    //         5.height,
                    //         Container(
                    //           width: Get.width,
                    //           child: ReadMoreText(
                    //             widget.service.description.validate(),
                    //             style: secondaryTextStyle(),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: screenHeight*0.22350991527,
                   child: Container(
                      color: Colors.white,
                        height:screenHeight*0.124172175
                    ,
                    ),),],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          ColorResources.blue1,
                          ColorResources.blue1,
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(widget.service.serviceProviderName.tr,
                        style: boldTextStyle(size: 25)
                            .copyWith(color: Color(0xFF5F60B9))),
                  ),
                  5.height,

                ],
              ),

              SizedBox(height: screenHeight*0.024844720),

              Padding(
                padding:  Get.locale?.languageCode == 'en'?EdgeInsets.only(left: screenWidth*0.0651041666):EdgeInsets.only(right: screenWidth*0.0551041666),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            ColorResources.blue1,
                            ColorResources.blue1,
                          ],
                        ).createShader(bounds);
                      },
                      child: Text('About'.tr,
                          style: boldTextStyle(size: 18)
                             ),
                    ),
                    5.height,
                    Container(
                      width: Get.width,
                      child: ReadMoreText(
                        widget.service.description.validate(),
                        style: secondaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child:
                  // !itemController.loadingList[index]
                  //     ?
                  Row(
                    children: [
                      Center(
                          child: SizedBox(
                              width:  screenWidth*0.703125,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(screenWidth*0.0260416666666),
                                  gradient:
                                     LinearGradient(colors: [
                                    ColorResources.blue1,
                                    ColorResources.blue1,

                                  ]),
                                ),
                                child: TextButton.icon(
                                  onPressed: (){
                                    launchCall(widget
                                                        .service.serviceProviderContact
                                                     .validate());
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(screenWidth*0.078125),
                                      ),
                                  ),),
                                      label:  Padding(
                                        padding:  EdgeInsets.only(top:screenHeight*0.0062086),
                                        child: Text('call us',

                                              style: robotoBold.copyWith(
                                                color:
                                                     Theme.of(context).cardColor,
                                                fontSize: screenWidth*0.0390625


                                              )),
                                      ), icon:   Icon(Icons.phone,
                                  color:
                                  Theme.of(context).cardColor,size: screenWidth*0.052083333,),

                                ),
                              ),),),
                      SizedBox(width: screenWidth*0.02604166666666,),
                      Center(
                        child: SizedBox(
                          width:  screenWidth*0.13802083333,
                          height:  screenWidth*0.13802083333,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                              LinearGradient(colors: [
                                ColorResources.blue1,
                                ColorResources.blue1,

                              ]),
                            ),
                            child: IconButton(
                              onPressed: (){ Get.to(
                                () => ServicesMapScreen(
                                  address: AddressModel(
                                  latitude:
                                        widget.service.latitude,
                                    longitude:
                                        widget.service.longitude,
                                  ),
                                  fromStore: true,
                               ),
                               );},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenWidth*0.078125),
                                  ),
                                ),),
                           icon:   Center(
                             child: Icon(Icons.location_on_outlined,
                                color:
                                Theme.of(context).cardColor,size: screenWidth*0.06510416666666666666,),
                           ),


                            ),
                          ),),),

                    ],
                  )),
              SizedBox(height:screenHeight*0.012417223 ,),
              Center(
                child: Padding(
                  padding:  EdgeInsets.only(right: screenWidth*0),
                  child: SizedBox(
                    width:   screenWidth*0.8854166666666,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth*0.026041666),
                        gradient:
                        LinearGradient(colors: [
                          ColorResources.blue1,
                          ColorResources.blue1,

                        ]),
                      ),
                      child: TextButton.icon(
                        onPressed: (){
                          launchUrl(
                                    Uri.parse(
                                            '${getSocialMediaLink(LinkProvider.WHATSAPP)}${widget.service.serviceProviderContact.validate()}'),
                                      mode: LaunchMode
                                          .externalApplication);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth*0.078125),
                            ),
                          ),),
                        label:  Padding(
                          padding:  EdgeInsets.only(top:screenHeight*0.00124172190),
                          child: Text('chat whatsapp',

                              style: robotoBold.copyWith(
                                  color:
                                  Theme.of(context).cardColor,
                                  fontSize: screenWidth*0.0390625


                              )),
                        ), icon:   Padding(
                          padding:  EdgeInsets.only(bottom:screenHeight*0.0062086),
                          child: Icon(FontAwesomeIcons.whatsapp,
                          color:
                          Theme.of(context).cardColor,size: screenWidth*0.05208333333,),
                        ),

                      ),
                    ),),
                ),),


              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Padding(
                padding:  EdgeInsets.only(top: screenHeight*0.00372516710478),
                child: Text(
                  'rate_the_item'.tr,
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).disabledColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: screenHeight*0.007450334209),
              SizedBox(
                height: screenHeight*0.03725167104,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        rating < (i + 1) ? Icons.star_border : Icons.star,
                        size: screenWidth*0.0651041666666,
                        color: rating < (i + 1)
                            ? Theme.of(context).disabledColor
                            : Colors.yellow,
                      ),
                      onTap: () {
                        setState(() {
                          rating = i + 1;
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight*0.0124172190570),
              MyTextField(
                controller: commentController,
                maxLines: 3,
                capitalization: TextCapitalization.sentences,
                isEnabled: true,
                hintText: 'write_your_review_here'.tr,
                fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
                // onChanged: (text) => itemController.setReview(index, text),
              ),
              SizedBox(height: screenHeight*0.02483443811),

              // Submit button
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child:
                      // !itemController.loadingList[index]
                      //     ?
                      CustomButton2(
                    buttonText: 'submit'.tr,
                    onPressed: isServiceReviewed
                        ? null
                        : () async {
                            if (!_isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotLoggedInScreen()));
                            } else {
                              final model = userController.userInfoModel;

                              final reviewsRef = FirebaseFirestore.instance.collection('reviews');
                              final documentRef = reviewsRef.doc(model.id.toString());

                              await documentRef.set({
                                'comment': commentController.text,
                                'reviews': rating,
                                'serviceProviderId':  widget.service.serviceProviderId,
                                'userId': model.id,
                                'userImage':model.image,
                                'userName': model.fName + model.lName,
                              }).then((value) =>  Utlils().toast('Review Submitted Successfully'));

                              // Map<String, dynamic> data = PostReviewModel(
                              //   comment: commentController.text,
                              //   reviews: rating,
                              //   serviceProviderId:
                              //       widget.service.serviceProviderId,
                              //   userId: model.id,
                              //   userImage: model.image,
                              //   userName: model.fName + model.lName,
                              // ).toJson();
                              // postReview(data);
                            }
                          },
                  )),
              SizedBox(height:screenHeight*0.05 ,),
        // Row(
        //   mainAxisAlignment:
        //   MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       '${'review'.tr} :',
        //       style: boldTextStyle()
        //           .copyWith(color: Color(0xFF5F60B9)),
        //       overflow: TextOverflow.ellipsis,
        //     ),
        //     RatingBar(
        //       rating: reviews.toDouble(),
        //       size: _desktop ? 15 : 12,
        //       ratingCount:
        //           widget.reviewDataList.length,
        //     ),
        //   ],
        // ),
]
        ),
        )     ),
    );
  }
}

Widget item(String name, String value) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: boldTextStyle().copyWith(color: Color(0xFF5F60B9)),
          overflow: TextOverflow.ellipsis,
        ),
        Text(value ?? '')
      ],
    ),
  );
}
class ReviewSubmittedPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Review submitted'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}