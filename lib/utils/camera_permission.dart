import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> cameraPermission(BuildContext context, State state,
    [VoidCallback? onGranted]) async {
  try {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      if (onGranted != null) {
        onGranted();
      }
    } else {
      if (state.mounted) {
        showCameraPermissionDialog(context);
      }
    }
  } catch (e) {
    print('PermissionStatusError$e');
  }
}

void showCameraPermissionDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("カメラが許可されていません"),
          content: const Text("設定からカメラの許可を行ってください"),
          actions: [
            TextButton(
                child: const Text('設定'), onPressed: () => {openAppSettings()}),
            TextButton(
              child: const Text("OK"),
              onPressed: () => {Navigator.of(context).pop()},
            )
          ],
        );
      });
}
