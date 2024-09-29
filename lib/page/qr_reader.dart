import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_howtouse.dart';
import 'package:ar_app/services/camera_permission.dart';

class QrReader extends StatefulWidget {
  const QrReader({super.key});

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  // MobileScannerController
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,// 自動で起動
    torchEnabled: false,// Flashライトのオンオフ
    useNewCameraSelector: true,//最新のカメラ機能を使うか
  );

  //変数_barcode
  Barcode? _barcode; 

  // init関数
  @override
  void initState() {
    super.initState();
    checkCameraPremission(context, controller, this);
  }
  //dispose関数
  @override
  Future<void> dispose() async {
    _barcode = null;
    super.dispose();
    await controller.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("QR Reader"),
        actions: const [HowtouseBtn()],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox=指定したサイズの長方形widgetを作成
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // MobileScanerWidget
            child: MobileScanner(
              controller: controller,
              fit: BoxFit.contain,
              // QRコードをスキャンしたら実行する関数
              onDetect: (scandata) {
                controller.stop();
                setState(() {
                  _barcode = scandata.barcodes.first;
                });
                print(_barcode?.rawValue);
                context.push('/waitingtime');
              },
            ),
          )
        ],
      ),
    );
  }
}
