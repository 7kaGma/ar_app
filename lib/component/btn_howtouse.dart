import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BtnHowtouse extends StatelessWidget {
  const BtnHowtouse({super.key});

  // ボタンの構成
  @override
  Widget build(BuildContext context) {
    return (
      IconButton(
        icon: const Icon(Icons.help),
        onPressed: () => {
          context.push('/howtouse')
        },
      )
    );
  }
}