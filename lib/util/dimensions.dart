import 'package:get/get.dart';

class Dimensions {
  static double fontSizeXExtraSmall = Get.context.width >= 1300 ? 12 : 10;
  static double fontSizeExtraSmall = Get.context.width >= 1300 ? 14 : 10;
  static double fontSizeSmall = Get.context.width >= 1300 ? 16 : 12;
  static double fontSizeDefault = Get.context.width >= 1300 ? 18 : 14;
  static double fontSizeLarge = Get.context.width >= 1300 ? 20 : 16;
  static double fontSizeExtraLarge = Get.context.width >= 1300 ? 22 : 18;
  static double fontSizeOverLarge = Get.context.width >= 1300 ? 28 : 24;

  static const double PADDING_SIZE_EXTRA_EXTRA_SMALL = 3.0;
  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;

  static const double RADIUS_SMALL = 5.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static const double RADIUS_EXTRA_LARGE = 20.0;

  static const double WEB_MAX_WIDTH = 1170;
  static const int MESSAGE_INPUT_LENGTH = 250;
}
