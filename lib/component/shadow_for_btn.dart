import 'package:flutter/material.dart';
import 'package:ar_app/constant/colors_constant.dart';

class ShadowForBtn extends StatelessWidget {
  const ShadowForBtn({super.key,required this.child});

  final Widget child;
  // ボタンの構成
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorConstants.backgroundColorSub.withOpacity(0.5),
            spreadRadius: 8,
            blurRadius: 20,
            offset: const Offset(0, 0)
          )
        ]
      ),
      child:child ,
    );
  }
}