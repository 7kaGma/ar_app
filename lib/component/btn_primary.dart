import 'package:flutter/material.dart';
import 'package:ar_app/constant/colors_constant.dart';

class BtnPrimary extends StatelessWidget {
  const BtnPrimary({super.key,required this.onPressed,required this.text});
  final VoidCallback onPressed;
  final String text;

  // ボタンの構成
  @override
  Widget build(BuildContext context) {
    return (
      ElevatedButton(
        onPressed:onPressed,
        style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        minimumSize:const Size(double.infinity,50)
      ),
        child: Text(
          text,
          style: const TextStyle(
            color: ColorConstants.fontColor,
            fontSize: 16
          ),),
      )
    );
  }
}