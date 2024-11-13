import 'package:flutter/material.dart';

void showCheckDialog(BuildContext context,String title, String content){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => {Navigator.of(context).pop()},
          )
        ],
      );
    }
  );
}