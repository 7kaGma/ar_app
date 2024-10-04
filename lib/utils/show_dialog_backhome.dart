import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showDialogBackhome(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ホーム画面に戻りますか？"),
          content: const Text("待ち時間がリセットされます"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => {context.go('/')}
            ),
            TextButton(
              child: const Text("キャンセル"),
              onPressed: () => {Navigator.of(context).pop()}
            )
          ],
        );
      });
}