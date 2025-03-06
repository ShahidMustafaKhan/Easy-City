import 'package:flutter/material.dart';

import '../../../../util/colors.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class MenuAppBar extends StatelessWidget with PreferredSizeWidget {
  const MenuAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 140,
      elevation: 0,
      backgroundColor: ColorResources.blue1,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.white, width: 3),
                  shape: BoxShape.circle),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: ColorResources.blue1, width: 3),
                    shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/image/menu/user.png',
                    color: ColorResources.blue1,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shahid Mustafa',
                  style:
                      robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                Text(
                  '12 Apr, 2023',
                  style:
                      robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 140);
}
