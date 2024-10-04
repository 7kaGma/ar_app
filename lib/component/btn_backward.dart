import 'package:flutter/material.dart';
import 'package:ar_app/constant/colors_constant.dart';

class BtnBackward extends StatelessWidget {
  const BtnBackward(
      {super.key,
      this.fontColor = ColorConstants.fontColorSub,
      this.bgColor = ColorConstants.appBarIconColor});

  final Color fontColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child:Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: bgColor.withOpacity(0.8)),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: fontColor,
        ),
      ),
    )
    );
  }
}
