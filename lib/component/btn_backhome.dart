import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BtnBackhome extends StatelessWidget {
  const BtnBackhome({super.key});

  // ボタンの構成
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => {_showDialog(context)},
        child: const Text(
            "やめる",
            style: TextStyle(color: ColorConstants.fontColor)
        ),
      ),
    );
  }

  // Dialogの表示
  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return (AlertDialog(
            title: const Text("アプリを中断してホーム画面に戻りますか？"),
            content: const Text("待ち時間がリセットされます"),
            actions: [
              TextButton(
                  child: const Text("OK"), onPressed: () => {context.go('/')}),
              TextButton(
                  child: const Text("キャンセル"),
                  onPressed: () => {Navigator.of(context).pop()})
            ],
          ));
        });
  }
}
