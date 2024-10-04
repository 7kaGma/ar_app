import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';


Future <void> checkCameraPremission(
  BuildContext context,
  MobileScannerController controller,
  // mountedチェック用
  State state
) async{
  try {
      PermissionStatus status = await Permission.camera.status;
      // 権限が許可されていない
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }
      // 権限が許可されている場合
      if (status.isGranted) {
        controller.start();
      } else {
        // 非同期処理でBuildContextを使用する場合ウィジェットが破棄されてないか確認
        if(state.mounted){
          showCameraPermissionDialog(context);
        }
      }
    } catch (e) {
      print('PermissionStatusError$e');
    }
}

void showCameraPermissionDialog(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("カメラが許可されていません"),
        content: const Text("設定からカメラの許可を行ってください"),
        actions: [
          TextButton(
            child: const Text('設定'),
            onPressed: () => {openAppSettings()}),
          TextButton(
            child: const Text("OK"),
            onPressed: () => {Navigator.of(context).pop()},
          )
        ],
      );
    }
  );
}