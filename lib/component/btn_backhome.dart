import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';
import  'package:ar_app/utils/show_dialog_backhome.dart';

class BtnBackhome extends StatelessWidget {
  const BtnBackhome({super.key});

  // ボタンの構成
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => {showDialogBackhome(context)},
        child:Text(
            "やめる",
            style: TextStyle(
              color: ColorConstants.fontColor,
              shadows: [
                Shadow(
                  offset: const Offset(2,2),
                  blurRadius: 8.0,
                  color: ColorConstants.backgroundColorSub.withOpacity(0.8)
                )
              ])
        ),
      ),
    );
  }
}
