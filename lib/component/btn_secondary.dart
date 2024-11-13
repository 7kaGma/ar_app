import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';

class BtnSecondary extends StatelessWidget {
  const BtnSecondary({super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  // ボタンの構成
  @override
  Widget build(BuildContext context) {
    return (OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color:ColorConstants.frameColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 50)),
      child: Text(
        text,
        style: const TextStyle(color: ColorConstants.fontColor, fontSize: 16),
      ),
    ));
  }
}
