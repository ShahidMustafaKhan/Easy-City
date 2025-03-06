import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/data/model/body/social_log_in_body.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';

import '../../../../util/colors.dart';

class SocialLoginWidget extends StatelessWidget {
  MaterialButton container(String image, BuildContext context) {
    return MaterialButton(
      height: 50,
   elevation: 10,
   padding: EdgeInsets.only(left: 8),
      minWidth: MediaQuery.of(context).size.width*0.860,
      color: ColorResources.blue1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
        side: BorderSide(color: ColorResources.blue1, width: 2), // Set the border color and width here

      ),


      child: Row(children: [
        Image.asset(image,width: 30, height: 30,matchTextDirection: true,),
        SizedBox(width: MediaQuery.of(context).size.width*0.04,),
        Padding(
          padding: const EdgeInsets.only(top:4.5),
          child: Text(
            'Sign_in with google'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: ColorResources.blue1,
            ),
          ),
        ),
        SizedBox(width: 25,)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 3,),
      InkWell(
        onTap: () async {
          GoogleSignInAccount _googleAccount = await GoogleSignIn().signIn();
          // .then((value) => Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // ));
          GoogleSignInAuthentication _auth =
              await _googleAccount.authentication;
          print("HELLO");
          if (_googleAccount != null) {
            Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
              email: _googleAccount.email,
              token: _auth.accessToken,
              uniqueId: _googleAccount.id,
              medium: 'google',
            ));
          }
        },
        child: container(Images.google, context),
        //  Container(
        //   height: 40,
        //   width: 40,
        //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.grey[Get.isDarkMode ? 700 : 300],
        //           spreadRadius: 1,
        //           blurRadius: 5)
        //     ],
        //   ),
        //   child: Image.asset(Images.google),
        // ),
      ),


    ]);
  }
}
class SocialRegisterWidget extends StatelessWidget {
  MaterialButton container(String image, BuildContext context) {
    return MaterialButton(
      height: 50,
      elevation: 10,
      padding: EdgeInsets.only(left: 8),
      minWidth: MediaQuery.of(context).size.width*0.860,
      color: ColorResources.blue1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
        side: BorderSide(color: ColorResources.blue1, width: 2), // Set the border color and width here

      ),


      child: Row(children: [
        SizedBox(width: 3,),
        Image.asset(image,width: 30, height: 30,matchTextDirection: true,),
        SizedBox(width: MediaQuery.of(context).size.width*0.04,),
        Padding(
          padding: const EdgeInsets.only(top:4.5),
          child: Text(
            'Sign_up with google'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: ColorResources.blue1,
            ),
          ),
        ),
        SizedBox(width: 25,)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () async {
          GoogleSignInAccount _googleAccount = await GoogleSignIn().signIn();
          // .then((value) => Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // ));
          GoogleSignInAuthentication _auth =
              await _googleAccount.authentication;
          print("HELLO");
          if (_googleAccount != null) {
            Get.find<AuthController>().registerWithSocialMedia(SocialLogInBody(
              email: _googleAccount.email,
              token: _auth.accessToken,
              uniqueId: _googleAccount.id,
              medium: 'google',
            ));
          }
        },
        child: container(Images.google,context),
        //  Container(
        //   height: 40,
        //   width: 40,
        //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.grey[Get.isDarkMode ? 700 : 300],
        //           spreadRadius: 1,
        //           blurRadius: 5)
        //     ],
        //   ),
        //   child: Image.asset(Images.google),
        // ),
      ),


    ]);
  }
}
